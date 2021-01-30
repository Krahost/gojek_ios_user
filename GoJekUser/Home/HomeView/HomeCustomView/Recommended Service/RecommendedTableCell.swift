//
//  RecommendedTableCell.swift
//  GoJekUser
//
//  Created by Ansar on 07/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import SDWebImage

class RecommendedTableCell: UITableViewCell {
    
    @IBOutlet weak var serviceImage: UIImageView!
    @IBOutlet weak var outerView: UIView!
    
    @IBOutlet weak var serviceNameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var actionLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var errorImageView: UIImageView!
    @IBOutlet weak var errorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setFont()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setFont() {
        serviceNameLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        descLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        actionLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        errorImageView.image = UIImage(named: HomeConstant.noFetaureImage)
        errorLabel.text = HomeConstant.nofeatureService
        errorLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        errorView.isHidden = true
    }
    
    func setRecommendedData(dataSource:[ServicesDetails],indexPath:IndexPath) {
        errorLabel.text = HomeConstant.nofeatureService.localized
        if dataSource.count == 0 {
            errorView.isHidden = false
            
        }else{
            errorView.isHidden = true
            let fService = dataSource[indexPath.row - 1]
            outerView.backgroundColor = UIColor(hexString:fService.bg_color ?? "").withAlphaComponent(0.5)
            
            self.serviceImage.sd_setImage(with: URL(string: fService.featured_image ?? ""), placeholderImage:UIImage(named: Constant.userPlaceholderImage)?.imageTintColor(color1: .veryLightGray),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                // Perform operation.
                if (error != nil) {
                    // Failed to load image
                    self.serviceImage.image = UIImage(named: Constant.userPlaceholderImage)
                } else {
                    // Successful in loading image
                    self.serviceImage.image = image
                }
            })
            serviceNameLabel.text = fService.title ?? ""
            switch fService.service?.admin_service_name ?? "" {
            case "TRANSPORT" :
                actionLabel.text = "GO RIDE"
                descLabel.text = "All in one service to get you to your destination or bring the solution to you with ease."
            case "ORDER" :
                actionLabel.text = "GO ORDER"
                descLabel.text = "Plan & book service wherever and whenever you want with just a few taps."
            case "SERVICE" :
                actionLabel.text = "GET APPOINMENT"
                descLabel.text = "Our service experts are always eager to assist you on the go, all-time, every time."
                
            default:
                actionLabel.text = "GO RIDE"
            }
            actionLabel.backgroundColor = UIColor(hexString: (indexPath.row % 2 == 1) ? "#6F98BC" : "#F7D047").withAlphaComponent(0.8)
            
        }
    }
    
}
