//
//  data.swift
//  同城推广
//
//  Created by Mac on 16/5/21.
//  Copyright © 2016年 tctg. All rights reserved.
//

import Foundation
import AVOSCloud

public typealias DataResultBlock = ([AVObject]!) -> Void

public typealias queryreturnAVfile = ([AVObject]!,[AVFile]!) -> Void

public typealias DataResultFirstS = (AVObject!)->Void


class tctgdata{
    let    SPtablename="SPinfo" //表名
    let    SJtablename="SJinfo"
    
    
    //首页获取商品信息
    func getdata(dataResultBlock:DataResultBlock){
        
        let query = AVQuery(className: SPtablename)
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock { (objects, e) in
            
            
            if let  objects = objects as? [AVObject]{
                
                dataResultBlock(objects)
                
            }
        }
    }
    
    //根据openid读取商家信息
    
    func getOpenidSJinfo(openid:String , DataResultFirst:DataResultFirstS){
        
        let query = AVQuery(className: SJtablename)
        query.whereKey("weixi", equalTo: openid)
        query.getFirstObjectInBackgroundWithBlock { (o, e) in
            if e != nil {
                print("该微信号还未申请开通店铺")
                DataResultFirst(nil)
            }else
            {
                
            DataResultFirst(o)
            }
        }
      
        
    }
    
    
    
    
    //顶部查询功能,返回记录
    func getdata( searchString:String,dataResultBlock:queryreturnAVfile)  {
        
        var avfiles:[AVFile]=[]
        //
        var ss=searchString
        //过滤掉搜索框里面多余的空格以及非法的字符
        let whitespace = NSCharacterSet.whitespaceAndNewlineCharacterSet()
        ss = ss.stringByTrimmingCharactersInSet(whitespace)
        
        var sArray = ss.componentsSeparatedByCharactersInSet(whitespace)
        
        sArray = sArray.filter{
            $0 != ""
        }
        
        if sArray.count == 0 {
            dataResultBlock(nil,nil)
            return
        }
        var sqls="select spname,pic,spjg,sp_tint,sp_hd from " + SPtablename + " where "
        var qs=""
        for i in 0..<sArray.count {
            
            sArray[i]="spname like '%"+sArray[i]+"%'"
            
        }
        qs=sArray.joinWithSeparator(" or ")
        //  let ss = JoinSequence(" or ",sArray)
        sqls=sqls+qs+" order by createdAt desc"
        print(sqls)
        AVQuery.doCloudQueryInBackgroundWithCQL(sqls ) { (o, e) in
            if ((e == nil )){
                
                
                
                if let  objects = o.results as? [AVObject]  {
                    
                    for i in 0..<o.results.count{
                        
                        objects[i].fetchInBackgroundWithKeys(["pic"], block: { (av, ee) in
                            let f:AVFile = av.objectForKey("pic") as! AVFile
                            
                            avfiles.append(f)
                            
                            if (avfiles.count == o.results.count){
                                dataResultBlock(objects,avfiles)}
                            
                        })
                        
                        
                    }
                    
                    dataResultBlock(nil,nil)
                    
                    
                }
                
                
            }
            
        }
    }
    
    
}

