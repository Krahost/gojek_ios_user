//
//  ServiceListEntity.swift
//  GoJekUser
//
//  Created by Ansar on 25/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation
import ObjectMapper

struct ServiceListEntity : Mappable {
    var statusCode : String?
    var title : String?
    var message : String?
    var responseData : ServiceListResponseData?
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

struct ServiceListResponseData : Mappable {
    var services : [Services]?
    var providers :[ProviderDetails]?
    var promocodes : [PromocodeData]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        services <- map["services"]
        promocodes <- map["promocodes"]
        providers <- map["providers"]
    }
    
}

struct ProviderDetails : Mappable {
    var id : Int?
    var first_name : String?
    var last_name : String?
    var payment_mode : String?
    var email : String?
    var country_code : String?
    var mobile : String?
    var gender : String?
    var device_token : String?
    var device_id : String?
    var device_type : String?
    var login_by : String?
    var social_unique_id : String?
    var latitude : Double?
    var longitude : Double?
    var stripe_cust_id : String?
    var wallet_balance : Int?
    var rating : Double?
    var status : String?
    var admin_id : String?
    var payment_gateway_id : String?
    var otp : String?
    var language : String?
    var picture : String?
    var referral_unique_id : String?
    var qrcode_url : String?
    var country_id : Int?
    var currency_symbol : String?
    var city_id : Int?
    var currency : String?
    var activation_status : Int?
    var is_service : Int?
    var is_document : Int?
    var is_bankdetail : Int?
    var is_online : Int?
    var state_id : Int?
    var distance : Int?
    var service_id : Int?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        payment_mode <- map["payment_mode"]
        email <- map["email"]
        country_code <- map["country_code"]
        mobile <- map["mobile"]
        gender <- map["gender"]
        device_token <- map["device_token"]
        device_id <- map["device_id"]
        device_type <- map["device_type"]
        login_by <- map["login_by"]
        social_unique_id <- map["social_unique_id"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        stripe_cust_id <- map["stripe_cust_id"]
        wallet_balance <- map["wallet_balance"]
        rating <- map["rating"]
        status <- map["status"]
        admin_id <- map["admin_id"]
        payment_gateway_id <- map["payment_gateway_id"]
        otp <- map["otp"]
        language <- map["language"]
        picture <- map["picture"]
        referral_unique_id <- map["referral_unique_id"]
        qrcode_url <- map["qrcode_url"]
        country_id <- map["country_id"]
        currency_symbol <- map["currency_symbol"]
        city_id <- map["city_id"]
        currency <- map["currency"]
        activation_status <- map["activation_status"]
        is_service <- map["is_service"]
        is_document <- map["is_document"]
        is_bankdetail <- map["is_bankdetail"]
        is_online <- map["is_online"]
        state_id <- map["state_id"]
        distance <- map["distance"]
        service_id <- map["service_id"]
    }
    
}


struct Services : Mappable {
    var id : Int?
    var company_id : Int?
    var ride_type_id : Int?
    var vehicle_type : String?
    var vehicle_name : String?
    var vehicle_image : String?
    var vehicle_marker : String?
    var capacity : Int?
    var weight : Int?
    var length : Int?
    var breadth : Int?
    var height : Int?
    var status : Int?
    var price_details : Price_details?
    var estimated_time : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        weight <- map["weight"]
        length <- map["length"]
        breadth <- map["breadth"]
        height <- map["height"]
        company_id <- map["company_id"]
        ride_type_id <- map["ride_type_id"]
        vehicle_type <- map["vehicle_type"]
        vehicle_name <- map["vehicle_name"]
        vehicle_image <- map["vehicle_image"]
        vehicle_marker <- map["vehicle_marker"]
        capacity <- map["capacity"]
        status <- map["status"]
        price_details <- map["price_details"]
        estimated_time <- map["estimated_time"]
    }
}

struct Price_details : Mappable {
    var id : Int?
    var city_id : Int?
    var vehicle_service_id : String?
    var ride_category_id : String?
    var ride_delivery_vehicle_id : Int?
    var company_id : Int?
    var calculator : String?
    var tax : Double?
    var fixed : Double?
    var price : Double?
    var minute : Int?
    var hour : Int?
    var distance : Int?
    var package_name : String?
    var base_price : Double?
    var base_unit : Int?
    var base_hour : Int?
    var per_unit_price : Int?
    var per_minute_price : Int?
    var per_km_price : Int?
    var per_hour : Int?
    var per_hour_distance : Int?
    var waiting_free_mins : Int?
    var waiting_min_charge : Int?
    var commission : Int?
    var fleet_commission : Int?
    var peak_commission : Int?
    var waiting_commission : Int?
    var status : Int?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        city_id <- map["city_id"]
        vehicle_service_id <- map["vehicle_service_id"]
        ride_category_id <- map["ride_category_id"]
        ride_delivery_vehicle_id <- map["ride_delivery_vehicle_id"]
        company_id <- map["company_id"]
        calculator <- map["calculator"]
        fixed <- map["fixed"]
        price <- map["price"]
        minute <- map["minute"]
        hour <- map["hour"]
        distance <- map["distance"]
        package_name <- map["package_name"]
        base_price <- map["base_price"]
        base_unit <- map["base_unit"]
        base_hour <- map["base_hour"]
        per_unit_price <- map["per_unit_price"]
        per_minute_price <- map["per_minute_price"]
        per_km_price <- map["per_km_price"]
        per_hour <- map["per_hour"]
        per_hour_distance <- map["per_hour_distance"]
        waiting_free_mins <- map["waiting_free_mins"]
        waiting_min_charge <- map["waiting_min_charge"]
        commission <- map["commission"]
        fleet_commission <- map["fleet_commission"]
        peak_commission <- map["peak_commission"]
        waiting_commission <- map["waiting_commission"]
        status <- map["status"]
    }
}


