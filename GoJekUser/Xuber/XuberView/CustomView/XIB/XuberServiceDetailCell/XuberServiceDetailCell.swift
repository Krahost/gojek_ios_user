//
//  XuberServiceDetailCell.swift
//  GoJekUser
//
//  Created by Ansar on 19/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class XuberServiceDetailCell: UITableViewCell {

    @IBOutlet  weak var serviceListLabel: UILabel!
    @IBOutlet  weak var qtyLabel: UILabel!
    @IBOutlet  weak var priceLabelLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        serviceListLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        qtyLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        priceLabelLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        setDarkMode()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setDarkMode(){
        self.contentView.backgroundColor = .boxColor
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        //set the values for top,left,bottom,right margins
//        let margins = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
//        contentView.frame = contentView.frame.inset(by: margins)
//    }
    
}
