//
//  mysjViewController.swift
//  tctg_u3
//
//  Created by Mac on 16/6/11.
//  Copyright © 2016年 tctg. All rights reserved.
//

import UIKit
import AVOSCloud
import WechatKit
import SwiftyJSON


class mysjViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate,UITextFieldDelegate,UITextViewDelegate{

    @IBOutlet weak var sjinfo: UITextView!
  
    @IBOutlet weak var sjaddess: UITextField!
    @IBOutlet weak var sjphone: UITextField!
    @IBOutlet weak var sjname: UITextField!
    
    @IBOutlet weak var sjimage: UIImageView!
    
    @IBOutlet weak var savebtn: UIButton!
    
     //提交申请
    @IBAction func sjsave(sender: AnyObject) {
        
     savebtn.enabled = false
        
      //检查除了商家图标和商家简介外,其他不能为空
        if(sjname.text!.isEmpty || sjaddess.text!.isEmpty || sjphone.text!.isEmpty){
        
        let alertController = UIAlertController(title: "提示", message: "请输入内容,不能保存为空值!", preferredStyle: UIAlertControllerStyle.Alert)
        
        
            
          let okAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.Default, handler: nil)
            alertController.addAction(okAction)
            
            
        self.presentViewController(alertController, animated: true, completion: nil)
            
        savebtn.enabled = true
        return
        }
        
      
        
        //删除首尾空格
        let whitespace = NSCharacterSet.whitespaceAndNewlineCharacterSet()
        let s1 = sjinfo.text.stringByTrimmingCharactersInSet(whitespace)
        
        let s2 = sjaddess.text!.stringByTrimmingCharactersInSet(whitespace)
        let s3 = sjphone.text!.stringByTrimmingCharactersInSet(whitespace)
        let s4 = sjname.text!.stringByTrimmingCharactersInSet(whitespace)

        
        let record = AVObject(className:"SJinfo")
        record["sjinfo"] = s1
        record["sjaddess"] = s2
        record["sjphone"] = s3
        record["sjname"] = s4
       record["weixi"] = WechatManager.openid
        

        //图像
        
        if (sjimage.image != nil){
        let imgFile = AVFile(data: UIImageJPEGRepresentation(sjimage.image!, 0.8))
        
            imgFile.saveInBackground()
            record["sjimg"] = imgFile
            
        }
        record.saveInBackgroundWithBlock { (_, e) in
            if let e = e {
            print(e.localizedDescription)
            }
            else{
            print("保存成功")
                self.navigationController!.popViewControllerAnimated(true);
            }
        }
        
           }
    
    @IBAction func uploadimage(sender: AnyObject) {
        //上传图片
        //判断设置是否支持图片库
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary){
            //初始化图片控制器
            let picker = UIImagePickerController()
            //设置代理
            picker.delegate = self
            //指定图片控制器类型
            picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            //设置是否允许编辑
            picker.allowsEditing = false
            //弹出控制器，显示界面
            self.presentViewController(picker, animated: true, completion: {
                () -> Void in
            })
        }else{
            print("读取相册错误")
        }
    }
    
    //选择图片成功后代理
    func imagePickerController(picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        //查看info对象
        //print(info)
        //获取选择的原图
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        sjimage.image = image
        //图片控制器退出
        picker.dismissViewControllerAnimated(true, completion: {
            () -> Void in
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
   
        
        
        
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated: Bool) {
        
        sjinfo.layer.borderColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1).CGColor
        sjinfo.layer.borderWidth = 0.6
        sjinfo.layer.cornerRadius = 6.0
        
        
        sjimage.layer.borderColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1).CGColor
        sjimage.layer.borderWidth = 0.6
        sjimage.layer.cornerRadius = 6.0
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }

    //简介编辑里面输入完成后关闭软键盘
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n"){
            textView.resignFirstResponder()
        return false
        }
        return true
    }
    

    @IBAction func savebtn_down(sender: UIButton) {
        
        sender.backgroundColor = UIColor.lightGrayColor()
       sender.tintColor = UIColor.whiteColor()
        
    }

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
