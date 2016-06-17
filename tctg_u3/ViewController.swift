//
//  ViewController.swift
//  同城推广
//
//  Created by Mac on 16/5/5.
//  Copyright © 2016年 tctg. All rights reserved.
//

import UIKit
import WechatKit
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet weak var wx: UIButton!
    @IBOutlet weak var yk: UIButton!
    @IBOutlet weak var loginimg: UIImageView!
    let Defaults = NSUserDefaults.standardUserDefaults()
    
    // var scrollView=UIScrollView()
    // var pagerconter=UIPageControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupWechatManager()
        
        wx.layer.borderColor = UIColor.whiteColor().CGColor
        wx.layer.borderWidth = 1
        wx.layer.cornerRadius = 5
        
        yk.layer.borderColor = UIColor.whiteColor().CGColor
        yk.layer.borderWidth = 1
        yk.layer.cornerRadius = 5
        
        //判断微信是否安装,没安装则只显示'游客登录',否则判断是否登录过,已登录过则不显示按钮,经过倒计时后进主界面,没登录过则显示'微信登录'
        
        if WechatManager.sharedInstance.isInstalled(){
            
            yk.hidden=true
            
            //判断微信之前登录过没有
            if (WechatManager.access_token == "" || WechatManager.access_token == nil){
                wx.hidden=false
                yk.hidden=true
            }
            else{
                wx.hidden=true
                yk.hidden=true
                wx_login(self)
            }
        }
        else {
            
            yk.hidden=false
            wx.hidden=true
        }
        
        
    }
    
    
    //MARK:游客登陆
    @IBAction func yk_login(sender: AnyObject) {
        
       //临时让游客登陆也是微信登陆方式
        let mainPageVC = self.storyboard!.instantiateViewControllerWithIdentifier("mainviewTabbar")
        self.presentViewController(mainPageVC, animated: true, completion: nil)
        
        
        
//        let mainPageVC = storyboard!.instantiateViewControllerWithIdentifier("ykNavigation")
//        
//        self.presentViewController(mainPageVC, animated: true, completion: nil)
      
    }
    
    //MARK:微信登陆
    @IBAction func wx_login(sender: AnyObject) {
        //
        //        let mainPageVC = self.storyboard!.instantiateViewControllerWithIdentifier("mainviewTabbar")
        //        self.presentViewController(mainPageVC, animated: true, completion: nil)
        
        // WXApi.getApiVersion() //所有微信SDK都可以直接调用
        
        
        WechatManager.sharedInstance.checkAuth { result in
            switch result {
            case .Failure(let errCode):
                print(errCode)
            case .Success(_):
                
                //MARK:微信登录成功则转到主界面
                
                let mainPageVC = self.storyboard!.instantiateViewControllerWithIdentifier("mainviewTabbar")
                self.presentViewController(mainPageVC, animated: true, completion: nil)
                
                // print(value)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
extension ViewController {
    private func setupWechatManager() {
        //设置appid
        WechatManager.appid = "wxb84a774b4a31dd40"
        //如果不设置appSecret 则无法获取access_token 无法完成认证
        
        WechatManager.appSecret = "84e4233a6eb8cd8148855277acaad901"
        
        //设置分享Delegation
        WechatManager.sharedInstance.shareDelegate = self
    }
}

//    // MARK: - WechatManagerShareDelegate
extension ViewController: WechatManagerShareDelegate {
    //app分享之后 点击分享内容自动回到app时调用 该方法
    func showMessage(message: String) {
        print(message)
    }
}


