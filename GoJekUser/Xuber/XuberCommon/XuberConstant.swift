//
//  XuberConstant.swift
//  GoJekUser
//
//  Created by Ansar on 12/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation
import UIKit

struct XuberConstant {
    
    //String
    static let proceed = "Proceed"
    static let serviceType = "Service Type"
    static let rate = "Rate"
    static let payment = "Payment"
    static let schedule = "Schedule"
    static let requestNow = "Request Now"
    static let status = "Status"
    static let acceptStatus = "Provider accept your request"
    static let startStatus = "Provider started service"
    static let onProgressStatus = "Provider work is on process"
    static let lookingProvider = "Looking for provider"
    static let bookNow = "Book Now"
    static let serviceProvider = "Service Provider"
    static let description = "Description"
    static let review = "Reviews"
    static let noReview = "No Review"
    static let sReview = "'s Review"
    static let next = "Next"
    static let complete = "Completed"
    static let confirmBooking = "Confirm Booking"
    static let kmAway = "KM Away"
    static let seeMore = "See more"
    static let noProvidersAvailable = "No Providers available for your location"
    static let name = "Service Name"
    static let qty = "Qty"
    static let scheduleOn = "Scheduled On "
    static let enterInstruction = "Enter your instruction"
    static let instruction = "Instruction"
    static let uploadImage = "You can upload a image"
    static let price = "Price"
    static let searchBy = "Search by name or rating"
    static let promoApplied = "Promocode Applied"

    
    static let selectDate = "Select Date"
    static let selectTime = "Select Time"
    static let dateErrorMsg = "Please select Date"
    static let timeErrorMsg = "Please select Time"
    
    static let chooseInstructionImage = "Please choose instruction image"
    static let instructionEmpty = "Please enter your instruction"
    static let rateYourProvider = "Rate your provider"
    //inoice
    static let bookingId = "Booking Id"
    static let baseFare = "Base Fare"
    static let taxFare = "Tax fare"
    static let hourlyFare = "Hourly fare"
    static let walletDetection = "Wallet deduction"
    static let coupon = "Coupon"
    static let total = "Total"
    static let amounToPaid = "Amount to be paid"
    static let cash = "Cash"
    static let before = "Before"
    static let after = "After"
    static let invoice = "Invoice"
    static let add = "Add"
    static let location = "Location"
    static let savedLocation = "Saved Location"
    static let suggestLocation = "Suggested Location"
    static let searchLocation = "Search Location"
    static let list = "List"
    static let map = "Map"
    static let chooseSubservice = "Please choose one subservice"
    static let qtyEmpty = "Please choose number of service"
    static let chooseLocation = "Please choose your location"
    static let selectLocation = "Select Location"
    static let apply = "Apply"
    static let tips = "Tips"
    static let extraCharges = "Extra Charges"
    
    static let findServiceProvider = "Finding nearby service provider"
    static let findService = "Waiting for provider approval"

    //XIB
    static let XuberServiceListCollectionCell = "XuberServiceListCollectionCell"
    static let XuberServiceListCell = "XuberServiceListCell"
    static let XuberLoader = "XuberLoader"
    static let XuberRideStatusView = "XuberRideStatusView"
    static let XuberInvoice = "XuberInvoice"
    static let XuberScheduleView = "XuberScheduleView"
    static let XuberSubSerivceListCell = "XuberSubSerivceListCell"
    static let XuberLocationCell = "XuberLocationCell"
    static let XuberProviderCell = "XuberProviderCell"
    static let XuberProviderDetailCell = "XuberProviderDetailCell"
    static let XuberProviderReviewCell = "XuberProviderReviewCell"
    static let XuberInstructionCell = "XuberInstructionCell"
    static let XuberApplyCouponCell = "XuberApplyCouponCell"
    static let XuberPaymentSelectionCell = "XuberPaymentSelectionCell"
    static let XuberServiceDetailCell = "XuberServiceDetailCell"
    static let XuberServiceDetailHeader = "XuberServiceDetailHeader"
    static let ExtraChargeView = "ExtraChargeView"
    
    static let LoaderView = "LoaderView"
    
    //Controller
    static let XuberServiceSelectionController = "XuberServiceSelectionController"
    static let XuberSubServiceController = "XuberSubServiceController"
    static let XuberHomeController = "XuberHomeController"
    static let XuberLocationSelectionController = "XuberLocationSelectionController"
    static let XuberProviderListController = "XuberProviderListController"
    static let XuberProviderReviewController = "XuberProviderReviewController"
    static let XuberConfirmBookingController = "XuberConfirmBookingController"
    static let ProviderReviewDetailController = "ProviderReviewDetailController"
    static let XuberMapSelectionController = "XuberMapSelectionController"
    
    //Images
    static let leftArrowImage = "ic_leftarrow"
    static let calendarImage = "ic_calendar"
    static let clockImage = "ic_clock"
    static let documentImage = "ic_file"
    static let trackImage = "ic_delivery_boy"
    static let addressImage = "address"
    static let chat = "ic_chat"
    static let phone = "ic_phone"
    
    static let applyCoupon = "Apply Coupon"
}


enum XuberRideStatus: String {
    case SEARCHING = "SEARCHING"
    case ACCEPTED = "ACCEPTED"
    case STARTED = "STARTED"
    case ARRIVED = "ARRIVED"
    case PICKEDUP = "PICKEDUP"
    case DROPPED = "DROPPED"
    case COMPLETED = "COMPLETED"
    case CANCELLED = "CANCELLED"
    case SCHEDULED = "SCHEDULED"
    case none = ""
    var statusStr: String  {
        switch self {
        case .ACCEPTED:
            return " accepted your request"
        case .ARRIVED:
            return " reached your location"

        case .PICKEDUP, .DROPPED , .STARTED:
            return "Started the service"
        case .COMPLETED:
            return "Service completed"
        default: //SCHEDULED, CANCELLED, SEARCHING
            return ""
        }
    }
}

enum ServiceFareType:String {
    case FIXED = "FIXED"
    case HOURLY = "HOURLY"
    case DISTANCETIME = "DISTANCETIME"
    case none = ""
    
    var fareString:String {
        switch self {
        case .HOURLY:
            return "/Hrs"
        case .FIXED:
            return "/Fare"
        case .DISTANCETIME:
            return "/Kms"
        default:
            return ""
        }
    }
}

struct XuberInput {
    static let lat = "lat"
    static let long = "long"
    static let id = "id"
    static let limit = "limit"
    static let offset = "offset"
    static let s_latitude = "s_latitude"
    static let s_longitude = "s_longitude"
    static let s_address = "s_address"
    static let service_id = "service_id"
    static let payment_mode = "payment_mode"
    static let tips = "tips"
    static let card_id = "card_id"
    static let use_wallet = "use_wallet"
    static let reason = "reason"
    static let type = "type"
    static let rating = "rating"
    static let comment = "comment"
    static let qty = "qty"
    static let admin_service_id = "admin_service"
    static let promocode_id = "promocode_id"
    static let price = "price"
    static let totalAmount = "total_amount"
    static let storeID = "store_id"
    static let quantity = "quantity"
    static let allow_description = "allow_description"
    static let allow_image = "allow_image"
    static let schedule_date = "schedule_date"
    static let schedule_time = "schedule_time"
}

struct XuberAPI {
    static let getSubServiceCategory = "/user/service_sub_category"
    static let getAddress = "/user/address"
    static let getProviderList = "/user/list"
    static let getService = "/user/services"
    static let getProviderReview = "/user/review"
    static let checkRequest = "/user/service/check/request"
    static let sendRequest = "/user/service/send/request"
    static let cancelRequest = "/user/service/cancel/request"
    static let rating = "/user/service/rate"
    static let getPromocode = "/user/promocode/Service"
    static let payment = "/user/service/payment"
    static let updatePayment = "/user/service/update/payment"
}


class SendRequestInput {
    static var shared = SendRequestInput()
    private init() {}
    
    var mainServiceId: Int?
    var subserviceId: Int?
    var serviceId: Int?
    var isSchedule:Bool?
    var scheduleTime: String?
    var scheduleDate: String?
    var subServiceCount: Int?
    var s_latitude: Double?
    var s_longitude: Double?
    var s_address: String?
    var allowInstruction:Bool?
    var paymentMode:String?
    var useWallet:Bool = false
    var providerId:Int?
    var promocode_id:Int?
    var allowImage:Bool?
    var instructionImage: UIImage?
    var instruction:String?
    var price:Double?
    var isAllowQuantity:Bool?
    var quantity:Int?
    var maxQuantity:Int?
    var fareType:ServiceFareType?
    var selectedSubService: String?
    var mainSelectedService: String?
    
    func clear() {
        subserviceId = nil
        serviceId = nil
        isSchedule = nil
        scheduleTime = nil
        scheduleDate = nil
        subServiceCount = nil
        s_latitude = nil
        s_longitude = nil
        s_address = nil
        allowInstruction = nil
        paymentMode = nil
        providerId = nil
        promocode_id = nil
        allowImage = nil
        instructionImage = nil
        instruction = nil
        price = nil
        isAllowQuantity = nil
        quantity = nil
        fareType = nil
        selectedSubService = nil
        maxQuantity = nil
    }
}


func getFareDetails(provider: Provider_service) -> (Double,String) {
    if let fareType = ServiceFareType(rawValue: provider.fare_type ?? "") {
        let hourPrice = provider.per_mins ?? "0"
        let basePrice = provider.base_fare ?? "0"
        let milePrice = provider.per_miles ?? "0"
        let baseFareStr = ServiceFareType(rawValue: "FIXED")?.fareString ?? ""
        let hourFareStr = ServiceFareType(rawValue: "HOURLY")?.fareString ?? ""
        let distanceFareStr = ServiceFareType(rawValue: "DISTANCETIME")?.fareString ?? ""
        if fareType == .FIXED {
            let fareStr = "\(basePrice)"+fareType.fareString
            return (basePrice.toDouble(),fareStr) //Here sending empty string when Fixed //fareType.fareString
        }else if fareType == .HOURLY {
            let fareStr = "\(basePrice)" + "\(baseFareStr)" + " | " + "\(hourPrice)" + "\(hourFareStr)"
            let hourPriceVal = basePrice.toDouble() + hourPrice.toDouble()
            return (hourPriceVal,fareStr)
        }else{
            let fareStr = "\(basePrice)" + "\(baseFareStr)" + " | " + "\(milePrice)" + "\(distanceFareStr)" + " | " + "\(hourPrice)" + "\(hourFareStr)"
            let distancePriceVal = basePrice.toDouble() + hourPrice.toDouble() + milePrice.toDouble()
            return (distancePriceVal,fareStr)
        }
    }
    return (0,String.empty)
}

