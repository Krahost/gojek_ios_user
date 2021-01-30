//
//  payStackView.swift
//  GoJekUser
//
//  Created by apple on 01/05/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class PayStackView: UIView {
    
    @IBOutlet weak var walletTitleLabel: UILabel!
    @IBOutlet weak var walletAmtTextField: UITextField!
    @IBOutlet weak var seperaterLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var payStackView: UIView!
    
    var onClickSubmit: ((String?)->())?
    var onClickCancel: ((String?)->())?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.walletAmtTextField.delegate = self as? UITextFieldDelegate
        self.walletTitleLabel.font = UIFont.setCustomFont(name: .bold, size: .x16)
        self.submitButton.titleLabel?.font = UIFont.setCustomFont(name: .bold, size: .x18)
        self.cancelButton.titleLabel?.font = UIFont.setCustomFont(name: .bold, size: .x18)
        self.walletAmtTextField.font = UIFont.setCustomFont(name: .bold, size: .x20)
        
        self.payStackView.setCornerRadiuswithValue(value: 5.0)
        self.submitButton.setTitle(Constant.SSubmit.localized, for: .normal)
        self.cancelButton.setTitle(Constant.SCancel.localized, for: .normal)
        self.cancelButton.textColor(color: .xuberColor)
        self.cancelButton.addTarget(self, action: #selector(cancelButtonAction(_:)), for: .touchUpInside)
        
        self.submitButton.textColor(color: .xuberColor)
        self.submitButton.addTarget(self, action: #selector(submitButtonAction(_:)), for: .touchUpInside)
        
        let userDetails = AppManager.shared.getUserDetails()
        self.walletTitleLabel.text = "\(Constant.walletAmount.localized) ( \(userDetails?.currency_symbol ?? "$") )".uppercased()
        payStackView.backgroundColor = .backgroundColor
        walletAmtTextField.backgroundColor = .boxColor
        walletAmtTextField.textColor = .blackColor
    }
    
    @objc func submitButtonAction(_ sender: UIButton) {
        onClickSubmit?(walletAmtTextField.text)
    }
    
    @objc func cancelButtonAction(_ sender: UIButton) {
        onClickCancel?(walletAmtTextField.text)
    }
}

