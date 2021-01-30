//
//  OrderStatusCell.swift
//  GoJekUser
//
//  Created by Ansar on 18/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class OrderStatusCell: UITableViewCell {
    
    @IBOutlet weak var statusImage: UIImageView!
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusDescLabel: UILabel!
    @IBOutlet weak var statusOuterView: UIView!
    
    var isCurrentState: Bool = false {
        didSet {
            statusLabel.font = UIFont.setCustomFont(name: isCurrentState ? .bold : .medium, size: .x14)
            statusDescLabel.font = UIFont.setCustomFont(name: isCurrentState ? .bold : .medium, size: .x14)
            statusDescLabel.textColor = isCurrentState ? .lightGray : UIColor.lightGray.withAlphaComponent(0.3)
            statusLabel.textColor = isCurrentState ?  UIColor.black : UIColor.lightGray.withAlphaComponent(0.3)
            statusOuterView.backgroundColor =  isCurrentState ? UIColor.lightGray.withAlphaComponent(0.4) : UIColor.lightGray.withAlphaComponent(0.1)
            statusImage.imageTintColor(color1: isCurrentState ? .foodieColor : UIColor.lightGray.withAlphaComponent(0.3))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialLoads()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension OrderStatusCell {
    private func initialLoads() {
        statusDescLabel.font = UIFont.setCustomFont(name: .medium, size: .x12)
        statusLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)

    }

}
