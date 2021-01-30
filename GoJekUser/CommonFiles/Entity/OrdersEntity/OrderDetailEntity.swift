//
//  OrderDetailEntity.swift
//  GoJekUser
//
//  Created by Ansar on 13/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation
import ObjectMapper

struct OrderDetailEntity : Mappable {
    var statusCode : String?
    var title : String?
    var message : String?
    var responseData : OrderDetailReponseData?
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

struct OrderDetailReponseData : Mappable {
    var type : String?
    var transport : TransportHistoryDetail?
    var service : TransportHistoryDetail?
    var order : FoodieHistoryDetail?
    var delivery : CourierHistoryEntity?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        type <- map["type"]
        transport <- map["transport"]
        service <- map["service"]
        order <- map["order"]
        delivery <- map["delivery"]
    }
    
}

struct TransportHistoryDetail : Mappable {
    var id : Int?
    var vehicle_type : String?
    var booking_id : String?
    var user_id : Int?
    var provider_id : Int?
    var provider_vehicle_id : String?
    var provider_service_id : Int?
    var ride_delivery_id : Int?
    var city_id : Int?
    var country_id : String?
    var promocode_id : Int?
    var company_id : Int?
    var status : String?
    var cancelled_by : String?
    var cancel_reason : String?
    var payment_mode : String?
    var paid : Int?
    var is_track : String?
    var distance : Int?
    var timezone : String?
    var travel_time : String?
    var s_address : String?
    var s_latitude : Double?
    var s_longitude : Double?
    var d_address : String?
    var d_latitude : Double?
    var d_longitude : Double?
    var track_distance : Int?
    var destination_log : String?
    var unit : String?
    var currency : String?
    var track_latitude : Double?
    var track_longitude : Double?
    var otp : String?
    var assigned_at : String?
    var schedule_at : String?
    var started_at : String?
    var finished_at : String?
    var is_scheduled : String?
    var request_type : String?
    var peak_hour_id : String?
    var user_rated : Int?
    var provider_rated : Int?
    var use_wallet : Int?
    var surge : Int?
    var route_key : String?
    var created_at : String?
    var static_map : String?
    var assigned_time : String?
    var schedule_time : String?
    var started_time : String?
    var finished_time : String?
    var provider : Provider?
    var payment : Payment?
    var ride : Ride?
    var dispute : Dispute?
    var lost_item : Lost_item?
    var service_type : Service_type?
    var provider_vehicle: Provider_vehicle?
    var service : XuberService?
    var rating : Rating?
    var created_time : String?
    var calculator : String?
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        vehicle_type <- map["vehicle_type"]
        booking_id <- map["booking_id"]
        user_id <- map["user_id"]
        provider_id <- map["provider_id"]
        provider_vehicle_id <- map["provider_vehicle_id"]
        provider_service_id <- map["provider_service_id"]
        ride_delivery_id <- map["ride_delivery_id"]
        city_id <- map["city_id"]
        country_id <- map["country_id"]
        promocode_id <- map["promocode_id"]
        company_id <- map["company_id"]
        status <- map["status"]
        cancelled_by <- map["cancelled_by"]
        cancel_reason <- map["cancel_reason"]
        payment_mode <- map["payment_mode"]
        paid <- map["paid"]
        is_track <- map["is_track"]
        distance <- map["distance"]
        timezone <- map["timezone"]
        travel_time <- map["travel_time"]
        s_address <- map["s_address"]
        s_latitude <- map["s_latitude"]
        s_longitude <- map["s_longitude"]
        d_address <- map["d_address"]
        d_latitude <- map["d_latitude"]
        d_longitude <- map["d_longitude"]
        track_distance <- map["track_distance"]
        destination_log <- map["destination_log"]
        unit <- map["unit"]
        currency <- map["currency"]
        track_latitude <- map["track_latitude"]
        track_longitude <- map["track_longitude"]
        otp <- map["otp"]
        assigned_at <- map["assigned_at"]
        schedule_at <- map["schedule_at"]
        started_at <- map["started_at"]
        finished_at <- map["finished_at"]
        is_scheduled <- map["is_scheduled"]
        request_type <- map["request_type"]
        peak_hour_id <- map["peak_hour_id"]
        user_rated <- map["user_rated"]
        provider_rated <- map["provider_rated"]
        use_wallet <- map["use_wallet"]
        surge <- map["surge"]
        route_key <- map["route_key"]
        created_at <- map["created_at"]
        static_map <- map["static_map"]
        assigned_time <- map["assigned_time"]
        schedule_time <- map["schedule_time"]
        started_time <- map["started_time"]
        finished_time <- map["finished_time"]
        provider <- map["provider"]
        payment <- map["payment"]
        ride <- map["ride"]
        dispute <- map["dispute"]
        lost_item <- map["lost_item"]
        service_type <- map["service_type"]
        provider_vehicle <- map["provider_vehicle"]
        service <- map["service"]
        rating <- map["rating"]
        created_time <- map["created_time"]
        calculator <- map["calculator"]

    }
    
}


struct Dispute : Mappable {
    var id : Int?
    var company_id : Int?
    var ride_request_id : Int?
    var dispute_type : String?
    var user_id : Int?
    var provider_id : Int?
    var dispute_name : String?
    var dispute_title : String?
    var comments : String?
    var refund_amount : Int?
    var comments_by : String?
    var status : String?
    var is_admin : Int?
    var created_at : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        company_id <- map["company_id"]
        ride_request_id <- map["ride_request_id"]
        dispute_type <- map["dispute_type"]
        user_id <- map["user_id"]
        provider_id <- map["provider_id"]
        dispute_name <- map["dispute_name"]
        dispute_title <- map["dispute_title"]
        comments <- map["comments"]
        refund_amount <- map["refund_amount"]
        comments_by <- map["comments_by"]
        status <- map["status"]
        is_admin <- map["is_admin"]
        created_at <- map["created_at"]
    }
    
}


struct Lost_item : Mappable {
    var id : Int?
    var ride_request_id : Int?
    var user_id : Int?
    var lost_item_name : String?
    var comments : String?
    var comments_by : String?
    var status : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        ride_request_id <- map["ride_request_id"]
        user_id <- map["user_id"]
        lost_item_name <- map["lost_item_name"]
        comments <- map["comments"]
        comments_by <- map["comments_by"]
        status <- map["status"]
    }
    
}

struct XuberService : Mappable {
    var id : Int?
    var service_name : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        service_name <- map["service_name"]
    }
}


struct FoodieHistoryDetail : Mappable {
    var id : Int?
    var store_id : Int?
    var store_order_invoice_id : String?
    var user_id : Int?
    var provider_id : Int?
    var admin_service_id : Int?
    var company_id : Int?
    var pickup_address : String?
    var delivery_address : String?
    var created_at : String?
    var status : String?
    var rating : Rating?
    var static_map : String?
    var dispute : Dispute?
    var delivery : Delivery?
    var pickup : Pickup?
    var order_invoice : Order_invoice?
    var user : User?
    var created_time : String?
    var provider : Provider?

    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        store_id <- map["store_id"]
        store_order_invoice_id <- map["store_order_invoice_id"]
        user_id <- map["user_id"]
        provider_id <- map["provider_id"]
        admin_service_id <- map["admin_service"]
        company_id <- map["company_id"]
        pickup_address <- map["pickup_address"]
        delivery_address <- map["delivery_address"]
        created_at <- map["created_at"]
        status <- map["status"]
        rating <- map["rating"]
        static_map <- map["static_map"]
        dispute <- map["dispute"]
        delivery <- map["delivery"]
        pickup <- map["pickup"]
        order_invoice <- map["order_invoice"]
        user <- map["user"]
        created_time <- map["created_time"]
        provider <- map["provider"]

    }
    
}

struct Order_invoice : Mappable {
    var id : Int?
    var store_order_id : Int?
    var gross : Double?
    var wallet_amount : Double?
    var total_amount : Double?
    var payment_mode : String?
    var tax_amount : Double?
    var delivery_amount : Double?
    var promocode_amount : Double?
    var payable : Double?
    var cart_details : String?
    var store_package_amount : Double?
    var items : [Items]?
    var discount : Double?
    var cash: Double?
    var round_of : Double?
    var item_price : Double?

    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        store_order_id <- map["store_order_id"]
        gross <- map["gross"]
        wallet_amount <- map["wallet_amount"]
        total_amount <- map["total_amount"]
        payment_mode <- map["payment_mode"]
        tax_amount <- map["tax_amount"]
        delivery_amount <- map["delivery_amount"]
        promocode_amount <- map["promocode_amount"]
        payable <- map["payable"]
        cart_details <- map["cart_details"]
        store_package_amount <- map["store_package_amount"]
        items <- map["items"]
        discount <- map["discount"]
        cash <- map["cash"]
        round_of <- map["round_of"]
        item_price <- map["item_price"]

    }
    
}


struct Rating : Mappable {
    var id : Int?
    var user_rating : Int?
    var provider_rating : Int?
    var store_rating : Int?
    var user_comment : String?
    var provider_comment : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        user_rating <- map["user_rating"]
        provider_rating <- map["provider_rating"]
        store_rating <- map["store_rating"]
        user_comment <- map["user_comment"]
        provider_comment <- map["provider_comment"]
    }
    
}

struct Items : Mappable {
    var id : Int?
    var user_id : Int?
    var store_item_id : Int?
    var store_id : Int?
    var store_order_id : Int?
    var company_id : Int?
    var quantity : Int?
    var item_price : Int?
    var total_item_price : Int?
    var tot_addon_price : Int?
    var note : String?
    var product_data : String?
    var product : FoodieProduct?
    var store : Store?
    var cartaddon : [String]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        user_id <- map["user_id"]
        store_item_id <- map["store_item_id"]
        store_id <- map["store_id"]
        store_order_id <- map["store_order_id"]
        company_id <- map["company_id"]
        quantity <- map["quantity"]
        item_price <- map["item_price"]
        total_item_price <- map["total_item_price"]
        tot_addon_price <- map["tot_addon_price"]
        note <- map["note"]
        product_data <- map["product_data"]
        product <- map["product"]
        store <- map["store"]
        cartaddon <- map["cartaddon"]
    }
    
}

