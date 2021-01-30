//
//  AddressCell.swift
//  CoreDataSample
//
//  Created by Ansar on 05/04/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class AddressCell: UITableViewCell {
    
    //MARK: - IBOutlet
    @IBOutlet weak var locationTextField: CustomTextField!
    @IBOutlet weak var flatTextField: CustomTextField!
    @IBOutlet weak var landmarkTextfield: CustomTextField!
    @IBOutlet weak var saveTextField: CustomTextField!
    @IBOutlet weak var titleTextfield: CustomTextField!
    
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var titleView: UIView!
    
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var enterDetails: UILabel!
    
    var titleHide: (()->Void)?
    var isHideTitle: Bool = false {
        didSet {
            titleView.isHidden = isHideTitle
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialLoads()
        customLocalize()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        confirmButton.setBothCorner()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

//MARK: - LocalMethod

extension AddressCell {
    
    private func initialLoads() {
        self.confirmButton.backgroundColor = .appPrimaryColor
        self.titleView.isHidden = true
        locationTextField.delegate = self
        flatTextField.delegate = self
        landmarkTextfield.delegate = self
        saveTextField.delegate = self
        titleTextfield.delegate = self
        
        self.backgroundColor = .veryLightGray
        self.detailView.setCornerRadiuswithValue(value: 5.0)
    }
    
    private func customLocalize() {
        
        self.locationTextField.placeholder = AccountConstant.location
        self.flatTextField.placeholder = AccountConstant.flatNo
        self.landmarkTextfield.placeholder = AccountConstant.landmark
        self.saveTextField.placeholder = AccountConstant.saveAs
        self.titleTextfield.placeholder = AccountConstant.title
        self.enterDetails.text = AccountConstant.enterDetail.localized
        self.confirmButton.setTitle(AccountConstant.confirmLocation.localized, for: .normal)
    }
    
    func setCellValues(values: AddressResponseData)  {
        
        self.locationTextField.text = values.street
        self.flatTextField.text =  values.flat_no
        self.saveTextField.text = values.address_type
        self.landmarkTextfield.text = values.landmark
    }
}

//MARK: - UITextFieldDelegate

extension AddressCell: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == saveTextField  {
            self.titleHide?()
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing()
        return true
    }
}
