//
//  TipsView.swift
//  GoJekUser
//
//  Created by Ansar on 05/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class TipsView: UIView {
    
    @IBOutlet weak var tipTitleLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var amountTextFieldView: UIView!
    
    @IBOutlet weak var firstTipLabel: UILabel!
    @IBOutlet weak var secondTipLabel: UILabel!
    @IBOutlet weak var thirdTipLabel: UILabel!
    @IBOutlet weak var othersLabel: UILabel!
    
    var amountArr = ["5","10","15","Other"]
    var labelArr:[UILabel] = []
    var buttonColor:UIColor = .appPrimaryColor
    
    var onClickAdd:((String)->Void)?
    var selectedIndex = 0  {
        didSet {
            for subView in stackView.subviews {
                if let innerView = subView.subviews.first {
                    if let currentButton = innerView as? RoundedRectButton {
                        currentButton.buttonColor = buttonColor
                        currentButton.selectedButton = currentButton.tag == selectedIndex
                        amountTextFieldView.isHidden  = selectedIndex != 4
                    }
                }
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        initialLoads()
    }

}

extension TipsView {
    private func initialLoads() {
        self.amountTextField.delegate = self
        tipTitleLabel.text = Constant.tips.localized
        amountTextField.placeholder = Constant.enterTips.localized
        addButton.setTitleColor(self.buttonColor, for: .normal)
        addButton.setTitle(Constant.add.localized, for: .normal)
        addButton.addTarget(self, action: #selector(tapAddAmount(_:)), for: .touchUpInside)
        self.closeButton.addTarget(self, action: #selector(tapClose), for: .touchUpInside)
        amountTextFieldView.isHidden = true
        for subView in stackView.subviews {
            if let innerView = subView.subviews.first {
                if let currentButton = innerView as? RoundedRectButton {
                    currentButton.addTarget(self, action: #selector(tapAmountButton(_:)), for: .touchUpInside)
                    currentButton.borderWidth = Double(currentButton.frame.height/4)
                    currentButton.buttonBorderColor = .veryLightGray
                }
            }
        }
        labelArr = [firstTipLabel,secondTipLabel,thirdTipLabel,othersLabel]
        for label in labelArr {
            if  amountArr[label.tag].isInt() {
                label.text = Double(amountArr[label.tag])?.setCurrency()
            }else{
                label.text = amountArr[label.tag]
            }
        }
    }
    
    @objc func tapClose() {
        self.onClickAdd?("") //remove if touch outside
    }
    
    @objc func tapAmountButton(_ sender: UIButton) {
        selectedIndex = sender.tag
    }
    
    @objc func tapAddAmount(_ sender: UIButton) {
        guard selectedIndex != 0 else {
            AppAlert.shared.simpleAlert(view: UIApplication.topViewController() ?? UIViewController(), title: Constant.tipErrorMsg.localized, message: "")
            return
        }
        if selectedIndex == 4 && (self.amountTextField.text?.isEmpty)! {
            AppAlert.shared.simpleAlert(view: UIApplication.topViewController() ?? UIViewController(), title: Constant.tipErrorMsg.localized, message: "")
            return
        }
        self.onClickAdd?(selectedIndex == 4 ? self.amountTextField.text ?? "" : amountArr[selectedIndex-1])
    }
    
}

extension TipsView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing()
        return true
    }
}
