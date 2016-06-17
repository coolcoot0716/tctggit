//
//  spinfoTableViewCell.swift
//  同城推广
//
//  Created by Mac on 16/5/29.
//  Copyright © 2016年 tctg. All rights reserved.
//

import UIKit

class spinfoTableViewCell: UITableViewCell {

    @IBOutlet weak var spname: UILabel!
    
    @IBOutlet weak var spjg: UILabel!
    
    @IBOutlet weak var sptint: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
