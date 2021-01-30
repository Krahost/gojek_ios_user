//
//  APIList.swift
//  GoJekUser
//
//  Created by Ansar on 21/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation
import UIKit


struct LoginAPI {
    static let signIn = "/user/login"
    static let countries = "/user/countries"
    static let signUp = "/user/signup"
    static let forgotPassword = "/user/forgot/otp"
    static let socialLogin = "/user/social/login"
    static let verify = "/user/verify"
    static let sendOtp = "/user/send-otp"
    static let verifyOtp = "/user/verify-otp"
}

struct TaxiAPI {
    static let serviceList = "/user/transport/services"
    static let estimateFare = "/user/transport/estimate"
    static let sendRequest = "/user/transport/send/request"
    static let checkRequest = "/user/transport/check/request"
    static let cancelRequest = "/user/transport/cancel/request"
    static let invoicePayment = "/user/transport/payment"
    static let rateProvider = "/user/transport/rate"
    static let updatePayment = "/user/transport/update/payment"
    static let extendTrip = "/user/transport/extend/trip"
}


struct CourierAPI
{
     static let serviceList = "/user/delivery/services"
     static let estimateFare = "/user/delivery/estimate"
     static let checkRequest = "/user/delivery/check/request"
     static let sendRequest = "/user/delivery/send/request"
     static let invoicePayment = "/user/delivery/payment"
     static let rateProvider = "/user/delivery/rate"
     static let packageList = "/user/delivery/package/types"
     static let deliveryTypeList = "/user/delivery/types/1"
    static let cancelRequest = "/user/delivery/cancel/request"

}

struct PaymentAPI {
    
    static let resetPassword = "/user/reset/otp"
    static let addCard = "/user/card"
}



