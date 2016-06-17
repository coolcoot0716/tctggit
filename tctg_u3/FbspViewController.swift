//
//  FbspViewController.swift
//  tctg_u3
//
//  Created by Mac on 16/6/14.
//  Copyright © 2016年 tctg. All rights reserved.
//

import UIKit

class FbspViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var spimage1: UIImageView!
    
    @IBOutlet weak var spimage4: UIImageView!
    @IBOutlet weak var spimage2: UIImageView!
    
    @IBOutlet weak var spimage3: UIImageView!
    
    var spimage:UIImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spimage1.userInteractionEnabled = true
        spimage2.userInteractionEnabled = true
        spimage3.userInteractionEnabled = true
        
        let tapGR1 = UITapGestureRecognizer(target: self, action: #selector(FbspViewController.tapHandler(_:)))
        let tapGR2 = UITapGestureRecognizer(target: self, action: #selector(FbspViewController.tapHandler(_:)))

        let tapGR3 = UITapGestureRecognizer(target: self, action: #selector(FbspViewController.tapHandler(_:)))

        spimage1.addGestureRecognizer(tapGR1)
        spimage2.addGestureRecognizer(tapGR2)
        spimage3.addGestureRecognizer(tapGR3)

        
        // Do any additional setup after loading the view.
      
    
    }
    //////手势处理函数
    func tapHandler(sender:UITapGestureRecognizer) {
        ///////todo....
        uploadimage(sender)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        spimage1.layer.borderColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1).CGColor
        spimage1.layer.borderWidth = 0.6
        spimage1.layer.cornerRadius = 6.0
        spimage2.layer.borderColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1).CGColor
        spimage2.layer.borderWidth = 0.6
        spimage2.layer.cornerRadius = 6.0
        spimage3.layer.borderColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1).CGColor
        spimage3.layer.borderWidth = 0.6
        spimage3.layer.cornerRadius = 6.0
        
        spimage4.layer.borderColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1).CGColor
        spimage4.layer.borderWidth = 0.6
        spimage4.layer.cornerRadius = 6.0

    }
 
    
    @IBAction func uploadimage(sender: AnyObject) {
        
        print(sender.view.tag)
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
       print(picker)
        //获取选择的原图
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        spimage = image
        //图片控制器退出
        picker.dismissViewControllerAnimated(true, completion: {
            () -> Void in
            
            
        })
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
