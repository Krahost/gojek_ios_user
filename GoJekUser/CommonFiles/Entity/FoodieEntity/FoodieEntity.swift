//
//  FoodieEntity.swift
//  GoJekUser
//
//  Created by apple on 20/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import ObjectMapper

class StoreListEntity: Mappable {
    
    var statusCode : String?
    var title : String?
    var message : String?
    var responseData : [ShopsListData]?
    var error : [String]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        statusCode <- map["statusCode"]
        title <- map["title"]
        message <- map["message"]
        responseData <- map["responseData"]
        error <- map["error"]
    }
}

struct ShopsListData : Mappable {
    var id : Int?
    var store_type_id : Int?
    var company_id : Int?
    var store_name : String?
    var store_location : String?
    var latitude : Double?
    var longitude : Double?
    var picture : String?
    var offer_min_amount : Double?
    var estimated_delivery_time : String?
    var free_delivery : Int?
    var is_veg : String?
    var rating : Int?
    var offer_percent : Int?
    var categories : [Categories]?
    var shopstatus : String?
    var storetype : Storetype?

    
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
        categories <- map["categories"]
        shopstatus <- map["shopstatus"]
        storetype <- map["storetype"]


    }
}

struct Categories : Mappable {
    
    var id : Int?
    var store_id : Int?
    var company_id : Int?
    var store_category_name : String?
    var store_category_description : String?
    var picture : String?
    var store_category_status : Int?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        store_id <- map["store_id"]
        company_id <- map["company_id"]
        store_category_name <- map["store_category_name"]
        store_category_description <- map["store_category_description"]
        picture <- map["picture"]
        store_category_status <- map["store_category_status"]
    }
}

