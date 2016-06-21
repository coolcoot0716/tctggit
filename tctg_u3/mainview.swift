//
//  mainview.swift
//  同城推广
//
//  Created by Mac on 16/5/7.
//  Copyright © 2016年 tctg. All rights reserved.
//

import UIKit
import AVOSCloud
import SwiftyJSON
import WechatKit

class mainview: UIViewController,UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UISearchBarDelegate{
    
    let wd = UIScreen.mainScreen().bounds.size.width //屏幕宽度
    
    let colletionCell :Int=2//collectionView几列
  
    var hArr : [CGFloat] = []//collectionCell数组存储不同高度
    
    var returndata: [AVObject] = [] //从leanCloud查询返回的数据
    
    let sp_name_height:CGFloat=40  //商品名高度
    let sp_tint_height:CGFloat=20 //商品标签高度
   
    let sp_jg_height:CGFloat=20 //商品价格高度
   
    
    
  //  @IBOutlet weak var sp_SV: UIStackView!
    
    @IBOutlet weak var spCV: UICollectionView!
    var spCC:SpCollectionViewCell? = nil
    //广告滚动
    @IBOutlet weak var sv: UIScrollView!
    
    @IBOutlet weak var pc: UIPageControl!
    
    //广告定时滚动器
    var timer:NSTimer!
    
    // 指示当前页面变量
    var currentPage = 0
    //广告数量
    var ADnum:CGFloat=3.0
    
    //加载器
     var activityIndicator:UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
       
        //加上 搜索栏
        let titleView:UIView = UIView(frame: CGRectMake(0,0,200,30))
         let color =  self.navigationController!.navigationBar.barTintColor
        
      
        titleView.backgroundColor = color
        
         let searchBar:UISearchBar = UISearchBar()
        searchBar.delegate = self;
        searchBar.frame = CGRectMake(0, 0, 200, 30);
        searchBar.backgroundColor = color;
        searchBar.layer.cornerRadius = 15;
        searchBar.layer.masksToBounds = true;
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = color?.CGColor
        let i:UITextField = searchBar.valueForKey("searchField") as! UITextField
        i.font = UIFont(name: "Courier New", size: 12.0)
        
      
        searchBar.placeholder = "搜索你想要的东西";
        
        
        
        titleView.addSubview(searchBar)
        
        //Set to titleView
        self.navigationItem.titleView?.sizeToFit()
        self.navigationController?.navigationBar.translucent = false
      
        self.navigationItem.titleView = titleView;
        
        //防止在加入导航控件后,主页scrollview显示第一图片广告时上面会留白,
        self.automaticallyAdjustsScrollViewInsets = false
        
        //加载数据时显示进度条
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle:
            UIActivityIndicatorViewStyle.WhiteLarge)
       
        
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
        
        
        
        //MARK:滚动广告开始
        sv.delegate=self
         sv.contentSize = CGSizeMake((self.view.frame.width * ADnum), sv.frame.height)
        for i in 1...Int(ADnum) { //loading the images
            let image = UIImage(named: "AD\(i).jpg")!
            let x = CGFloat(i - 1) * self.view.frame.width //这一步获取ScrollView的宽度时我用IPHONE6实体机测试是320，右边会出现第二张图片的一部分，最后还是用ROOT VIEW的宽度
            let imageView = UIImageView(frame: CGRectMake(x, 0, self.view.frame.width, sv.frame.height))
            imageView.image = image
            imageView.backgroundColor = UIColor.blueColor()
            sv.pagingEnabled = true
            sv.showsHorizontalScrollIndicator = false
            sv.scrollEnabled = true
          
            sv.addSubview(imageView)
           
        }
       
        pc.numberOfPages = Int(ADnum)
        
        addTimer()
      
        
        
    }
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
      
        return true
    }

    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
       searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
          searchBar.setShowsCancelButton(false, animated: true)
//        let s = searchView()
//        s.searchString = searchBar.text!
//        self.navigationController?.pushViewController(s, animated: false)
        let myStoryBoard = self.storyboard
        let anotherView:searchView = myStoryBoard?.instantiateViewControllerWithIdentifier("search")  as! searchView
        anotherView.searchString = searchBar.text!
       
        
        
        
        self.navigationController?.pushViewController(anotherView, animated: true)
        
    }
    
    
       /**
     Description:可以定制不同的item
     
     - returns: item的大小
     */
    //    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    //
    //            return CGSize(width: 100, height: 140)
    //
    //    }
    
    
    override func viewWillAppear(animated:Bool) {
        
       self.navigationController?.setNavigationBarHidden(false, animated: true)
        spCV.reloadData()
        
    }
  
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let width = self.view.frame.width
        let offsetX = scrollView.contentOffset.x
        let index = (offsetX + width / 2) / width
        pc.currentPage = Int(index)
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        removeTimer()
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        addTimer()
    }
    
    func addTimer() {
        timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: #selector(mainview.nextImage), userInfo: nil, repeats: true)
    }
    
    func removeTimer() {
        timer.invalidate()
    }
    
    
    func nextImage() {
        var pageIndex = pc.currentPage
        if pageIndex == Int(ADnum)-1 {
            pageIndex = 0
        } else {
            pageIndex += 1
        }
        
        let offsetX = CGFloat(pageIndex) * self.view.frame.width
        sv.setContentOffset(CGPointMake(offsetX, 0), animated: true)
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



