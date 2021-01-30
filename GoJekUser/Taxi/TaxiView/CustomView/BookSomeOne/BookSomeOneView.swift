//
//  BookSomeOneView.swift
//  GoJekUser
//
//  Created by Ansar on 04/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class BookSomeOneView: UIView {
    
    @IBOutlet weak var outterView: UIView!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var contactView: UIView!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var mobileView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var contactAdminLabel: UILabel!
    var onClickSubmit:((String,String,String)->Void)?
    var onClickClose:(()->Void)?
    let baseConfig = AppConfigurationManager.shared.baseConfigModel

    override func awakeFromNib() {
        super.awakeFromNib()
        nameTextField.delegate = self
        phoneNumberTextField.delegate = self
        emailTextField.delegate = self
        initialLoads()
    }
    
}

extension BookSomeOneView {
    private func initialLoads() {
        
        submitButton.setTitleColor(.taxiColor, for: .normal)
        submitButton.setTitle(Constant.SSubmit.localized, for: .normal)
        headingLabel.text = TaxiConstant.bookSomeone.localized
        nameTextField.placeholder = Constant.SName.localized
        emailTextField.placeholder = TaxiConstant.emailOptional.localized
        phoneNumberTextField.placeholder = Constant.SPhoneNumber.localized
        submitButton.addTarget(self, action: #selector(tapSubmit), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(tapClose), for: .touchUpInside)
        setFont()
        
        
        if baseConfig?.responseData?.appsetting?.send_email == 1 && baseConfig?.responseData?.appsetting?.send_sms == 1  {
            emailView.isHidden = false
            mobileView.isHidden = false
            nameView.isHidden = false
            contactView.isHidden = true
            
        }else if baseConfig?.responseData?.appsetting?.send_email == 1   {
            emailView.isHidden = false
            mobileView.isHidden = true
             nameView.isHidden = false
            contactView.isHidden = true
            
        }else if baseConfig?.responseData?.appsetting?.send_sms == 1   {
            
            emailView.isHidden = true
            mobileView.isHidden = false
             contactView.isHidden = true
            nameView.isHidden = false
            
        }else if baseConfig?.responseData?.appsetting?.send_email == 0 && baseConfig?.responseData?.appsetting?.ride_otp == 1  && baseConfig?.responseData?.appsetting?.send_sms == 0 {
            emailView.isHidden = true
            mobileView.isHidden = true
            nameView.isHidden = true
            contactView.isHidden = false
            
        }else{
            emailView.isHidden = true
            mobileView.isHidden = true
            nameView.isHidden = true
            contactView.isHidden = false
        }
        
        contactAdminLabel.text = "To Book for someone please Contact Admin" + " \(baseConfig?.responseData?.appsetting?.supportdetails?.contact_number?.first?.number ?? "")"
        setDarkMode()
    }
    
    
    private func setDarkMode(){
        self.outterView.backgroundColor = .backgroundColor
        self.emailView.backgroundColor = .boxColor
        self.mobileView.backgroundColor = .boxColor
        self.nameView.backgroundColor = .boxColor
        self.contactView.backgroundColor = .boxColor
    }
    
    private func setFont()  {
        headingLabel.font = .setCustomFont(name: .medium, size: .x16)
        nameTextField.font = .setCustomFont(name: .medium, size: .x16)
        phoneNumberTextField.font = .setCustomFont(name: .medium, size: .x16)
        emailTextField.font = .setCustomFont(name: .medium, size: .x16)
        submitButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x16)
        contactAdminLabel.font = .setCustomFont(name: .medium, size: .x16)
    }
    
    @objc func tapSubmit() {
        
        if baseConfig?.responseData?.appsetting?.send_email == 1 && baseConfig?.responseData?.appsetting?.send_sms == 1  {
            
            guard let nameStr = nameTextField.text?.trimString(), !nameStr.isEmpty else {
                nameTextField.becomeFirstResponder()
                ToastManager.show(title: Constant.nameEmpty.localized , state: .error)
                return
            }
            guard let emailStr = emailTextField.text?.trimString(), !emailStr.isEmpty else {
                emailTextField.becomeFirstResponder()
                ToastManager.show(title: LoginConstant.validEmail.localized , state: .error)
                return
            }
            guard emailStr.isValidEmail() else {
                emailTextField.becomeFirstResponder()
                ToastManager.show(title: LoginConstant.validEmail.localized , state: .error)
                return
            }
            guard let phoneStr = phoneNumberTextField.text?.trimString(), !phoneStr.isEmpty else {
                phoneNumberTextField.becomeFirstResponder()
                ToastManager.show(title: LoginConstant.phoneEmpty.localized , state: .error)
                return
            }
            guard phoneStr.isPhoneNumber else {
                phoneNumberTextField.becomeFirstResponder()
                ToastManager.show(title: LoginConstant.validPhone.localized , state: .error)
                return
            }
            
            
            onClickSubmit!(nameStr, phoneStr, emailStr)
        }else if baseConfig?.responseData?.appsetting?.send_email == 1   {
            guard let nameStr = nameTextField.text?.trimString(), !nameStr.isEmpty else {
                nameTextField.becomeFirstResponder()
                ToastManager.show(title: Constant.nameEmpty.localized , state: .error)
                return
            }
            guard let emailStr = emailTextField.text?.trimString(), !emailStr.isEmpty else {
                emailTextField.becomeFirstResponder()
                ToastManager.show(title: LoginConstant.validEmail.localized , state: .error)
                return
            }
            guard emailStr.isValidEmail() else {
                emailTextField.becomeFirstResponder()
                ToastManager.show(title: LoginConstant.validEmail.localized , state: .error)
                return
            }
            
            
            
            onClickSubmit!(nameStr, "", emailStr)
            
        }else if baseConfig?.responseData?.appsetting?.send_sms == 1   {
            
            guard let nameStr = nameTextField.text?.trimString(), !nameStr.isEmpty else {
                nameTextField.becomeFirstResponder()
                ToastManager.show(title: Constant.nameEmpty.localized , state: .error)
                return
            }
            guard let phoneStr = phoneNumberTextField.text?.trimString(), !phoneStr.isEmpty else {
                phoneNumberTextField.becomeFirstResponder()
                ToastManager.show(title: LoginConstant.phoneEmpty.localized , state: .error)
                return
            }
            guard phoneStr.isPhoneNumber else {
                phoneNumberTextField.becomeFirstResponder()
                ToastManager.show(title: LoginConstant.validPhone.localized , state: .error)
                return
            }
            
            
            onClickSubmit!(nameStr, phoneStr, "")
            
        }else if baseConfig?.responseData?.appsetting?.send_email == 0 && baseConfig?.responseData?.appsetting?.ride_otp == 1  && baseConfig?.responseData?.appsetting?.send_sms == 0 {
            onClickSubmit!("", "", "")
        }else{
           onClickSubmit!("", "", "")
        }
        
       
       
    }
    
    @objc func tapClose() {
        onClickClose!()
    }
}

extension BookSomeOneView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing()
        return textField.resignFirstResponder()
    }
    
}
