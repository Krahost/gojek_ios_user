//
//  MyProfileController.swift
//  GoJekUser
//
//  Created by Ansar on 25/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import PhoneNumberKit

class MyProfileController: UIViewController {
    
    @IBOutlet weak var editImageView:UIImageView!
    @IBOutlet weak var profileImage:UIImageView!
    
    @IBOutlet weak var changePasswordButton:UIButton!
    @IBOutlet weak var saveButton:UIButton!
    @IBOutlet weak var maleButton:UIButton!
    @IBOutlet weak var femaleButton:UIButton!
    @IBOutlet weak var profileView: UIView!
    
    @IBOutlet weak var genderLabel:UILabel!
    @IBOutlet weak var editOuterView:UIView!
    
    @IBOutlet weak var firsrNameTextField:CustomTextField!
    @IBOutlet weak var countryCodeTextField:CustomTextField!
    @IBOutlet weak var phoneNumberTextField:CustomTextField!
    @IBOutlet weak var emailTextField:CustomTextField!
    @IBOutlet weak var cityTextField:CustomTextField!
    @IBOutlet weak var countryTextField:CustomTextField!
    @IBOutlet weak var lastNameTextField: CustomTextField!
    
    var iso2 = String()
    
    var userData = UserProfileEntity() {
        didSet {
            setProfileDetails()
        }
    }
    
    //Set country code and image
    private var countryDetail: Country? {
        didSet {
            if countryDetail != nil {
                self.countryCodeTextField.text = "   \(countryDetail?.dial_code ?? "")"
                self.iso2 = countryDetail?.code ?? ""
                self.countryCodeTextField.setFlag(imageStr: "CountryPicker.bundle/"+(countryDetail?.code ?? "US"))
            }
        }
    }
    
    var isMaleFemale:Bool = false { //true - male , false - female
        didSet {
            maleButton.setImage(UIImage(named: isMaleFemale ? Constant.circleFullImage : Constant.circleImage), for: .normal)
            femaleButton.setImage(UIImage(named: isMaleFemale ? Constant.circleImage : Constant.circleFullImage), for: .normal)
        }
    }
    
    var cityData: [CityData] = []
    var selectedCityId:Int = 0
    var isMobileEdited: Bool = false //local flag for isMobile Edited
    let phoneNumberKit = PhoneNumberKit()

    override func viewDidLoad() {
        super.viewDidLoad()
         if guestLogin() {
        initialLoads()
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        editOuterView.setCornerRadius()
        saveButton.setBothCorner()
        self.profileImage.setCornerRadius()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideTabBar()
        
        if checkisRTL() {
            // maleButton.semanticContentAttribute = UIApplication.shared
            //  .userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
            
            maleButton.setImageTitle(spacing: 10)
            femaleButton.setImageTitle(spacing: 10)
            femaleButton.imageEdgeInsets = UIEdgeInsets(top: 4, left: 6, bottom: 4, right: -6)
            femaleButton.imageView?.contentMode = .scaleAspectFit
            maleButton.imageEdgeInsets = UIEdgeInsets(top: 4, left: 6, bottom: 4, right: -6)
            maleButton.imageView?.contentMode = .scaleAspectFit
                        
        }
    }
}

//MARK: - Methods

extension MyProfileController  {
    
    private func initialLoads() {
        self.setNavigationBar()
        setCustomFont()
        profileView.setCornerRadiuswithValue(value: 8)
        profileImage.image  = UIImage(named: Constant.userPlaceholderImage)
        profileImage.backgroundColor = .whiteColor
        profileImage.isUserInteractionEnabled = true
        self.changePasswordButton.addTarget(self, action: #selector(tapChangePassword), for: .touchUpInside)
        self.maleButton.addTarget(self, action: #selector(tapGender(_:)), for: .touchUpInside)
        self.femaleButton.addTarget(self, action: #selector(tapGender(_:)), for: .touchUpInside)
        self.saveButton.addTarget(self, action: #selector(tapSaveButton), for: .touchUpInside)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapImage(_:)))
        self.profileImage.addGestureRecognizer(gesture)
        let editViewgesture = UITapGestureRecognizer(target: self, action: #selector(tapImage(_:)))
        self.editOuterView.addGestureRecognizer(editViewgesture)
        profileImage.layer.borderWidth = 1
        profileImage.layer.borderColor = UIColor.appPrimaryColor.cgColor
        self.editImageView.image = UIImage(named: Constant.editImage)
        self.editImageView.imageTintColor(color1: .whiteColor)
        self.editOuterView.setBorder(width: 5.0, color: .whiteColor)
        self.phoneNumberTextField.fieldShapeType = .Right
        self.countryCodeTextField.fieldShapeType = .Left
        maleButton.setImageTitle(spacing: 10)
        femaleButton.setImageTitle(spacing: 10)
        femaleButton.imageEdgeInsets = UIEdgeInsets(top: 4, left: 6, bottom: 4, right: 6)
        femaleButton.imageView?.contentMode = .scaleAspectFit
        maleButton.imageEdgeInsets = UIEdgeInsets(top: 4, left: 6, bottom: 4, right: 6)
        maleButton.imageView?.contentMode = .scaleAspectFit
        setLocalize()
        setColor()
        phoneNumberTextField.keyboardType = .phonePad
        userData = AppManager.shared.getUserDetails() ?? UserProfileEntity()
        getCountries()
        
        //Disable user interaction
        self.countryTextField.isUserInteractionEnabled = false
        self.emailTextField.isUserInteractionEnabled = false
        setDarkMode()
    }
    
    private func setDarkMode(){
        self.view.backgroundColor = .backgroundColor
        self.profileView.backgroundColor = .boxColor
        self.changePasswordButton.setTitleColor(.blackColor, for: .normal)
    }
    
    
    private func setNavigationBar() {
        self.title = AccountConstant.profile.localized
        setNavigationTitle()
        setLeftBarButtonWith(color: .blackColor)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    private func setCustomFont() {
        genderLabel.font = .setCustomFont(name: .light, size: .x16)
        self.firsrNameTextField.font = .setCustomFont(name: .light, size: .x16)
        self.lastNameTextField.font = .setCustomFont(name: .light, size: .x16)
        self.countryCodeTextField.font = .setCustomFont(name: .light, size: .x16)
        self.phoneNumberTextField.font = .setCustomFont(name: .light, size: .x16)
        self.emailTextField.font = .setCustomFont(name: .light, size: .x16)
        self.cityTextField.font = .setCustomFont(name: .light, size: .x16)
        self.countryTextField.font = .setCustomFont(name: .light, size: .x16)
        self.changePasswordButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x14)
        
        self.saveButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x20)
    }
    
    private func setColor() {
        self.editOuterView.backgroundColor = .appPrimaryColor
        self.changePasswordButton.setTitleColor(.black, for: .normal)
        self.saveButton.backgroundColor = .appPrimaryColor
        self.saveButton.setTitleColor(.white, for: .normal)
    }
    
    private func setLocalize() {
        self.firsrNameTextField.placeholder = Constant.firstName.localized
        self.lastNameTextField.placeholder = Constant.lastName.localized
        self.countryCodeTextField.placeholder = Constant.code.localized
        self.emailTextField.placeholder = Constant.emailId.localized
        self.phoneNumberTextField.placeholder = Constant.phoneNumber.localized
        self.cityTextField.placeholder = Constant.city.localized
        self.countryTextField.placeholder = Constant.country.localized
        genderLabel.text = LoginConstant.staticGender.localized
        maleButton.setTitle(LoginConstant.male.localized, for: .normal)
        femaleButton.setTitle(LoginConstant.female.localized, for: .normal)
        changePasswordButton.setTitle(AccountConstant.changePwd.localized, for: .normal)
        self.saveButton.setTitle(Constant.SSave.localized, for: .normal)
    }
    
    private func setProfileDetails() {
        
        self.firsrNameTextField.text = userData.first_name
        self.lastNameTextField.text = userData.last_name
        self.phoneNumberTextField.text = userData.mobile
        self.emailTextField.text = userData.email
        self.cityTextField.text = userData.city?.city_name
        self.countryTextField.text = userData.country?.country_name
//        let countryCode = "+"+(userData.country_code ?? "+1")
        let countryCodeList = AppUtils.shared.getCountries()
        for eachCountry in countryCodeList {
            
//            if countryCode.trimString() == eachCountry.dial_code {
//                self.countryDetail = Country(name: eachCountry.name, dial_code: eachCountry.dial_code, code: eachCountry.code)
//            }
            
            if (userData.iso2 ?? "NP").uppercased() == eachCountry.code.uppercased() {
                self.countryDetail = Country(name: eachCountry.name, dial_code: eachCountry.dial_code, code: eachCountry.code)
            }
            
            
        }
        if self.userData.login_by == AccountConstant.loginManual {
            self.changePasswordButton.isHidden = false
        }else{
            self.changePasswordButton.isHidden = true
        }
        if userData.gender != "" {
            isMaleFemale = userData.gender == gender.male.rawValue
        }else{
            maleButton.setImage(UIImage(named: Constant.circleImage), for: .normal)
            femaleButton.setImage(UIImage(named: Constant.circleImage), for: .normal)
        }
        
        self.profileImage.sd_setImage(with: URL(string: userData.picture ?? ""), placeholderImage: UIImage(named: Constant.userPlaceholderImage),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
            // Perform operation.
            if (error != nil) {
                // Failed to load image
                self.profileImage.image = UIImage(named: Constant.userPlaceholderImage)
            } else {
                // Successful in loading image
                self.profileImage.image = image
            }
        })
        self.selectedCityId = userData.city?.id ?? 0
        
    }
    
    private func showPicker(pickerType: PickerType) {
        let countryCodeView = LoginRouter.loginStoryboard.instantiateViewController(withIdentifier: LoginConstant.CountryCodeViewController) as! CountryCodeViewController
        countryCodeView.pickerType = pickerType
        
        if pickerType == .cityList {
            countryCodeView.cityListEntity = self.cityData
            countryCodeView.selectedCity = { [weak self] cityDetail in
                guard let self = self else {
                    return
                }
                self.cityTextField.text = cityDetail.city_name
                self.selectedCityId = cityDetail.id ?? 0
            }
        }else {
            countryCodeView.countryCode = { [weak self] countryDetail in
                guard let self = self else {
                    return
                }
                self.isMobileEdited = true
                self.countryDetail = countryDetail
                if self.phoneNumberTextField.text != "" {
                    do {
                        
                        let phoneNumber = try self.phoneNumberKit.parse((self.phoneNumberTextField.text ?? ""), withRegion: countryDetail.code, ignoreType: false)
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
    
    private func getCountries() {
        let param:Parameters = [LoginConstant.salt_key : APPConstant.salt_key]
        self.accountPresenter?.getCountries(param: param)
    }
    
    private func editProfileAPI() {
        var param : Parameters
        
        param = [LoginConstant.first_name : firsrNameTextField.text!,
                 LoginConstant.last_name : lastNameTextField.text!,
                 LoginConstant.iso2 : self.iso2,
                 LoginConstant.city_id : self.selectedCityId]
        if isMobileEdited {
            let countryCode = self.countryCodeTextField.text?.trimString()
            param[LoginConstant.country_code] = countryCode?.dropFirst()
            param[LoginConstant.mobile] = self.phoneNumberTextField.text?.trimString()
        }
        if (maleButton.imageView?.image == UIImage(named: Constant.circleImage)) && (femaleButton.imageView?.image == UIImage(named: Constant.circleImage)){
            param[LoginConstant.gender] = ""
            
        }else{
            param[LoginConstant.gender] = self.isMaleFemale ? gender.male.rawValue : gender.female.rawValue
        }
        
        var profileImageData: Data!
        if  let profileData = profileImage.image?.jpegData(compressionQuality: 0.5) {
            profileImageData = profileData
        }
        if profileImage.image?.isEqual(to: UIImage(named: Constant.userPlaceholderImage) ?? UIImage()) ?? false {
            profileImageData  = nil
        }
        if profileImageData != nil {
            accountPresenter?.editProfile(param: param, imageData: [Constant.picture:profileImageData])
        }else {
            param[Constant.picture] = "no_image"
            self.accountPresenter?.editProfile(param: param, imageData: nil)
        }
        
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
    
    private func validation() -> Bool {
        guard let firstName = firsrNameTextField.text?.trimString(), !firstName.isEmpty else {
            firsrNameTextField.becomeFirstResponder()
            AppAlert.shared.simpleAlert(view: self, title: LoginConstant.firstNameEmpty.localized, message: nil)
            return false
        }
        guard let lastName = lastNameTextField.text?.trimString(),  !(lastName.isEmpty ) else {
            lastNameTextField.becomeFirstResponder()
            AppAlert.shared.simpleAlert(view: self, title: LoginConstant.lastNameEmpty.localized, message: nil)
            return false
        }
        guard let phoneNumber = phoneNumberTextField.text?.trimString(),  !(phoneNumber.isEmpty)  else {
            phoneNumberTextField.becomeFirstResponder()
            AppAlert.shared.simpleAlert(view: self, title: LoginConstant.phoneEmpty.localized, message: nil)
            return false
        }
        guard phoneNumber.isPhoneNumber else {
            phoneNumberTextField.becomeFirstResponder()
            AppAlert.shared.simpleAlert(view: self, title: LoginConstant.validPhone.localized, message: nil)
            return false
        }
        
        guard let city = cityTextField.text?.trimString(), !city.isEmpty else {
            AppAlert.shared.simpleAlert(view: self, title: LoginConstant.cityEmpty.localized, message: nil)
            return false
        }
        return true
    }
    
    @objc func tapImage(_ sender:UITapGestureRecognizer) {
        if self.profileImage.image?.isEqual(to: UIImage(named: Constant.userPlaceholderImage)  ?? UIImage()) ?? false {
            self.showImage(isRemoveNeed: nil, with:{ (image) in
                self.profileImage.image = image
            })
        }else{
            self.showImage(isRemoveNeed: Constant.removePhoto.localized, with:{ (image) in
                self.profileImage.image = image
            })
        }
    }
    
    @objc func tapChangePassword() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: AccountConstant.ChangePasswordController) as! ChangePasswordController
        vc.isFromForgotPassword = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func tapGender(_ sender:UIButton) {
        isMaleFemale = sender.tag == 0
    }
    @objc func tapSaveButton() {
        if validation() {
            let countryCode = "+"+(userData.country_code ?? "+1")
            if userData.mobile == self.phoneNumberTextField.text!.replacingOccurrences(of: " ", with: "") && countryCode == self.countryCodeTextField.text!.replacingOccurrences(of: " ", with: ""){
                editProfileAPI()
            }else{
                let baseDetails = AppConfigurationManager.shared.baseConfigModel
                if baseDetails?.responseData?.appsetting?.send_sms == 1 {
                    let param:Parameters = [LoginConstant.salt_key: APPConstant.salt_key,
                                            LoginConstant.country_code: (countryCodeTextField.text ?? "").trimString().dropFirst(),
                                            LoginConstant.iso2 : self.iso2,
                                            LoginConstant.mobile: phoneNumberTextField.text!.trimString()]
                    
                    self.accountPresenter?.sendOtp(param: param)
                }else{
                    editProfileAPI()
                    
                }
            }
        }
        
    }
    private func checkisRTL() -> Bool {
        if let languageStr = UserDefaults.standard.value(forKey: AccountConstant.language) as? String {
            if languageStr == "ar" {
                return true
            }
        }
        return false
    }
}

//MARK: - Textfield delegate

extension MyProfileController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        switch textField {
        case cityTextField:
            guard let stateStr = countryTextField.text, !stateStr.isEmpty else{
                AppAlert.shared.simpleAlert(view: self, title: LoginConstant.countryEmpty, message: nil)
                return false
            }
            self.showPicker(pickerType: .cityList)
            return false
        case countryCodeTextField:
            self.showPicker(pickerType: .countryCode)
            return false
        default:
            break
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if reason == .committed {
            print("done")
            if textField == phoneNumberTextField {
                 do {
                    
                     let phoneNumber = try phoneNumberKit.parse((phoneNumberTextField.text ?? ""), withRegion: countryDetail!.code, ignoreType: false)
                            let formatedNumber = phoneNumberKit.format(phoneNumber, toType: .international)
                            print(formatedNumber)
                            isMobileEdited = true
                 }
                 catch {
                     print("Generic parser error")
                    AppAlert.shared.simpleAlert(view: self, title: LoginConstant.validPhone.localized, message: nil)

                    
                 }
            }
        }
    }
}

//MARK:- Account VIPER protocvols
extension MyProfileController: AccountPresenterToAccountViewProtocol {
    
    func getCountries(countryEntity: CountryEntity) {
        for country in countryEntity.countryData ?? [] {
            if country.id  == userData.country?.id {
                self.cityData = country.city ?? []
            }
        }
    }
    func sendOtpSuccess(sendOtpEntity: sendOtpEntity) {
        let otpController = LoginRouter.loginStoryboard.instantiateViewController(withIdentifier: LoginConstant.OtpController) as! OtpController
        otpController.delegate = self
        otpController.isprofile = true
        otpController.countryCode = countryCodeTextField.text!
        otpController.phoneNumber = phoneNumberTextField.text!
        otpController.iso2 = self.iso2
        navigationController?.pushViewController(otpController, animated: true)
    }
    
    func editProfileSuccess(profileEntity: SuccessEntity) {
        
        self.accountPresenter?.fetchUserProfileDetails()
    }
    
    func showUserProfileDtails(details: UserProfileResponse) {
        if let userDetail = details.responseData{
            AppManager.shared.setUserDetails(details: userDetail)
        }
        self.userData = details.responseData ?? UserProfileEntity()
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        appDelegate.window?.rootViewController = TabBarController().listTabBarController()
        appDelegate.window?.makeKeyAndVisible()
        ToastManager.show(title: AccountConstant.profileUpdated, state: .success)
        
    }
}
extension MyProfileController: updateOtpDelegate {
    func updateOtp(countryCode: String,mobile: String) {
        phoneNumberTextField.text = mobile
        countryCodeTextField.text = countryCode
        isMobileEdited = true
        editProfileAPI()
    }
}

// MARK: - Protocol
protocol updateOtpDelegate: class {
    func updateOtp(countryCode: String,mobile: String)
}
