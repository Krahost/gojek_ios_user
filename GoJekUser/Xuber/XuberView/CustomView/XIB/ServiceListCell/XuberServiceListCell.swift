//
//  ServiceListTableCell.swift
//  GoJekUser
//
//  Created by Ansar on 13/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class XuberServiceListCell: UITableViewCell {
    
    @IBOutlet weak var serviceNameLabel: UILabel!
    @IBOutlet weak var underLineLabel: UILabel!
    
    @IBOutlet weak var rightImage: UIImageView!
    
    @IBOutlet weak var contentOuterView: UIView!
    @IBOutlet weak var underlineLeading: NSLayoutConstraint!
    
    @IBOutlet weak var underlineTralling: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        initialLoads()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

extension XuberServiceListCell {
    private func initialLoads() {
        self.serviceNameLabel.font = UIFont.setCustomFont(name: .medium, size: .x16)
        rightImage.image = UIImage(named: Constant.rightArrowImage)
        rightImage.imageTintColor(color1: .lightGray)
        if CommonFunction.checkisRTL() {
            rightImage.transform = rightImage.transform.rotated(by: .pi)
        }
        setDarkMode()
    }
    
    private func setDarkMode(){
        self.contentView.backgroundColor = .boxColor
        self.serviceNameLabel.textColor = .blackColor
     }
    
}
