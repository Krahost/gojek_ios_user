//
//  PaymentView.swift
//  GoJekUser
//
//  Created by Ansar on 08/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class PaymentView: UIView {
    
    @IBOutlet weak var addAmountButton: UIButton!
    @IBOutlet weak var walletLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var walletOuterView: UIView!
    @IBOutlet weak var cashTextField: UITextField!
    @IBOutlet weak var walletButtonStackView: UIStackView!
    @IBOutlet weak var walletImageView: UIImageView!
    @IBOutlet weak var walletAmtLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialLoads()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addAmountButton.setBothCorner()
    }
}

extension PaymentView {
    
    private func initialLoads() {
        
        self.addAmountButton.setTitle(Constant.addAmount.localized, for: .normal)
        self.setCustomFont()
        self.setCustomColor()
        setDarkMode()
    }
    
    private func setDarkMode(){
        self.walletOuterView.backgroundColor = .boxColor
        self.cashTextField.textColor = .darkGray

    }
    
    private func setCustomColor() {
        
        self.backgroundColor = .veryLightGray
        self.addAmountButton.backgroundColor = UIColor.appPrimaryColor
        self.cashTextField.backgroundColor = .veryLightGray
        self.walletOuterView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        self.addAmountButton.setTitleColor(.white, for: .normal)
        
        var walletImage = UIImage.init(named: Constant.walletImage)
        walletImage = walletImage?.withRenderingMode(.alwaysTemplate)
        walletImage = walletImage?.imageTintColor(color1: .appPrimaryColor)
        self.walletImageView.image = walletImage
    }

    private func setCustomFont() {
        let currencySymbol = AppManager.shared.getUserDetails()?.currency_symbol ?? ""
        walletAmtLabel.font = UIFont.setCustomFont(name: .bold, size: .x22)
        walletLabel.font = UIFont.setCustomFont(name: .medium, size: .x16)
        currencyLabel.font = UIFont.setCustomFont(name: .bold, size: .x18)
        walletAmtLabel.textColor = UIColor.black
        walletAmtLabel.textAlignment = .center
        currencyLabel.text = currencySymbol
        addAmountButton.titleLabel?.font = UIFont.setCustomFont(name: .bold, size: .x20)
        currencyLabel.adjustsFontSizeToFitWidth = true
        for subView in walletButtonStackView.subviews {
            if let button = subView as? UIButton {
                button.backgroundColor = .darkGray
                button.titleLabel?.adjustsFontSizeToFitWidth = true
                button.titleLabel?.font = UIFont.setCustomFont(name: .medium, size: .x14)
                button.setCornerRadiuswithValue(value: 5.0)
                button.setTitle("\(button.tag*50)", for: .normal)
                button.addTarget(self, action: #selector(tapWalletCash(_:)), for: .touchUpInside)
            }
        }
    }
    
    @objc func tapWalletCash(_ sender: UIButton) {
        cashTextField.text = String(sender.titleLabel?.text ?? "")
    }
}


