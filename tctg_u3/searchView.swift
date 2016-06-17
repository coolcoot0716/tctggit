
import UIKit
import AVOSCloud
import SwiftyJSON
import WechatKit

class searchView: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    let wd = UIScreen.mainScreen().bounds.size.width //屏幕宽度
    
    let colletionCell :Int=2//collectionView几列
    
    var hArr : [CGFloat] = []//collectionCell数组存储不同高度
    
    var queryReturnData:[AVObject] = [] //从leanCloud查询返回的数据
   // var queryimgData:[NSData]=[]
    var ar:[AVFile]=[]
   
    var searchString:String = ""
    
    let sp_name_height:CGFloat=40  //商品名高度
    let sp_tint_height:CGFloat=20 //商品标签高度
    
    let sp_jg_height:CGFloat=20 //商品价格高度
    
    @IBOutlet weak var emptylable: UILabel!
    
    //  @IBOutlet weak var sp_SV: UIStackView!

    @IBOutlet weak var search_spCV: UICollectionView!
 
    var search_spCC:SpCollectionViewCell? = nil
  
    var activityIndicator:UIActivityIndicatorView!
   
    override func viewDidLoad() {
        
        super.viewDidLoad()
     
//          search_spCV.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headView")
                        //Set to titleView
//        self.navigationItem.titleView?.sizeToFit()
//        self.navigationController?.navigationBar.translucent = false
        
       // self.navigationItem.titleView = titleView;
        
        //防止在加入导航控件后,主页scrollview显示第一图片广告时上面会留白,
       // self.automaticallyAdjustsScrollViewInsets = false
        //加载数据时显示进度条
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle:
            UIActivityIndicatorViewStyle.White)
        activityIndicator.center=self.view.center
        self.view.addSubview(activityIndicator);
        activityIndicator.startAnimating()
        //读取数据
        let d = tctgdata()
          d.getdata(searchString) { (objects,avfiles) in
         
            if (objects == nil){
              self.activityIndicator.stopAnimating()
                self.emptylable.hidden = false
                self.search_spCV.hidden = true
            }
            else {
                self.search_spCV.hidden = false
                self.emptylable.hidden = true
                
             self.queryReturnData = objects
            self.ar = avfiles
            //self.queryimgData = ndata
          
          // print("getdata",objects.count,ndata.count)
            //调用主线程来更新视图数据
     
            }
            NSOperationQueue.mainQueue().addOperationWithBlock({
                self.activityIndicator.stopAnimating()
                self.search_spCV.reloadData()
             
                
            })        }
        
        
    }
    

    
    override func viewWillAppear(animated:Bool) {
       
               search_spCV.reloadData()
        
    }
    
    
    
//    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
//                let h =
//            collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "HeaderView", forIndexPath: indexPath) as UICollectionReusableView
//        let t = UILabel(frame: h.frame)
//        if (queryReturnData.count > 0){
//          t.text = " "
//        }
//        else{
//        
//            t.text = "未找到符合条件的商品! "
//
//        }
//            h.addSubview(t)
//        
//        
//          return h
//    }
//    
    
    
    //返回cell总个数
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
        
        return queryReturnData.count
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
        
        if (hArr.count < indexPath.row+1){
            
            var rheight : CGFloat=wd/CGFloat(colletionCell)+sp_name_height+sp_jg_height
            
            if  ((queryReturnData[indexPath.row])["sp_tint"] as? String) != nil{
                rheight+=sp_tint_height        }
            
           
            let string:NSString = ((queryReturnData[indexPath.row])["spname"] as? String)!
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
  
//    func loadimage(){
//        
//    search_spCC = self.search_spCV.dequeueReusableCellWithReuseIdentifier("searchspcell", forIndexPath: NSIndexPath(forItem: 0, inSection: 1)) as? SpCollectionViewCell
//        
//      //  search_spCC?.spimage.image = UIImage(data:ar[0].getData())
//    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        search_spCC = collectionView.dequeueReusableCellWithReuseIdentifier("searchspcell", forIndexPath: indexPath) as? SpCollectionViewCell
        
        
        let re = queryReturnData[indexPath.row]
//        let d = data()
//        d.queryGetAvfile(re) { (av) in
//            self.ar.append(av)
//            self.loadimage()
//            //self.search_spCC?.spimage.image = UIImage(data: self.ar.getData())
//            
//           
//            
//        }
        // let img = re["pic"] as! AVFile
        
        
        
        
        //重新定义cell位置、宽高
        let remainder :Int = indexPath.row%colletionCell
        let currentRow :Int = indexPath.row/colletionCell
        
        
        //        CGFloat labelHeight = [testLabel sizeThatFits:CGSizeMake(testLabel.frame.size.width, MAXFLOAT)].height;
        //        NSNumber *count = @((labelHeight) / testLabel.font.lineHeight);
        
        
        
        let currentHeight :CGFloat=hArr[indexPath.row]
        
        
        
        
        let positonX = CGFloat( (Int(wd) / colletionCell-3) * remainder + 2*(remainder+1) )
        var positionY = CGFloat((currentRow+1)*2)
        //        print("remainder:\(remainder) currentRow:\(currentRow) currentHeight:\(currentHeight) positonX:\(positonX) positionY:\(positionY)")
        
        for i in 0..<currentRow{
            let position = remainder + i * colletionCell
            positionY += hArr[position]
        }
        search_spCC?.backgroundColor = UIColor.whiteColor()
        search_spCC!.frame=CGRectMake(positonX, positionY,CGFloat(Int(wd)/colletionCell-3),currentHeight)
       //   print("cell",queryReturnData.count,queryimgData.count)
     
      //  let redata = queryimgData[indexPath.row]
      
        
        search_spCC!.spName.text = re["spname"] as? String
        
        let s = re["pic"] as! AVFile
        
        
        for ii in ar{
            if ii == s{
            self.search_spCC?.spimage.image = UIImage(data:ii.getData())
            }
        
        }
        
        
        
        search_spCC?.spJG.text = "￥\(re["spjg"] as! Float)"
        
        if let tint = re["sp_tint"] as? String {
            search_spCC?.spTint.text = tint
           search_spCC?.spTint.hidden = false
        }
        else{
            search_spCC?.spTint.hidden=true
        }
        
        
        
        
        if (re["sp_hd"] as? String) != nil {
            //显示图标
            
            search_spCC?.rm.hidden=false
            
        }else{
            //隐藏图标
            search_spCC?.rm.hidden=true
        }
        
        
        
        
     
        
        
    return search_spCC!
    }
    
    
    //具体点击的哪个cell
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // let re = queryReturnData[indexPath.row]
        
        
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showSpinfo"{
            
            let spinfoVC = segue.destinationViewController as! spinfoTableViewController
            
            let cell = sender as! SpCollectionViewCell
            let indexPath = self.search_spCV!.indexPathForCell(cell)
            
            spinfoVC.spinfo =  queryReturnData[(indexPath?.row)!]
        }
        
    }
}
