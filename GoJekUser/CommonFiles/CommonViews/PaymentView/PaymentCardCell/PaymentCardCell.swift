//
//  PaymentCardCell.swift
//  GoJekUser
//
//  Created by Ansar on 19/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class PaymentCardCell: UICollectionViewCell {
    
    @IBOutlet weak var cardLabel: UILabel!
    @IBOutlet weak var cardNameLabel: UILabel!
    
    var isSelectedItem:Bool = false {
        didSet {
            self.cornerRadius = 5.0
            self.maskToBounds = true
            self.backgroundColor = isSelectedItem ? .appPrimaryColor : .white
            cardLabel.textColor = isSelectedItem ? .white : .gray
            cardNameLabel.textColor = isSelectedItem ? .white : .gray
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardNameLabel.font = UIFont.setCustomFont(name: .medium, size: .x16)
        cardLabel.font = UIFont.setCustomFont(name: .medium, size: .x12)
        self.contentView.backgroundColor = UIColor.appPrimaryColor.withAlphaComponent(0.2)
        self.contentView.cornerRadius = 5.0
        self.contentView.maskToBounds = true
    }

}
