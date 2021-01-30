//
//  AccountInteractor.swift
//  GoJekUser
//
//  Created by apple on 20/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

class AccountInteractor: AccountPresenterToAccountInteractorProtocol {
    
    var accountPresenter: AccountInteractorToAccountPresenterProtocol?
    
    
    //MARK:- Profile
    func fetchUserProfileDetails() {
        WebServices.shared.requestToApi(type: UserProfileResponse.self, with: AccountAPI.getProfile, urlMethod: .get, showLoader: true, encode: URLEncoding.default) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value  {
                self.accountPresenter?.showUserProfileDtails(details: response)
            }
        }
    }
    
    func resetPassword(param: Parameters) {
        WebServices.shared.requestToApi(type: ResetPasswordEntity.self, with: PaymentAPI.resetPassword, urlMethod: .post, showLoader: true, params: param) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.accountPresenter?.resetPasswordSuccess(resetPasswordEntity: response)
            }
        }
    }
    
    func editProfile(param: Parameters,imageData: [String:Data]?) {
        WebServices.shared.requestToImageUpload(type: SuccessEntity.self, with: AccountAPI.editProfile, imageData: imageData, showLoader: true, params: param) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.accountPresenter?.editProfileSuccess(profileEntity: response)
            }
        }
    }
    
    func changePassword(param: Parameters) {
        WebServices.shared.requestToApi(type: SuccessEntity.self, with: AccountAPI.changePassword, urlMethod: .post, showLoader: true,params: param) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.accountPresenter?.changePassword(changePassword: response)
            }
        }
    }
    
    func toLogout() {
        WebServices.shared.requestToApi(type: LogoutEntity.self, with: AccountAPI.logout, urlMethod: .post, showLoader: true) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.accountPresenter?.getLogoutSuccess(logoutEntity: response)
            }
        }
    }
    
    //MARK: - Payment
    func addCard(param: Parameters) {
        
        WebServices.shared.requestToApi(type: CardEntityResponse.self, with: PaymentAPI.addCard, urlMethod: .post, showLoader: true,params: param) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.accountPresenter?.addCardSuccess(addCardResponse: response)
            }
        }
    }
    
    func getCard() {
        WebServices.shared.requestToApi(type: CardEntityResponse.self, with: AccountAPI.getCard, urlMethod: .get, showLoader: true, encode: URLEncoding.default) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.accountPresenter?.getCardResponse(getCardResponse: response)
            }
        }
    }
    
    func deleteCard(cardID: Int) {
        WebServices.shared.requestToApi(type: CardEntityResponse.self, with: "\(AccountAPI.deleteCard)/\(cardID)", urlMethod: .delete, showLoader: true) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.accountPresenter?.deleteCardSuccess(deleteCardResponse: response)
            }
        }
    }
    
    func addMoneyToWallet(param: Parameters) {
        WebServices.shared.requestToApi(type: AddAmountEntity.self, with: AccountAPI.addMoney, urlMethod: .post, showLoader: true,params: param) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.accountPresenter?.addMoneyToWalletSuccess(walletSuccessResponse: response)
            }
        }
    }
    
    func getTransactionList(offet:Int,limit: String,ishideLoader: Bool){
        let url = AccountAPI.getTransaction
            //+ "?offset=" + offet.toString() + "&limit=" + limit
        let param:Parameters = [
            "offset":offet,
            "limit":limit
        ]
        
        WebServices.shared.requestToApi(type: TransactionEntity.self, with: url, urlMethod: .get, showLoader: ishideLoader, params: param, encode: URLEncoding.default) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.accountPresenter?.getTransactionList(transactionEntity: response)
            }
        }
    }
    
    func qrCodeWalletTransfer(param: Parameters) {
        WebServices.shared.requestToApi(type: SuccessEntity.self, with: AccountAPI.myQRCode, urlMethod: .post, showLoader: true, params: param) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.accountPresenter?.qrCodeWalletTransferSuccess(qrCodeSuccess: response)
            }
        }
    }
    
    //MARK: - Address
    func getSavedAddress() {
        WebServices.shared.requestToApi(type: SavedAddressEntity.self, with: AccountAPI.getAddress, urlMethod: .get, showLoader: true, encode: URLEncoding.default) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.accountPresenter?.savedAddressSuccess(addressEntity: response)
            }
        }
    }
    
    func addAddress(param: Parameters) {
        WebServices.shared.requestToApi(type: SuccessEntity.self, with: AccountAPI.addAddress, urlMethod: .post, showLoader: true,params: param) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.accountPresenter?.addAddressSuccess(addressEntity: response)
            }
        }
    }
    
    func editAddress(param: Parameters) {
        WebServices.shared.requestToApi(type: SuccessEntity.self, with: AccountAPI.editAddress, urlMethod: .post, showLoader: true,params: param) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.accountPresenter?.editAddressSuccess(addressEntity: response)
            }
        }
    }
    
    func deleteAddress(id: String) {
        WebServices.shared.requestToApi(type: SuccessEntity.self, with: AccountAPI.deleteAddress+"/"+id, urlMethod: .delete,showLoader: true) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value  {
                self.accountPresenter?.deleteAddressSuccess(addressEntity: response)
            }
        }
    }
    
    //MARK: - Settings
    func updateLanguage(param: Parameters) {
        WebServices.shared.requestToApi(type: LogoutEntity.self, with: AccountAPI.updateLanguage, urlMethod: .post, showLoader: true,params: param) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.accountPresenter?.updateLanguageSuccess(updateLanguageEntity: response)
            }
        }
    }
    
    func postAppsettings(param: Parameters) {
        WebServices.shared.requestToApi(type: BaseEntity.self, with:  AccountAPI.appSettings, urlMethod: .post, showLoader: true, params: param) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.accountPresenter?.postAppsettingsResponse(baseEntity: response)
            }
        }
    }
    
    func getCountries(param: Parameters) {
        WebServices.shared.requestToApi(type: CountryEntity.self, with: LoginAPI.countries, urlMethod: .post, showLoader: false,params: param) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.accountPresenter?.getCountries(countryEntity: response)
            }
        }
    }
    
    func sendOtp(param: Parameters) {
        
        WebServices.shared.requestToApi(type: sendOtpEntity.self, with: LoginAPI.sendOtp, urlMethod: .post,showLoader: true,params: param,accessTokenAdd: false) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value  {
                self.accountPresenter?.sendOtpSuccess(sendOtpEntity: response)
            }
        }
    }
    
    func verifyOtp(param: Parameters) {
        
        WebServices.shared.requestToApi(type: VerifyOtpEntity.self, with: LoginAPI.verifyOtp, urlMethod: .post,showLoader: true,params: param,accessTokenAdd: false) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value  {
                self.accountPresenter?.verifyOtpSuccess(verifyOtpEntity: response)
            }
        }
    }
}
