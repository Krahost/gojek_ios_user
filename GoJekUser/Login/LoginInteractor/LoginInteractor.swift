//
//  LoginInteractor.swift
//  GoJekUser
//
//  Created by apple on 19/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

class LoginInteractor: LoginPresentorToLoginInterectorProtocol{
    
    //MARK:- Presenter
    var loginPresenter: LoginInterectorToLoginPresenterProtocol?
    
     //MARK:-
    func signUp(param: Parameters, imageData: [String:Data]?) {
        WebServices.shared.requestToImageUpload(type: LoginEntity.self, with: LoginAPI.signUp, imageData: imageData, showLoader: true, params: param, accessTokenAdd: false) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let responseValue = response?.value {
                self.loginPresenter?.signUpSuccess(signUpEntity: responseValue)
            }
        }
    }
    
    func getBaseURL(param: Parameters) {
       
        WebServices.shared.requestToApi(type: BaseEntity.self, with:  APPConstant.baseUrl, urlMethod: .post, showLoader: false,params: param) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.loginPresenter?.getBaseURLResponse(baseEntity: response)
            }
        }
    }
    
    func signin(param: Parameters) {
        WebServices.shared.requestToApi(type: LoginEntity.self, with: LoginAPI.signIn, urlMethod: .post,showLoader: true,params: param) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value  {
                self.loginPresenter?.signinSuccess(loginEntity: response)
            }
        }
    }
    
    func getCountries(param: Parameters) {
        WebServices.shared.requestToApi(type: CountryEntity.self, with: LoginAPI.countries, urlMethod: .post, showLoader: true,params: param) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.loginPresenter?.getCountries(countryEntity: response)
            }
        }
    }
    
    func forgotPassword(param: Parameters) {
        WebServices.shared.requestToApi(type: ForgotPasswordEntity.self, with: LoginAPI.forgotPassword, urlMethod: .post,showLoader: true,params: param) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value  {
                self.loginPresenter?.forgotPasswordSuccess(forgotPasswordEntity: response)
            }
        }
    }
    
    func socialLoginWithUserDetail(param: Parameters) {
        
        WebServices.shared.requestToApi(type: LoginEntity.self, with: LoginAPI.socialLogin, urlMethod: .post, showLoader: true, params: param, failureReturen: true, completion: { [weak self] response in
            guard let self = self else {
                return
            }
            if let responseValue = response?.value {
                self.loginPresenter?.updateSocialLoginSuccess(socialEntity: responseValue)
            }
            else {
                self.loginPresenter?.failureResponse(failureData: (response?.data)!)
            }
        })
    }
    
    func verifyMobileAndEmail(param: Parameters) {
        
        WebServices.shared.requestToApi(type: LoginEntity.self, with: LoginAPI.verify, urlMethod: .post,showLoader: true,params: param) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value  {
                self.loginPresenter?.verifySuccess(verifyEntity: response)
            }
        }
    }
    
    func sendOtp(param: Parameters) {
        
        WebServices.shared.requestToApi(type: sendOtpEntity.self, with: LoginAPI.sendOtp, urlMethod: .post,showLoader: true,params: param) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value  {
                self.loginPresenter?.sendOtpSuccess(sendOtpEntity: response)
            }
        }
    }
    
    func verifyOtp(param: Parameters) {
        
        WebServices.shared.requestToApi(type: VerifyOtpEntity.self, with: LoginAPI.verifyOtp, urlMethod: .post,showLoader: true,params: param) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value  {
                self.loginPresenter?.verifyOtpSuccess(verifyOtpEntity: response)
            }
        }
    }
}
