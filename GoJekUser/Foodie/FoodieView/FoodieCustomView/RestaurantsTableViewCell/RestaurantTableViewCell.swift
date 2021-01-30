//
//  RestaurantTableViewCell.swift
//  GoJekUser
//
//  Created by Thiru on 27/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import SDWebImage

class RestaurantTableViewCell: UITableViewCell {

    //Outlets
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var descrLabel: UILabel!
    @IBOutlet weak var offerLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var detailStackView: UIStackView!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var offerView: UIStackView!
    @IBOutlet weak var closeView: UIView!
    @IBOutlet weak var closeLabel: UILabel!
    @IBOutlet weak var dotView: UIView!
    @IBOutlet weak var offerImageView: UIImageView!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var imageOuterView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        initialLoad()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
//        restaurantImageView?.applyshadowWithCorner(containerView : imageOuterView, cornerRadious : 5.0)

    }
    
    func setSearchShopListData(data: SearchResponseData,isFoodCategory: Bool){
        let placeHolderImage = UIImage(named: Constant.imagePlaceHolder)?.imageTintColor(color1: UIColor.veryLightGray.withAlphaComponent(0.5))
       
        restaurantImageView.sd_setImage(with: URL(string: data.picture ?? ""), placeholderImage: placeHolderImage,options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
            // Perform operation.
            if (error != nil) {
                // Failed to load image
                self.restaurantImageView.image = placeHolderImage
            } else {
                // Successful in loading image
                self.restaurantImageView.image = image
            }
        })
        titleLable.text = data.name
        if data.offer_percent != 0 {
            offerLabel.text = (data.item_discount?.toString() ?? "0") + FoodieConstant.offerPercent.localized
            offerView.isHidden = false
            
        }else{
            offerView.isHidden = true
            
        }
        let rateValue = Double(data.rating ?? 0).rounded(.awayFromZero)
        ratingLabel.text = rateValue.toString()
        timeLabel.text = (data.delivery_time ?? "") + FoodieConstant.mins.localized
        
       
        if isFoodCategory {
            timeLabel.isHidden = false
            dotView.isHidden = false
            
        }else{
            timeLabel.isHidden = true
            dotView.isHidden = true
        }
        descrLabel.text = data.category
        
        if data.shopstatus == "CLOSED" {
            closeView.isHidden = false
        }else{
            closeView.isHidden = true
        }
    }
    
    
    func setShopListData(data: ShopsListData){
 
        restaurantImageView.sd_setImage(with: URL(string: data.picture ?? ""), placeholderImage: #imageLiteral(resourceName: "ImagePlaceHolder"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                // Perform operation.
                if (error != nil) {
                    // Failed to load image
                    self.restaurantImageView.image = #imageLiteral(resourceName: "ImagePlaceHolder")
                } else {
                    // Successful in loading image
                    self.restaurantImageView.image = image
                }
            })

        titleLable.text = data.store_name
        if data.offer_percent != 0 {
            offerLabel.text = (data.offer_percent?.toString() ?? "0") + FoodieConstant.offerPercent.localized
            offerView.isHidden = false

        }
        else {
            offerView.isHidden = true

        }
        
         
        let rateValue = Double(data.rating ?? 0).rounded(.awayFromZero)
        ratingLabel.text = rateValue.toString()
        if data.rating == nil || data.rating == 0 {
        self.ratingView.isHidden = true
                }else{
                     self.ratingView.isHidden = false
                }
        
        if data.estimated_delivery_time == nil && data.estimated_delivery_time == "" {
            dotView.isHidden = true
            timeLabel.isHidden = true
        }else{
            dotView.isHidden = false
            timeLabel.isHidden = false
            timeLabel.text = (data.estimated_delivery_time ?? "") + FoodieConstant.mins.localized

        }
        timeLabel.isHidden = data.storetype?.category != FoodieConstant.food
        dotView.isHidden = data.storetype?.category != FoodieConstant.food
        
        var categoryNameArr: [String] = []
        categoryNameArr.removeAll()
        _ = data.categories?.filter({ (key) -> Bool in
            
            categoryNameArr.append(key.store_category_name ?? "")
            return true
        })
        
        let categorystr = categoryNameArr.joined(separator: ", ")
        descrLabel.text = categorystr
        
        if data.shopstatus == "CLOSED" {
            closeView.isHidden = false
        }else{
            closeView.isHidden = true

        }
        
    }
    
}
extension RestaurantTableViewCell {
    
    private func initialLoad() {
        
        self.backgroundColor = .clear
        restaurantImageView.setCornerRadiuswithValue(value: 8)
//        self.cellBackgroundView.addShadow(radius: 3.0, color: .lightGray)
        setFont()
        setColor()
        closeView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        closeView.setCornerRadiuswithValue(value: 8)
        closeLabel.text = FoodieConstant.closed.localized
        
        offerImageView.image = UIImage(named: FoodieConstant.ic_offer)?.imageTintColor(color1: .foodieColor)
        ratingImageView.image = UIImage(named: FoodieConstant.ic_starfilled)?.imageTintColor(color1: .foodieColor)
        setDarkMode()
    }
    
    private func setDarkMode(){
        self.cellBackgroundView.backgroundColor = .boxColor
        self.titleLable.textColor = .blackColor
    }
    
    private func setColor(){
        titleLable.textColor = UIColor.black
        descrLabel.textColor = UIColor.lightGray
        offerLabel.textColor = .foodieColor
        ratingLabel.textColor = .foodieColor
        timeLabel.textColor = UIColor.lightGray
        closeLabel.textColor = UIColor.white
    }
    
    private func setFont(){
        titleLable.font = UIFont.setCustomFont(name: .medium, size: .x16)
        descrLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        offerLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        ratingLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        timeLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        closeLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
    }
}


