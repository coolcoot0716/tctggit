//
//  myTableViewController.swift
//  同城推广
//
//  Created by Mac on 16/5/19.
//  Copyright © 2016年 tctg. All rights reserved.
//

import UIKit
import WechatKit
import SwiftyJSON
import AVOSCloud


class myTableViewController: UITableViewController {

    let d = tctgdata()
    var dp:AVObject!
   
    @IBOutlet weak var dshsp: UILabel!
    @IBOutlet weak var spfb: UILabel!
    @IBOutlet weak var c1: UITableViewCell!
    
    @IBOutlet weak var c3: UITableViewCell!
    @IBOutlet weak var c2: UITableViewCell!
    @IBOutlet weak var wxpic: UIImageView!
    @IBOutlet weak var wxinfo: UILabel!
    
    @IBOutlet weak var mydp: UILabel!
    //微信退出控制
    @IBAction func wxlogout(sender: AnyObject) {
      WechatManager.sharedInstance.logout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        c1.userInteractionEnabled = false
        mydp.enabled = false
        c2.userInteractionEnabled = false
        spfb.enabled = false
        
        c3.userInteractionEnabled = false
        dshsp.enabled = false
        winxiInfo()
        selectSJ()
        
           }
    
    //在表里查询是否有openid信息,用来判断是否开通了店铺
    func selectSJ(){
        
        // d.getOpenidSJinfo(WechatManager.openid)
        d.getOpenidSJinfo("o9p_hvwY2MhfzZC_88g3-gANJ_PE") { (o) in
            
            if (o == nil) {
            
            self.mydp.text = "我的店铺(未申请)"
             self.c1.userInteractionEnabled = true
                self.mydp.enabled = true
                
                return
            }
            
            let i = o["sh"] as! Int
            
            switch i {
            case 0 :
                self.mydp.text = "我的店铺(待审核)"
               
                
            case 1 :
                
                
                self.mydp.text = "我的店铺(已通过)"
                self.c1.userInteractionEnabled = true
                self.mydp.enabled=true
                
                
                self.c2.userInteractionEnabled = true
                self.c3.userInteractionEnabled = true
                self.spfb.enabled = true
                self.dshsp.enabled = true
                //店铺已开通
                self.dp = o
                
            default:
                break
                            }
            
           //self.tableView.reloadData()
        }
        
    }
    
    
   
    //将微信个人信息显示在界面
    func winxiInfo(){
        WechatManager.sharedInstance.getUserInfo { result in
            switch result {
            case .Failure(let errCode):
                print(errCode)
            case .Success(let value):
                
                let json=JSON(value)
                print(value)
                self.wxinfo.text=json["nickname"].stringValue
                if let url = NSURL(string:json["headimgurl"].stringValue
                    ) {
                    if let data = NSData(contentsOfURL: url) {
                        self.wxpic.image = UIImage(data: data)
                    }
                }
            }
        }

    }
    
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
      //  print(WechatManager.access_token)
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
    
    
          return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
       // print(WechatManager.access_token)
        
        
       //微信帐户进入
        
        if (section==0)
        {
            return 4
        }
        if section==1 {
            return 2
        }
        if section==2 {
            return 1
        }
        return 0
   }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 1:
                
                if (dp == nil){
                  //如果没开通,则显示申请开通视图
               let mysj = self.storyboard!.instantiateViewControllerWithIdentifier("mysj")
               
             self.navigationController?.pushViewController(mysj, animated: true)
                }
                else{
                //如果已经开通,则显示商铺信息
                
                
                }
            case 2:
                let fbsp = self.storyboard!.instantiateViewControllerWithIdentifier("fbsp")
                
                self.navigationController?.pushViewController(fbsp, animated: true)
            case 3:
                print("0,3")
                
            default: break
               
            }
        case 1:
            print("1,1")
        case 2: break
            
            
        default: break
        }
        
       // print(indexPath.section,indexPath.row)
      //  self.navigationController.pus
        
    }
    
    
        /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
