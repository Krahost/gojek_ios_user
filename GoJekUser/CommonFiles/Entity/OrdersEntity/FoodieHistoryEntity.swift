//
//  FoodieHistoryEntity.swift
//  GoJekUser
//
//  Created by Ansar on 13/05/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation
import ObjectMapper

struct FoodieHistoryEntity : Mappable {
    var statusCode : String?
    var title : String?
    var message : String?
    var responseData : FoodieHistoryResponse?
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

struct FoodieHistoryResponse : Mappable {
    var type : String?
    var total_records : Int?
    var order : OrderData?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        type <- map["type"]
        total_records <- map["total_records"]
               order <- map["order"]
    }

}

struct OrderData : Mappable {
    var current_page : Int?
    var data : [FoodieHistoryData]?
    var first_page_url : String?
    var from : Int?
    var last_page : Int?
    var last_page_url : String?
    var next_page_url : String?
    var path : String?
    var per_page : Int?
    var prev_page_url : String?
    var to : Int?
    var total : Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        current_page <- map["current_page"]
        data <- map["data"]
        first_page_url <- map["first_page_url"]
        from <- map["from"]
        last_page <- map["last_page"]
        last_page_url <- map["last_page_url"]
        next_page_url <- map["next_page_url"]
        path <- map["path"]
        per_page <- map["per_page"]
        prev_page_url <- map["prev_page_url"]
        to <- map["to"]
        total <- map["total"]
    }

}

struct FoodieHistoryData : Mappable {
    var id : Int?
    var store_order_invoice_id : String?
    var admin_service_id : Int?
    var user_id : Int?
    var city_id : Int?
    var country_id : Int?
    var user_address_id : Int?
    var promocode_id : Int?
    var store_id : Int?
    var provider_id : String?
    var provider_vehicle_id : String?
    var company_id : Int?
    var note : String?
    var route_key : String?
    var delivery_date : String?
    var pickup_address : String?
    var delivery_address : String?
    var order_type : String?
    var schedule_datetime : String?
    var order_otp : String?
    var order_ready_time : Int?
    var order_ready_status : String?
    var paid : String?
    var status : String?
    var currency : String?
    var cancelled_by : String?
    var cancel_reason : String?
    var user_rated : Int?
    var provider_rated : Int?
    var schedule_status : Int?
    var request_type : String?
    var created_at : String?
    var total_amount : String?
    var payment_mode : String?
    var delivery : Delivery?
    var pickup : Pickup?
    var user : User?
    var provider : Provider?
    var created_time : String?
    var rating: FoodieRating?


    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        store_order_invoice_id <- map["store_order_invoice_id"]
        admin_service_id <- map["admin_service"]
        user_id <- map["user_id"]
        city_id <- map["city_id"]
        country_id <- map["country_id"]
        user_address_id <- map["user_address_id"]
        promocode_id <- map["promocode_id"]
        store_id <- map["store_id"]
        provider_id <- map["provider_id"]
        provider_vehicle_id <- map["provider_vehicle_id"]
        company_id <- map["company_id"]
        note <- map["note"]
        route_key <- map["route_key"]
        delivery_date <- map["delivery_date"]
        pickup_address <- map["pickup_address"]
        delivery_address <- map["delivery_address"]
        order_type <- map["order_type"]
        schedule_datetime <- map["schedule_datetime"]
        order_otp <- map["order_otp"]
        order_ready_time <- map["order_ready_time"]
        order_ready_status <- map["order_ready_status"]
        paid <- map["paid"]
        status <- map["status"]
        currency <- map["currency"]
        cancelled_by <- map["cancelled_by"]
        cancel_reason <- map["cancel_reason"]
        user_rated <- map["user_rated"]
        provider_rated <- map["provider_rated"]
        schedule_status <- map["schedule_status"]
        request_type <- map["request_type"]
        created_at <- map["created_at"]
        total_amount <- map["total_amount"]
        payment_mode <- map["payment_mode"]
        delivery <- map["delivery"]
        pickup <- map["pickup"]
        user <- map["user"]
        provider <- map["provider"]
        created_time <- map["created_time"]
        rating <- map["rating"]
    }
    
}

struct FoodieRating : Mappable {
    var request_id : Int?
    var user_rating : Int?
    var provider_rating : Int?
    var user_comment : String?
    var provider_comment: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        request_id <- map["request_id"]
        user_rating <- map["user_rating"]
        provider_rating <- map["provider_rating"]
        user_comment <- map["user_comment"]
        provider_comment <- map["provider_comment"]
    }
    
}
