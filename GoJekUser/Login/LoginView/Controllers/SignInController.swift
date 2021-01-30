//
//  SignInController.swift
//  GoJekUser
//
//  Created by Ansar on 21/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire
import GoogleSignIn
import AuthenticationServices
var isDarkMode = false

class SignInController: UIViewController {
    
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var topView:UIView!
    @IBOutlet weak var phoneView:UIView!
    @IBOutlet weak var mailView:UIView!
    @IBOutlet weak var phoneTextFieldView:UIView!
    @IBOutlet weak var mailTextFieldView:UIView!
    @IBOutlet weak var signInView:RoundedView!
    @IBOutlet weak var socialSigninOuterView:UIView!
    @IBOutlet weak var phoneImage:UIImageView!
    @IBOutlet weak var mailImage:UIImageView!
    @IBOutlet weak var signUpButton:UIButton!
    @IBOutlet weak var forgotPasswordButton:UIButton!
    @IBOutlet weak var showPasswordButton:UIButton!
    @IBOutlet weak var facebookButton:UIButton!
    @IBOutlet weak var googleButton:UIButton!
    @IBOutlet weak var appleButton:UIButton!
    @IBOutlet weak var guestButton: UIButton!
    
    //static labels
    @IBOutlet weak var socialLoginLabel:UILabel!
    @IBOutlet weak var dontHaveAccountLabel:UILabel!
    @IBOutlet weak var loginViaLabel:UILabel!
    @IBOutlet weak var orLabel:UILabel!
    
    //Textfield
    @IBOutlet weak var countryCodeTextField:CustomTextField!
    @IBOutlet weak var phoneNumberTextField:CustomTextField!
    @IBOutlet weak var passwordTextField:CustomTextField!
    @IBOutlet weak var emailTextField:CustomTextField!
    
    private var accessToken : String?
    var firstName = ""
    var lastName = ""
    var email = ""
    var loginby: loginBy = .manual
    
    var isPhoneSelect = false {
        didSet {
            phoneTextFieldView.isHidden = !isPhoneSelect
            mailTextFieldView.isHidden = isPhoneSelect
            textfieldUIUpdate()
        }
    }
    
    var isShowPassword:Bool = false {
        didSet {
            passwordTextField.isSecureTextEntry = isShowPassword
            showPasswordButton.setImage(UIImage(named: isShowPassword ? Constant.eyeOff : Constant.eye), for: .normal)
        }
    }
    
    var isHideSocialSignin:Bool = false {
        didSet {
            socialSigninOuterView.isHidden = isHideSocialSignin
            orLabel.isHidden = isHideSocialSignin
        }
    }
    
    //Set country code and image
    private var countryDetail: Country? {
        didSet {
            if countryDetail != nil {
                countryCodeTextField.text = "   \(countryDetail?.dial_code ?? "")"
                countryCodeTextField.setFlag(imageStr: "CountryPicker.bundle/"+(countryDetail?.code ?? "US"))
            }
        }
    }
    
    //MARK:- Presenter
    //    var loginPresenter: LoginViewToLoginPresenterProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoads()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        setDarkMode()
        if CommonFunction.checkisRTL() {
            facebookButton.changeToRight(spacing: -15)
            googleButton.changeToRight(spacing: -15)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        topView.roundedTop(desiredCurve: topView.frame.height/3)
    }
}

//MARK: - Methods

extension SignInController {
    
    private func initialLoads(){
        signInView.addShadow(radius: 3.0, color: .lightGray)
//        if #available(iOS 13.0, *) {
//            overrideUserInterfaceStyle = .light
//        } else {
//            // Fallback on earlier versions
//        }
        setupSignInButton()
//        self.view.backgroundColor = .veryLightGray
        localize()
        setColors()
        let signinGuesture = UITapGestureRecognizer(target: self, action: #selector(tapSignIn))
        signInView.addGestureRecognizer(signinGuesture)
        signUpButton.addTarget(self, action: #selector(tapSignUp), for: .touchUpInside)
        showPasswordButton.addTarget(self, action: #selector(tapShowPassword), for: .touchUpInside)
        forgotPasswordButton.addTarget(self, action: #selector(tapForgotPassword), for: .touchUpInside)
        let phoneViewGesture = UITapGestureRecognizer(target: self, action: #selector(tapPhoneEmail(_:)))
        let mailViewGesture = UITapGestureRecognizer(target: self, action: #selector(tapPhoneEmail(_:)))
        phoneNumberTextField.textColor = .black
        passwordTextField.textColor = .black
        countryCodeTextField.textColor = .black
        facebookButton.setImage(UIImage(named: LoginConstant.faceBookImage), for: .normal)
        googleButton.setImage(UIImage(named: LoginConstant.googleImage), for: .normal)
        facebookButton.setImageTitle(spacing: 15)
        googleButton.setImageTitle(spacing: 15)
        facebookButton.addTarget(self, action: #selector(tapFacebook), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(tapGoogle), for: .touchUpInside)
        guestButton.addTarget(self, action: #selector(tapGuest), for: .touchUpInside)
        mailView.addGestureRecognizer(mailViewGesture)
        phoneView.addGestureRecognizer(phoneViewGesture)
        self.phoneImage.image = UIImage(named: LoginConstant.phone)
        self.mailImage.image = UIImage(named: LoginConstant.mail)
        isPhoneSelect = true
        isShowPassword = true
        self.guestButton.cornerRadius = 5.0
        self.countryCodeTextField.fieldShapeType = .Left
        self.phoneNumberTextField.fieldShapeType = .Right
        setFont()
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            let countryCodeList = AppUtils.shared.getCountries()
            for eachCountry in countryCodeList {
                if countryCode == eachCountry.code {
                    countryDetail = Country(name: eachCountry.name, dial_code: eachCountry.dial_code, code: eachCountry.code)
                }
            }
        }
        let baseConfig = AppConfigurationManager.shared.baseConfigModel
        //Hide social signin
        isHideSocialSignin = baseConfig?.responseData?.appsetting?.social_login == 0
    }
    
    
    
    
    private func setDarkMode(){
        self.view.backgroundColor = .backgroundColor
        self.socialSigninOuterView.backgroundColor = .boxColor
        self.loginView.backgroundColor = .boxColor
        self.phoneView.backgroundColor = .boxColor
        self.mailView.backgroundColor = .boxColor
        self.socialLoginLabel.textColor = .blackColor
        self.emailTextField.textColor = .blackColor
        self.passwordTextField.textColor = .blackColor
        self.countryCodeTextField.textColor = .blackColor
        self.loginViaLabel.textColor = .blackColor
        self.phoneNumberTextField.textColor = .blackColor
        self.facebookButton.setTitleColor(.blackColor, for: .normal)
        self.googleButton.setTitleColor(.blackColor, for: .normal)
        self.forgotPasswordButton.setTitleColor(.blackColor, for: .normal)
        textfieldUIUpdate()
      }
    
    private func localize() {
        emailTextField.placeholder = Constant.email.localized
        loginViaLabel.text = LoginConstant.loginVia.localized
        forgotPasswordButton.setTitle(LoginConstant.forgotPassword.localized+"?", for: .normal)
        signUpButton.setTitle(LoginConstant.signUp.localized, for: .normal)
        socialLoginLabel.text = LoginConstant.socialLogin.localized
        orLabel.text = LoginConstant.or.localized.uppercased()
        dontHaveAccountLabel.text = LoginConstant.dontHaveAcc.localized
        facebookButton.setTitle(LoginConstant.connectFacebook.localized, for: .normal)
        googleButton.setTitle(LoginConstant.connectGoogle.localized, for: .normal)
        guestButton.setTitle(LoginConstant.connectGuest.localized, for: .normal)
        passwordTextField.placeholder = Constant.password.localized
        countryCodeTextField.placeholder = "  \(Constant.code.localized)"
        phoneNumberTextField.placeholder = Constant.phoneNumber.localized
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
                    self.loginby = .apple
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
        DispatchQueue.main.async {
            if #available(iOS 13.0, *) {
                self.appleButton.isHidden = false
                let signInButton = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
                signInButton.addTarget(self, action: #selector(self.tapApple), for: .touchDown)
                self.socialSigninOuterView.addSubview(signInButton)
                signInButton.translatesAutoresizingMaskIntoConstraints = false
                signInButton.bottomAnchor.constraint(equalTo: self.appleButton.bottomAnchor).isActive = true
                signInButton.leftAnchor.constraint(equalTo: self.appleButton.leftAnchor).isActive = true
                signInButton.topAnchor.constraint(equalTo: self.appleButton.topAnchor).isActive = true
                signInButton.rightAnchor.constraint(equalTo: self.appleButton.rightAnchor).isActive = true
            } else {
                // Fallback on earlier versions
                self.appleButton.isHidden = true
            }
        }
    }
    
    private func setFont() {
        forgotPasswordButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x14)
        socialLoginLabel.font = .setCustomFont(name: .medium, size: .x20)
        dontHaveAccountLabel.font = .setCustomFont(name: .light, size: .x12)
        loginViaLabel.font = .setCustomFont(name: .medium, size: .x20)
        orLabel.font = .setCustomFont(name: .medium, size: .x16)
        facebookButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x14)
        googleButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x14)
        guestButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x14)
        countryCodeTextField.font = .setCustomFont(name: .medium, size: .x14)
        phoneNumberTextField.font = .setCustomFont(name: .medium, size: .x14)
        passwordTextField.font = .setCustomFont(name: .medium, size: .x14)
        emailTextField.font = .setCustomFont(name: .medium, size: .x14)
    }
    
    private func setColors() {
        loginViaLabel.textColor = .black
        forgotPasswordButton.textColor(color: .black)
        dontHaveAccountLabel.textColor = .darkGray
        socialLoginLabel.textColor = .black
        orLabel.textColor = .appPrimaryColor
        signUpButton.textColor(color: .appPrimaryColor)
        signInView.backgroundColor = .appPrimaryColor
        signInView.centerImageView.imageTintColor(color1: .white)
        facebookButton.setTitleColor(.black, for: .normal)
        googleButton.setTitleColor(.black, for: .normal)
        guestButton.setTitleColor(.white, for: .normal)
        guestButton.backgroundColor = .appPrimaryColor
    }
    
    private func textfieldUIUpdate() {
        passwordTextField.text = String.empty
        emailTextField.text = String.empty
        phoneNumberTextField.text = String.empty
        self.view.endEditing()
        UIView.animate(withDuration: 0.3) {
            if self.isPhoneSelect {
                self.phoneImage.imageTintColor(color1: .appPrimaryColor)
                self.mailImage.imageTintColor(color1: .lightGray)
                self.phoneView.backgroundColor = UIColor.appPrimaryColor.withAlphaComponent(0.1)
                self.mailView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
            }else {
                self.mailImage.imageTintColor(color1: .appPrimaryColor)
                self.phoneImage.imageTintColor(color1: .lightGray)
                self.phoneView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
                self.mailView.backgroundColor = UIColor.appPrimaryColor.withAlphaComponent(0.1)
            }
        }
    }
    
    private func validation() -> Bool {
        if isPhoneSelect  {
            guard let phoneStr = phoneNumberTextField.text?.trimString(), !phoneStr.isEmpty else {
                phoneNumberTextField.becomeFirstResponder()
                ToastManager.show(title: LoginConstant.phoneEmpty.localized , state: .error)
                return false
            }
            guard phoneStr.isPhoneNumber else {
                phoneNumberTextField.becomeFirstResponder()
                AppAlert.shared.simpleAlert(view: self, title: LoginConstant.validPhone.localized, message: nil)
                return false
            }
        }else {
            guard let emailStr = emailTextField.text?.trimString(), !emailStr.isEmpty else {
                emailTextField.becomeFirstResponder()
                AppAlert.shared.simpleAlert(view: self, title: LoginConstant.emailEmpty.localized, message: nil)
                return false
            }
            guard emailStr.isValidEmail() else {
                emailTextField.becomeFirstResponder()
                AppAlert.shared.simpleAlert(view: self, title: LoginConstant.validEmail.localized, message: nil)
                return false
            }
        }
        guard let passwordStr = passwordTextField.text?.trimString(), !passwordStr.isEmpty else {
            passwordTextField.becomeFirstResponder()
            AppAlert.shared.simpleAlert(view: self, title: LoginConstant.passwordEmpty.localized, message: nil)
            return false
        }
        guard passwordStr.isValidPassword else {
            passwordTextField.becomeFirstResponder()
            AppAlert.shared.simpleAlert(view: self, title: LoginConstant.passwordlength.localized, message: nil)
            return false
        }
        return true
    }
    
    private func socialLoginApi(){
        let param: Parameters = [LoginConstant.salt_key: APPConstant.salt_key,
                                 LoginConstant.device_type: deviceType.ios.rawValue,
                                 LoginConstant.socialUniqueid: accessToken ?? "",
                                 LoginConstant.device_token: deviceTokenString,
                                 LoginConstant.login_by: loginby.rawValue]
        loginPresenter?.socialLoginWithUserDetail(param: param)
    }
}

//MARK: - Actions

extension SignInController {
    @objc func tapSignIn() {
        signInView.addPressAnimation()
        self.view.endEditing()
        if validation() {
            var param: Parameters
            if isPhoneSelect {
                let countryCode = countryCodeTextField.text!.trimString().dropFirst()
                param = [LoginConstant.country_code: countryCode.trimmingCharacters(in: .whitespaces),
                         LoginConstant.mobile: phoneNumberTextField.text!,
                         LoginConstant.password: passwordTextField.text!]
            }else{
                param = [LoginConstant.email:emailTextField.text!,
                         LoginConstant.password:passwordTextField.text!]
            }
            param[LoginConstant.salt_key] = APPConstant.salt_key
            param[LoginConstant.device_token] = deviceTokenString
            param[LoginConstant.device_type] = deviceType.ios.rawValue
            
            loginPresenter?.signin(param: param)
        }
    }
    
    @objc func tapSignUp() {
        let loginViewcontroller =  LoginRouter.loginStoryboard.instantiateViewController(withIdentifier: LoginConstant.SignUpController)
        navigationController?.pushViewController(loginViewcontroller, animated: true)
    }
    
    @objc func tapGoogle() {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        let googleSignin = GoogleSignin.share
        googleSignin.getGoogleData { [weak self] (googleDetails,error) in
            guard let self = self else {
                return
            }
            if googleDetails != nil {
                self.accessToken = googleDetails?.userID ?? ""
                self.firstName = googleDetails?.profile.name ?? ""
                self.lastName = googleDetails?.profile.familyName ?? ""
                self.email = googleDetails?.profile.email ?? ""
                self.loginby = .google
                self.socialLoginApi()
            }else {
                ToastManager.show(title: error ?? "", state: .warning)
            }
        }
    }
    
    @objc func tapGuest() {
        isGuestAccount = true
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        appDelegate.window?.rootViewController = TabBarController().listTabBarController()
        appDelegate.window?.makeKeyAndVisible()
    }
    
    @objc func tapFacebook() {
        let fbClass = FacebookLoginClass()
        fbClass.initializeFacebook(controller: self) { [weak self] (fbDetails) in
            guard let self = self else {
                return
            }
            self.firstName = fbDetails?.first_name ?? .empty
            self.lastName = fbDetails?.last_name ?? .empty
            self.email = fbDetails?.email ?? .empty
            self.accessToken = "\(fbDetails?.id ?? 0 as AnyObject)"
            print(self.accessToken ?? 0)
            self.loginby = .facebook
            self.socialLoginApi()
        }
    }
    
    @objc func tapShowPassword() {
        isShowPassword = !isShowPassword
    }
    
    @objc func tapPhoneEmail(_ sender: UITapGestureRecognizer) {
        if sender.view?.tag == 1 {
            isPhoneSelect = true
        }else{
            isPhoneSelect = false
        }
    }
    
    @objc func tapForgotPassword() {
        self.view.endEditing()
        let vc = LoginRouter.loginStoryboard.instantiateViewController(withIdentifier: LoginConstant.ForgotPasswordController) as! ForgotPasswordController
        vc.isPhoneSelect = isPhoneSelect
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension SignInController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case countryCodeTextField:
            let countryCodeView = LoginRouter.loginStoryboard.instantiateViewController(withIdentifier: LoginConstant.CountryCodeViewController) as! CountryCodeViewController
            countryCodeView.pickerType = .countryCode
            countryCodeView.countryCode = { [weak self] countryDetail in
                guard let self = self else {
                    return
                }
                self.countryDetail = countryDetail
            }
            present(countryCodeView, animated: true, completion: nil)
            return false
        default:
            break
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.phoneNumberTextField && (textField.text?.count ?? 0) > 19 && !string.isEmpty  {
            return false
        }
        if !string.canBeConverted(to: String.Encoding.ascii){
            return false
        }
        return true
    }
    
}


extension SignInController: LoginPresenterToLoginViewProtocol {
    
    func signinSuccess(loginEntity: LoginEntity) {
        isGuestAccount = false
        AppManager.shared.accessToken = loginEntity.responseData?.access_token
        saveSignin(loginEntity: loginEntity)
        CommonFunction.isFirstSignin = true
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        appDelegate.window?.rootViewController = TabBarController().listTabBarController()
        appDelegate.window?.makeKeyAndVisible()
    }
    
    //To save coredata
    func saveSignin(loginEntity: LoginEntity) {
        let fetchData = try!PersistentManager.shared.context.fetch(LoginData.fetchRequest()) as? [LoginData]
        if fetchData?.count ?? 0 > 0 {
            PersistentManager.shared.delete(entityName: CoreDataEntity.loginData.rawValue)
        }
        
        let loginDetail = LoginData(context: PersistentManager.shared.persistentContainer.viewContext)
        loginDetail.access_token  = loginEntity.responseData?.access_token
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
    
    func failureResponse(failureData: Data) {
        if
            let utf8Text = String(data: failureData, encoding: .utf8),
            let messageDic = AppUtils.shared.stringToDictionary(text: utf8Text),
            let message =  messageDic[Constant.message] as? String {
            if message == LoginConstant.soicalLoginmessage {
                let signUpController = LoginRouter.loginStoryboard.instantiateViewController(withIdentifier: LoginConstant.SignUpController) as! SignUpController
                signUpController.firstName = firstName
                signUpController.lastName = lastName
                signUpController.email = email
                signUpController.loginby = loginby
                signUpController.accessToken = accessToken
                navigationController?.pushViewController(signUpController, animated: true)
            }
        }
    }
}

