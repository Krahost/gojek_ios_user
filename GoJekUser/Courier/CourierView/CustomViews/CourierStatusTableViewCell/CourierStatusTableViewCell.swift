//
//  CourierStatusTableViewCell.swift
//  GoJekUser
//
//  Created by Thiru on 03/06/20.
//  Copyright © 2020 Appoets. All rights reserved.
//

import UIKit

class CourierStatusTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var bgVw: UIView!
    @IBOutlet weak var statusImgVw: UIImageView!
    @IBOutlet weak var locationTitleLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var topLineVw: UIView!
    @IBOutlet weak var bottomLineVw: UIView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        setFont()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    private func setFont() {
        locationTitleLbl.font = .setCustomFont(name: .bold, size: .x14)
        locationLbl.font = .setCustomFont(name: .medium, size: .x12)
        locationLbl.textColor = .lightGray
        
    }
}
