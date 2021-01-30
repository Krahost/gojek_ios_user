//
//  XuberApplyCouponCell.swift
//  GoJekUser
//
//  Created by Ansar on 19/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class XuberApplyCouponCell: UITableViewCell {
    
    @IBOutlet weak var staticApplyCouponLabel: UILabel!
    @IBOutlet weak var couponTextField: UITextField!
    @IBOutlet weak var applyButton: UIButton!
    
    var onTapCouponCode:(()->Void)?
    var onTapApply:((Int)->Void)?
    
    
    override func layoutSubviews() {
        self.couponTextField.superview?.addDashLine(strokeColor: .xuberColor, lineWidth: 0.5)
        self.couponTextField.superview?.setCornerRadiuswithValue(value: 5.0)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        couponTextField.delegate = self
        staticApplyCouponLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        couponTextField.font = UIFont.setCustomFont(name: .medium, size: .x14)
        applyButton.titleLabel?.font = UIFont.setCustomFont(name: .medium, size: .x14)
        self.applyButton.backgroundColor = UIColor.xuberColor.withAlphaComponent(0.3)
        self.applyButton.setTitleColor(.xuberColor, for: .normal)
        applyButton.setTitle(Constant.apply.localized, for: .normal)
        self.applyButton.addTarget(self, action: #selector(tapApply), for: .touchUpInside)
        self.staticApplyCouponLabel.text = XuberConstant.applyCoupon.localized
        self.couponTextField.superview?.backgroundColor = UIColor.xuberColor.withAlphaComponent(0.1)
        setDarkMode()
    }
    
    private func setDarkMode(){
        self.contentView.backgroundColor = .boxColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func tapApply() {
        self.onTapApply!(self.applyButton.currentTitle == Constant.apply.localized ? 0 : 1)
    }
    
}

extension  XuberApplyCouponCell: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.onTapCouponCode!()
        return false
    }
}
