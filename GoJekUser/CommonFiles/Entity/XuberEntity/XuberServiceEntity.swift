//
//  XuberServiceEntity.swift
//  GoJekUser
//
//  Created by Ansar on 23/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation
import ObjectMapper

struct XuberServiceEntity : Mappable {
    var statusCode : String?
    var title : String?
    var message : String?
    var responseData : [XuberServiceList]?
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


struct XuberServiceList : Mappable {
    var id : Int?
    var service_category_id : Int?
    var service_subcategory_id : Int?
    var company_id : Int?
    var service_name : String?
    var picture : String?
    var allow_desc : Int?
    var allow_before_image : Int?
    var allow_after_image : Int?
    var is_professional : Int?
    var service_status : Int?
    var service_city : Service_city?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        service_category_id <- map["service_category_id"]
        service_subcategory_id <- map["service_subcategory_id"]
        company_id <- map["company_id"]
        service_name <- map["service_name"]
        picture <- map["picture"]
        allow_desc <- map["allow_desc"]
        allow_before_image <- map["allow_before_image"]
        allow_after_image <- map["allow_after_image"]
        is_professional <- map["is_professional"]
        service_status <- map["service_status"]
        service_city <- map["service_city"]
    }
    
}

struct Service_city : Mappable {
    var id : Int?
    var service_id : Int?
    var country_id : Int?
    var city_id : Int?
    var company_id : Int?
    var fare_type : String?
    var base_fare : String?
    var base_distance : String?
    var per_miles : String?
    var per_mins : String?
    var minimum_fare : String?
    var commission : String?
    var fleet_commission : String?
    var cancellation_time : String?
    var cancellation_charge : String?
    var waiting_time : String?
    var waiting_charges : String?
    var allow_quantity : Int?
    var max_quantity : Int?
    var status : Int?
    var tax : String?
    var city : City?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        service_id <- map["service_id"]
        country_id <- map["country_id"]
        city_id <- map["city_id"]
        company_id <- map["company_id"]
        fare_type <- map["fare_type"]
        base_fare <- map["base_fare"]
        base_distance <- map["base_distance"]
        per_miles <- map["per_miles"]
        per_mins <- map["per_mins"]
        minimum_fare <- map["minimum_fare"]
        commission <- map["commission"]
        fleet_commission <- map["fleet_commission"]
        cancellation_time <- map["cancellation_time"]
        cancellation_charge <- map["cancellation_charge"]
        waiting_time <- map["waiting_time"]
        waiting_charges <- map["waiting_charges"]
        allow_quantity <- map["allow_quantity"]
        max_quantity <- map["max_quantity"]
        status <- map["status"]
        tax <- map["tax"]
        city <- map["city"]
    }
    
}

struct ServiceDetail : Mappable {
    var id : Int?
    var provider_id : Int?
    var admin_service_id : Int?
    var provider_vehicle_id : Int?
    var ride_delivery_id : Int?
    var service_id : String?
    var category_id : String?
    var sub_category_id : String?
    var company_id : Int?
    var base_fare : String?
    var per_miles : String?
    var per_mins : String?
    var status : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        provider_id <- map["provider_id"]
        admin_service_id <- map["admin_service"]
        provider_vehicle_id <- map["provider_vehicle_id"]
        ride_delivery_id <- map["ride_delivery_id"]
        service_id <- map["service_id"]
        category_id <- map["category_id"]
        sub_category_id <- map["sub_category_id"]
        company_id <- map["company_id"]
        base_fare <- map["base_fare"]
        per_miles <- map["per_miles"]
        per_mins <- map["per_mins"]
        status <- map["status"]
    }
    
}


struct City : Mappable {
    var id : Int?
    var country_id : Int?
    var state_id : Int?
    var city_name : String?
    var status : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        country_id <- map["country_id"]
        state_id <- map["state_id"]
        city_name <- map["city_name"]
        status <- map["status"]
    }
    
}
