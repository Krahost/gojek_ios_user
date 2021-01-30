//
//  LoginPresenter.swift
//  GoJekUser
//
//  Created by apple on 19/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

class LoginPresenter: LoginViewToLoginPresenterProtocol {
   
    
    var loginView: LoginPresenterToLoginViewProtocol?;
    var loginInterector: LoginPresentorToLoginInterectorProtocol?;
    var loginRouter: LoginPresenterToLoginRouterProtocol?
    
    //getBase url
    func getBaseURL(param: Parameters) {
        loginInterector?.getBaseURL(param: param)
    }
    
    func signin(param: Parameters) {
        loginInterector?.signin(param: param)
    }
    func getCountries(param: Parameters) {
        loginInterector?.getCountries(param: param)
    }
  
    func signUp(param: Parameters, imageData: [String:Data]?) {
        loginInterector?.signUp(param: param, imageData:  imageData)
    }
    
    func forgotPassword(param: Parameters) {
        loginInterector?.forgotPassword(param: param)
    }
    
    func socialLoginWithUserDetail(param: Parameters) {
        loginInterector?.socialLoginWithUserDetail(param: param)
    }
    
    func verifyMobileAndEmail(param: Parameters) {
        loginInterector?.verifyMobileAndEmail(param: param)
    }
    
    func sendOtp(param: Parameters){
        loginInterector?.sendOtp(param: param)
    }
    
    func verifyOtp(param: Parameters){
         loginInterector?.verifyOtp(param: param)
    }
}

extension LoginPresenter: LoginInterectorToLoginPresenterProtocol {
    
    func sendOtpSuccess(sendOtpEntity: sendOtpEntity) {
        loginView?.sendOtpSuccess(sendOtpEntity: sendOtpEntity)
    }
    
    func verifyOtpSuccess(verifyOtpEntity: VerifyOtpEntity) {
        loginView?.verifyOtpSuccess(verifyOtpEntity: verifyOtpEntity)
    }
    
    func verifySuccess(verifyEntity: LoginEntity) {
        loginView?.verifySuccess(verifyEntity: verifyEntity)
    }
    
    //get base url response
    func getBaseURLResponse(baseEntity: BaseEntity) {
        loginView?.getBaseURLResponse(baseEntity: baseEntity)
    }
    
    func signinSuccess(loginEntity: LoginEntity) {
        loginView?.signinSuccess(loginEntity: loginEntity)
    }
    
    func getCountries(countryEntity: CountryEntity) {
        loginView?.getCountries(countryEntity: countryEntity)
    }
    
    func signUpSuccess(signUpEntity: LoginEntity) {
        loginView?.signUpSuccess(signUpEntity: signUpEntity)
    }
    
    func forgotPasswordSuccess(forgotPasswordEntity: ForgotPasswordEntity) {
        loginView?.forgotPasswordSuccess(forgotPasswordEntity: forgotPasswordEntity)
    }
    
    func updateSocialLoginSuccess(socialEntity: LoginEntity) {
        loginView?.updateSocialLoginSuccess(socialEntity: socialEntity)
    }
    
    //Failure response
    func failureResponse(failureData: Data) {
        loginView?.failureResponse(failureData: failureData)
    }
}
