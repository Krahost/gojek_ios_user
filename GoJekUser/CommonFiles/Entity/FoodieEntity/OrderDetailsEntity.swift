//
//  OrderDetailsEntity.swift
//  GoJekUser
//
//  Created by CSS on 04/05/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation
import ObjectMapper

struct FoodieOrderDetailEntity : Mappable {
    var statusCode : String?
    var title : String?
    var message : String?
    var responseData : FoodieResponseData?
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

struct FoodieDelivery : Mappable {
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


struct FoodieDeliveryaddress : Mappable {
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


struct FoodieInvoice : Mappable {
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
    var item_price: Double?
    
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
        item_price <- map["item_price"]
    }
    
}



struct FoodieItems : Mappable {
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
    var store : FoodieStore?
    var cartaddon : [Itemsaddon]?
    
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


struct FoodiePickup : Mappable {
    var id : Int?
    var store_type_id : Int?
    var latitude : Double?
    var longitude : Double?
    var store_location : String?
    var store_name : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        store_type_id <- map["store_type_id"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        store_location <- map["store_location"]
        store_name <- map["store_name"]
    }
    
}


struct FoodieResponseData : Mappable {
    var id : Int?
    var admin_service_id : String?
    var store_order_invoice_id: String?
    var user_id : Int?
    var user_address_id : Int?
    var promocode_id : Int?
    var store_id : Int?
    var provider_id : Int?
    var provider_vehicle_id : String?
    var company_id : Int?
    var note : String?
    var route_key : String?
    var delivery_date : String?
    var pickup_address : String?
    var delivery_address : String?
    var order_type : String?
    var order_otp : String?
    var order_ready_time : Int?
    var order_ready_status : Int?
    var paid : String?
    var status : String?
    var cancelled_by : String?
    var cancel_reason : String?
    var user_rated : Int?
    var provider_rated : Int?
    var schedule_status : Int?
    var request_type : String?
    var created_at : String?
    var delivery : FoodieDelivery?
    var pickup : Pickup?
    var store : FoodieStore?
    var deliveryaddress : FoodieDeliveryaddress?
    var invoice : FoodieInvoice?
    var user : FoodieUser?
    var provider : FoodieProvider?

    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        admin_service_id <- map["admin_service"]
        store_order_invoice_id <- map["store_order_invoice_id"]
        user_id <- map["user_id"]
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
        order_otp <- map["order_otp"]
        order_ready_time <- map["order_ready_time"]
        order_ready_status <- map["order_ready_status"]
        paid <- map["paid"]
        status <- map["status"]
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


struct Storetype : Mappable {
    var id : Int?
    var company_id : Int?
    var name : String?
    var category : String?
    var status : Int?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        company_id <- map["company_id"]
        name <- map["name"]
        category <- map["category"]
        status <- map["status"]
    }
    
}

struct Store : Mappable {
    var store_name : String?
    var picture : String?
    var rating : Int?
    var store_packing_charges : String?
    var store_gst : Int?
    var commission : Int?
    var offer_min_amount : String?
    var offer_percent : Int?
    var free_delivery : Int?
    var id : Int?
    var store_type_id : Int?
    var storetype : Storetype?
    var store_cusinie : [Store_cusinie]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        store_name <- map["store_name"]
        picture <- map["picture"]
        rating <- map["rating"]
        store_packing_charges <- map["store_packing_charges"]
        store_gst <- map["store_gst"]
        commission <- map["commission"]
        offer_min_amount <- map["offer_min_amount"]
        offer_percent <- map["offer_percent"]
        free_delivery <- map["free_delivery"]
        id <- map["id"]
        store_type_id <- map["store_type_id"]
        storetype <- map["storetype"]
        store_cusinie <- map["store_cusinie"]
    }
    
}


struct FoodieStore : Mappable {
    var store_name : String?
    var store_packing_charges : String?
    var store_gst : Int?
    var commission : Int?
    var offer_min_amount : String?
    var offer_percent : Int?
    var free_delivery : Int?
    var id : Int?
    var store_type_id : Int?
    var storetype : FoodieStoretype?
    var estimated_delivery_time: String?

    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        store_name <- map["store_name"]
        store_packing_charges <- map["store_packing_charges"]
        store_gst <- map["store_gst"]
        commission <- map["commission"]
        offer_min_amount <- map["offer_min_amount"]
        offer_percent <- map["offer_percent"]
        free_delivery <- map["free_delivery"]
        id <- map["id"]
        store_type_id <- map["store_type_id"]
        storetype <- map["storetype"]
        estimated_delivery_time <- map["estimated_delivery_time"]

    }
    
}


struct FoodieStoretype : Mappable {
    var id : Int?
    var company_id : Int?
    var name : String?
    var category : String?
    var status : Int?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        company_id <- map["company_id"]
        name <- map["name"]
        category <- map["category"]
        status <- map["status"]
    }
    
}

struct FoodieUser : Mappable {
    var id : Int?
    var first_name : String?
    var last_name : String?
    var payment_mode : String?
    var user_type : String?
    var email : String?
    var mobile : String?
    var gender : String?
    var country_code : String?
    var currency_symbol : String?
    var picture : String?
    var login_by : String?
    var latitude : String?
    var longitude : String?
    var wallet_balance : Int?
    var rating : String?
    var language : String?
    var country_id : Int?
    var state_id : Int?
    var city_id : Int?
    var status : Int?
    var created_at : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        payment_mode <- map["payment_mode"]
        user_type <- map["user_type"]
        email <- map["email"]
        mobile <- map["mobile"]
        gender <- map["gender"]
        country_code <- map["country_code"]
        currency_symbol <- map["currency_symbol"]
        picture <- map["picture"]
        login_by <- map["login_by"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        wallet_balance <- map["wallet_balance"]
        rating <- map["rating"]
        language <- map["language"]
        country_id <- map["country_id"]
        state_id <- map["state_id"]
        city_id <- map["city_id"]
        status <- map["status"]
        created_at <- map["created_at"]
    }
    
}

struct FoodieProvider : Mappable {
    var id : Int?
    var first_name : String?
    var last_name : String?
    var country_code : String?
    var mobile : String?
    var rating : Double?
    var latitude : Double?
    var longitude : Double?
    var picture : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        country_code <- map["country_code"]
        mobile <- map["mobile"]
        rating <- map["rating"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        picture <- map["picture"]
    }
    
}

