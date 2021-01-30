//
//  AccountPresenter.swift
//  GoJekUser
//
//  Created by apple on 20/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

class AccountPresenter: AccountViewToAccountPresenterProtocol {
    
    var accountView: AccountPresenterToAccountViewProtocol?
    var accountInterector: AccountPresenterToAccountInteractorProtocol?
    var acountRouter: AccountPresenterToAccountRouterProtocol?
    
    //MARK: - Profile
    func fetchUserProfileDetails() {
        accountInterector?.fetchUserProfileDetails()
    }
    
    func resetPassword(param: Parameters) {
        accountInterector?.resetPassword(param: param)
    }
    
    func editProfile(param: Parameters,imageData: [String:Data]?) {
        accountInterector?.editProfile(param: param, imageData: imageData)
    }
    
    func changePassword(param: Parameters) {
        accountInterector?.changePassword(param: param)
    }
    
    //MARK: - Payment
    func addCard(param: Parameters) {
        accountInterector?.addCard(param: param)
    }
    
    func getCard() {
        accountInterector?.getCard()
    }
    
    func deleteCard(cardID: Int) {
        accountInterector?.deleteCard(cardID: cardID)
    }
    
    func addMoneyToWallet(param: Parameters) {
        accountInterector?.addMoneyToWallet(param: param)
    }
    
    func getTransactionList(offet:Int,limit: String,ishideLoader: Bool) {

        accountInterector?.getTransactionList(offet: offet, limit: limit, ishideLoader: ishideLoader)
    }
    
    func qrCodeWalletTransfer(param: Parameters) {
        accountInterector?.qrCodeWalletTransfer(param: param)
    }
    
    //MARK: - Address
    func getSavedAddress() {
        accountInterector?.getSavedAddress()
    }
    
    func addAddress(param: Parameters) {
        accountInterector?.addAddress(param: param)
    }
    
    func editAddress(param: Parameters) {
        accountInterector?.editAddress(param: param)
    }
    
    func deleteAddress(id: String) {
        accountInterector?.deleteAddress(id: id)
    }
    
    //MARK: - Setting
    func getCountries(param: Parameters) {
        accountInterector?.getCountries(param: param)
    }
    
    func updateLanguage(param: Parameters) {
        accountInterector?.updateLanguage(param: param)
    }
    
    func postAppsettings(param: Parameters) {
        accountInterector?.postAppsettings(param: param)
    }
    
    func toLogout() {
        accountInterector?.toLogout()
    }
    func sendOtp(param: Parameters){
        accountInterector?.sendOtp(param: param)
    }
    func verifyOtp(param: Parameters){
        accountInterector?.verifyOtp(param: param)
    }
}

extension AccountPresenter: AccountInteractorToAccountPresenterProtocol {
    
    //MARK: - Profile
    func showUserProfileDtails(details: UserProfileResponse) {
        accountView?.showUserProfileDtails(details: details)
    }
    
    func resetPasswordSuccess(resetPasswordEntity: ResetPasswordEntity) {
        accountView?.resetPassword(resetPasswordEntity: resetPasswordEntity)
    }
    
    func editProfileSuccess(profileEntity: SuccessEntity) {
        accountView?.editProfileSuccess(profileEntity: profileEntity)
    }
    
    func changePassword(changePassword: SuccessEntity) {
        accountView?.changePasswordSuccess(changePassword: changePassword)
    }
    
    //MARK: - Payment
    func addCardSuccess(addCardResponse: CardEntityResponse) {
        accountView?.addCardSuccess(addCardResponse: addCardResponse)
    }
    
    func getCardResponse(getCardResponse: CardEntityResponse) {
        accountView?.getCardResponse(getCardResponse: getCardResponse)
    }
    
    func deleteCardSuccess(deleteCardResponse: CardEntityResponse) {
        accountView?.deleteCardSuccess(deleteCardResponse: deleteCardResponse)
    }
    
    func addMoneyToWalletSuccess(walletSuccessResponse: AddAmountEntity) {
        accountView?.addMoneyToWalletSuccess(walletSuccessResponse: walletSuccessResponse)
    }
    
    func getTransactionList(transactionEntity: TransactionEntity) {
        accountView?.getTransactionList(transactionEntity: transactionEntity)
    }
    
    func qrCodeWalletTransferSuccess(qrCodeSuccess: SuccessEntity) {
        accountView?.qrCodeWalletTransferSuccess(qrCodeSuccess: qrCodeSuccess)
    }
    
    //MARK: - Address
    func savedAddressSuccess(addressEntity: SavedAddressEntity) {
        accountView?.savedAddressSuccess(addressEntity: addressEntity)
    }
    
    func addAddressSuccess(addressEntity: SuccessEntity) {
        accountView?.addAddressSuccess(addressEntity: addressEntity)
    }
    
    func editAddressSuccess(addressEntity: SuccessEntity) {
        accountView?.editAddressSuccess(addressEntity: addressEntity)
    }
    
    func deleteAddressSuccess(addressEntity: SuccessEntity) {
        accountView?.deleteAddressSuccess(addressEntity: addressEntity)
    }
    
    //MARK: - Setting
    func getCountries(countryEntity: CountryEntity) {
        accountView?.getCountries(countryEntity: countryEntity)
    }
    
    func updateLanguageSuccess(updateLanguageEntity: LogoutEntity) {
        accountView?.updateLanguageSuccess(updateLanguageEntity: updateLanguageEntity)
    }
    
    func postAppsettingsResponse(baseEntity: BaseEntity) {
        accountView?.postAppsettingsResponse(baseEntity: baseEntity)
    }
    
    func getLogoutSuccess(logoutEntity: LogoutEntity) {
        accountView?.getLogoutSuccess(logoutEntity: logoutEntity)
    }
    func sendOtpSuccess(sendOtpEntity: sendOtpEntity) {
        accountView?.sendOtpSuccess(sendOtpEntity: sendOtpEntity)
    }
    
    func verifyOtpSuccess(verifyOtpEntity: VerifyOtpEntity) {
        accountView?.verifyOtpSuccess(verifyOtpEntity: verifyOtpEntity)
    }
}
