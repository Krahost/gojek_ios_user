//
//  DisputeSenderCell.swift
//  TranxitUser
//
//  Created by Ansar on 19/01/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class DisputeSenderCell: UITableViewCell {
    
    @IBOutlet weak var imgProfile:UIImageView!
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var lblContent:UILabel!
    @IBOutlet weak var viewStatus:UIView!
    @IBOutlet weak var lblStatus:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setFont()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


extension DisputeSenderCell {
    private func setFont() {
        lblName.font = UIFont.setCustomFont(name: .bold, size: .x16)
        lblContent.font = UIFont.setCustomFont(name: .bold, size: .x14)
        lblStatus.font = UIFont.setCustomFont(name: .bold, size: .x14)
        imgProfile.setBorder(width: 1, color: .black)
        DispatchQueue.main.async {
            self.imgProfile.setRoundCorner()
            self.viewStatus.setCornerRadius()
        }
        setDarkMode()
    }
    
    private func setDarkMode(){
        self.contentView.backgroundColor = .boxColor
    }
    
}
