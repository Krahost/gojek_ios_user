//
//  XuberProviderDetailCell.swift
//  GoJekUser
//
//  Created by on 14/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import SDWebImage

class XuberProviderDetailCell: UITableViewCell {
    
    @IBOutlet weak var userNameLabel : UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var staticDescriptionLabel: UILabel!
    @IBOutlet weak var providerDescLabel: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var descOuterView: UIView!

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
        DispatchQueue.main.async {
            self.profileImage.setRoundCorner()
        }
    }
    
    
}

extension XuberProviderDetailCell {
    private func initialLoads() {
        staticDescriptionLabel.text = XuberConstant.description.localized
        userNameLabel.font = UIFont.setCustomFont(name: .bold, size: .x14)
        priceLabel.font = UIFont.setCustomFont(name: .light, size: .x12)
        distanceLabel.font = UIFont.setCustomFont(name: .light, size: .x12)
        ratingLabel.font = UIFont.setCustomFont(name: .light, size: .x12)
        setDarkMode()
    }
    
    private func setDarkMode(){
        self.contentView.backgroundColor = .boxColor
    }
    
    func setProviderValues(provider:Provider_service) {
     
        self.profileImage.sd_setImage(with: URL(string: provider.picture ?? "") , placeholderImage: #imageLiteral(resourceName: "ImagePlaceHolder"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                                               // Perform operation.
                                               if (error != nil) {
                                                   // Failed to load image
                                                    self.profileImage.image = #imageLiteral(resourceName: "ImagePlaceHolder")
                                               } else {
                                                   // Successful in loading image
                                                    self.profileImage.image = image
                                               }
                                           })
        self.userNameLabel.text = (provider.first_name ?? "") + " " + (provider.last_name ?? "")
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
