//
//  OtpController.swift
//  GoJekUser
//
//  Created by CSS on 18/09/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

class OtpController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thirdTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var fourthTextField: UITextField!
    @IBOutlet weak var otpVerifyButton: UIButton!
    
    var isprofile = false
    var countryCode = ""
    var phoneNumber = ""
    var iso2 = String()
    weak var delegate: updateOtpDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initalLoads()
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension OtpController {
    private func initalLoads(){
        setNavigationTitle()
        titleLabel.text = LoginConstant.otpTitle
        self.navigationController?.isNavigationBarHidden = false
        otpVerifyButton.addShadow(radius: 3.0, color: .lightGray)
        
        otpVerifyButton.addTarget(self, action: #selector(tapOtpVerify), for: .touchUpInside)
        otpVerifyButton.backgroundColor = .appPrimaryColor
        otpVerifyButton.setTitle(LoginConstant.verify, for: .normal)
        self.title = LoginConstant.otpVerification
        
        titleLabel.font = .setCustomFont(name: .bold, size: .x18)
        firstTextField.font = .setCustomFont(name: .bold, size: .x20)
        secondTextField.font = .setCustomFont(name: .bold, size: .x20)
        thirdTextField.font = .setCustomFont(name: .bold, size: .x20)
        fourthTextField.font = .setCustomFont(name: .bold, size: .x20)
        otpVerifyButton.setTitleColor(.white, for: .normal)
        otpVerifyButton.titleLabel?.font = .setCustomFont(name: .bold, size: .x20)
        titleLabel.font = .setCustomFont(name: .bold, size: .x22)
        
        firstTextField.delegate = self
        secondTextField.delegate = self
        thirdTextField.delegate = self
        fourthTextField.delegate = self
        
        firstTextField.tintColor = .appPrimaryColor
        secondTextField.tintColor = .appPrimaryColor
        thirdTextField.tintColor = .appPrimaryColor
        fourthTextField.tintColor = .appPrimaryColor
        
        firstTextField.backgroundColor = UIColor.veryLightGray.withAlphaComponent(0.3)
        secondTextField.backgroundColor = UIColor.veryLightGray.withAlphaComponent(0.3)
        thirdTextField.backgroundColor = UIColor.veryLightGray.withAlphaComponent(0.3)
        fourthTextField.backgroundColor = UIColor.veryLightGray.withAlphaComponent(0.3)
        
        firstTextField.becomeFirstResponder()
        addTextEditChangedAction()
        setNavigationBar()
        setDarkMode()
    }
    
    private func setDarkMode(){
        self.view.backgroundColor = .backgroundColor

      }
    
    // set Navigation
    private func setNavigationBar() {
        setNavigationTitle()
        self.title = LoginConstant.otpVerification.localized
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func addTextEditChangedAction() {
        firstTextField.addTarget(self, action: #selector(textEditChanged(_:)), for: .editingChanged)
        secondTextField.addTarget(self, action: #selector(textEditChanged(_:)), for: .editingChanged)
        thirdTextField.addTarget(self, action: #selector(textEditChanged(_:)), for: .editingChanged)
        fourthTextField.addTarget(self, action: #selector(textEditChanged(_:)), for: .editingChanged)
    }
    
    @objc func tapOtpVerify() {
        self.view.endEditing()
        guard let otp1 = firstTextField.text, !otp1.isEmpty else {
            firstTextField.becomeFirstResponder()
            ToastManager.show(title: LoginConstant.InvalidOTP.localized , state: .error)
            return
        }
        
        guard let otp2 = secondTextField.text, !otp2.isEmpty else {
            secondTextField.becomeFirstResponder()
            ToastManager.show(title: LoginConstant.InvalidOTP.localized , state: .error)
            return
        }
        
        guard let otp3 = thirdTextField.text, !otp3.isEmpty else {
            thirdTextField.becomeFirstResponder()
            ToastManager.show(title: LoginConstant.InvalidOTP.localized , state: .error)
            return
        }
        
        guard let otp4 = fourthTextField.text, !otp4.isEmpty else {
            fourthTextField.becomeFirstResponder()
            ToastManager.show(title: LoginConstant.InvalidOTP.localized , state: .error)
            return
        }
        
        var otp: [String] = []
        otp.append(otp1)
        otp.append(otp2)
        otp.append(otp3)
        otp.append(otp4)
        
        let checkOtp = otp.joined()
        var param:Parameters
        param =  [LoginConstant.salt_key : APPConstant.salt_key,
                  LoginConstant.otp: checkOtp]
        if isprofile {
            
            
            let newString = countryCode.replacingOccurrences(of: "+", with: "", options: .literal, range: nil)
            
            param[LoginConstant.country_code] = newString.trimString()
            param[LoginConstant.mobile] = phoneNumber
            
        }else{
            param[LoginConstant.country_code] = (StoreLoginData.shared.countryCode  ?? "").trimString().dropFirst()
            param[LoginConstant.mobile] = StoreLoginData.shared.mobile ?? ""
        }
        
        
        loginPresenter?.verifyOtp(param: param)
        
    }
    
    private func socialSignUp(loginBy:loginBy) {
        
        let param:Parameters = [LoginConstant.salt_key: APPConstant.salt_key,
                                LoginConstant.device_type: deviceType.ios.rawValue,
                                LoginConstant.device_token: deviceTokenString,
                                LoginConstant.socialUniqueid: StoreLoginData.shared.socialAccessToken ?? "",
                                LoginConstant.device_id: UUID().uuidString,
                                LoginConstant.login_by: loginBy.rawValue,
                                LoginConstant.first_name: StoreLoginData.shared.firstName ?? "",
                                LoginConstant.last_name: StoreLoginData.shared.lastName ?? "",
                                LoginConstant.email: StoreLoginData.shared.email ?? "",
                                LoginConstant.gender: StoreLoginData.shared.gender ?? "",
                                LoginConstant.country_code: (StoreLoginData.shared.countryCode ?? "").trimString().dropFirst(),
                                LoginConstant.iso2 : self.iso2,
                                LoginConstant.mobile: StoreLoginData.shared.mobile ?? "",
                                LoginConstant.country_id: StoreLoginData.shared.countryId ?? 0,
                                LoginConstant.city_id: StoreLoginData.shared.cityId ?? 0,
                                LoginConstant.referral_code : StoreLoginData.shared.referralCode ?? ""]
        
        
        loginPresenter?.signUp(param: param, imageData: StoreLoginData.shared.profileImageData)
    }
    private func normalSignUp() {
        let param:Parameters = [LoginConstant.salt_key : APPConstant.salt_key,
                                LoginConstant.device_type : deviceType.ios.rawValue,
                                LoginConstant.device_token : deviceTokenString,
                                LoginConstant.device_id : UUID().uuidString,
                                LoginConstant.login_by : loginBy.manual.rawValue,
                                LoginConstant.password : StoreLoginData.shared.password ?? "",
                                LoginConstant.password_confirmation : StoreLoginData.shared.password ?? "",
                                LoginConstant.first_name: StoreLoginData.shared.firstName ?? "",
                                LoginConstant.last_name: StoreLoginData.shared.lastName ?? "",
                                LoginConstant.email: StoreLoginData.shared.email ?? "",
                                LoginConstant.gender: StoreLoginData.shared.gender ?? "",
                                LoginConstant.country_code: (StoreLoginData.shared.countryCode ?? "").trimString().dropFirst(),
                                LoginConstant.iso2 : self.iso2,
                                LoginConstant.mobile: StoreLoginData.shared.mobile ?? "",
                                LoginConstant.country_id: StoreLoginData.shared.countryId ?? 0,
                                LoginConstant.city_id: StoreLoginData.shared.cityId ?? 0,
                                LoginConstant.referral_code : StoreLoginData.shared.referralCode ?? ""]
        
        
        loginPresenter?.signUp(param: param, imageData: StoreLoginData.shared.profileImageData)
    }
}
//MARK: - LoginPresenterToLoginViewProtocolxs

extension OtpController: LoginPresenterToLoginViewProtocol {
    
    func signUpSuccess(signUpEntity: LoginEntity) {
        AppManager.shared.accessToken = signUpEntity.responseData?.access_token
        saveSignin(loginEntity: signUpEntity)
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        appDelegate.window?.rootViewController = TabBarController().listTabBarController()
        appDelegate.window?.makeKeyAndVisible()
    }
    //To save coredata
    func saveSignin(loginEntity: LoginEntity) {
        let fetchData = try!PersistentManager.shared.context.fetch(UserData.fetchRequest()) as? [UserData]
        if fetchData?.count ?? 0 > 0 {
            PersistentManager.shared.delete(entityName: CoreDataEntity.loginData.rawValue)
        }
        let loginDetails = LoginData(context: PersistentManager.shared.persistentContainer.viewContext)
        loginDetails.access_token = loginEntity.responseData?.access_token
        PersistentManager.shared.saveContext()
    }
    func verifyOtpSuccess(verifyOtpEntity: VerifyOtpEntity) {
        if isprofile {
            delegate?.updateOtp(countryCode: countryCode,mobile: phoneNumber)
            self.navigationController?.popViewController(animated: true)
        }else{
            if StoreLoginData.shared.loginBy == .manual {
                self.normalSignUp()
            }else{
                self.socialSignUp(loginBy: StoreLoginData.shared.loginBy!)
            }
        }
    }
    
    
    
    
}
extension OtpController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        textField.text = ""
        if textField.text == "" {
            print("Backspace has been pressed")
        }
        
        if string == "" {
            print("Backspace was pressed")
            switch textField {
            case secondTextField:
                firstTextField.becomeFirstResponder()
            case thirdTextField:
                secondTextField.becomeFirstResponder()
            case fourthTextField:
                thirdTextField.becomeFirstResponder()
            default:
                print("default")
            }
            textField.text = ""
            return false
        }
        return true
    }
    
    @objc func textEditChanged(_ sender: UITextField) {
        print("textEditChanged has been pressed")
        let count = sender.text?.count
        if count == 1{
            switch sender {
            case firstTextField:
                secondTextField.becomeFirstResponder()
            case secondTextField:
                thirdTextField.becomeFirstResponder()
            case thirdTextField:
                fourthTextField.becomeFirstResponder()
            case fourthTextField:
                fourthTextField.resignFirstResponder()
            default:
                print("default")
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if !(textField.text?.isEmpty)!{
            //textField.selectAll(self)
        }else{
            print("Empty")
            textField.text = " "
        }
    }
}
