//
//  HomeBannerCollectionViewCell.swift
//  GoJekUser
//
//  Created by Thiru on 27/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import SDWebImage
class HomeBannerCollectionViewCell: UICollectionViewCell {
    
    //Outlets
    @IBOutlet weak var offerImageView: UIImageView!
    @IBOutlet weak var getLabel: UILabel!
    @IBOutlet weak var presentageLabel: UILabel!
    @IBOutlet weak var offerLabel: UILabel!
    @IBOutlet weak var shopNow: UIButton!
    @IBOutlet weak var bannerOverView: UIView!
    
    // LifeCycles
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initialLoad()
      
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 13.0, *) {
            if UITraitCollection.current.userInterfaceStyle == .dark {
                isDarkMode = true
            }
            else {
                isDarkMode = false
            }
        }
        else{
            isDarkMode = false
        }
        setDarkMode()
    }
    
    
    
    
}
extension HomeBannerCollectionViewCell {
  
    func initialLoad() {
        DispatchQueue.main.async {
            self.offerImageView.setCornerRadiuswithValue(value: 10)
            self.shopNow.setCornerRadiuswithValue(value: 5)
            self.bannerOverView.setCornerRadiuswithValue(value: 10)
        
        }
        offerImageView.layer.shadowColor = UIColor.lightGray.cgColor
        offerImageView.layer.shadowOffset = CGSize(width: -1.0, height: 3.0)
        offerImageView.layer.shadowOpacity = 0.4
        offerImageView.layer.shadowRadius = 4.0
        offerImageView.layer.masksToBounds = false
        localize()
        setFont()
        setDarkMode()
    }
    
    
    func setDarkMode(){
        if(isDarkMode){
            self.bannerOverView.borderColor = .white
            self.bannerOverView.borderLineWidth = 1.0
        }
    }

    func localize() {
        
        getLabel.text = FoodieConstant.TGetupTo.localized
        offerLabel.text = FoodieConstant.TOffers.localized
        shopNow.setTitle(FoodieConstant.TShopNow.localized, for: .normal)
    }
    
    func setFont(){
        presentageLabel.font = UIFont.setCustomFont(name: .bold, size: .x30)
        getLabel.font = UIFont.setCustomFont(name: .medium, size: .x18)
        offerLabel.font = UIFont.setCustomFont(name: .medium, size: .x18)
        shopNow.titleLabel?.font = UIFont.setCustomFont(name: .medium, size: .x14)

    }
    
    func setPromoCodeData(data: PromocodeData){
        
        offerImageView.sd_setImage(with: URL(string: data.picture ?? ""), placeholderImage:#imageLiteral(resourceName: "ImagePlaceHolder"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
            // Perform operation.
            if (error != nil) {
                // Failed to load image
                self.offerImageView.image = #imageLiteral(resourceName: "ImagePlaceHolder")
            } else {
                // Successful in loading image
                self.offerImageView.image = image
            }
        })
        presentageLabel.text = (data.percentage?.toString() ?? "") + "%"
    }
    
}
