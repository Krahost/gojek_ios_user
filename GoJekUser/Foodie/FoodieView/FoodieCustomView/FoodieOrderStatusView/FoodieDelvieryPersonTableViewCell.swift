//
//  FoodieDelvieryPersonTableViewCell.swift
//  GoJekUser
//
//  Created by Thiru on 09/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class FoodieDelvieryPersonTableViewCell: UITableViewCell {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var delvieryLabel: UILabel!
    @IBOutlet weak var etaLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var deliveryPersonNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var etaView: UIView!
    
     @IBOutlet weak var phoneButton: UIButton!
     @IBOutlet weak var mapTrackButton: UIButton!
    
    @IBOutlet weak var deliveryView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var msgButton: UIButton!
    var onTapMatTrack:(()->Void)?
    
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
        self.etaView.setCornerRadius()
        self.etaView.setBorder(width: 1.0, color: .foodieColor)
        self.etaView.backgroundColor = UIColor.foodieColor.withAlphaComponent(0.1)
        self.profileImageView.setCornerRadius()
        self.profileImageView.setBorder(width: 5.0, color: .white)
        deliveryView.setCornerRadiuswithValue(value: 8)
        mapTrackButton.backgroundColor = .boxColor
        topView.backgroundColor = .boxColor
        phoneButton.backgroundColor = .boxColor
        msgButton.backgroundColor = .boxColor

    }
    
}

//MARK: - Methods

extension FoodieDelvieryPersonTableViewCell {
    private func initialLoads() {
        self.delvieryLabel.text = FoodieConstant.deliveryPersonDetail.uppercased()
        self.nameLabel.text = FoodieConstant.name
        self.etaLabel.text = FoodieConstant.eta.uppercased()
        self.etaLabel.textColor = UIColor.foodieColor
        self.delvieryLabel.textColor = UIColor.foodieColor
        self.mapTrackButton.setTitle(FoodieConstant.mapTrackTitle, for: .normal)
        self.phoneButton.tintColor = UIColor.foodieColor
        self.mapTrackButton.tintColor = UIColor.foodieColor
        self.msgButton.tintColor = UIColor.foodieColor
        deliveryView.backgroundColor = UIColor.foodieColor

        self.phoneButton.setImage(UIImage(named: Constant.phoneImage), for: .normal)
        self.mapTrackButton.setImage(UIImage(named: Constant.ic_map), for: .normal)
        if CommonFunction.checkisRTL() {
            self.phoneButton.setImageTitle(spacing: -8)
            self.mapTrackButton.setImageTitle(spacing: -8)
            msgButton.setImageTitle(spacing: -8)
        }else {
            self.phoneButton.setImageTitle(spacing: 10)
            self.mapTrackButton.setImageTitle(spacing: 10)
            msgButton.setImageTitle(spacing: 10)
        }
        
        self.mapTrackButton.addTarget(self, action: #selector(self.tapMapTrack), for: .touchUpInside)
        msgButton.setTitleColor(.foodieColor, for: .normal)
        msgButton.setTitle(FoodieConstant.chat, for: .normal)
        msgButton.setImage(UIImage(named: Constant.chatImage), for: .normal)
        setFont()
    }
    private func setFont() {
        self.delvieryLabel.font = UIFont.setCustomFont(name: .medium, size: .x16)
        self.nameLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        self.etaLabel.font = UIFont.setCustomFont(name: .medium, size: .x12)
        self.deliveryPersonNameLabel.font = UIFont.setCustomFont(name: .medium, size: .x12)
        self.dateLabel.font = UIFont.setCustomFont(name: .medium, size: .x12)
        self.timeLabel.font = UIFont.setCustomFont(name: .medium, size: .x10)
        phoneButton.titleLabel?.font = UIFont.setCustomFont(name: .medium, size: .x14)
        mapTrackButton.titleLabel?.font = UIFont.setCustomFont(name: .medium, size: .x14)
        msgButton.titleLabel?.font = UIFont.setCustomFont(name: .medium, size: .x14)
    }
    
    @objc func tapMapTrack() {
        self.onTapMatTrack?()
    }
}
