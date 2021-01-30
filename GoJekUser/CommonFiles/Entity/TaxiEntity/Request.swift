//
//  Request.swift
//  GoJekUser
//
//  Created by Sravani on 02/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation
import ObjectMapper

//Request Model
class Request : Mappable {
    
    var statusCode : String?
    var title : String?
    var message : String?
    var responseData : RequestResponseData?
    var error : [String]?
    
    required convenience init?(map: Map)
    {
        self.init()
    }
    
    func mapping(map: Map) {
        
        statusCode <- map["statusCode"]
        title <- map["title"]
        message <- map["message"]
        responseData <- map["responseData"]
        error <- map["error"]
    }
}

//RequestResponseData
struct RequestResponseData : Mappable {
    
    var message: String?
    var data : [RequestData]?
    var sos : String?
    var emergency : [Emergency]?
    var cash : String?
    var card : String?
    var stripe_secret_key : String?
    var stripe_publishable_key : String?
    var stripe_currency : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        message <- map["message"]
        data <- map["data"]
        sos <- map["sos"]
        emergency <- map["emergency"]
        cash <- map["cash"]
        card <- map["card"]
        stripe_secret_key <- map["stripe_secret_key"]
        stripe_publishable_key <- map["stripe_publishable_key"]
        stripe_currency <- map["stripe_currency"]
    }
    
}

// Emergency Data
struct Emergency : Mappable {
    var number : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        number <- map["number"]
    }
    
}

// RequestData
class RequestData : Mappable {
    var id : Int?
    var vehicle_type : VehicleType?
    var booking_id : String?
    var user_id : Int?
    var provider_id : String?
    var current_provider_id : Int?
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
    var payment_by : String?
    var paid : Int?
    var is_track : String?
    var distance : Double?
    var calculator : String?
    var travel_time : String?
    var s_address : String?
    var s_latitude : Double?
    var s_longitude : Double?
    var d_address : String?
    var d_latitude : Double?
    var d_longitude : Double?
    var track_distance : Int?
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
    var timezone : String?
    var created_at : String?
    var assigned_time : String?
    var schedule_time : String?
    var started_time : String?
    var finished_time : String?
    var user : User?
    var provider : Provider?
    var service_type : Service_type?
    var ride : Ride?
    var payment : Payment?
    var rating : Double?
    var ride_otp : Int?
    var reasons : [Reasons]?
    var peak : Int?
    var deliveries : [DeliveryEntity]?
    var total_amount : Double?
    var payable_amount : Double?
    var total_distance : Double?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
     func mapping(map: Map) {
        
        id <- map["id"]
        vehicle_type <- map["vehicle_type"]
        booking_id <- map["booking_id"]
        user_id <- map["user_id"]
        provider_id <- map["provider_id"]
        current_provider_id <- map["current_provider_id"]
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
        calculator <- map["calculator"]
        travel_time <- map["travel_time"]
        s_address <- map["s_address"]
        s_latitude <- map["s_latitude"]
        s_longitude <- map["s_longitude"]
        d_address <- map["d_address"]
        d_latitude <- map["d_latitude"]
        d_longitude <- map["d_longitude"]
        track_distance <- map["track_distance"]
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
        timezone <- map["timezone"]
        created_at <- map["created_at"]
        assigned_time <- map["assigned_time"]
        schedule_time <- map["schedule_time"]
        started_time <- map["started_time"]
        finished_time <- map["finished_time"]
        user <- map["user"]
        provider <- map["provider"]
        service_type <- map["service_type"]
        ride <- map["ride"]
        payment <- map["payment"]
        rating <- map["rating"]
        ride_otp <- map["ride_otp"]
        reasons <- map["reasons"]
        peak <- map["peak"]
        deliveries <- map["deliveries"]
        total_amount <- map["total_amount"]
        payable_amount <- map["payable_amount"]
        payment_by <- map["payment_by"]
        total_distance <- map["total_distance"]
    }
    
}

//Ride
struct Ride : Mappable {
    var id : Int?
    var company_id : Int?
    var ride_type_id : Int?
    var vehicle_type : String?
    var vehicle_name : String?
    var vehicle_image : String?
    var vehicle_marker : String?
    var capacity : Int?
    var status : Int?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        company_id <- map["company_id"]
        ride_type_id <- map["ride_type_id"]
        vehicle_type <- map["vehicle_type"]
        vehicle_name <- map["vehicle_name"]
        vehicle_image <- map["vehicle_image"]
        vehicle_marker <- map["vehicle_marker"]
        capacity <- map["capacity"]
        status <- map["status"]
    }
}

struct Reasons : Mappable {
    
    var id : Int?
    var service : String?
    var type : String?
    var reason : String?
    var created_type : String?
    var created_by : Int?
    var modified_type : String?
    var modified_by : Int?
    var deleted_type : String?
    var deleted_by : String?
    var status : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        service <- map["service"]
        type <- map["type"]
        reason <- map["reason"]
        created_type <- map["created_type"]
        created_by <- map["created_by"]
        modified_type <- map["modified_type"]
        modified_by <- map["modified_by"]
        deleted_type <- map["deleted_type"]
        deleted_by <- map["deleted_by"]
        status <- map["status"]
    }
    
}

struct Provider : Mappable {
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
    var stripe_acc_id : String?
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
    var company_id : Int?
    var state_id : Int?
    
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
        stripe_acc_id <- map["stripe_acc_id"]
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
        company_id <- map["company_id"]
        state_id <- map["state_id"]
    }
    
}

struct Service_type : Mappable {
    var id : Int?
    var provider_id : Int?
    var admin_service_id : String?
    var provider_vehicle_id : Int?
    var ride_delivery_id : Int?
    var service_id : String?
    var company_id : Int?
    var base_fare : String?
    var per_miles : String?
    var per_mins : String?
    var status : String?
    var vehicle : Vehicle?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        provider_id <- map["provider_id"]
        admin_service_id <- map["admin_service"]
        provider_vehicle_id <- map["provider_vehicle_id"]
        ride_delivery_id <- map["ride_delivery_id"]
        service_id <- map["service_id"]
        company_id <- map["company_id"]
        base_fare <- map["base_fare"]
        per_miles <- map["per_miles"]
        per_mins <- map["per_mins"]
        status <- map["status"]
        vehicle <- map["vehicle"]
    }
    
}

struct Vehicle : Mappable {
    var id : Int?
    var provider_id : Int?
    var vehicle_service_id : Int?
    var vehicle_year : Int?
    var vehicle_color : String?
    var vehicle_make : String?
    var company_id : Int?
    var vehicle_model : String?
    var vehicle_no : String?
    var picture : String?
    var picture1 : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        provider_id <- map["provider_id"]
        vehicle_service_id <- map["vehicle_service_id"]
        vehicle_year <- map["vehicle_year"]
        vehicle_color <- map["vehicle_color"]
        vehicle_make <- map["vehicle_make"]
        company_id <- map["company_id"]
        vehicle_model <- map["vehicle_model"]
        vehicle_no <- map["vehicle_no"]
        picture <- map["picture"]
        picture1 <- map["picture1"]
    }
    
}

struct Payment : Mappable {
    var id : Int?
    var ride_request_id : Int?
    var service_request_id: Int?
    var user_id : Int?
    var provider_id : Int?
    var fleet_id : String?
    var promocode_id : Int?
    var payment_id : String?
    var company_id : Int?
    var payment_mode : String?
    var fixed : Double?
    var distance : Double?
    var minute : Double?
    var hour : Double?
    var commision : Double?
    var commision_percent : Double?
    var fleet : Int?
    var fleet_percent : Int?
    var discount : Double?
    var discount_percent : Double?
    var tax : Double?
    var weight : Int?
    var tax_percent : Int?
    var wallet : Double?
    var is_partial : String?
    var cash : Double?
    var card : Double?
    var surge : Int?
    var peak_amount : Double?
    var peak_comm_amount : String?
    var total_waiting_time : Int?
    var waiting_amount : Double?
    var waiting_comm_amount : String?
    var tips : Double?
    var toll_charge : Double?
    var round_of : Double?
    var total : Double?
    var payable : Double?
    var provider_pay : Double?
    var extra_charges: Double?
    var extra_charges_notes: String?
    var base_fare_text: String?
    var distance_fare_text: String?
    var time_fare_text: String?
    var sub_total: Double?
    var total_fare: Double?
    var calculator : String?

    var waiting_fare_text: String?
       var discount_fare_text: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        ride_request_id <- map["ride_request_id"]
        service_request_id <- map["service_request_id"]
        user_id <- map["user_id"]
        provider_id <- map["provider_id"]
        fleet_id <- map["fleet_id"]
        promocode_id <- map["promocode_id"]
        payment_id <- map["payment_id"]
        company_id <- map["company_id"]
        payment_mode <- map["payment_mode"]
        fixed <- map["fixed"]
        distance <- map["distance"]
        minute <- map["minute"]
        hour <- map["hour"]
        commision <- map["commision"]
        commision_percent <- map["commision_percent"]
        fleet <- map["fleet"]
        fleet_percent <- map["fleet_percent"]
        discount <- map["discount"]
        discount_percent <- map["discount_percent"]
        tax <- map["tax"]
        tax_percent <- map["tax_percent"]
        wallet <- map["wallet"]
        is_partial <- map["is_partial"]
        cash <- map["cash"]
        card <- map["card"]
        surge <- map["surge"]
        peak_amount <- map["peak_amount"]
        peak_comm_amount <- map["peak_comm_amount"]
        total_waiting_time <- map["total_waiting_time"]
        waiting_amount <- map["waiting_amount"]
        waiting_comm_amount <- map["waiting_comm_amount"]
        tips <- map["tips"]
        toll_charge <- map["toll_charge"]
        round_of <- map["round_of"]
        total <- map["total"]
        payable <- map["payable"]
        provider_pay <- map["provider_pay"]
        extra_charges <- map["extra_charges"]
        extra_charges_notes <- map["extra_charges_notes"]
        weight <- map["weight"]
        base_fare_text <- map["base_fare_text"]
        distance_fare_text <- map["distance_fare_text"]
        time_fare_text <- map["time_fare_text"]
        sub_total <- map["sub_total"]
        total_fare <- map["total_fare"]
        calculator <- map["calculator"]
        waiting_fare_text <- map["waiting_fare_text"]
        discount_fare_text <- map["discount_fare_text"]
    }
    
}


// request invoice calculation

enum invoiceCalculator: String {
    case distance = "DISTANCE"
    case min = "MIN"
    case hour = "HOUR"
    case distancemin = "DISTANCEMIN"
    case distancehour = "DISTANCEHOUR"
}
