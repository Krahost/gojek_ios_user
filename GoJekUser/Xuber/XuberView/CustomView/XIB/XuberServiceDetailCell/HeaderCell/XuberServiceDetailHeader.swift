//
//  XuberServiceDetailHeader.swift
//  GoJekUser
//
//  Created by Ansar on 19/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class XuberServiceDetailHeader: UIView {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var qtyLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.text = XuberConstant.name.localized
        qtyLabel.text = XuberConstant.qty.localized
        nameLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        qtyLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        priceLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        setDarkMode()
    }
    
    private func setDarkMode(){
        self.backgroundColor = .boxColor
    }
}
