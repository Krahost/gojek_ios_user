//
//  Constant.swift
//  GoJekUser
//
//  Created by apple on 18/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import CoreLocation

enum Constant {
    
    //MARK:- ViewControllers
    static let VCViewController = "ViewController"
    static let VCOrdersController = "OrdersController"
    static let VFilterView = "FilterView"
    static let VCInviteViewController = "InviteViewController"
    static let VFoodieScheduleTimeView = "FoodieScheduleTimeView"
    
    //View
    static let CustomTableView = "CustomTableView"
    static let TipsView = "TipsView"
    static let LocationTableView = "LocationTableView"
    static let SavedLocationCell = "SavedLocationCell"
     static let LocationTableViewCell = "LocationTableViewCell"

    //XIB
    static let CouponCollectionViewCell = "CouponCollectionViewCell"
    static let CouponView = "CouponView"
    static let RatingView = "RatingView"
    static let FoodieRatingView = "FoodieRatingView"
    static let paymentView = "PaymentView"
    static let PaymentTypeCell = "PaymentTypeCell"
    static let PaymentCardCell = "PaymentCardCell"
    static let CustomTableCell = "CustomTableCell"
         
    //MARK:- String
    static let cancelRequest = "Cancel Request"
    static let findDriver = "Finding driver nearby..."
    static let tChat = "Chat"
    static let cardPrefix = "**** "
    static let enterLocation = "Enter your location"
    static let chooseLocation = "Choose your location"
    static let walletAmount = "Wallet Amount"

    static let SOk = "OK"
    static let adminService = "admin_service"
    static let user = "user"
    static let provider = "provider"
    static let message = "message"
    static let type = "type"
    static let room = "room"
    static let id = "id"
    static let SCancel = "Cancel"
    static let SopenCamera = "Open Camera"
    static let SopenGalley = "Open Gallery"  
    static let SSave = "Save"
    static let SDone = "Done"
    static let Shome = "Home"
    static let Swork = "Work"
    static let SYes = "Yes"
    static let SNo = "No"
    static let SChoose = "I'll Choose"
    static let SRepeat = "Repeat Last"
    static let SSubmit = "Submit"
    static let SName = "Name"
    static let SPhoneNumber = "Phone Number"
    static let otp = "OTP : "
    static let change = "Change"
    static let confirm = "Confirm"
    static let add = "Add"
    static let other = "Others"
    static let noNetwork = "Please check your Internet conncection"
    static let choosePicture = "Choose your picture"
    static let choose = "Choose"
    static let writingSomething = "Write Something"
    static let Semail = "email"
    static let userName = "User Name"
    static let firstName = "First Name"
    static let lastName = "Last Name"  //
    static let code = "Code"
    static let phoneNumber = "Phone Number"
    static let emailId = "Email Id"
    static let password = "Password"
    static let city = "City"
    static let country = "Country"
    static let savedCards = "Saved Cards"
    static let addCard = "Add Cards"
    static let pleaseConfirmPayment = "Please confirm your payment"
    static let location = "Location"
    static let passwordChangesMsg = "Your password has been changed. Please login with new password"
    static let noSavedAddress = "No Address Found"
    static let eta = "ETA"
    static let removePhoto = "Remove Photo"
    
    static let chooseReason = "Choose Reason"
    static let confirmPayment = "Confirm Payment"
    static let ic_search = "ic_search"
    static let RatingToast = "Rated Successfully"
    static let googleConstant = "Can't open GoogleMap Application."
    
    //tips
    static let enterTips = "Enter amount for tips"
    static let tipErrorMsg = "Enter tip amount"
    static let tips = "Tips"
    
    //Schedule
    static let date = "Select Date"
    static let time = "Select Time"
    static let scheduleDateTime = "Schedule Your Date and Time"
    
    //Coupon
    static let useThis = "Use this"
    static let remove = "Remove"
    static let apply = "Apply"
    static let validityTill = "Validity till:"
    static let viewCoupon = "View Coupon"
    
    //Rating
    static let rating = "Rating"
    static let rateDriver = "Rate your driver"
    static let rateRestaurant = "Rate the Shop"
    static let leaveComment = "Leave your comments"
    
    //Payment
    static let addAmount = "Add Amount"
    static let cash = "Cash"
    static let card = "Card"
    static let payPal = "Paypal"
    static let payTm = "PayTm"
    static let payUMoney = "PayUMoney"
    static let brainTree = "Braintree"
    static let enterAmount = "Enter Amount"
    static let email = "Email"
    static let wallet = "Wallet"
    static let statusCode = "statusCode"
    static let addedAmountWalletAlert = "Amount Added to your Wallet"
    static let saltKey = "salt_key"
    static let PUrl = "url"
    static let transport = "TRANSPORT"
    static let service = "SERVICE"
    static let delivery = "DELIVERY"
    static let dismiss = "Dismiss"

    
    //validation
    static let nameEmpty = "Enter name"
    
    //MARK: Images
    static let home = "ic_home"
    static let locationHome = "ic_address_home"
    static let order = "ic_orders"
    static let notification = "ic_notification"
    static let account = "ic_account"
    static let editImage = "ic_edit"
    static let eye = "ic_eye"
    static let eyeOff = "ic_eye_off"
    static let squareFill = "ic_square_fill"
    static let sqaureEmpty = "ic_square_empty"
    static let deleteImage = "ic_delete"
    static let circleImage = "ic_circle"
    static let circleFullImage = "ic_circle_full"
    static let checkImage = "ic_check"
    static let closeImage = "ic_close"
    static let closee = "ic_close_cross"
    static let phoneImage = "ic_phone"
    static let chatImage = "ic_chat"
    static let cardImage = "ic_credit_card"
    static let ratingEmptyImage = "ic_star_empty"
    static let ratingFull = "ic_rating"
    static let payment = "ic_payment"
    static let walletSmall = "ic_wallet"
    static let ic_delivery_home = "ic_delivery_home"
    static let ic_map = "ic_map"
    static let ic_empty_card = "ic_empty_card"
    static let ic_downarrow = "ic_downarrow"
    static let ic_location_pin = "ic_location_pin"
    static let ic_current_location = "ic_current_location"
    static let ic_work = "ic_work"
    static let ic_back = "ic_back"
    static let leftArrowImage = "ic_leftarrow"
    static let shareImage = "ic_share"
    static let userPlaceholderImage = "ic_user"
    static let rightArrowImage = "ic_right_arrow_image"
    static let searchImage = "ic_searching"
    static let infoImage = "info"
    static let back = "ic_leftarrow"
    static let icSearchImage = "ic_search"
    static let sourcePin = "sourcePin"
    static let destinationPin = "destinationPin"
    static let moreCrossImage = "ic_more_cross"
    static let imagePlaceHolder = "ImagePlaceHolder"
    static let Xjek_User_01 = "Xjek_User_01"
    static let Xjek_User_02 = "Xjek_User_02"
    static let Xjek_User_03 = "Xjek_User_03"
    static let closeCross = "ic_close_cross"
    static let walletImage = "wallet"

    //MARK:- Alert Mesage
    static let requestTimeOut = "Request time out"
    
    //MARK: Parameters
    static let picture = "picture" //Image upload
    
    //Content Type
    static let RequestType = "X-Requested-With"
    static let RequestValue = "XMLHttpRequest"
    static let ContentType = "Content-Type"
    static let ContentValue = "application/json"
    static let Authorization = "Authorization"
    static let MultiPartValue = "multipart/form-data"
    static let Bearer = "Bearer"
    static let multiPartValue = "multipart/form-data"
    static let errorCode = "statusCode"
    
    static let extendTripAlert = "Are you sure you want to update the destination location"
    static let deleteScheduleReq = "Are you sure you want to delete this schedule"
    static let dateTimeSelect = "Please select Date and Time"
    static let cameraPermission = "Unable to open camera, Check your camera permission"
    static let descriptionOne = "All in one service to get you to your destination or bring the solution to you with ease."
    static let descriptionTwo = "Plan & book service wherever and whenever you want with just a few taps."
    static let descriptionThree = "Our service experts are always eager to assist you on the go, all-time, every time."
    static let serviceSelection = "Service Selection"
    static let serviceOngoing = "Service Ongoing"
    static let rateService = "Rate Service"
    
    static let English = "English"
    static let Arabic = "Arabic"
    
    //MARK: - Socket Room
    static let CommonUserRoom = "joinCommonUserRoom"
    static let PrivateRoomKey = "joinPrivateRoom"
    static let SocketStatus = "socketStatus"
    static let PrivateRoomListener = "serveRequest"
    static let LeaveRoom = "leaveRoom"
    static let SettingUpdate = "settingUpdate"
    
    //Chat
    static let JoinPrivateChatRoom = "joinPrivateChatRoom"
    static let NewMessage = "new_message"
    static let SendMessage = "send_message"
    
    //Location
    static let UpdateLocation = "updateLocation"
    
    //Image
    static let couponImage = "ic_coupon"
    
    static let newRequestHideSearch = "NewRequestHideSearch"


}

// push notifications type

enum pushNotificationType: String {
    
      case transport = "transport"
      case service = "service"
      case order = "order"
      case chat = "chat"
      case chat_order = "chat_order"
      case chat_transport = "chat_transport"
      case chat_delivery = "chat_delivery"
      case chat_servce = "chat_service"
}

enum RoomListener: String {
    case NewRequest = "newRequest"
    case Transport = "rideRequest"
    case Service = "serveRequest"
    case Order = "orderRequest"
    case Delivery = "deliveryRequest"
    case SettingUpdate = "settingUpdate"
}

enum VehicleType: String {
    
    case ride = "RIDE"
    case nont = "none"
}

struct SourceDestinationLocation {
    var address: String?
    var locationCoordinate: CLLocationCoordinate2D?
}

struct CourierData {
    
       var s_latitude : Double?
       var s_longitude : Double?
       var card_id : String?
       var service_type : Int?
       var s_address : String?
       var payment_mode : String?
       var use_wallet : Int?
       var promocode_id : Int?
       var delivery_type_id : Int?
       var receiver_name : String?
       var receiver_mobile : String?
       var d_latitude : Double?
       var package_details : String?
       var d_longitude : Double?
       var d_address : String?
       var distance : Double?
       var package_type_id : Int?
       var receiver_instruction : String?
       var weight : Int?
       var breadth : Int?
       var length : Int?
       var height : Int?
    
       var is_fragile : Int?
       var picture : Data?
    
}




//Payment Type

enum PaymentType: String {
    
    case CASH = "CASH"
    case CARD = "CARD"
    case PAYTM = "PAYTM"
    case PAYUMONEY = "PAYUMONEY"
    case BRAINTREE = "BRAINTREE"
    case WALLET = "WALLET"
    case NONE = ""
    
    var image : UIImage? {
        var name = "ic_error"
        switch self {
        case .CARD:
            name = "ic_credit_card"
        case .CASH:
            name = "money_icon"
        case .BRAINTREE:
            name = "ic_credit_card"
        case .PAYTM:
            name = "ic_credit_card"
        case .PAYUMONEY:
            name = "ic_credit_card"
        case .WALLET:
            name = "ic_wallet"
        case .NONE :
            name = "ic_error"
        }
        return UIImage(named: name)
    }
}

enum StripeCredentialKey: String {
    case stripe_secret_key = "stripe_secret_key"
    case stripe_publishable_key = "stripe_publishable_key"
    case stripe_currency = "stripe_currency"
}

struct DateFormat {
    
    static let yyyy_mm_dd_hh_mm_ss = "yyyy-MM-dd HH:mm:ss"
    static let yyyy_mm_dd_hh_mm_ss_a = "yyyy-MM-dd HH:mm:ss"
    static let dd_mm_yyyy_hh_mm_ss = "dd-MM-yyyy HH:mm:ss"
    static let dd_mm_yyyy_hh_mm_ss_a = "dd-MM-yyyy hh:mm a"
    static let ddmmyyyy = "dd-MM-yyyy"
    static let ddMMMyy12 = "dd MMM yyyy, hh:mm a"
    static let ddMMMyy24 = "dd MMM yyyy, HH:mm:ss"
}

//Protocol

protocol LocationDelegate {
    func selectedLocation(isSource:Bool,addressDetails:SourceDestinationLocation)
}
