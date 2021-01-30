//
//  XuberLocationCell.swift
//  GoJekUser
//
//  Created by on 14/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class XuberLocationCell: UITableViewCell {
    
    @IBOutlet weak var locationTypeImage: UIImageView!
    
    @IBOutlet weak var locationTitleLabel: UILabel!
    @IBOutlet weak var locationDescLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        initialLoads()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
    func setCellValues(values: AddressResponseData)  {
        
        self.locationDescLabel.text = values.locationAddress()
        self.locationTitleLabel.text = values.address_type
        if let addressImage = AddressType(rawValue: values.address_type ?? "") {
            self.locationTypeImage.image = UIImage(named: addressImage.image)
            self.locationTypeImage.imageTintColor(color1: .lightGray)
        }
    }
}

extension XuberLocationCell {
    private func initialLoads() {
        locationTitleLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        locationDescLabel.font = UIFont.setCustomFont(name: .medium, size: .x12)
        setDarkMode()
    }
    
    private func setDarkMode(){
        locationTitleLabel.textColor = .blackColor
        self.contentView.backgroundColor = .boxColor
    }
}
