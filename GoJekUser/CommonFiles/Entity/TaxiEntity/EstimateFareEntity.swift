//
//  EstimateFareEntity.swift
//  GoJekUser
//
//  Created by Ansar on 26/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation
import ObjectMapper

class EstimateFareEntity : Mappable {
    var statusCode : String?
    var title : String?
    var message : String?
    var responseData : EstimateFareData?
    var error : [String]?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
     func mapping(map: Map) {
        
        statusCode <- map["statusCode"]
        title <- map["title"]
        message <- map["message"]
        responseData <- map["responseData"]
        error <- map["error"]
    }
    
}

struct EstimateFareData : Mappable {
    var fare : Fare?
    var service : Services?
    var promocodes : [PromocodeData]?
    var currency : String?
    var base_price : String?
    var discount : Double?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        discount <- map["discount"]
        base_price <- map["base_price"]
        fare <- map["fare"]
        service <- map["service"]
        promocodes <- map["promocodes"]
        currency <- map["currency"]
    }
    
}

struct Fare : Mappable {
    var estimated_fare : Double?
    var distance : Double?
    var time : String?
    var tax_price : Int?
    var base_price : Int?
    var service_type : Int?
    var service : String?
    var peak : Int?
    var coupon_amount : Int?
    var peak_percentage : String?
    var wallet_balance : Int?
    var weight : String?

    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        estimated_fare <- map["estimated_fare"]
        distance <- map["distance"]
        time <- map["time"]
        tax_price <- map["tax_price"]
        base_price <- map["base_price"]
        service_type <- map["service_type"]
        service <- map["service"]
        peak <- map["peak"]
        peak_percentage <- map["peak_percentage"]
        wallet_balance <- map["wallet_balance"]
        weight <- map["weight"]
        coupon_amount <- map["coupon_amount"]
    }
    
}
