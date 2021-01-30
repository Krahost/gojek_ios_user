//
//  XuberRequestEntity.swift
//  GoJekUser
//
//  Created by Ansar on 25/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation
import ObjectMapper

struct XuberRequestEntity : Mappable {
    var statusCode : String?
    var title : String?
    var message : String?
    var request : XuberRequest?
    var error : [String]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        statusCode <- map["statusCode"]
        title <- map["title"]
        message <- map["message"]
        request <- map["responseData"]
        error <- map["error"]
    }
    
}


struct XuberRequest : Mappable {
    var message:String?
    var data : [XuberRequestData]?
    var sos : String?
    var emergency : [Emergency]?
    var serve_otp : String?
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        data <- map["data"]
        sos <- map["sos"]
        emergency <- map["emergency"]
        message <- map["message"]
        serve_otp <- map["serve_otp"]
    }
    
}

struct XuberRequestData : Mappable {
    var id : Int?
    var booking_id : String?
    var admin_service_id: String?
    var user_id : Int?
    var provider_id : Int?
    var service_id : Int?
    var city_id : Int?
    var country_id : String?
    var promocode_id : Int?
    var company_id : Int?
    var before_image : String?
    var allow_description : String?
    var allow_image : String?
    var quantity : String?
    var price : String?
    var after_image : String?
    var after_comment : String?
    var status : String?
    var cancelled_by : String?
    var cancel_reason : String?
    var payment_mode : String?
    var paid : Int?
    var distance : Double?
    var travel_time : String?
    var s_address : String?
    var s_latitude : Double?
    var s_longitude : Double?
    var unit : String?
    var currency : String?
    var timezone : String?
    var otp : String?
    var assigned_at : String?
    var schedule_at : String?
    var started_at : String?
    var finished_at : String?
    var is_scheduled : String?
    var request_type : String?
    var user_rated : Int?
    var provider_rated : Int?
    var use_wallet : Int?
    var surge : Int?
    var route_key : String?
    var admin_id : String?
    var user : User?
    var provider : Provider?
    var service : Service?
    var payment : Payment?
    var reasons : [Reasons]?
    var category: XuberCategory?
    var serve_otp: String?

    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        booking_id <- map["booking_id"]
        admin_service_id <- map["admin_service"]
        user_id <- map["user_id"]
        provider_id <- map["provider_id"]
        service_id <- map["service_id"]
        city_id <- map["city_id"]
        country_id <- map["country_id"]
        promocode_id <- map["promocode_id"]
        company_id <- map["company_id"]
        before_image <- map["before_image"]
        allow_description <- map["allow_description"]
        allow_image <- map["allow_image"]
        quantity <- map["quantity"]
        price <- map["price"]
        after_image <- map["after_image"]
        after_comment <- map["after_comment"]
        status <- map["status"]
        cancelled_by <- map["cancelled_by"]
        cancel_reason <- map["cancel_reason"]
        payment_mode <- map["payment_mode"]
        paid <- map["paid"]
        distance <- map["distance"]
        travel_time <- map["travel_time"]
        s_address <- map["s_address"]
        s_latitude <- map["s_latitude"]
        s_longitude <- map["s_longitude"]
        unit <- map["unit"]
        currency <- map["currency"]
        timezone <- map["timezone"]
        otp <- map["otp"]
        assigned_at <- map["assigned_at"]
        schedule_at <- map["schedule_at"]
        started_at <- map["started_at"]
        finished_at <- map["finished_at"]
        is_scheduled <- map["is_scheduled"]
        request_type <- map["request_type"]
        user_rated <- map["user_rated"]
        provider_rated <- map["provider_rated"]
        use_wallet <- map["use_wallet"]
        surge <- map["surge"]
        route_key <- map["route_key"]
        admin_id <- map["admin_id"]
        user <- map["user"]
        provider <- map["provider"]
        service <- map["service"]
        payment <- map["payment"]
        reasons <- map["reasons"]
        category <- map["category"]
        serve_otp <- map["serve_otp"]

    }
    
}

struct XuberCategory : Mappable {
    var id:Int?
    var company_id : Int?
    var service_category_name : String?
    var alias_name : String?

    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        company_id <- map["company_id"]
        service_category_name <- map["service_category_name"]
        alias_name <- map["alias_name"]
    }
    
}
