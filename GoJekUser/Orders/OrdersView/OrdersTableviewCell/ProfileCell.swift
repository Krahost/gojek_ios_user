//
//  ProfileCell.swift
//  GoJekUser
//
//  Created by Sudar on 06/07/20.
//  Copyright © 2020 Appoets. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {
    
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var userImage : UIImageView!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var totalValueLabel: UILabel!
    
    @IBOutlet weak var profileOuterView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initalLoads()
        
    }
    
    private func initalLoads(){
        DispatchQueue.main.async {
            self.userImage.setShadow(color: .red)
        }
        setFont()
        setRating()
    }
    
    func setValues(data: OrderDetailReponseData)  {
        DispatchQueue.main.async {
            self.totalLabel.isHidden = true
            self.totalValueLabel.isHidden = true
            if let transportData = data.transport {
                if let provider = transportData.provider {
                    self.userImage.setImage(with: provider.picture, placeHolder: UIImage(named: Constant.userPlaceholderImage))
                    self.userNameLabel.text = String.removeNil(provider.first_name).giveSpace+String.removeNil(provider.last_name)
                    
                    if let rating = transportData.rating {
                        self.ratingView.rating = Double(rating.user_rating ?? 1)
                    }
                }else{
                    self.profileOuterView.isHidden  = true
                }
            }
          
            if let transportData = data.service {
                if let provider = transportData.provider {
                    self.userImage.setImage(with: provider.picture, placeHolder: UIImage(named: Constant.userPlaceholderImage))
                    self.userNameLabel.text = String.removeNil(provider.first_name).giveSpace+String.removeNil(provider.last_name)
                    if let rating = transportData.rating {
                        self.ratingView.rating = Double(rating.user_rating ?? 1)
                    }
                }else{
                    self.profileOuterView.isHidden  = true
                }
            }
            if let foodieValue = data.order {
                
                if let provider = foodieValue.provider {
                    self.userImage.setImage(with: provider.picture, placeHolder: UIImage(named: Constant.userPlaceholderImage))
                    self.userNameLabel.text = String.removeNil(provider.first_name).giveSpace+String.removeNil(provider.last_name)
                    //                    self.ratingView.rating = Double(provider.rating ?? 1.0).rounded(.awayFromZero)
                    if let rating = foodieValue.rating {
                        self.ratingView.rating = Double(rating.user_rating ?? 1)
                    }
                }else{
                    self.profileOuterView.isHidden  = true
                }
            }
            
            if let courierValue = data.delivery {
                self.totalLabel.isHidden = false
                self.totalValueLabel.isHidden = false
                if let provider = courierValue.provider {
                    self.userImage.setImage(with: provider.picture, placeHolder: UIImage(named: Constant.userPlaceholderImage))
                    self.totalValueLabel.text = courierValue.total_amount?.setCurrency()
                    self.userNameLabel.text = String.removeNil(provider.first_name).giveSpace+String.removeNil(provider.last_name)
                    //                    self.ratingView.rating = Double(provider.rating ?? 1.0).rounded(.awayFromZero)
                    if let rating = courierValue.rating {
                        self.ratingView.rating = Double(rating.user_rating ?? 1)
                    }
                }else{
                    self.profileOuterView.isHidden  = true
                }
            }
        }
    }
    
    private func setRating() {
        self.ratingView.minRating = 1
        self.ratingView.maxRating = 5
        self.ratingView.emptyImage = UIImage(named: Constant.ratingEmptyImage)
        self.ratingView.fullImage = UIImage(named: Constant.ratingFull)
        self.ratingView.emptyTintColor = .lightGray
        self.ratingView.fullImageTintColor = .taxiColor
        self.totalLabel.textColor = .appPrimaryColor
    }
    
    private func setFont() {
        userNameLabel.font = UIFont.setCustomFont(name: .medium, size: .x12)
        totalLabel.font = UIFont.setCustomFont(name: .bold, size: .x12)
        totalValueLabel.font = UIFont.setCustomFont(name: .medium, size: .x12)
        totalLabel.text = OrderConstant.total
    }
    
    override func layoutSubviews() {
        self.userImage.setRoundCorner()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
