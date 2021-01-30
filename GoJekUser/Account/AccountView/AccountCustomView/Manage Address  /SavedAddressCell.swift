//
//  SavedAddressCell.swift
//  GoJekUser
//
//  Created by Ansar on 25/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class SavedAddressCell: UITableViewCell {
    
    //MARK: - IBOutlet
    @IBOutlet weak var addressTypeLabel:UILabel!
    @IBOutlet weak var addressDetailLabel:UILabel!
    @IBOutlet weak var addressTypeImageView:UIImageView!
    @IBOutlet weak var deleteButton:UIButton!
    @IBOutlet weak var editButton:UIButton!
    @IBOutlet weak var outterView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialLoads()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}

//MARK: - LocalMethod

extension SavedAddressCell {
    
    private func initialLoads() {

        addressTypeLabel.textColor = .black
        addressDetailLabel.textColor = .lightGray
        deleteButton.textColor(color: .appPrimaryColor)
        editButton.textColor(color: .appPrimaryColor)
        editButton.setTitle(AccountConstant.edit.localized, for: .normal)
        deleteButton.setTitle(AccountConstant.delete.localized, for: .normal)
        
        editButton.titleLabel?.font = UIFont.setCustomFont(name: .medium, size: .x16)
        deleteButton.titleLabel?.font = UIFont.setCustomFont(name: .medium, size: .x16)
        addressTypeLabel.font = UIFont.setCustomFont(name: .medium, size: .x16)
        addressDetailLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        setDarkMode()
    }
    
    private func setDarkMode(){
        outterView.backgroundColor = .boxColor
        addressTypeLabel.textColor = .blackColor
    }
    
    func setCellValues(values: AddressResponseData)  {
        
        if let addressType = values.address_type {
            if addressType.uppercased() == AddressType.Other.rawValue.uppercased() {
                self.addressTypeLabel.text = values.title
            }
            else {
                self.addressTypeLabel.text = addressType.localized
            }
        }
        
        self.addressDetailLabel.text = values.locationAddress()
        if let addressImage = AddressType(rawValue: values.address_type ?? "") {
            self.addressTypeImageView.image = UIImage(named: addressImage.image)
            self.addressTypeImageView.imageTintColor(color1: .lightGray)
        }
    }
}
