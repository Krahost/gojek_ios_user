//
//  SearchEntity.swift
//  GoJekUser
//
//  Created by CSS on 05/05/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation
import ObjectMapper

struct SearchEntity : Mappable {
    var statusCode : String?
    var title : String?
    var message : String?
    var responseData : [SearchResponseData]?
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


struct SearchResponseData : Mappable {
    var id : Int?
    var store_type_id : Int?
    var company_id : Int?
    var store_name : String?
    var store_location : String?
    var latitude : Double?
    var longitude : Double?
    var picture : String?
    var offer_min_amount : String?
    var estimated_delivery_time : String?
    var free_delivery : Int?
    var is_veg : String?
    var rating : Int?
    var offer_percent : Int?
    var name : String?
    var item_discount : Int?
    var store_id : Int?
    var delivery_time : String?
    var shopstatus : String?
    var category : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        store_type_id <- map["store_type_id"]
        company_id <- map["company_id"]
        store_name <- map["store_name"]
        store_location <- map["store_location"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        picture <- map["picture"]
        offer_min_amount <- map["offer_min_amount"]
        estimated_delivery_time <- map["estimated_delivery_time"]
        free_delivery <- map["free_delivery"]
        is_veg <- map["is_veg"]
        rating <- map["rating"]
        offer_percent <- map["offer_percent"]
        name <- map["name"]
        item_discount <- map["item_discount"]
        store_id <- map["store_id"]
        delivery_time <- map["delivery_time"]
        shopstatus <- map["shopstatus"]
        category <- map["category"]
    }
    
}
