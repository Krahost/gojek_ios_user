//
//  XuberProviderCell.swift
//  GoJekUser
//
//  Created by on 14/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import SDWebImage

class XuberProviderCell: UITableViewCell {
    
    @IBOutlet weak var providerImage: UIImageView!
    
    @IBOutlet weak var providerNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var outerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        initialLoads()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async {
            self.providerImage.setRoundCorner()
        }
    }
    
    func setValues(provider: Provider_service) {
        
        self.providerImage.sd_setImage(with: URL(string: provider.picture ?? "")  , placeholderImage: #imageLiteral(resourceName: "ic_user"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
            // Perform operation.
            if (error != nil) {
                // Failed to load image
                self.providerImage.image = #imageLiteral(resourceName: "ic_user")
            } else {
                // Successful in loading image
                self.providerImage.image = image
            }
        })
        
        self.providerNameLabel.text = (provider.first_name ?? "") + " " + (provider.last_name ?? "")
        let fareDetails = getFareDetails(provider: provider)
        let baseModel = AppManager.shared.getUserDetails()
        let currency = baseModel?.currency ?? ""
        self.priceLabel.text = currency + fareDetails.1 //fareDetails.0.setCurrency()
        self.ratingLabel.text = provider.rating?.roundOff(1)
        if let distance = provider.distance?.roundOff(1) {
            self.distanceLabel.text = distance.giveSpace + XuberConstant.kmAway
        }
    }
}   

extension XuberProviderCell {
    private func initialLoads() {
        self.outerView.setBorder(width: 1.0, color: .lightGray)
        self.providerNameLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        self.priceLabel.font = UIFont.setCustomFont(name: .medium, size: .x12)
        self.distanceLabel.font = UIFont.setCustomFont(name: .medium, size: .x12)
        self.ratingLabel.font = UIFont.setCustomFont(name: .medium, size: .x12)
        setDarkMode()
    }
    
    private func setDarkMode(){
        self.contentView.backgroundColor = .boxColor
        self.outerView.backgroundColor = .backgroundColor
        self.providerNameLabel.textColor = .blackColor

    }
}
