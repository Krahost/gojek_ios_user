//
//  CourierEstimateEntity.swift
//  GoJekUser
//
//  Created by Sudar vizhi on 17/07/20.
//  Copyright © 2020 Appoets. All rights reserved.
//

import Foundation
import ObjectMapper

struct CourierEstimateEntity : Mappable {
    var statusCode : String?
    var title : String?
    var message : String?
    var responseData : CourierResponseData?
    var error : [String]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        statusCode <- map["statusCode"]
        title <- map["title"]
        message <- map["message"]
        responseData <- map["responseData"]
        error <- map["error"]
    }

}

struct CourierFare : Mappable {
    var estimated_fare : Double?
    var distance : Double?
    var weight : String?
    var tax_price : Double?
    var base_price : Int?
    var service_type : Int?
    var service : String?
    var unit : String?
    var peak : Int?
    var peak_percentage : Int?
    var wallet_balance : Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        estimated_fare <- map["estimated_fare"]
        distance <- map["distance"]
        weight <- map["weight"]
        tax_price <- map["tax_price"]
        base_price <- map["base_price"]
        service_type <- map["service_type"]
        service <- map["service"]
        unit <- map["unit"]
        peak <- map["peak"]
        peak_percentage <- map["peak_percentage"]
        wallet_balance <- map["wallet_balance"]
    }

}

struct CourierResponseData : Mappable {
    var fare : CourierFare?
    var service : CourierService?
    var promocodes : [PromocodeData]?
    var currency : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        fare <- map["fare"]
        service <- map["service"]
        promocodes <- map["promocodes"]
        currency <- map["currency"]
    }

}

