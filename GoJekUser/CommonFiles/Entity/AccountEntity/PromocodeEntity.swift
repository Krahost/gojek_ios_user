//
//  PromocodeEntity.swift
//  GoJekUser
//
//  Created by Ansar on 30/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation
import ObjectMapper

struct PromocodeEntity : Mappable {
    var statusCode : String?
    var title : String?
    var message : String?
    var responseData : [PromocodeData]?
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


struct PromocodeData : Mappable {
    var id : Int?
    var promo_code : String?
    var service : String?
    var picture : String?
    var percentage : Int?
    var max_amount : Int?
    var promo_description : String?
    var expiration : String?
    var status : String?
    var coupon_amount : Int?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        promo_code <- map["promo_code"]
        service <- map["service"]
        picture <- map["picture"]
        percentage <- map["percentage"]
        max_amount <- map["max_amount"]
        promo_description <- map["promo_description"]
        expiration <- map["expiration"]
        status <- map["status"]
        coupon_amount <- map["coupon_amount"]
    }
    
}
