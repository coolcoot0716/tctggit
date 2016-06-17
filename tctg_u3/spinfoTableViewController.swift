//
//  spinfoTableViewController.swift
//  同城推广
//
//  Created by Mac on 16/5/27.
//  Copyright © 2016年 tctg. All rights reserved.
//

import UIKit
import AVOSCloud


extension UIImage{
    class func colorImage(color: UIColor) -> UIImage{
        return self.colorImage(color,size:CGSize(width:2,height:2))
    }
    class func colorImage(color:UIColor,size:CGSize)->UIImage {
        
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFillUsingBlendMode(CGRectMake(0, 0, size.width, size.height),CGBlendMode.XOR)
    let cgImage = CGBitmapContextCreateImage(UIGraphicsGetCurrentContext())
        UIGraphicsEndImageContext()
        return UIImage(CGImage:cgImage!).stretchableImageWithLeftCapWidth(1, topCapHeight: 1)
    }
    
}

class spinfoTableViewController: UITableViewController,UINavigationControllerDelegate{
    
    var spinfo:AVObject = AVObject()
    
    @IBOutlet weak var spimage: UIImageView!
    
 
   

 
    
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        if (viewController == self) {
            //进入本视图时,导航栏透明显示
            self.edgesForExtendedLayout = .All
            self.navigationController?.navigationBar.translucent = true
            let clearimage = UIImage.colorImage(UIColor.clearColor())
            self.navigationController?.navigationBar.setBackgroundImage(clearimage, forBarMetrics: .Default)
            self.navigationController?.navigationBar.shadowImage = clearimage

        } else {
            // 进入其他视图控制器
           self.navigationController!.navigationBar.alpha = 1;
            // 背景颜色设置为系统默认颜色
            self.navigationController!.navigationBar.tintColor = UIColor.whiteColor();
            self.navigationController!.navigationBar.translucent = false;
        }
    }
 
    override func viewDidAppear(animated: Bool) {
        
        tableView.reloadData()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //修改返回按钮为一个图片
        let leftBarBtn = UIBarButtonItem(title: "", style: .Plain, target: self, action: #selector(spinfoTableViewController.backToPrevious))
        
        leftBarBtn.image = UIImage(named: "re")
        
        
        //用于消除左边空隙，要不然按钮顶不到最前面
        let spacer = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        spacer.width = -10;
        
        self.navigationItem.leftBarButtonItems = [spacer, leftBarBtn]
        
        
        // 修改tableview的cell高度为自适应
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 40.0
        
        self.navigationController?.delegate = self
        
        
        
    }
    
    //左上角返回按钮点击响应
    func backToPrevious(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

   
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("spinfocell", forIndexPath: indexPath) as! spinfoTableViewCell

        // Configure the cell...
        let img = spinfo["pic"] as! AVFile
        spimage.image = UIImage(data: img.getData())
        
        cell.spname.text = spinfo["spname"] as? String
        cell.spjg.text = "¥\(spinfo["spjg"] as! Float)"

        cell.sptint.text = spinfo["sp_tint"] as? String
        
        return cell
    }
    

    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
 
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
