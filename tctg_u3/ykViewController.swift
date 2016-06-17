//
//  ykViewController.swift
//  tctg_u3
//
//  Created by Mac on 16/6/6.
//  Copyright © 2016年 tctg. All rights reserved.
//

import UIKit
import AVOSCloud
import SwiftyJSON
import WechatKit

class ykViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    
    let wd = UIScreen.mainScreen().bounds.size.width //屏幕宽度
    
    let colletionCell :Int=2//collectionView几列
    
    var hArr : [CGFloat] = []//collectionCell数组存储不同高度
    
    var returndata: [AVObject] = [] //从leanCloud查询返回的数据
    
    let sp_name_height:CGFloat=40  //商品名高度
    let sp_tint_height:CGFloat=20 //商品标签高度
    
    let sp_jg_height:CGFloat=20 //商品价格高度

    //加载器
    var activityIndicator:UIActivityIndicatorView!
    
    @IBOutlet weak var spCV: UICollectionView!
    var spCC:SpCollectionViewCell? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //防止在加入导航控件后,主页scrollview显示第一图片广告时上面会留白,
        self.automaticallyAdjustsScrollViewInsets = false

        //加载数据时显示进度条
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle:
            UIActivityIndicatorViewStyle.White)
        activityIndicator.center=self.view.center
        self.view.addSubview(activityIndicator);
        activityIndicator.startAnimating()
        
        //读取数据
        let d = tctgdata()
        d.getdata { (objects) in
            self.returndata = objects
            //调用主线程来更新视图数据
            NSOperationQueue.mainQueue().addOperationWithBlock({
                self.activityIndicator.stopAnimating()
                self.spCV.reloadData()
                
                
            })
        }
        

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated:Bool) {
     //self.navigationController?.setNavigationBarHidden(false, animated: true)
        spCV.reloadData()
        
    }
    

    
    //返回cell总个数
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return returndata.count
    }
    
    //返回section个数
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        collectionView.collectionViewLayout.invalidateLayout()
        return 1
    }
    //定制cell的大小
    func collectionView(collectionView:UICollectionView, layout collectionViewLayout:UICollectionViewLayout, sizeForItemAtIndexPath indexPath:NSIndexPath) ->CGSize{
        
        //  let rheight : CGFloat=CGFloat(80 + (arc4random() % 250))
        //
        //如果数组已经定义了,再次刷新cell时,不需要再次append
        if (hArr.count < indexPath.row+1){
            
            var rheight : CGFloat=wd/CGFloat(colletionCell)+sp_name_height+sp_jg_height
            
            if  ((returndata[indexPath.row])["sp_tint"] as? String) != nil{
                rheight+=sp_tint_height        }
            
            
            
            let string:NSString = ((returndata[indexPath.row])["spname"] as? String)!
            let options : NSStringDrawingOptions = .UsesLineFragmentOrigin
            let boundingRect = string.boundingRectWithSize(CGSizeMake(CGFloat(Int(wd)/colletionCell-3), 0), options: options, attributes: nil, context: nil)
            
            //如果商品名只有一行,则减少高度
            if ((boundingRect.height/13.8) == 1){
                rheight-=20
            }
            hArr.append(rheight)
            
            return CGSizeMake(wd/CGFloat(colletionCell) - 3,rheight )
        }
        else{
            return CGSizeMake(wd/CGFloat(colletionCell) - 3,hArr[indexPath.row])
        }
        
    }
    
    //定制cell的间距
    func collectionView(collectionView:UICollectionView, layout collectionViewLayout:UICollectionViewLayout, insetForSectionAtIndex section:Int) ->UIEdgeInsets{
        
        return UIEdgeInsetsMake(0,0,0,0)
        
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        spCC = collectionView.dequeueReusableCellWithReuseIdentifier("spcell", forIndexPath: indexPath) as? SpCollectionViewCell
        
        
        
        //重新定义cell位置、宽高
        let remainder :Int = indexPath.row%colletionCell
        let currentRow :Int = indexPath.row/colletionCell
        
        
        //        CGFloat labelHeight = [self.testLabel sizeThatFits:CGSizeMake(self.testLabel.frame.size.width, MAXFLOAT)].height;
        //        NSNumber *count = @((labelHeight) / self.testLabel.font.lineHeight);
        
        
        
        let currentHeight :CGFloat=hArr[indexPath.row]
        
        
        
        
        let positonX = CGFloat( (Int(wd) / colletionCell-3) * remainder + 2*(remainder+1) )
        var positionY = CGFloat((currentRow+1)*2)
        //        print("remainder:\(remainder) currentRow:\(currentRow) currentHeight:\(currentHeight) positonX:\(positonX) positionY:\(positionY)")
        
        for i in 0..<currentRow{
            let position = remainder + i * colletionCell
            positionY += hArr[position]
        }
        spCC?.backgroundColor = UIColor.whiteColor()
        spCC!.frame=CGRectMake(positonX, positionY,CGFloat(Int(wd)/colletionCell-3),currentHeight)
        
        let re = returndata[indexPath.row]
        
        spCC!.spName.text = re["spname"] as? String
        
        
        
        let img = re["pic"] as! AVFile
        
        spCC?.spimage.image = UIImage(data: img.getData())
        
        spCC?.spJG.text = "￥\(re["spjg"] as! Float)"
        
        if let tint = re["sp_tint"] as? String {
            spCC?.spTint.text = tint
            spCC?.spTint.hidden = false
        }
        else{
            spCC?.spTint.hidden=true
        }
        
        
        
        
        if (re["sp_hd"] as? String) != nil {
            //显示图标
            
            spCC?.rm.hidden=false
            
        }else{
            //隐藏图标
            spCC?.rm.hidden=true
        }
        
        
        
        
        return spCC!
    }
    
    //具体点击的哪个cell
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // let re = returndata[indexPath.row]
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showSpinfo"{
            
            let spinfoVC = segue.destinationViewController as! spinfoTableViewController
            
            let cell = sender as! SpCollectionViewCell
            let indexPath = self.spCV!.indexPathForCell(cell)
            
            spinfoVC.spinfo =  returndata[(indexPath?.row)!]
        }
        
    }

    

}
