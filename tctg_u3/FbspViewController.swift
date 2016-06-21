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
    
    @IBOutlet weak var spimage4height: NSLayoutConstraint!
    
    @IBOutlet weak var spimage5height: NSLayoutConstraint!
    
    @IBOutlet weak var spimage6height: NSLayoutConstraint!
    
    @IBOutlet weak var spimage5: UIImageView!
    
    @IBOutlet weak var spimage6: UIImageView!
    
    @IBOutlet weak var spimage2: UIImageView!
    
    @IBOutlet weak var spimage3: UIImageView!
    
  
    @IBOutlet weak var spmc: UITextField!
    @IBOutlet weak var sptd: UITextField!
    @IBOutlet weak var spjg: UITextField!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //取消scrollview顶部的空白
        self.edgesForExtendedLayout = .None
            imageEvent()
      //修改导航栏,添加标题和完成按钮
        self.title="商品发布"

        let rightbtn:UIBarButtonItem = UIBarButtonItem(title: "完成", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(FbspViewController.doneButtonTouched))
        self.navigationItem.rightBarButtonItem = rightbtn
    }
    
    func doneButtonTouched(){
        //检查除了商家图标和商家简介外,其他不能为空
        if(spmc.text!.isEmpty || sptd.text!.isEmpty || spjg.text!.isEmpty){
            
            let alertController = UIAlertController(title: "提示", message: "请输入内容,不能保存为空值!", preferredStyle: UIAlertControllerStyle.Alert)
            
            
            
            let okAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.Default, handler: nil)
            alertController.addAction(okAction)
            
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
            
            return
        }
        //不为空时,保存
self.navigationController!.popViewControllerAnimated(true);
    }
    
    
    
    //给图片分配点击事件
    func imageEvent()
    {
        spimage1.userInteractionEnabled = true
        spimage2.userInteractionEnabled = true
        spimage3.userInteractionEnabled = true
        spimage4.userInteractionEnabled = true
        spimage5.userInteractionEnabled = true
        spimage6.userInteractionEnabled = true
        
        let tapGR1 = UITapGestureRecognizer(target: self, action: #selector(FbspViewController.tapHandler(_:)))
        let tapGR2 = UITapGestureRecognizer(target: self, action: #selector(FbspViewController.tapHandler(_:)))
        
        let tapGR3 = UITapGestureRecognizer(target: self, action: #selector(FbspViewController.tapHandler(_:)))
        
        let tapGR4 = UITapGestureRecognizer(target: self, action: #selector(FbspViewController.tapHandler(_:)))
        
        
        let tapGR5 = UITapGestureRecognizer(target: self, action: #selector(FbspViewController.tapHandler(_:)))
        
        let tapGR6 = UITapGestureRecognizer(target: self, action: #selector(FbspViewController.tapHandler(_:)))
        spimage1.addGestureRecognizer(tapGR1)
        spimage2.addGestureRecognizer(tapGR2)
        spimage3.addGestureRecognizer(tapGR3)
        spimage4.addGestureRecognizer(tapGR4)
        spimage5.addGestureRecognizer(tapGR5)
        spimage6.addGestureRecognizer(tapGR6)
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
        imageBorder()
    }
    
    
    @IBAction func uploadimage(sender: AnyObject) {
        
        //print(sender.view.tag)
        //上传图片
        //判断设置是否支持图片库
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary){
            //初始化图片控制器
            let picker = UIImagePickerController()
            //设置代理
            picker.delegate = self
            //指定图片控制器类型
            picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            //指定tag
            picker.view.tag = sender.view.tag
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
        //获取选择的原图
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        switch picker.view.tag {
        case 801:
            spimage1.image = image
        case 802:
            spimage2.image = image
        case 803:
            spimage3.image = image
        case 901:
            let i = image.size.height/image.size.width
            spimage4height.constant = spimage4.frame.width * i
            spimage4.image = image
            
        case 902:
            let i = image.size.height/image.size.width
            spimage5height.constant = spimage5.frame.width * i
            spimage5.image = image

        case 903:
            let i = image.size.height/image.size.width
            spimage6height.constant = spimage6.frame.width * i
            spimage6.image = image

            
            
            
        default:
            break
        }
        
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
    func imageBorder(){
        spimage1.layer.borderColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1).CGColor
        spimage1.layer.borderWidth = 0.6
        spimage1.layer.cornerRadius = 6.0
        spimage1.layer.masksToBounds = true
        
        spimage2.layer.borderColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1).CGColor
        spimage2.layer.borderWidth = 0.6
        spimage2.layer.cornerRadius = 6.0
        
        spimage2.layer.masksToBounds = true
        spimage3.layer.borderColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1).CGColor
        spimage3.layer.borderWidth = 0.6
        spimage3.layer.cornerRadius = 6.0
        spimage3.layer.masksToBounds = true
        spimage4.layer.borderColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1).CGColor
        spimage4.layer.borderWidth = 0.6
        spimage4.layer.cornerRadius = 6.0
        spimage4.layer.masksToBounds = true
        
        spimage5.layer.borderColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1).CGColor
        spimage5.layer.borderWidth = 0.6
        spimage5.layer.cornerRadius = 6.0
        spimage5.layer.masksToBounds = true
        spimage6.layer.borderColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1).CGColor
        spimage6.layer.borderWidth = 0.6
        spimage6.layer.cornerRadius = 6.0
        spimage6.layer.masksToBounds = true

    }
}
