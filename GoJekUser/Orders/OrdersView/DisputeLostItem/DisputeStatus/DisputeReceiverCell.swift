//
//  DisputeReceiverCell.swift
//  TranxitUser
//
//  Created by Ansar on 19/01/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class DisputeReceiverCell: UITableViewCell {

    @IBOutlet var imgProfile:UIImageView!
    @IBOutlet var lblName:UILabel!
    @IBOutlet var lblContent:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setFont()
        setDarkMode()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension DisputeReceiverCell {
    private func setFont() {
        lblName.font = UIFont.setCustomFont(name: .medium, size: .x16)
        lblContent.font = UIFont.setCustomFont(name: .medium, size: .x14)
        self.lblName.textAlignment = .right
        self.lblContent.textAlignment = .right
        imgProfile.setBorder(width: 1, color: .black)
        imgProfile.image = UIImage(named: Constant.userPlaceholderImage)
        DispatchQueue.main.async {
            self.imgProfile.setRoundCorner()
        }
    }
    
    private func setDarkMode(){
        self.contentView.backgroundColor = .boxColor
    }
}
