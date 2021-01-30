//
//  FoodieCheckoutEntity.swift
//  GoJekUser
//
//  Created by apple on 03/05/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import ObjectMapper

class FoodieCheckoutEntity: Mappable {
    
    var statusCode : String?
    var title : String?
    var message : String?
    var responseData : FoodieCheckoutResponseData?
    var error : [String]?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        
        statusCode <- map["statusCode"]
        title <- map["title"]
        message <- map["message"]
        responseData <- map["responseData"]
        error <- map["error"]
    }
}

struct Cuisine : Mappable {
    var id : Int?
    var store_type_id : Int?
    var name : String?
    var status : Int?
    var company_id : Int?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        store_type_id <- map["store_type_id"]
        name <- map["name"]
        status <- map["status"]
        company_id <- map["company_id"]
    }
    
}


struct Delivery : Mappable {
    var id : Int?
    var latitude : Double?
    var longitude : Double?
    var map_address : String?
    var flat_no : String?
    var street : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        map_address <- map["map_address"]
        flat_no <- map["flat_no"]
        street <- map["street"]
    }
    
}

struct Deliveryaddress : Mappable {
    var map_address : String?
    var id : Int?
    var latitude : Double?
    var longitude : Double?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        map_address <- map["map_address"]
        id <- map["id"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
    }
    
}

struct Invoice : Mappable {
    var id : Int?
    var store_order_id : Int?
    var payment_mode : String?
    var payment_id : String?
    var company_id : Int?
    var gross : Double?
    var net : Double?
    var discount : Double?
    var promocode_id : Int?
    var promocode_amount : Double?
    var wallet_amount : Double?
    var tax_per : Double?
    var tax_amount : Double?
    var commision_per : Double?
    var commision_amount : Double?
    var delivery_per : Double?
    var delivery_amount : Double?
    var store_package_amount : Double?
    var total_amount : Double?
    var cash : Double?
    var payable : Double?
    var cart_details : String?
    var status : Int?
    var items : [FoodieItems]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        store_order_id <- map["store_order_id"]
        payment_mode <- map["payment_mode"]
        payment_id <- map["payment_id"]
        company_id <- map["company_id"]
        gross <- map["gross"]
        net <- map["net"]
        discount <- map["discount"]
        promocode_id <- map["promocode_id"]
        promocode_amount <- map["promocode_amount"]
        wallet_amount <- map["wallet_amount"]
        tax_per <- map["tax_per"]
        tax_amount <- map["tax_amount"]
        commision_per <- map["commision_per"]
        commision_amount <- map["commision_amount"]
        delivery_per <- map["delivery_per"]
        delivery_amount <- map["delivery_amount"]
        store_package_amount <- map["store_package_amount"]
        total_amount <- map["total_amount"]
        cash <- map["cash"]
        payable <- map["payable"]
        cart_details <- map["cart_details"]
        status <- map["status"]
        items <- map["items"]
    }
    
}

struct Pickup : Mappable {
    var id : Int?
    var picture : String?
    var contact_number : String?
    var store_type_id : Int?
    var latitude : Double?
    var longitude : Double?
    var store_location : String?
    var store_name : String?
    var storetype : Storetype?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        picture <- map["picture"]
        contact_number <- map["contact_number"]
        store_type_id <- map["store_type_id"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        store_location <- map["store_location"]
        store_name <- map["store_name"]
        storetype <- map["storetype"]
    }
    
}

struct FoodieProduct : Mappable {
    var item_name : String?
    var item_price : Double?
    var id : Int?
    var is_veg : String?
    var picture : String?
    var item_discount : Int?
    var item_discount_type : String?
    var itemsaddon : [Itemsaddon]?
    var status : Int?
    var unit : Unit?
    var quantity : Int?
     init?(map: Map){}

    
    mutating func mapping(map: Map) {
        
        item_name <- map["item_name"]
        item_price <- map["item_price"]
        id <- map["id"]
        is_veg <- map["is_veg"]
        picture <- map["picture"]
        item_discount <- map["item_discount"]
        item_discount_type <- map["item_discount_type"]
        itemsaddon <- map["itemsaddon"]
        status <- map["status"]
        unit <- map["unit"]
        quantity <- map["quantity"]
    }
    
}

struct FoodieCheckoutResponseData : Mappable {
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
    var order_ready_time : String?
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
    var delivery : Delivery?
    var pickup : Pickup?
    var store : Store?
    var deliveryaddress : Deliveryaddress?
    var invoice : Invoice?
    var user : FoodieUser?
    var provider : String?
    
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
        delivery <- map["delivery"]
        pickup <- map["pickup"]
        store <- map["store"]
        deliveryaddress <- map["deliveryaddress"]
        invoice <- map["invoice"]
        user <- map["user"]
        provider <- map["provider"]
    }
    
}


struct Store_cusinie : Mappable {
    var id : Int?
    var store_type_id : Int?
    var store_id : Int?
    var cuisines_id : Int?
    var company_id : Int?
    var cuisine : Cuisine?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        store_type_id <- map["store_type_id"]
        store_id <- map["store_id"]
        cuisines_id <- map["cuisines_id"]
        company_id <- map["company_id"]
        cuisine <- map["cuisine"]
    }
    
}



