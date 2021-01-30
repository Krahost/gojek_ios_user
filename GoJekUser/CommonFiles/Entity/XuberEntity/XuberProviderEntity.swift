//
//  XuberProviderListEntity.swift
//  GoJekUser
//
//  Created by Ansar on 20/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation
import ObjectMapper

struct XuberProviderEntity : Mappable {
    var statusCode : String?
    var title : String?
    var message : String?
    var responseData : XuberProviderListData?
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

struct XuberProviderListData : Mappable {
    var provider_service : [Provider_service]?
    var currency : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        provider_service <- map["provider_service"]
        currency <- map["currency"]
    }
    
}

struct Provider_service : Mappable {
    var distance : Double?
    var id : Int?
    var first_name : String?
    var last_name : String?
    var picture : String?
    var rating : Double?
    var city_id : Int?
    var latitude : Double?
    var longitude : Double?
    var fare_type : String?
    var base_fare : String?
    var per_miles : String?
    var per_mins : String?
    var price_choose : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        distance <- map["distance"]
        id <- map["id"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        picture <- map["picture"]
        rating <- map["rating"]
        city_id <- map["city_id"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        fare_type <- map["fare_type"]
        base_fare <- map["base_fare"]
        per_miles <- map["per_miles"]
        per_mins <- map["per_mins"]
        price_choose <- map["price_choose"]
    }
    
}
