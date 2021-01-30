//
//  LoginConstant.swift
//  GoJekUser
//
//  Created by Ansar on 20/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation

enum LoginConstant {
    
    
    //MARK: - String
    static let signIn = "Sign In"
    static let signUp = "Sign Up"
    static let socialLogin =  "Social Login"
    static let socialSignup = "Sign up via"
    static let connectGoogle = "Connect via Google"
    static let connectGuest = "Login As Guest"
    static let connectFacebook = "Connect via Facebook"
    static let loginVia = "Login Via"
    static let forgotPwdVia = "Forgot Password Via"
    
    static let forgotPassword = "Forgot Password"
    static let or = "or"
    static let dontHaveAcc = "Don't have an account"
    static let createAccount = "Create Account"
    static let alreadyHaveAcc = "Already have an account"
    static let acceptTermsCondition = "I accept the following Terms and conditions"
    static let cannotMakeCallAtThisMoment = "Cannot make call at this moment"
    static let couldnotOpenEmailAttheMoment = "Could not open Email at the moment."
    static let chooseCountry = "Choose Country"
    static let chooseCity  = "Choose City"
    static let male = "Male"
    static let female = "Female"
    static let staticGender = "Gender"
    static let state = "State"
    static let search = "Search"
    static let referal = "Referral(Optional)"
    static let termsAndCondition = "Terms and Conditions"
    static let coupon = "Coupon"
    static let rideOffer = "Ride Offer"
    static let expiredOffer = "Offer Will expire in "
    static let countrySearchError = "No Country Found"
    static let citySearchError = "No City Found"
    static let countryCodeSearchError = "No Country Code Found"
    static let otpTitle = "Enter the OTP received on the registered mobile number"
    static let InvalidOTP = "Enter valid OTP"
    static let otpVerification = "Otp Verification"
    static let verify = "VERIFY"
    static let optional = "(optional)"
    static let connectApple = "Connect via Apple"
    static let networkConnection = "Please check the Network Connection"
    static let close = "Close"
    static let completeaccount = "Please take a moment to complete your account"



    //Validation
    static let emailEmpty = "Enter Email Id"
    static let phoneEmpty = "Enter Phone Number"
    static let passwordEmpty = "Enter Password"
    static let validEmail = "Enter valid email id"
    static let validPhone = "Enter valid phone number"
    static let passwordlength = "Password Must have Atleast 6 Characters."
    static let enterNewPassword = "Enter new password"
    static let enterOldPassword = "Enter old password"
    static let enterConfirmPassword = "Enter confirm password"
    static let passwordNotSame = "Old password and new password not be same"
    static let passwordSame = "New password and confirm password should be same"
    
    //Signup validation
    static let firstNameEmpty = "Enter First Name"
    static let lastNameEmpty = "Enter Last Name"
    static let cityEmpty = "Enter City"
    static let countryEmpty = "Enter Country"
    static let stateEmpty = "Enter State"
    static let notAcceptTC = "Please accept Terms and conditions"
    
    //MARK: - CustomView
    static let WalkThroughCell = "WalkThroughCell"
    static let PaymentView = "PaymentView"
    static let CountryListCell = "CountryListCell"
    
    //MARK: - Viewcontroller Identifier
    static let WalkThroughController = "WalkThroughController"
    static let SignInController = "SignInController"
    static let SignUpController = "SignUpController"
    static let CountryCodeViewController = "CountryCodeViewController"
    static let ForgotPasswordController = "ForgotPasswordController"
    static let WebViewController = "WebViewController"
    static let SplashViewController = "SplashViewController"
    static let ChatViewController = "ChatViewController"
    static let OtpController = "OtpController"
    
    //MARK:- Image Names
    static let phone = "ic_phone"
    static let mail = "ic_mail"
    static let back = "ic_back"
    static let faceBookImage = "ic_facebook"
    static let googleImage = "ic_google"
    static let couponImage = "icnCoupon"
    static let searchImage = "search"
    static let soicalLoginmessage = "Please signup this account."
    
    ///Paramets
    //Sigin
    static let email = "email"
    static let password = "password"
    static let salt_key = "salt_key"
    
    //signup
    static let device_type = "device_type"
    static let device_token = "device_token"
    static let device_id = "device_id"
    static let login_by = "login_by"
    static let first_name = "first_name"
    static let last_name = "last_name"
    static let gender = "gender"
    static let country_code = "country_code"
    static let iso2 = "iso2"//used for signin too
    static let mobile = "mobile" //used for signin too
    static let password_confirmation = "password_confirmation"
    static let old_password = "old_password"
    static let country_id = "country_id"
    static let state_id = "state_id"
    static let city_id = "city_id"
    static let socialUniqueid = "social_unique_id"
    static let picture = "picture"
    static let referral_code = "referral_code"
    
    //forgot password
    static let account_type = "account_type"
    static let otp = "otp"
    static let username = "username"
}

struct Country: Decodable {
    
    var name : String
    var dial_code : String
    var code : String
}

//Device Type
enum deviceType: String {
    case android = "ANDROID"
    case ios = "IOS"
}

enum loginBy: String {
    case manual = "MANUAL"
    case facebook = "FACEBOOK"
    case google = "GOOGLE"
    case apple = "APPLE"
}

enum gender: String {
    case male = "MALE"
    case female = "FEMALE"
}

enum accountType: String { //Forgot Password
    case email = "email"
    case mobile = "mobile"
}

enum userType: String {
    case user = "user"
    case Provider = "provider"
}


enum CoreDataEntity: String {
    case userData = "UserData"
    case loginData = "LoginData"
}

class StoreLoginData {
    static var shared = StoreLoginData()
    private init() {}
    
    var firstName: String?
    var lastName: String?
    var email:String?
    var gender: String?
    var countryCode: String?
    var mobile: String?
    var countryId: Int?
    var cityId: Int?
    var referralCode: String?
    var socialAccessToken: String?
    var loginBy: loginBy?
    var profileImageData:[String:Data]?
    var password: String?
    
    func clear() {
        firstName = nil
        lastName = nil
        email = nil
        gender = nil
        countryCode = nil
        mobile = nil
        countryId = nil
        cityId = nil
        referralCode = nil
        socialAccessToken = nil
        loginBy = nil
        profileImageData = nil
        password = nil
    }
}



