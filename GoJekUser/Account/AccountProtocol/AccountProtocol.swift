//
//  AccountProtocol.swift
//  GoJekUser
//
//  Created by apple on 20/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

var myAccountPresenterObject: AccountViewToAccountPresenterProtocol?

//MARK:- Account Presenter to Account View Protocol

protocol AccountPresenterToAccountViewProtocol: class {
    
    //Profile
    func showUserProfileDtails(details:UserProfileResponse)
    func resetPassword(resetPasswordEntity: ResetPasswordEntity)
    func editProfileSuccess(profileEntity: SuccessEntity)
    func changePasswordSuccess(changePassword: SuccessEntity)
    func getLogoutSuccess(logoutEntity: LogoutEntity)
    
    //Payment
    func addCardSuccess(addCardResponse: CardEntityResponse)
    func getCardResponse(getCardResponse: CardEntityResponse)
    func deleteCardSuccess(deleteCardResponse: CardEntityResponse)
    func addMoneyToWalletSuccess(walletSuccessResponse: AddAmountEntity)
    func getTransactionList(transactionEntity: TransactionEntity)
    func qrCodeWalletTransferSuccess(qrCodeSuccess: SuccessEntity)
    
    //Address
    func savedAddressSuccess(addressEntity: SavedAddressEntity)
    func addAddressSuccess(addressEntity: SuccessEntity)
    func editAddressSuccess(addressEntity: SuccessEntity)
    func deleteAddressSuccess(addressEntity: SuccessEntity)
    
    //Setting
    func updateLanguageSuccess(updateLanguageEntity: LogoutEntity)
    func postAppsettingsResponse(baseEntity: BaseEntity)
    func getCountries(countryEntity: CountryEntity)
    func showFailureDetails()
    func sendOtpSuccess(sendOtpEntity:sendOtpEntity)
    func verifyOtpSuccess(verifyOtpEntity:VerifyOtpEntity)
}

extension AccountPresenterToAccountViewProtocol {
    
    var accountPresenter: AccountViewToAccountPresenterProtocol? {
        get {
            myAccountPresenterObject?.accountView = self
            return myAccountPresenterObject
        }
        set(newValue) {
            myAccountPresenterObject = newValue
        }
    }
    
    //Profile
    func showUserProfileDtails(details:UserProfileResponse) { return }
    func resetPassword(resetPasswordEntity: ResetPasswordEntity) { return }
    func editProfileSuccess(profileEntity:  SuccessEntity) { return }
    func changePasswordSuccess(changePassword:  SuccessEntity) { return }
    func getLogoutSuccess(logoutEntity: LogoutEntity) { return }
    
    //Payment
    func addCardSuccess(addCardResponse: CardEntityResponse) { return }
    func getCardResponse(getCardResponse: CardEntityResponse) { return }
    func deleteCardSuccess(deleteCardResponse: CardEntityResponse) { return }
    func addMoneyToWalletSuccess(walletSuccessResponse: AddAmountEntity) { return }
    func getTransactionList(transactionEntity: TransactionEntity) { return }
    func qrCodeWalletTransferSuccess(qrCodeSuccess: SuccessEntity) { return }

    //Address
    func savedAddressSuccess(addressEntity: SavedAddressEntity) { return }
    func addAddressSuccess(addressEntity: SuccessEntity) { return }
    func editAddressSuccess(addressEntity: SuccessEntity) { return }
    func deleteAddressSuccess(addressEntity: SuccessEntity) { return }
    
    //Setting
    func updateLanguageSuccess(updateLanguageEntity: LogoutEntity) { return }
    func postAppsettingsResponse(baseEntity: BaseEntity) { return }
    func getCountries(countryEntity: CountryEntity) { return }
    func sendOtpSuccess(sendOtpEntity:sendOtpEntity) { return }
    func verifyOtpSuccess(verifyOtpEntity:VerifyOtpEntity) { return }
    func showFailureDetails() { return }
}

//MARK:- Account interactor to Account presenter

protocol AccountInteractorToAccountPresenterProtocol: class {
    
    //Profile
    func showUserProfileDtails(details:UserProfileResponse)
    func resetPasswordSuccess(resetPasswordEntity: ResetPasswordEntity)
    func editProfileSuccess(profileEntity: SuccessEntity)
    func changePassword(changePassword: SuccessEntity)
    func getLogoutSuccess(logoutEntity: LogoutEntity)

    //Payment
    func addCardSuccess(addCardResponse: CardEntityResponse)
    func getCardResponse(getCardResponse: CardEntityResponse)
    func deleteCardSuccess(deleteCardResponse: CardEntityResponse)
    func addMoneyToWalletSuccess(walletSuccessResponse: AddAmountEntity)
    func getTransactionList(transactionEntity: TransactionEntity)
    func qrCodeWalletTransferSuccess(qrCodeSuccess: SuccessEntity)

    //Address
    func savedAddressSuccess(addressEntity: SavedAddressEntity)
    func addAddressSuccess(addressEntity: SuccessEntity)
    func editAddressSuccess(addressEntity: SuccessEntity)
    func deleteAddressSuccess(addressEntity: SuccessEntity)
    
    //Setting
    func updateLanguageSuccess(updateLanguageEntity: LogoutEntity)
    func postAppsettingsResponse(baseEntity: BaseEntity)
    func getCountries(countryEntity: CountryEntity)
    func sendOtpSuccess(sendOtpEntity:sendOtpEntity)
    func verifyOtpSuccess(verifyOtpEntity:VerifyOtpEntity)
}


//MARK:- Account presenter to Account Interactor

protocol AccountPresenterToAccountInteractorProtocol: class {
    
    var accountPresenter: AccountInteractorToAccountPresenterProtocol? {get set}
    
    //Profile
    func fetchUserProfileDetails()
    func resetPassword(param: Parameters)
    func editProfile(param: Parameters,imageData: [String:Data]?)
    func changePassword(param: Parameters)
    func toLogout()

    //Payment
    func getCard()
    func deleteCard(cardID:Int)
    func addCard(param: Parameters)
    func addMoneyToWallet(param: Parameters)
    func getTransactionList(offet:Int, limit: String, ishideLoader: Bool)
    func qrCodeWalletTransfer(param: Parameters)

    //Address
    func getSavedAddress()
    func addAddress(param: Parameters)
    func editAddress(param: Parameters)
    func deleteAddress(id: String)
    
    //Setting
    func updateLanguage(param: Parameters)
    func postAppsettings(param: Parameters)
    func getCountries(param: Parameters)
    func sendOtp(param: Parameters)
    func verifyOtp(param: Parameters)
}

//MARK:- Account View to Account presenter
protocol AccountViewToAccountPresenterProtocol: class {
    
    var accountView: AccountPresenterToAccountViewProtocol? {get set}
    var accountInterector: AccountPresenterToAccountInteractorProtocol? {get set}
    var acountRouter: AccountPresenterToAccountRouterProtocol? {get set}
    
    //Profile
    func fetchUserProfileDetails()
    func resetPassword(param: Parameters)
    func editProfile(param: Parameters,imageData: [String:Data]?)
    func changePassword(param: Parameters)
    func toLogout()

    //Payment
    func addCard(param: Parameters)
    func getCard()
    func deleteCard(cardID:Int)
    func addMoneyToWallet(param: Parameters)
    func getTransactionList(offet:Int,limit: String,ishideLoader: Bool)
    func qrCodeWalletTransfer(param: Parameters)

    //Address
    func getSavedAddress()
    func addAddress(param: Parameters)
    func editAddress(param: Parameters)
    func deleteAddress(id: String)
    
    //Setting
    func updateLanguage(param: Parameters)
    func postAppsettings(param: Parameters)
    func getCountries(param: Parameters)
    func sendOtp(param: Parameters)
    func verifyOtp(param: Parameters)

}

//MARK:- Account presenter to Account Router
protocol AccountPresenterToAccountRouterProtocol: class {
    
    // static func createModule(viewIdentifier: String, currentController: UIViewController) -> UIViewController
}

protocol PaymentBackDelegate {
    func isFromCard()
}
