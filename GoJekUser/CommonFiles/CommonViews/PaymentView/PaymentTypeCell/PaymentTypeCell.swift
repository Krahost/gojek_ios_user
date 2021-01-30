//
//  PaymentTypeCell.swift
//  GoJekUser
//
//  Created by Ansar on 19/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class PaymentTypeCell: UICollectionViewCell {
    
    @IBOutlet weak var paymentTypeLabel: UILabel!
    @IBOutlet weak var outerView: UIView!
    
    var isSelectedItem:Bool = false {
        didSet {
            self.outerView.backgroundColor = isSelectedItem ? .appPrimaryColor : .white
            paymentTypeLabel.textColor = isSelectedItem ? .white : .lightGray
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        DispatchQueue.main.async {
            self.outerView.setCornerRadius()
        }
        paymentTypeLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}
