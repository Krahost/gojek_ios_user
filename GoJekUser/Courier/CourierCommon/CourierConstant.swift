//
//  CourierConstant.swift
//  GoJekUser
//
//  Created by Sudar on 17/01/20.
//  Copyright © 2020 Appoets. All rights reserved.
//

import Foundation

enum CourierConstant {
    
    //Strings
    static let vehicleType = "Vehicle Type"
    static let fareDetails = "Fare Details"
    static let route = "Route"
    static let price = "Price"
    static let enterPickup = "Enter your Pickup Location"
    static let enterDestination = "Enter your Destination"
    static let next = "Next"
    static let cash = "Cash"
    static let card = "Card"
    static let paymentmethod = "Payment Method"
    static let from = "From"
    static let to = "To"
    static let paymentType = "Payment Type"
    static let paymentBy = "Payment By"
    static let instruction = "Instruction"
    static let pickLocation = "Enter your Pickup Location"
    static let applyCoupon = "Apply Coupon"
    static let sender = "Sender"
    static let invoice = "Invoice"
    static let receiver = "Receiver"
    static let courier = "Courier"
    static let current = "Current"
    static let single = "SINGLE"
    static let multiple = "MULTIPLE"
    static let singleDelivery = "Single Delivery"
    static let multipleDelivery = "Mutiple Delivery"
    static let dropAlert = "dropoff location exceeds the Limit"
    
    // ratingScreen
    static let rating = "Rating"
    static let totalfare = "Total fare"
    static let deliverydate = "Delivery date"
    static let discountapplied = "Discount Applied"
    static let pickuplocation = "Pickup location"
    static let dropofflocation = "Dropoff location"
    static let basefare = "Base fare"
    static let estimateDistance = "Estimate Distance"
    static let estimateFare = "Estimate Fare"

    static let distance = "Distance"
    static let done = "Done"
    static let distanceFare = "Distance Fare"
    static let totalDistance = "Distance Fare"

    static let time = "Time"
    static let tax = "Tax"
    static let subTotal = "Subtotal"
    static let total = "Total"
    static let roundoff = "Round off"
    static let delivery = "Delivery"

    static let howwas =  "How was your delivery ?"
    static let providerfeedback = "Provider Feedback"
    static let submit = "Submit"
    static let totalprice = "Total Price"
    static let proceed = "PROCEED"
    static let deliveryHow = "HOW WAS YOUR DELIVERY?"
    
    //
    static let DeliveryTypeViewController = "DeliveryTypeViewController"
    static let DeliveryTypeCell = "DeliveryTypeCell"
    static let ChoosenDeliveryTypeController = "ChoosenDeliveryTypeController"
    static let CourierHomeController = "CourierHomeController"
    static let CourierPricingViewController = "CourierPricingViewController"
    static let CourierRouteViewController = "CourierRouteViewController"
    static let CourierRatingViewController = "CourierRatingViewController"
    static let HeaderRouteCell = "HeaderRouteCell"
    static let FooterRouteCell = "FooterRouteCell"
    
    // Xib
    static let CourierServiceSelectionView = "CourierServiceSelectionView"
    static let CourierServiceTypeCell = "CourierServiceTypeCell"
    static let CourierScheduleView = "CourierScheduleView"
    static let RouteTableViewCell = "RouteTableViewCell"
    static let CourierStatusTableViewCell = "CourierStatusTableViewCell"
    static let CourierInvoiceCell = "CourierInvoiceCell"

    static let CourierAddAddressController = "CourierAddAddressController"
    static let CourierRequestStatusView = "CourierRequestStatusView"
    static let CourierInvoiceView = "CourierInvoiceView"
    
    //Toast
    static let selectServiceType = "Please select service"
    static let addAddress = "Add Address"
    static let toAddress = "To Address"
    
    //Titles
    static let chooseYourDelivery = "Choose your Delivery Type"
    static let deliveryDetails = "Delivery Details"
    static let receiverName = "Receiver Name"
    static let receiverPhoneNumber = "Receiver Phone Number"
    static let packageType = "Package Type"
    static let packageDetails = "Package Details"
    static let weight1 = "Weight (kg)"
    static let lentgh1 = "Length (cm)"
    static let breath1 = "Breadth (cm)"
    static let height1 = "Height (cm)"
    static let bookingId = "Booking ID"
    static let repeatLast = "Repeat Last"
    static let reset = "Reset"
    static let destinationAddr = "Enter Destination Address"
    static let deliveryInstruction = "Delivery Instruction"
    static let arrivedStatus = "Driver has arrived your location"
    static let acceptStatus = "Driver accepted your request"
    static let onRideStatus = "You are on ride"
    static let overAll = "Over All"
    static let emptyDestinationAddress = "Please Select Destination address"
    static let weightIncreaseValidation = "Please Decrease Weight \n Maximum Weight is "
    static let lengthIncreaseValidation = "Please Decrease length \n Maximum length is "
    static let breadthIncreaseValidation = "Please Decrease breadth \n Maximum breadth is "
    static let heightIncreaseValidation = "Please Decrease height \n  Maximum height is "

    static let emptyReceiverName = "Enter Receiver Name"
    static let emptyReceiverMobileNUmber = "Enter Receiver Mobile Number"
    static let emptyInstruction = "Enter Instruction"
    static let emptyWeight = "Enter Weight"
    static let weight = "Weight"
    static let weightFare = "Weight Fare"


    //Images
    static let redTapeImg = "redtap"
    static let ic_gray_icon = "ic_gray_icon"
    static let ic_greenTap = "greentap"
    
    //Params
    
    static let id = "id"
    static let latitude = "latitude"
    static let longitude = "longitude"
    static let deliveryMode = "delivery_mode"
    static let deliveryTypeId = "delivery_type_id"
    static let distance1 =  "distance"
    static let Ptype = "type"
    static let Pd_latitude = "d_latitude"
    static let Pd_longitude = "d_longitude"
    static let Puse_wallet = "use_wallet"
    static let Preceiver_name = "receiver_name"
    static let Preceiver_mobile = "receiver_mobile"
    static let Pd_address = "d_address"
    static let Pdistance = "distance"
    static let Ppackage_type_id = "package_type_id"
    static let PReceiverInstruction = "receiver_instruction"
    static let Pweight = "weight"
    static let Pbreadth = "breadth"
    static let Plength = "length"
    static let Pheight = "height"
    static let Pis_fragile = "is_fragile"
    static let Ps_latitude = "s_latitude"
    static let Ps_longitude = "s_longitude"
    static let Pservice_type = "service_type"
    static let Ps_address = "s_address"
    static let Ppayment_mode = "payment_mode"
    static let Ppayment_by = "payment_by"
    static let Pdelivery_type_id = "delivery_type_id"
    static let PPPicture = "picture"
    static var deliveryType = ""

    
    
}

enum CourierDeliveryType : String {
    
    case single = "SINGLE"
    case mutiple = "MUTIPLE"
    case none

    var statusString:String {
        switch self {
        case .single:
            return CourierConstant.singleDelivery.localized
        case .mutiple:
            return CourierConstant.multipleDelivery.localized
        default:
            return ""
        }
    }
}
// MARK:- Ride Status

enum CourierRequestStatus : String {
    
    case searching = "SEARCHING"
    case accepted = "ACCEPTED"
    case processing = "PROCESSING"
    case started = "STARTED"
    case arrived = "ARRIVED"
    case pickedup = "PICKEDUP"
    case dropped = "DROPPED"
    case completed = "COMPLETED"
    case cancelled = "CANCELLED"
    case none
    
    var statusString:String {
        switch self {
        case .accepted, .started , .processing:
            return CourierConstant.acceptStatus.localized
        case .arrived:
            return CourierConstant.arrivedStatus.localized
        case .pickedup, .dropped:
            return CourierConstant.onRideStatus.localized
        default:
            return ""
        }
    }
    
}
