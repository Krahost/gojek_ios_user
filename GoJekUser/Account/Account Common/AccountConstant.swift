//
//  AccountConstant.swift
//  GoJekUser
//
//  Created by apple on 21/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

enum AccountConstant {
    
    //MARK: - String
    static let yourRefferalcode = "Your Referral Code"
    static let referralCount = "Referral Count"
    static let referralAmount = "Referral Amount"
    static let account = "My Account"
    static let profile = "Profile"
    static let manageAddress = "Manage Address"
    static let payment = "Payment"
    static let wallet = "Wallet"
    static let inviteReferral = "Invite Referrals"
    static let privacyPolicy = "Privacy Policy"
    static let support = "Support"
    static let language = "Language"
    static let call = "Call"
    static let mail = "Mail"
    static let website = "Website"
    static let contactOurTeam = "Contact Our Team Via"
    static let supportDesc = "You can contact our team \n\n anytime for your queries."
    static let createNewPassword = "Create new password"
    static let resetPassword = "Reset Password"
    static let otpVerification = "OTP Verification"
    static let oldPassword = "Old Password"
    static let newPassword = "New Password"
    static let confirmPassword = "Confirm Password"
    static let inviteFriend = "Invite your friends and earn"
    static let forEvery = "for every"
    static let newUser = "new users"
    static let otp = "OTP"
    static let invalidOtp = "Invalid OTP"
    static let enterOtp = "Enter OTP"
    static let logout = "Logout"
    static let logoutMsg = "Are you sure want to logout?"
    static let profileUpdated = "Profile updated successfully"
    static let inviteContent = "Hey, I am using  \(APPConstant.appName) and invite you to join! Use my referral code: "
    static let haveGoodDay = "Have a good day!"
    static let deleteMsg = "Are you sure want to delete?"
    static let noAddress = "You not save any address"
    static let selectLanguage = "Select Language"
    static let noTransaction = "You dont have transaction"
    static let AddAddress = "Add Address"
    
    static let changePassword = "Change Password"
    static let changePwd = "Change Password ?"
    static let cardEmpty = "Please enter your card"
    static let yearEmpty = "Please enter expire year"
    static let monthEmpty = "Please enter expire month"
    static let cvvEmpty = "Enter your CVV number"
    static let loginManual = "MANUAL"
    static let paymentTitle = "Payment Type"
    static let PLimit = "limit"
    static let POffset = "offset"
    static let languageSuccess = "Language updated successfully"
    
    static let choosePayment = "Choose Payment"
    static let noPaymentType = "No Payment gateway"
    static let availablePayment = "Available Payments"
    
    //payment
    static let addCardAlert = "Please add card"
    static let cardSelection = "Please select card"
    static let cardEmptyField = "Please add valid amount"
    static let transaction = "Transaction"
    static let transactionID = "Transaction id"
    static let status = "Status"
    static let addCard = "Add Card Payments"
    static let addedAddress = "Your address added successfully"
    static let validAmount = "Enter amount more than 0 and proceed"
    
    //Manage address
    static let savedLocation = "Saved Locations"
    static let edit = "Edit"
    static let delete = "Delete"
    static let addNewAddress = "Add New Address"
    static let location = "Location"
    static let flatNo = "House/Flat No."
    //    static let landmark = "Landmark"
    static let saveAs = "Save As"
    //    static let title = "Title"
    static let enterDetail = "Enter the details"
    static let confirmLocation = "Confirm Location"
    static let enterLocation = "Enter location"
    static let enterFlat = "Enter flat"
    static let enterLandmark = "Enter landmark"
    static let enterTitle = "Enter address title"
    static let addressType = "Choose address type"
    static let addressTypeExit = "This address type already exist, whould you like to edit?"
    
    static let languageUpdated = "Language updated successfully"
    static let AddAmountSuccess = "Amount Added Successfully"
    static let qrCOde = "Scan for send or receive amount"
    static let qrsendAmount = "Send amount"
    static let qrreceiveAmount = "Receive amount"
    static let myQRcode = "My QRCode"
    static let scanQRcode = "Scan QRCode"
    
    //Controller
    static let InviteController = "InviteViewController"
    static let MyAccountController = "MyAccountController"
    static let SupportController = "SupportController"
    static let MyProfileController = "MyProfileController"
    static let ManageAddressController = "ManageAddressController"
    static let ChangePasswordController = "ChangePasswordController"
    static let PaymentController = "PaymentController"
    static let WebViewController = "WebViewController"
    static let AddAddressController = "AddAddressController"
    static let LanguageController = "LanguageController"
    static let PaymentSelectViewController = "PaymentSelectViewController"
    static let PaymentTypeTableViewCell = "PaymentTypeTableViewCell"
    static let CardView = "CardView"
    static let AccountCollectionViewCell = "AccountCollectionViewCell"
    static let SavedAddressCell = "SavedAddressCell"
    static let LanguageTableViewCell = "LanguageTableViewCell"
    static let MapCell = "MapCell"
    static let AddressCell = "AddressCell"
    static let TransactionTableCell = "TransactionTableCell"
    static let TransactionHeaderView = "TransactionHeaderView"
    static let payStackView = "PayStackView"
    static let myQRCodeViewController = "MyQRCodeViewController"
    static let scanQRCodeViewController = "ScanQRCodeViewController"
    
    ///Images
    static let icprofile = "ic_profile"
    static let referFriend = "ic_gift_card"
    static let icprivacyPolicy = "ic_privacy_policy"
    static let icsupport = "ic_support"
    static let web = "ic_web"
    static let phone = "ic_phone"
    static let icmail = "ic_mail"
    static let languageImage = "ic_language"
    static let logoutImage = "ic_logout"
    static let ic_scan = "ic_scan"
    static let ic_qrcode = "ic_qrcode"
    
    ///Parameter
    
    static let stripeToken = "stripe_token"
    
    //wallet Post
    static let amount = "amount"
    static let staticamount = "Amount"
    static let card_id = "card_id"
    static let user_type = "user_type"
    static let payment_Mode = "payment_mode"
    
    //Manage Address
    static let address_type = "address_type"
    static let landmark = "landmark"
    static let flat_no = "flat_no"
    static let street = "street"
    static let latitude = "latitude"
    static let longitude = "longitude"
    static let map_address = "map_address"
    static let id = "id"
    static let title = "title"
    static let Language = "language"
}

enum AccountAPI {
    
    static let getProfile = "/user/profile"
    static let getCard = "/user/card"
    static let deleteCard = "/user/card"
    static let addMoney = "/user/add/money"
    static let editProfile = "/user/profile"
    static let changePassword = "/user/password"
    static let getAddress = "/user/address"
    static let addAddress = "/user/address/add"
    static let editAddress = "/user/address/update"
    static let deleteAddress = "/user/address"
    static let getTransaction = "/user/wallet"
    static let logout = "/user/logout"
    static let userCity = "/user/city"
    static let updateLanguage = "/user/updatelanguage"
    static let appSettings = "/user/appsettings"
    static let userChat = "/user/chat"
    static let KChat = "/chat"
    static let myQRCode = "/user/wallet/transfer"
}

enum paymentMode: String {
    case card = "Card"
}

enum AddressType: String,CaseIterable {
    case Home
    case Work
    case Other
    
    var image: String {
        switch self {
        case .Home: return "ic_address_home"
        case .Work: return "ic_work"
        case .Other: return "ic_location_pin"
        }
    }
}

struct AddressDetails {
    
    var location : String
    var flatno : String
    var latitude: Double
    var longitude: Double
}

enum PredefineAddressType: String {
    
    case Home = "Home"
    case Work = "Work"
}
