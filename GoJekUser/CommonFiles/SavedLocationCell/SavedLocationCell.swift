//
//  SavedLocationCell.swift
//  GoJekUser
//
//  Created by Ansar on 28/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class SavedLocationCell: UITableViewCell {
    
    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var locationTitleLabel: UILabel!
    @IBOutlet weak var locationDetailsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        locationTitleLabel.font = .setCustomFont(name: .medium, size: .x12)
        locationDetailsLabel.font = .setCustomFont(name: .medium, size: .x10)
        locationDetailsLabel.textColor = .lightGray
        setDarkMode()
    }
    
    private func setDarkMode(){
        self.contentView.backgroundColor = .boxColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setLocationDetails(addressDetails:AddressResponseData) {
        setLocationMarkerImage(savedType: addressDetails.address_type ?? "")
        locationTitleLabel.text = addressDetails.address_type ?? ""
        locationDetailsLabel.text = addressDetails.locationAddress()
        
    }
    
    private func setLocationMarkerImage(savedType:String) {
        
        switch savedType {
        case PredefineAddressType.Home.rawValue:
            locationImage.image = #imageLiteral(resourceName: "ic_address_home").imageTintColor(color1: .lightGray)
        case PredefineAddressType.Work.rawValue:
            locationImage.image = #imageLiteral(resourceName: "ic_work").imageTintColor(color1: .lightGray)
        default:
            locationImage.image = #imageLiteral(resourceName: "ic_location_pin").imageTintColor(color1: .lightGray)
        }
    }
    
}
