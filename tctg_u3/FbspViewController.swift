//
//  FbspViewController.swift
//  tctg_u3
//
//  Created by Mac on 16/6/14.
//  Copyright © 2016年 tctg. All rights reserved.
//

import UIKit

class FbspViewController: UIViewController {

    @IBOutlet weak var spimage1: UIImageView!
    
    @IBOutlet weak var spimage4: UIImageView!
    @IBOutlet weak var spimage2: UIImageView!
    
    @IBOutlet weak var spimage3: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    //////手势处理函数
    func tapHandler(sender:UITapGestureRecognizer) {
        ///////todo....
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
 
    


    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
