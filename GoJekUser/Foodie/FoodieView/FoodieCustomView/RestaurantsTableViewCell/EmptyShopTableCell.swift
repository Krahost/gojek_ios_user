//
//  EmptyShopTableCell.swift
//  GoJekUser
//
//  Created by Sudar on 24/04/20.
//  Copyright © 2020 Appoets. All rights reserved.
//

import UIKit

class EmptyShopTableCell: UITableViewCell {
    
    @IBOutlet weak var emptyLabel: UILabel!
     @IBOutlet weak var emptyImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        emptyImageView.image =  UIImage(named: FoodieConstant.orderEmpty)
        emptyLabel.text = FoodieConstant.noRestaurant.localized
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
