//
//  DisputeCell.swift
//  TranxitUser
//
//  Created by on 12/01/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class DisputeCell: UITableViewCell {
    
    @IBOutlet weak var imageRadio:UIImageView!
    @IBOutlet weak var lblTitle:UILabel!
    
    var isSelect: Bool = false {
        didSet {
            imageRadio.image  = UIImage(named: isSelect ? Constant.circleFullImage : Constant.circleImage)
            imageRadio.imageTintColor(color1: .appPrimaryColor)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        lblTitle.font = UIFont.setCustomFont(name: .medium, size: .x14)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
