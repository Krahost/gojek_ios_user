//
//  ShopDetailTableViewCell.swift
//  GoJekUser
//
//  Created by CSS on 07/06/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class ShopDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var overView: UIView!
    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var mapTrackButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var shopAddressLabel: UILabel!

    var onTapMatTrack:(()->Void)?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initalLoad()
        
    }
    
    override func layoutSubviews() {
        overView.setCornerRadiuswithValue(value: 8)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func initalLoad(){
        titleLabel.text = FoodieConstant.shopDetail.uppercased()
        titleLabel.textColor = .foodieColor
        shopNameLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        titleLabel.font =  UIFont.setCustomFont(name: .medium, size: .x16)
        callButton.titleLabel?.font = UIFont.setCustomFont(name: .medium, size: .x14)
        mapTrackButton.titleLabel?.font = UIFont.setCustomFont(name: .medium, size: .x14)
        mapTrackButton.addTarget(self, action: #selector(self.tapMapTrack), for: .touchUpInside)
        self.mapTrackButton.setTitle(FoodieConstant.mapTrackTitle.localized, for: .normal)
        shopAddressLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        self.mapTrackButton.setImage(UIImage(named: FoodieConstant.ic_navigation), for: .normal)
        self.callButton.changeToRight(spacing: 20)
        
        self.mapTrackButton.changeToRight(spacing: 20)
        self.callButton.tintColor = UIColor.foodieColor
        self.callButton.setTitleColor(.foodieColor, for: .normal)
        titleLabel?.textColor = UIColor.foodieColor
        
        mapTrackButton.setTitleColor(.foodieColor, for: .normal)
        mapTrackButton.tintColor = .foodieColor
        overView.backgroundColor = .boxColor
        callButton.backgroundColor = .boxColor
        mapTrackButton.backgroundColor = .boxColor
        self.contentView.backgroundColor = .clear
        self.callButton.setImage(UIImage(named: Constant.phoneImage), for: .normal)
        
    }
    @objc func tapMapTrack() {
        self.onTapMatTrack?()
    }
    
}
