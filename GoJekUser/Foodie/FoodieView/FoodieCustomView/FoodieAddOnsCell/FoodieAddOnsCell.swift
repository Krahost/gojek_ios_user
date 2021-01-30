//
//  FoodieAddOnsCell.swift
//  GoJekUser
//
//  Created by CSS on 07/05/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class FoodieAddOnsCell: UITableViewCell {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addOnsImageView: UIImageView!
    @IBOutlet weak var addOnsNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initalLoad()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func initalLoad(){
        addOnsNameLabel.font =  UIFont.setCustomFont(name: .medium, size: .x14)
        priceLabel.font =  UIFont.setCustomFont(name: .medium, size: .x14)
        addOnsImageView.image = UIImage(named: Constant.circleImage)
        self.contentView.backgroundColor = .boxColor
    }
    
    func setSelectedAddons(isSelected :Bool) {
//        if isSelected {
//            addOnsImageView.image = UIImage(named: Constant.circleFullImage)
//
//        }else {
//            addOnsImageView.image = UIImage(named: Constant.circleImage)
//        }
    }
    
}
