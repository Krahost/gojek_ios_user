//
//  CourierEntity.swift
//  GoJekUser
//
//  Created by Chan Basha on 12/06/20.
//  Copyright © 2020 Appoets. All rights reserved.
//

import UIKit
import ObjectMapper

struct CourierRequestEntity : Mappable {
    
    var s_latitude : Double?
    var s_longitude : Double?
    var card_id : String?
    var service_type : Int?
    var s_address : String?
    var payment_mode : String?
    var use_wallet : Int?
    var promocode_id : Int?
    var delivery_type_id : Int?
    var receiver_name : String?
    var receiver_mobile : String?
    var d_latitude : Double?
    var d_longitude : Double?
    var d_address : String?
    var distance : Int?
    var package_type_id : Int?
    var receiver_instruction : String?
    var weight : Int?
    var is_fragile : Int?
    var picture : Data?
  
    
    init?(map: Map) {
        
        
    }
    
    mutating func mapping(map: Map) {
        
        
        s_latitude <- map["s_latitude"]
        s_longitude <- map["s_longitude"]
        card_id <- map["card_id"]
        service_type <- map["service_type"]
        s_address <- map["s_address"]
        payment_mode <- map["payment_mode"]
        use_wallet <- map["use_wallet"]
        promocode_id <- map["promocode_id"]
        use_wallet <- map["use_wallet"]
        promocode_id <- map["promocode_id"]
        delivery_type_id <- map["delivery_type_id"]
        receiver_name <- map["receiver_name"]
        receiver_mobile <- map["receiver_mobile"]
        d_latitude <- map["d_latitude"]
        d_longitude <- map["d_longitude"]
        d_address <- map["d_address"]
        distance <- map["distance"]
        package_type_id <- map["package_type_id"]
        receiver_instruction <- map["receiver_instruction"]
        weight <- map["weight"]
        is_fragile <- map["is_fragile"]
        picture <- map["picture"]
        
        
    }
    
    
}

struct DeliveryEntity : Mappable {
  
    
    var id : Int?
    var deliveryRequestId : Int?
    var userId : Int?
    var providerId:Int?
    var geofenceId : Int?
    var packageTypeId : Int?
    var status : String?
    var adminService : String?
    var paid : Int?
    var providerRated : Int?
    var distance : Float?
    var weight : Int?
    var name : String?
    var mobile : String?
    var paymentMode  : String?
    var payment_by  : String?
    var instruction : String?
    var sAddress : String?
    var sLatitude : Double?
    var sLongitude : Double?
    var dAddress : String?
    var dLatitude : Double?
    var dLongitude : Double?
    var trackDistance : Int?
    var unit : String?
    var isFragile : Int?
    var currency : String?
    var picture : String?
    var track_latitude : Double?
    var track_longitude : Double?
    var otp : String?
    var assigned_at : String?
    var schedule_at : String?
    var started_at : String?
    var finished_at : String?
    var surge : Int?
    var admin_id : Int?
    var payment : Payment?
    var length : Int?
    var breadth : Int?
    var height : Int?
    var package_type : PackageType?
    
       init?(map: Map) {
          
      }
      
      mutating func mapping(map: Map) {
        
         id <- map["id"]
         deliveryRequestId <- map["delivery_request_id"]
         userId <- map["user_id"]
         providerId <- map["provider_id"]
         geofenceId <- map["geofence_id"]
         packageTypeId <- map["package_type_id"]
         status <- map["status"]
         adminService <- map["admin_service"]
         paid <- map["paid"]
         providerRated <- map["provider_rated"]
         distance <- map["distance"]
        
        length <- map["length"]
        breadth <- map["breadth"]
        height <- map["height"]
        package_type <- map["package_type"]
         weight <- map["weight"]
         name <- map["name"]
         mobile <- map["mobile"]
         paymentMode <- map["payment_mode"]
         instruction <- map["instruction"]
         sAddress <- map["s_address"]
         sLatitude <- map["s_latitude"]
         sLongitude <- map["s_longitude"]
         dAddress <- map["d_address"]
         dLatitude <- map["d_latitude"]
         dLongitude <- map["d_longitude"]
        
        
         trackDistance <- map["track_distance"]
         unit <- map["unit"]
         isFragile <- map["is_fragile"]
         currency <- map["currency"]
         track_latitude <- map["track_latitude"]
         track_longitude <- map["track_longitude"]
         otp <- map["otp"]
         assigned_at <- map["assigned_at"]
         schedule_at <- map["schedule_at"]
         started_at <- map["started_at"]
         finished_at <- map["finished_at"]
         payment <- map["payment"]
         payment_by <- map["payment_by"]
      }
      

}


struct CourierPackagesList : Mappable
{

    var responseData : [CourierPackage]?
    
    init?(map: Map)
    {
              
    }
       
    mutating func mapping(map: Map)
    {
        responseData <- map["responseData"]
    }

}

struct CourierPackage : Mappable {
    
    
    var id : Int?
    var package_name : String?
    var delivery_name : String?
    
    init?(map: Map)
    {
           
    }
    
     mutating func mapping(map: Map)
     {
        
        id <- map["id"]
        package_name <- map["package_name"]
        delivery_name <- map["delivery_name"]
        
    }
    
}
struct CourierHistoryEntity : Mappable {
    var id : Int?
    var booking_id : String?
    var assigned_at : String?
    var s_address : String?
    var d_address : String?
    var provider_id : Int?
    var user_id : Int?
    var timezone : String?
    var delivery_vehicle_id : Int?
    var status : String?
    var provider_vehicle_id : String?
    var started_at : String?
    var static_map : String?
    var user : CourierUser?
    var provider : CourierProvider?
    var provider_vehicle : String?
    var payment : Payment?
    var service : CourierService?
    var service_type : Service_type?
    var assigned_time : String?
    var rating : Rating?
    var dispute : Dispute?
    var created_time : String?
    var schedule_time : String?
    var started_time : String?
    var finished_time : String?
    var payment_mode : String?
    var deliveries : [Deliveries]?
    var fixed_amount : Double?
    var weight_amount : Double?
    var distance_amount : Double?
    var tax_amount : Double?
    var discount_amount : Double?
    var total_amount : Double?


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
        delivery_vehicle_id <- map["delivery_vehicle_id"]
        status <- map["status"]
        provider_vehicle_id <- map["provider_vehicle_id"]
        started_at <- map["started_at"]
        static_map <- map["static_map"]
        user <- map["user"]
        provider <- map["provider"]
        provider_vehicle <- map["provider_vehicle"]
        payment <- map["payment"]
        service <- map["service"]
        service_type <- map["service_type"]
        assigned_time <- map["assigned_time"]
        rating <- map["rating"]
        dispute <- map["dispute"]
        created_time <- map["created_time"]
        assigned_time <- map["assigned_time"]
        schedule_time <- map["schedule_time"]
        started_time <- map["started_time"]
        finished_time <- map["finished_time"]
        payment_mode <- map["payment_mode"]
        deliveries <- map["deliveries"]
        fixed_amount <- map["fixed_amount"]
        weight_amount <- map["weight_amount"]
        distance_amount <- map["distance_amount"]
        tax_amount <- map["tax_amount"]
        discount_amount <- map["discount_amount"]
        total_amount <- map["total_amount"] 
    }

}

struct Deliveries : Mappable {
    var id : Int?
    var d_address : String?
    var d_latitude : Double?
    var d_longitude : Double?
    var delivery_request_id : Int?
    var status : String?
    var paid : Int?
    var name : String?
    var mobile : String?
    var weight : Int?
    var length : Int?
    var breadth : Int?
    var height : Int?
    var package_type : PackageType?

    var payment : Payment?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        d_address <- map["d_address"]
        d_latitude <- map["d_latitude"]
        d_longitude <- map["d_longitude"]
        delivery_request_id <- map["delivery_request_id"]
        status <- map["status"]
        paid <- map["paid"]
        name <- map["name"]
        mobile <- map["mobile"]
        weight <- map["weight"]
        length <- map["length"]
        breadth <- map["breadth"]
        height <- map["height"]
        package_type <- map["package_type"]
        payment <- map["payment"]
    }

}


struct PackageType : Mappable {
    var id : Int?
    var package_name : String?
    var status : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        status <- map["status"]
        package_name <- map["package_name"]
    }

}


struct CourierProvider : Mappable {
    var id : Int?
    var first_name : String?
    var last_name : String?
    var rating : Double?
    var picture : String?
    var currency_symbol : String?
    var current_ride_vehicle : String?
    var current_store : String?
    var mobile : String?
    var latitude : String?
    var longitude : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        rating <- map["rating"]
        picture <- map["picture"]
        currency_symbol <- map["currency_symbol"]
        current_ride_vehicle <- map["current_ride_vehicle"]
        current_store <- map["current_store"]
        mobile <- map["mobile"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
    }

}

struct CourierUser : Mappable {
    var id : Int?
    var first_name : String?
    var last_name : String?
    var rating : Double?
    var picture : String?
    var currency_symbol : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        rating <- map["rating"]
        picture <- map["picture"]
        currency_symbol <- map["currency_symbol"]
    }

}

struct CourierService : Mappable {
    var id : Int?
    var vehicle_name : String?
    var vehicle_image : String?
    var delivery_types_id : Int?
    var vehicle_type : String?
    var vehicle_marker : String?
    var capacity : Int?
    var status : Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        vehicle_name <- map["vehicle_name"]
        vehicle_image <- map["vehicle_image"]
        vehicle_marker <- map["vehicle_marker"]
        capacity <- map["capacity"]
        status <- map["status"]
        delivery_types_id <- map["delivery_types_id"]
        vehicle_type <- map["vehicle_type"]
    }

}
