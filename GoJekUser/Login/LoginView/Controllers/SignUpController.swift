//
//  SignUpController.swift
//  GoJekUser
//
//  Created by Ansar on 21/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire
import GoogleSignIn
import AuthenticationServices
import PhoneNumberKit

class SignUpController: UIViewController {
    
    
    @IBOutlet weak var outterView: UIView!
    @IBOutlet weak var createAccountLabel:UILabel!
    @IBOutlet weak var alreadyHaveAccLabel:UILabel!
    @IBOutlet weak var genderLabel:UILabel!
    @IBOutlet weak var staticSocialLoginLabel: InsetLabel!
    @IBOutlet weak var facebookView: UIView!
    @IBOutlet weak var googleView: UIView!
    @IBOutlet weak var signUpView:RoundedView!
    @IBOutlet weak var signInButton:UIButton!
    @IBOutlet weak var tcCheckBoxButton:UIButton!
    @IBOutlet weak var termsConditionTitleButton: UIButton!
    @IBOutlet weak var showPasswordButton:UIButton!
    @IBOutlet weak var maleButton:UIButton!
    @IBOutlet weak var femaleButton:UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var topView:UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var socialSignupOuterView:UIView!
    @IBOutlet weak var optionalLabel: UILabel!
    @IBOutlet weak var referralView: UIView!
    @IBOutlet weak var appleView: UIView!
    @IBOutlet weak var appleButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    
    //Textfield
    @IBOutlet weak var firstNameTextfield:CustomTextField!
    @IBOutlet weak var lastNameTextfield:CustomTextField!
    @IBOutlet weak var countryCodeTextfield:CustomTextField!
    @IBOutlet weak var phoneNumberTextfield:CustomTextField!
    @IBOutlet weak var emailTextfield:CustomTextField!
    @IBOutlet weak var passwordTextfield:CustomTextField!
    @IBOutlet weak var countryTextfield:CustomTextField!
    @IBOutlet weak var cityTextfield:CustomTextField!
    @IBOutlet weak var referalTextfield:CustomTextField!
    
    var iso2 = String()
    var isAcceptTerms = false {
        didSet {
            var image = UIImage()
            image = UIImage(named: isAcceptTerms ? Constant.squareFill : Constant.sqaureEmpty)!
            tcCheckBoxButton.setImage(image, for: .normal)
        }
    }
    
    var isMaleFemale:Bool = false { //true - male , false - female
        didSet {
            maleButton.setImage(UIImage(named: isMaleFemale ? Constant.circleFullImage : Constant.circleImage), for: .normal)
            femaleButton.setImage(UIImage(named: isMaleFemale ? Constant.circleImage : Constant.circleFullImage), for: .normal)
        }
    }
    
    var isShowPassword: Bool = false {
        didSet {
            passwordTextfield.isSecureTextEntry = isShowPassword
            showPasswordButton.setImage(UIImage(named: isShowPassword ? Constant.eyeOff : Constant.eye), for: .normal)
        }
    }
    
    var isSocialSignup:Bool = false {
        didSet {
            passwordView.isHidden = isSocialSignup
        }
    }
    
    private var countryDetail: Country? {
        didSet {
            if countryDetail != nil {
                countryCodeTextfield.text = "   \(countryDetail?.dial_code ?? "")"
                iso2 = countryDetail?.code ?? ""
                countryCodeTextfield.setFlag(imageStr: "CountryPicker.bundle/"+(countryDetail?.code ?? "US"))
            }
        }
    }
    
    var selectedCityId:Int = 0
    var selectedCountryId:Int = 0
    var selectedStateId:Int = 0
    var accessToken : String?
    var firstName = ""
    var lastName = ""
    var email = ""
    var profileImageStr = ""
    var loginby: loginBy = .manual
    let phoneNumberKit = PhoneNumberKit()

    var countryList: [String] = []
    var countryData: [CountryData] = []
    var cityData: [CityData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoads()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        if CommonFunction.checkisRTL() {
            facebookButton.changeToRight(spacing: -15)
            googleButton.changeToRight(spacing: -15)
            maleButton.changeToRight(spacing: -10)
            femaleButton.changeToRight(spacing: -10)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        topView.roundedTop(desiredCurve: topView.frame.height/3)
    }
}

extension SignUpController {
    private func initialLoads() {
        setupSignInButton()
        signUpView.addShadow(radius: 3.0, color: .lightGray)
        optionalLabel.textColor = .lightGray
        optionalLabel.text = LoginConstant.optional.localized
        optionalLabel.font = .setCustomFont(name: .medium, size: .x12)
//        view.backgroundColor = .veryLightGray
        tcCheckBoxButton.addTarget(self, action: #selector(tapTermsCondtions(_:)), for: .touchUpInside)
        signInButton.addTarget(self, action: #selector(tapSignIn(_:)), for: .touchUpInside)
        showPasswordButton.addTarget(self, action: #selector(showPassword), for: .touchUpInside)
        maleButton.addTarget(self, action: #selector(tapGender(_:)), for: .touchUpInside)
        femaleButton.addTarget(self, action: #selector(tapGender(_:)), for: .touchUpInside)
        termsConditionTitleButton.addTarget(self, action: #selector(tapTCTitle(_:)), for: .touchUpInside)
        let signUp = UITapGestureRecognizer(target: self, action: #selector(tapSignUp))
        signUpView.addGestureRecognizer(signUp)
        maleButton.setImageTitle(spacing: 10)
        femaleButton.setImageTitle(spacing: 10)
        femaleButton.imageEdgeInsets = UIEdgeInsets(top: 4, left: 6, bottom: 4, right: 6)
        femaleButton.imageView?.contentMode = .scaleAspectFit
        maleButton.imageEdgeInsets = UIEdgeInsets(top: 4, left: 6, bottom: 4, right: 6)
        maleButton.imageView?.contentMode = .scaleAspectFit
        facebookButton.setImage(UIImage(named: LoginConstant.faceBookImage), for: .normal)
        googleButton.setImage(UIImage(named: LoginConstant.googleImage), for: .normal)
        facebookButton.setImageTitle(spacing: 20)
        googleButton.setImageTitle(spacing: 20)
        self.appleView.backgroundColor = .black
        self.appleView.setCornerRadiuswithValue(value: 5)
        facebookView.setCornerRadiuswithValue(value: 5)
        googleView.setCornerRadiuswithValue(value: 5)
        
        facebookButton.addTarget(self, action: #selector(tapFacebook), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(tapGoogle), for: .touchUpInside)
        
        setColors()
        localize()
        getCountries()
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            let countryCodeList = AppUtils.shared.getCountries()
            for eachCountry in countryCodeList {
                if countryCode == eachCountry.code {
                    countryDetail = Country(name: eachCountry.name, dial_code: eachCountry.dial_code, code: eachCountry.code)
                }
            }
        }
        
        isSocialSignup = loginby != .manual
        if isSocialSignup {
            setSocialValues()
        }
        let baseConfig = AppConfigurationManager.shared.baseConfigModel
        //Hide social signin
        if baseConfig?.responseData?.appsetting?.referral == 0 {
            referralView.isHidden = true
        }
        
        if baseConfig?.responseData?.appsetting?.referral == 0 {
            referralView.isHidden = true
        }
        
        loginByUpdate()
        setDarkMode()
    }
   
    private func setDarkMode(){
        self.socialSignupOuterView.backgroundColor = .backgroundColor
        self.view.backgroundColor = .backgroundColor
        self.googleView.backgroundColor = .boxColor
        self.facebookView.backgroundColor = .boxColor
        self.firstNameTextfield.textColor = .blackColor
        self.lastNameTextfield.textColor = .blackColor
        self.countryCodeTextfield.textColor = .blackColor
        self.phoneNumberTextfield.textColor = .blackColor
        self.emailTextfield.textColor = .blackColor
        self.passwordTextfield.textColor = .blackColor
        self.countryTextfield.textColor = .blackColor
        self.cityTextfield.textColor = .blackColor
        self.referalTextfield.textColor = .blackColor
        self.createAccountLabel.textColor = .blackColor
        self.stackView.backgroundColor = .boxColor
        self.outterView.backgroundColor = .boxColor
        self.facebookButton.setTitleColor(.blackColor, for: .normal)
        self.googleButton.setTitleColor(.blackColor, for: .normal)
      }
    
    
    private func setColors() {
        signUpView.centerImageView.imageTintColor(color1: .white)
        signUpView.backgroundColor = .appPrimaryColor
        termsConditionTitleButton.setTitleColor(.darkGray, for: .normal)
        alreadyHaveAccLabel.textColor = .darkGray
        createAccountLabel.textColor = .black
        signInButton.textColor(color: .appPrimaryColor)
        facebookButton.setTitleColor(.black, for: .normal)
        googleButton.setTitleColor(.black, for: .normal)
    }
    
    private func loginByUpdate() {
        if loginby != .manual {
            socialSignupOuterView.isHidden = true
            let attrString = NSMutableAttributedString(string: "Welcome to \(APPConstant.appName)\n",
                attributes: [NSAttributedString.Key.font: UIFont.init(name: FontType.medium.rawValue, size: 20)!])
            attrString.append(NSMutableAttributedString(string: LoginConstant.completeaccount.localized,
                                                        attributes: [NSAttributedString.Key.font: UIFont.init(name: FontType.light.rawValue, size: 12)!]))
            createAccountLabel.attributedText = attrString
            alreadyHaveAccLabel.isHidden = true
            signInButton.setTitle(LoginConstant.close.localized, for: .normal)
        } else {
            createAccountLabel.text = LoginConstant.createAccount.localized
            let baseConfig = AppConfigurationManager.shared.baseConfigModel
            socialSignupOuterView.isHidden = baseConfig?.responseData?.appsetting?.social_login == 0
        }
    }
    
    private func localize() {
        createAccountLabel.text = LoginConstant.createAccount.localized
        alreadyHaveAccLabel.text = LoginConstant.alreadyHaveAcc.localized
        genderLabel.text = LoginConstant.staticGender.localized
        maleButton.setTitle(LoginConstant.male.localized, for: .normal)
        femaleButton.setTitle(LoginConstant.female.localized, for: .normal)
        signInButton.setTitle(LoginConstant.signIn.localized, for: .normal)
        termsConditionTitleButton.setTitle(LoginConstant.acceptTermsCondition.localized, for: .normal)
        termsConditionTitleButton.titleLabel?.numberOfLines = 1;
        termsConditionTitleButton.titleLabel?.adjustsFontSizeToFitWidth = true;
        termsConditionTitleButton.titleLabel?.lineBreakMode = .byClipping;
        isAcceptTerms = false
        isShowPassword = true
        firstNameTextfield.autocapitalizationType = .words
        lastNameTextfield.autocapitalizationType = .words
        firstNameTextfield.placeholder = Constant.firstName.localized
        lastNameTextfield.placeholder = Constant.lastName.localized
        countryCodeTextfield.placeholder = Constant.code.localized
        phoneNumberTextfield.placeholder = Constant.phoneNumber.localized
        emailTextfield.placeholder = Constant.emailId.localized
        passwordTextfield.placeholder = Constant.password.localized
        cityTextfield.placeholder = Constant.city.localized
        countryTextfield.placeholder = Constant.country.localized
        staticSocialLoginLabel.text = LoginConstant.socialSignup.localized
        referalTextfield.placeholder = LoginConstant.referal.localized
        facebookButton.setTitle(LoginConstant.connectFacebook.localized, for: .normal)
        googleButton.setTitle(LoginConstant.connectGoogle.localized, for: .normal)
        maleButton.setImage(UIImage(named: Constant.circleImage), for: .normal)
        femaleButton.setImage(UIImage(named: Constant.circleImage), for: .normal)
        countryCodeTextfield.fieldShapeType = .Left
        phoneNumberTextfield.fieldShapeType = .Right
        setFont()
        setTermsAndConditionAttributeText()
        
    }
    
    private func setFont() {
        createAccountLabel.font = .setCustomFont(name: .medium, size: .x20)
        alreadyHaveAccLabel.font = .setCustomFont(name: .medium, size: .x14)
        firstNameTextfield.font = .setCustomFont(name: .medium, size: .x16)
        lastNameTextfield.font = .setCustomFont(name: .medium, size: .x16)
        countryCodeTextfield.font = .setCustomFont(name: .medium, size: .x16)
        phoneNumberTextfield.font = .setCustomFont(name: .medium, size: .x16)
        emailTextfield.font = .setCustomFont(name: .medium, size: .x16)
        cityTextfield.font = .setCustomFont(name: .medium, size: .x16)
        countryCodeTextfield.font = .setCustomFont(name: .medium, size: .x16)
        countryTextfield.font = .setCustomFont(name: .medium, size: .x16)
        genderLabel.font = .setCustomFont(name: .medium, size: .x16)
        passwordTextfield.font = .setCustomFont(name: .medium, size: .x16)
        staticSocialLoginLabel.font = .setCustomFont(name: .medium, size: .x20)
        referalTextfield.font = .setCustomFont(name: .medium, size: .x16)
        signInButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x14)
        termsConditionTitleButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x14)
        maleButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x14)
        femaleButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x14)
        facebookButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x14)
        googleButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x14)
    }
    
    func setTermsAndConditionAttributeText() {
        
        let text = (termsConditionTitleButton.titleLabel?.text)!
        let underlineAttriString = NSMutableAttributedString(string: text)
        let range = (text as NSString).range(of: "Terms and conditions")
        
        let linkAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.blue,
            NSAttributedString.Key.underlineColor: UIColor.blue,
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
            NSAttributedString.Key.font: UIFont.setCustomFont(name: .medium, size: .x14)]
        
        underlineAttriString.addAttributes(linkAttributes, range: range)
        termsConditionTitleButton.setAttributedTitle(underlineAttriString, for: .normal)
    }
    
    private func validation() -> Bool {
        guard let firstName = firstNameTextfield.text?.trimString(), !firstName.isEmpty else {
            firstNameTextfield.becomeFirstResponder()
            AppAlert.shared.simpleAlert(view: self, title: LoginConstant.firstNameEmpty.localized, message: nil)
            return false
        }
        guard let lastName = lastNameTextfield.text?.trimString(),  !(lastName.isEmpty ) else {
            lastNameTextfield.becomeFirstResponder()
            AppAlert.shared.simpleAlert(view: self, title: LoginConstant.lastNameEmpty.localized, message: nil)
            return false
        }
        guard let phoneNumber = phoneNumberTextfield.text?.trimString(),  !(phoneNumber.isEmpty)  else {
            phoneNumberTextfield.becomeFirstResponder()
            AppAlert.shared.simpleAlert(view: self, title: LoginConstant.phoneEmpty.localized, message: nil)
            return false
        }
        guard phoneNumber.isPhoneNumber else {
            phoneNumberTextfield.becomeFirstResponder()
            AppAlert.shared.simpleAlert(view: self, title: LoginConstant.validPhone.localized, message: nil)
            return false
        }
        guard let emailStr = emailTextfield.text?.trimString(), !(emailStr.isEmpty) else {
            emailTextfield.becomeFirstResponder()
            AppAlert.shared.simpleAlert(view: self, title: LoginConstant.emailEmpty.localized, message: nil)
            return false
        }
        guard (emailStr.isValidEmail()) else {
            emailTextfield.becomeFirstResponder()
            AppAlert.shared.simpleAlert(view: self, title: LoginConstant.validEmail.localized, message: nil)
            return false
        }
        if !isSocialSignup {
            guard let password = passwordTextfield.text?.trimString(), !password.isEmpty  else {
                passwordTextfield.becomeFirstResponder()
                AppAlert.shared.simpleAlert(view: self, title: LoginConstant.passwordEmpty.localized, message: nil)
                return false
            }
            guard password.isValidPassword else {
                passwordTextfield.becomeFirstResponder()
                AppAlert.shared.simpleAlert(view: self, title: LoginConstant.passwordlength.localized, message: nil)
                return false
            }
        }
        guard let country = countryTextfield.text?.trimString(), !country.isEmpty else {
            AppAlert.shared.simpleAlert(view: self, title: LoginConstant.countryEmpty.localized, message: nil)
            return false
        }
        guard let city = cityTextfield.text?.trimString(), !city.isEmpty else {
            AppAlert.shared.simpleAlert(view: self, title: LoginConstant.cityEmpty.localized, message: nil)
            return false
        }
        guard isAcceptTerms else {
            AppAlert.shared.simpleAlert(view: self, title: LoginConstant.notAcceptTC.localized, message: nil)
            return false
        }
        return true
    }
    
    private func getCountries() {
        let param:Parameters = [LoginConstant.salt_key : APPConstant.salt_key]
       loginPresenter?.getCountries(param: param)
    }
    
    private func showPicker(pickerType: PickerType) {
        let countryCodeView = LoginRouter.loginStoryboard.instantiateViewController(withIdentifier: LoginConstant.CountryCodeViewController) as! CountryCodeViewController
        countryCodeView.pickerType = pickerType
        
        if pickerType == .countryList {
            countryCodeView.countryListEntity = countryData
            countryCodeView.selectedCountry = { [weak self] countryDetail in
                guard let self = self else {
                    return
                }
                self.countryTextfield.text = countryDetail.country_name
                self.cityTextfield.text = .empty
                self.selectedCountryId = countryDetail.id ?? 0
                self.cityData =  countryDetail.city ?? []
            }
        }else if pickerType == .cityList {
            countryCodeView.cityListEntity = cityData
            countryCodeView.selectedCity = { [weak self] cityDetail in
                guard let self = self else {
                    return
                }
                self.cityTextfield.text = cityDetail.city_name
                self.selectedCityId = cityDetail.id ?? 0
            }
        }else {
            countryCodeView.countryCode = { [weak self] countryDetail in
                guard let self = self else {
                    return
                }
                self.countryDetail = countryDetail
                self.phoneNumberTextfield.text = ""
                if self.phoneNumberTextfield.text != "" {
                                do {
                             
                                    let phoneNumber = try self.phoneNumberKit.parse((self.phoneNumberTextfield.text ?? ""), withRegion: countryDetail.code, ignoreType: false)
                                    let formatedNumber = self.phoneNumberKit.format(phoneNumber, toType: .international)
                                           print(phoneNumber)
                                           print(formatedNumber)
                                }
                                catch {
                                    print("Generic parser error")
                                   AppAlert.shared.simpleAlert(view: self, title: LoginConstant.validPhone.localized, message: nil)

                                   
                                }
                           }
            }
        }
        self.present(countryCodeView, animated: true, completion: nil)
    }
    
    // Google Login
    
    private func googleLogin(){
        GIDSignIn.sharedInstance()?.presentingViewController = self
        let googleSignin = GoogleSignin.share
        googleSignin.getGoogleData { [weak self] (googleDetails,error) in
            guard let self = self else {
                return
            }
            if googleDetails != nil {
                self.accessToken = googleDetails?.userID ?? ""
                self.firstName = googleDetails?.profile.givenName ?? ""
                self.lastName = googleDetails?.profile.familyName ?? ""
                self.email = googleDetails?.profile.email ?? ""
                self.isSocialSignup = true
                self.loginby = .google
                self.loginByUpdate()
                self.socialLoginApi()
            } else {
                ToastManager.show(title: error ?? "", state: .warning)
            }
        }
    }
    
    private func socialLoginApi(){
        var param:Parameters
        param = [LoginConstant.salt_key: APPConstant.salt_key,
                 LoginConstant.device_type: deviceType.ios.rawValue,
                 LoginConstant.socialUniqueid: accessToken ?? .empty,
                 LoginConstant.login_by:  loginby.rawValue]
        loginPresenter?.socialLoginWithUserDetail(param: param)
    }
    
    private func setSocialValues(){
        firstNameTextfield.text = firstName
        lastNameTextfield.text = lastName
        emailTextfield.text = email
        if email == .empty {
            emailTextfield.isUserInteractionEnabled = true
        }else{
            emailTextfield.isUserInteractionEnabled = false
        }
    }
}

//MARK: - Button Action
extension SignUpController {
    
    @objc func tapSignIn(_ sender:UIButton) {
        self.view.endEditing()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: LoginConstant.SignInController) as! SignInController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func tapGender(_ sender:UIButton) {
        isMaleFemale = sender.tag == 0
    }
    
    @objc func tapTermsCondtions(_ sender:UIButton) {
        isAcceptTerms = !isAcceptTerms
    }
    
    @objc func tapTCTitle(_ sender:UIButton) {
        self.view.endEditing()
        let vc = WebViewController()
        if let termsUrl = AppConfigurationManager.shared.baseConfigModel.responseData?.appsetting?.cmspage?.terms {
            vc.urlString = termsUrl
            print("termsUrl--->",termsUrl)
        }
        vc.navTitle = LoginConstant.termsAndCondition.localized
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func tapSignUp() {
        self.view.endEditing()
        signUpView.addPressAnimation()
        if validation() {
            
            let param:Parameters = [LoginConstant.email:emailTextfield.text ?? "",
                                    LoginConstant.mobile:phoneNumberTextfield.text ?? "",
                                    LoginConstant.country_code:(countryCodeTextfield.text ?? "").trimString().dropFirst(),
                                    LoginConstant.iso2 : self.iso2,
                                    LoginConstant.salt_key : APPConstant.salt_key,
                                    LoginConstant.referral_code : referalTextfield.text ?? ""]
            loginPresenter?.verifyMobileAndEmail(param: param)
        }
    }
    
    @objc func showPassword() {
        isShowPassword = !isShowPassword
    }
    
    //Apple login
    @objc func tapApple() {
        if #available(iOS 13.0, *) {
            AppleSignin.shared.initAppleSignin(scope: [.email, .fullName]) { (appleData) in
                if appleData.error == nil {
                    self.accessToken = appleData.userId ?? ""
                    self.firstName = appleData.firstName ?? ""
                    self.lastName = appleData.lastName ?? ""
                    self.email = appleData.email ?? ""
                    self.isSocialSignup = true
                    self.loginby = .apple
                    self.loginByUpdate()
                    self.socialLoginApi()
                } else {
                    AppAlert.shared.simpleAlert(view: self, title: appleData.error?.localized, message: nil)
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    private func setupSignInButton() {
        if #available(iOS 13.2, *) {
            self.appleView.isHidden = false
            let signInButton = ASAuthorizationAppleIDButton(type: .signUp, style: .black)
            signInButton.addTarget(self, action: #selector(tapApple), for: .touchDown)
            self.appleView.addSubview(signInButton)
            signInButton.translatesAutoresizingMaskIntoConstraints = false
            signInButton.bottomAnchor.constraint(equalTo: appleButton.bottomAnchor,constant: 0).isActive = true
            signInButton.leftAnchor.constraint(equalTo: appleButton.leftAnchor,constant: 0).isActive = true
            signInButton.topAnchor.constraint(equalTo: appleButton.topAnchor,constant: 0).isActive = true
            signInButton.rightAnchor.constraint(equalTo: appleButton.rightAnchor,constant: 0).isActive = true
            signInButton.setCornerRadiuswithValue(value: 8)
        } else {
            // Fallback on earlier versions
            if #available(iOS 13.0, *) {
                 self.appleView.isHidden = false
                let signInButton = ASAuthorizationAppleIDButton(type: .continue, style: .black)
                signInButton.addTarget(self, action: #selector(tapApple), for: .touchDown)
                self.appleView.addSubview(signInButton)
                signInButton.translatesAutoresizingMaskIntoConstraints = false
                signInButton.bottomAnchor.constraint(equalTo: appleButton.bottomAnchor,constant: 0).isActive = true
                signInButton.leftAnchor.constraint(equalTo: appleButton.leftAnchor,constant: 0).isActive = true
                signInButton.topAnchor.constraint(equalTo: appleButton.topAnchor,constant: 0).isActive = true
                signInButton.rightAnchor.constraint(equalTo: appleButton.rightAnchor,constant: 0).isActive = true
                signInButton.setCornerRadiuswithValue(value: 8)
            } else {
                 self.appleView.isHidden = true
                // Fallback on earlier versions
            }
            
        }
    }
    
    @objc func tapGoogle() {
        self.view.endEditing()
        googleLogin()
    }
    
    @objc func tapGuest() {
        
    }
    
    @objc func tapFacebook() {
        self.view.endEditing()

        let fbClass = FacebookLoginClass()
        fbClass.initializeFacebook(controller: self) { [weak self] (fbDetails) in
            guard let self = self else {
                return
            }
            self.accessToken = "\(fbDetails?.id ?? 0 as AnyObject)"
            self.firstName = fbDetails?.first_name ?? .empty
            self.lastName = fbDetails?.last_name ?? .empty
            self.email = fbDetails?.email ?? .empty
            
            self.loginby = .facebook
            self.isSocialSignup = true
            self.loginByUpdate()
            self.socialLoginApi()
        }
    }
    
}

//MARK: - Textfield delegate

extension SignUpController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == countryTextfield  {
            showPicker(pickerType: .countryList)
            return false
        }else if textField == cityTextfield {
            guard let stateStr = countryTextfield.text, !stateStr.isEmpty else{
                AppAlert.shared.simpleAlert(view: self, title: LoginConstant.countryEmpty.localized, message: nil)
                return false
            }
            showPicker(pickerType: .cityList)
            return false
        }else if textField == countryCodeTextfield{
            showPicker(pickerType: .countryCode)
            return false
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if reason == .committed {
            print("done")
            if textField == phoneNumberTextfield {
                 do {
              
                     let phoneNumber = try phoneNumberKit.parse((phoneNumberTextfield.text ?? ""), withRegion: countryDetail!.code, ignoreType: false)
                            let formatedNumber = phoneNumberKit.format(phoneNumber, toType: .international)
                            print(phoneNumber)
                            print(formatedNumber)
                 }
                 catch {
                     print("Generic parser error")
                    AppAlert.shared.simpleAlert(view: self, title: LoginConstant.validPhone.localized, message: nil)

                    
                 }
            }
        }
    }
  
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       if textField == passwordTextfield && (textField.text?.count ?? 0) > 19 && !string.isEmpty  {
            return false
        }
        if !string.canBeConverted(to: String.Encoding.ascii){
            return false
        }
        return true
    }   
}

//MARK: - LoginPresenterToLoginViewProtocolxs

extension SignUpController: LoginPresenterToLoginViewProtocol {
    
    func getCountries(countryEntity: CountryEntity) {
        countryData = countryEntity.countryData ?? []
    }
    
    func verifySuccess(verifyEntity: LoginEntity) {
        if verifyEntity.responseData?.otp == 1 {
            AppConfigurationManager.shared.baseConfigModel = nil
           loginPresenter?.getBaseURL(param: [LoginConstant.salt_key: APPConstant.salt_key])

        }else{
            if self.loginby == .manual {
                self.normalSignUp()
            }else{
                self.socialSignUp(loginBy: self.loginby)
            }
        }
    }
    
    func getBaseURLResponse(baseEntity: BaseEntity) {
        AppConfigurationManager.shared.baseConfigModel = baseEntity
        AppConfigurationManager.shared.setBasicConfig(data: baseEntity)
        let param:Parameters = [LoginConstant.salt_key: APPConstant.salt_key,
                                           LoginConstant.country_code: (countryCodeTextfield.text ?? "").trimString().dropFirst(),
                                           LoginConstant.iso2 : self.iso2,
                                           LoginConstant.mobile: phoneNumberTextfield.text!.trimString()]
                   loginPresenter?.sendOtp(param: param)
    }
    
    private func socialSignUp(loginBy:loginBy) {
        var param:Parameters
        param = [LoginConstant.salt_key: APPConstant.salt_key,
                 LoginConstant.device_type: deviceType.ios.rawValue,
                 LoginConstant.device_token: deviceTokenString,
                 LoginConstant.socialUniqueid: accessToken ?? "",
                 LoginConstant.device_id: UUID().uuidString,
                 LoginConstant.login_by: loginBy.rawValue,
                 LoginConstant.first_name: firstNameTextfield.text!,
                 LoginConstant.last_name: lastNameTextfield.text!,
                 LoginConstant.email: emailTextfield.text!,
                 LoginConstant.gender: isMaleFemale ? gender.male.rawValue : gender.female.rawValue,
                 LoginConstant.country_code: countryCodeTextfield.text!.trimString().dropFirst(),
                 LoginConstant.mobile: phoneNumberTextfield.text!.trimString(),
                 LoginConstant.country_id: selectedCountryId,
                 LoginConstant.city_id: selectedCityId,
                 LoginConstant.referral_code : referalTextfield.text ?? ""]
        
        let profileImageData:[String:Data]? = nil
        loginPresenter?.signUp(param: param, imageData: profileImageData)
    }
    
    private func normalSignUp() {
        let param:Parameters = [LoginConstant.salt_key : APPConstant.salt_key,
                                LoginConstant.device_type : deviceType.ios.rawValue,
                                LoginConstant.device_token : deviceTokenString,
                                LoginConstant.device_id : UUID().uuidString,
                                LoginConstant.login_by : loginBy.manual.rawValue,
                                LoginConstant.first_name : firstNameTextfield.text!.trimString(),
                                LoginConstant.last_name : lastNameTextfield.text!.trimString(),
                                LoginConstant.email : emailTextfield.text!.trimString(),
                                LoginConstant.gender : isMaleFemale ? gender.male.rawValue : gender.female.rawValue,
                                LoginConstant.country_code : countryCodeTextfield.text!.trimString().dropFirst(),
                                LoginConstant.iso2 : self.iso2,
                                LoginConstant.mobile : phoneNumberTextfield.text!.trimString(),
                                LoginConstant.password : passwordTextfield.text!.trimString(),
                                LoginConstant.password_confirmation : passwordTextfield.text!.trimString(),
                                LoginConstant.country_id : selectedCountryId,
                                LoginConstant.city_id : selectedCityId,
                                LoginConstant.referral_code : referalTextfield.text ?? ""]
        
        let profileImageData:[String:Data]? = nil
        loginPresenter?.signUp(param: param, imageData: profileImageData)
    }
    
    func sendOtpSuccess(sendOtpEntity: sendOtpEntity) {
        StoreLoginData.shared.socialAccessToken = accessToken ?? ""
        StoreLoginData.shared.loginBy = self.loginby
        StoreLoginData.shared.firstName = firstNameTextfield.text!
        StoreLoginData.shared.lastName = lastNameTextfield.text!
        StoreLoginData.shared.email = emailTextfield.text!
        if (maleButton.imageView?.image == UIImage(named: Constant.circleImage)) && (femaleButton.imageView?.image == UIImage(named: Constant.circleImage)){
            StoreLoginData.shared.gender = nil
        }else{
            StoreLoginData.shared.gender = isMaleFemale ? gender.male.rawValue : gender.female.rawValue
        }
        StoreLoginData.shared.countryCode = (countryCodeTextfield.text ?? "").trimString()
        StoreLoginData.shared.mobile = phoneNumberTextfield.text!.trimString()
        StoreLoginData.shared.countryId = selectedCountryId
        StoreLoginData.shared.cityId = selectedCityId
        StoreLoginData.shared.referralCode = referalTextfield.text ?? ""
        StoreLoginData.shared.password = passwordTextfield.text?.trimString()
        StoreLoginData.shared.profileImageData  = nil
        let otpController = LoginRouter.loginStoryboard.instantiateViewController(withIdentifier: LoginConstant.OtpController) as! OtpController
        otpController.iso2 = self.iso2
        navigationController?.pushViewController(otpController, animated: true)
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
    
    func updateSocialLoginSuccess(socialEntity: LoginEntity) {
        isGuestAccount = false
        AppManager.shared.accessToken = socialEntity.responseData?.access_token
        saveSignin(loginEntity: socialEntity)
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        appDelegate.window?.rootViewController = TabBarController().listTabBarController()
        appDelegate.window?.makeKeyAndVisible()
    }
    
    func signUpSuccess(signUpEntity: LoginEntity) {
        isGuestAccount = false
        AppManager.shared.accessToken = signUpEntity.responseData?.access_token
        saveSignin(loginEntity: signUpEntity)
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        appDelegate.window?.rootViewController = TabBarController().listTabBarController()
        appDelegate.window?.makeKeyAndVisible()
    }
    
    func failureResponse(failureData: Data) {
        if
            let utf8Text = String(data: failureData, encoding: .utf8),
            let messageDic = AppUtils.shared.stringToDictionary(text: utf8Text),
            let message =  messageDic[Constant.message] as? String {
            if message == LoginConstant.soicalLoginmessage {
                print("Already register")
                setSocialValues()
                self.isSocialSignup = true
                if loginby == .google {
                    self.googleButton.isUserInteractionEnabled = false
                    self.facebookButton.isUserInteractionEnabled = true
                }else{
                    self.googleButton.isUserInteractionEnabled = true
                    self.facebookButton.isUserInteractionEnabled = false
                }
            }
        }
    }
}


import SafariServices

extension  SFSafariViewController {
    override open var modalPresentationStyle: UIModalPresentationStyle {
        get { return .fullScreen}
        set { super.modalPresentationStyle = newValue }
    }
}
