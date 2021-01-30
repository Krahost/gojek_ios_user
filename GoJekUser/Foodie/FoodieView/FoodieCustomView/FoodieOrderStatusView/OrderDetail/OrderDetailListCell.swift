//
//  OrderDetailListCell.swift
//  GoJekUser
//
//  Created by Ansar on 18/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class OrderDetailListCell: UITableViewCell {
    
    @IBOutlet weak var AddonsLabel: UILabel!
    @IBOutlet weak var vegNonVegImage: UIImageView!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var isVeg: Bool = false {
        didSet {
            vegNonVegImage.image = UIImage(named: isVeg ? FoodieConstant.ic_veg : FoodieConstant.ic_nonveg)
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

//MARK: - Methods
extension OrderDetailListCell {
    private func initialLoads()  {
        foodNameLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        priceLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        foodNameLabel.textColor = .darkGray
        priceLabel.textColor = .darkGray
        AddonsLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        self.contentView.backgroundColor = .boxColor
    }
}
