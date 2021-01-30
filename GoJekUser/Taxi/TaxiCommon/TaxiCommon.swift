//
//  TaxiCommon.swift
//  GoJekUser
//
//  Created by Ansar on 26/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

enum TaxiConstant {
    
    //String
    static let dailyRide = "Daily Ride"
    static let mins = "mins"
    static let hatchBag = "Hatch Bag"
    static let sedan = "Sedan"
    static let suv = "SUV"
    static let getPricing = "Get Pricing"
    static let baseFare = "Base Fare"
    static let fareString = "Distance Fare"
    static let fareType = "Time Fare"
    static let capacity = "Capacity"
    static let pickLocation = "PickUp Location"
    static let dropLocation = "Drop Location"
    static let priceEstimation = "Price Estimation"
    static let selectDateTime = "Select date and time"
    static let estimateFare = "Estimated Fare"
    static let totalPrice = "Total Price"
    static let eta = "ETA"
    static let model = "Model"
    static let wheelChair = "Wheel Chair"
    static let childSeat = "Child Seat"
    static let bookSomeone = "Book for someone"
    static let useWallet = "Use wallet amount"
    static let coupon = "Coupon"
    static let applyCoupon = "Apply Coupon"
    static let surgeMessage = "Due to high demand price may vary"
    static let scheduleNow = "Schedule"
    static let rideNow = "Ride Now"
    static let status = "Status"
    static let arrivedStatus = "Driver has arrived your location"
    static let acceptStatus = "Driver accepted your request"
    static let onRideStatus = "You are on ride"
    static let statusDesc = "Due to peak hours, charges are based on providers availability"
    static let enterSource = "Enter source location"
    static let enterDestination = "Enter destination location"
    static let location = "Location"
    static let emailOptional = "email"
    static let edit = "EDIT"
    static let chooseProviderLoc = "Please Choose Drop Location"
    static let shareRide = "Share Ride"
    static let shareRideInitialContent = "I'm in my way and would like to share my trip details with you, as currently with"
    static let shareContentIn = "in"
    static let geolocation = "at exact geolocation of"
    static let tookFrom = "Took my trip from"
    static let to = "to"
    
    static let selectServiceType = "Please select service"
    
    static let OTP = "OTP : "
    static let sos = "SOS"
    static let sosAlert = "Whould you like to make sos call"
    
    //invoice
    static let invoice = "Invoice"
    static let sourceDestination = "Source and Destination"
    static let bookingId = "Booking ID"
    static let distanceTravel = "Distance Travelled"
    static let discount = "Discount"
    static let distan = "Distance"
    static let estimateDistance = "Estimated Distance"
    static let peakHour = "Peak Hour"
    static let taxPrice = "Tax Price"
    static let taxFare = "Tax Fare"
    static let basePrice = "Base Price"
    static let couponAmount = "Coupon Amount"
    static let timeTaken = "Waiting Charge"
    static let waitCharge = "Waiting Charge"
    static let peakCharge = "Peak Charge"
    static let waitingFare = "Waiting Fare"
    static let distanceFare = "Distance Fare"
    static let tollCharge = "Toll Charge"
    static let tax = "Tax"
    static let total = "Total"
    static let subtotal = "SubTotal"
    static let totalfare = "Total Fare"
    static let paymentVia = "Payment Via"
    static let walletDeduction = "Wallet Deduction"
    static let payable = "Payable"
    static let totalpay = "Total Pay"
    static let rideAlreadyCancel = "Already Ride Cancelled"
    
    
    //Location
    static let savedLocation = "Saved Locations"
    
    // Request
    static let noDriversFound = "No Drivers Found"
    
    //XIB
    static let ServiceSelectionView = "ServiceSelectionView"
    static let ServiceTypeCell = "ServiceTypeCell"
    static let RateCardView = "RateCardView"
 
    
    static let BookSomeOneView = "BookSomeOneView"
    static let LoaderView = "LoaderView"
    static let RideStatusView = "RideStatusView"
    static let InvoiceView = "InvoiceView"
    static let RideDetailView = "RideDetailView"
    
    static let ScheduleView = "ScheduleView"
    
    //Controller
    static let TaxiHomeController = "TaxiHomeController"
    static let LocationSelectionController = "LocationSelectionController"
    static let PriceEstimationController = "PriceEstimationController"
    static let TaxiHomeViewController = "TaxiHomeViewController"
    
    //Images
    static let calendarImage = "ic_calendar"
    static let clockImage = "ic_clock"
    static let pinImage = "ic_pin"
    static let walletImage = "wallet"
    static let car_marker = "car_marker"
    static let phone = "ic_phone"
    
    ///Paramets
    //Send Request
    static let s_latitude = "s_latitude"
    static let s_longitude = "s_longitude"
    static let service_type = "service_type"
    static let d_latitude = "d_latitude"
    static let d_longitude = "d_longitude"
    static let distance = "distance"
    static let payment_mode = "payment_mode"
    static let card_id = "card_id"
    static let use_wallet = "use_wallet"
    static let wheelchair = "wheel_chair"
    static let child_seat = "child_seat"
    static let someone = "someone"
    static let someone_name = "someone_name"
    static let someone_email = "someone_email"
    static let someone_mobile = "someone_mobile"
    static let schedule_time = "schedule_time"
    static let schedule_date = "schedule_date"
    static let promocode_id = "promocode_id"
    static let percentage = "percentage"
    static let max_amount = "max_amount"
    static let type = "type"
    static let reason = "reason"
    static let ride_type_id = "ride_type_id"
    static let latitude = "latitude"
    static let longitude = "longitude"
    static let address = "address"
    
    static let s_address = "s_address"
    static let d_address = "d_address"
    
    //cancel request
    static let id = "id"
    
    //invoice payment
    static let tips = "tips"
    
    //rating
    static let rating = "rating"
    static let comment = "comment"
    static let admin_service_id = "admin_service"
    static let scheduleOn = "Schedule On"
}




// MARK:- Ride Status

enum TaxiRideStatus : String {
    
    case searching = "SEARCHING"
    case accepted = "ACCEPTED"
    case started = "STARTED"
    case arrived = "ARRIVED"
    case pickedup = "PICKEDUP"
    case dropped = "DROPPED"
    case completed = "COMPLETED"
    case cancelled = "CANCELLED"
    case none
    
    var statusString:String {
        switch self {
        case .accepted, .started:
            return TaxiConstant.acceptStatus.localized
        case .arrived:
            return TaxiConstant.arrivedStatus.localized
        case .pickedup, .dropped:
            return TaxiConstant.onRideStatus.localized
        default:
            return ""
        }
    }
    
}


//MARK:- Single Ton for Taxi request

class TaxiSendRequest {
    static var shared = TaxiSendRequest()
    private init() {}
    
    var s_longitude: Double?
    var s_latitude: Double?
    var service_type: Int?
    var d_latitude:Double?
    var d_longitude: Double?
    var payment_mode: String?
    var distance: Int?
    var use_wallet: Int?
    var wheelchair:Int?
    var child_seat:Int?
    var someone_name:String?
    var someone_mobile:String?
    var someone_email:String?
    var promocode_id:Int?
    var card_id: String?
    var s_address:String?
    var d_address:String?
    var ride_type_id:Int?
    
    
    func clear() {
        s_longitude = nil
        s_latitude = nil
        service_type = nil
        d_latitude = nil
        d_longitude = nil
        payment_mode = nil
        distance = nil
        use_wallet = nil
        wheelchair = nil
        child_seat = nil
        someone_name = nil
        someone_mobile = nil
        someone_email = nil
        promocode_id = nil
        card_id = nil
        s_address = nil
        d_address = nil
        ride_type_id = nil
    }
}
