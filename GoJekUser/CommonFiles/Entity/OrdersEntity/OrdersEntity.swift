//
//  OrdersEntity.swift
//  GoJekUser
//
//  Created by apple on 20/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import ObjectMapper

struct OrdersEntity : Mappable {
    var statusCode : String?
    var title : String?
    var message : String?
    var responseData : HistoryResponseData?
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

struct HistoryResponseData : Mappable {
    var type : String?
    var total_records : Int?
    var transport : TransporterData?
       var service : TransporterData?
      var delivery : Courier?
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        type <- map["type"]
        total_records <- map["total_records"]
         transport <- map["transport"]
        service <- map["service"]
        delivery <- map["delivery"]
    }

}

struct Courier : Mappable {
    var current_page : Int?
    var data : [CourierHistoryEntity]?
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







struct TransporterData : Mappable {
    var current_page : Int?
    var data : [Transport]?
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



struct Transport : Mappable {
    var id : Int?
    var booking_id : String?
    var assigned_at : String?
    var s_address : String?
    var d_address : String?
    var provider_id : Int?
    var user_id : Int?
    var timezone : String?
    var ride_delivery_id : Int?
    var status : String?
    var provider_vehicle_id : String?
    var static_map : String?
    var assigned_time : String?
    var schedule_time : String?
    var started_time : String?
    var finished_time : String?
    var user : User?
    var provider : Provider?
    var provider_vehicle : Provider_vehicle?
    var payment : Payment?
    var ride : Ride?
    var service : Service?
    var delivery : Delivery?
    var pickup : Pickup?
    var rating: OrderRating?
    var dispute_count: Int?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        booking_id <- map["booking_id"]
        assigned_at <- map["assigned_at"]
        s_address <- map["s_address"]
        d_address <- map["d_address"]
        provider_id <- map["provider_id"]
        user_id <- map["user_id"]
        timezone <- map["timezone"]
        ride_delivery_id <- map["ride_delivery_id"]
        status <- map["status"]
        provider_vehicle_id <- map["provider_vehicle_id"]
        static_map <- map["static_map"]
        assigned_time <- map["assigned_time"]
        schedule_time <- map["schedule_time"]
        started_time <- map["started_time"]
        finished_time <- map["finished_time"]
        user <- map["user"]
        provider <- map["provider"]
        provider_vehicle <- map["provider_vehicle"]
        payment <- map["payment"]
        ride <- map["ride"]
        service <- map["service"]
        delivery <- map["delivery"]
        pickup <- map["pickup"]
        rating <- map["rating"]
        dispute_count <- map["dispute_count"]
    }
}

struct Provider_vehicle : Mappable {
    var provider_id : Int?
    var vehicle_make : String?
    var vehicle_model : String?
    var vehicle_no : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        provider_id <- map["provider_id"]
        vehicle_make <- map["vehicle_make"]
        vehicle_model <- map["vehicle_model"]
        vehicle_no <- map["vehicle_no"]
    }
}

struct OrderRating : Mappable {
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
