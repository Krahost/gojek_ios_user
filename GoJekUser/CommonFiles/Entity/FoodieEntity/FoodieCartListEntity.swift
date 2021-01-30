//
//  FoodieCartListEntity.swift
//  GoJekUser
//
//  Created by apple on 03/05/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import ObjectMapper

class FoodieCartListEntity: Mappable {
    
    var statusCode : String?
    var title : String?
    var message : String?
    var responseData : CartListResponse?
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

class CartListResponse: Mappable{
    
    var carts : [Cart]?
    var deliveryCharges : Double?
    var deliveryFreeMinimum : Double?
    var net : Double?
    var payable : Double?
    var promocodeAmount : Double?
    var promocodeId : Int?
    var shopDiscount : Double?
    var shopGst : Double?
    var shopGstAmount : Double?
    var shopPackageCharge : Double?
    var storeCommisionPer : Int?
    var storeId : Int?
    var storeType : String?
    var taxPercentage : Int?
    var totalCart : Int?
    var totalPrice : Double?
    var walletBalance : Double?
    var totalItemPrice : Double?

    
    required init?(map: Map){}
    
    func mapping(map: Map) {
        
        carts <- map["carts"]
        deliveryCharges <- map["delivery_charges"]
        deliveryFreeMinimum <- map["delivery_free_minimum"]
        net <- map["net"]
        payable <- map["payable"]
        promocodeAmount <- map["promocode_amount"]
        promocodeId <- map["promocode_id"]
        shopDiscount <- map["shop_discount"]
        shopGst <- map["shop_gst"]
        shopGstAmount <- map["shop_gst_amount"]
        shopPackageCharge <- map["shop_package_charge"]
        storeCommisionPer <- map["store_commision_per"]
        storeId <- map["store_id"]
        storeType <- map["store_type"]
        taxPercentage <- map["tax_percentage"]
        totalCart <- map["total_cart"]
        totalPrice <- map["total_price"]
        walletBalance <- map["wallet_balance"]
        totalItemPrice <- map["total_item_price"]

    }
}

class Cart: Mappable{
    
    var companyId : Int?
    var id : Int?
    var itemPrice : Int?
    var note : AnyObject?
    var product : FoodieProduct?
    var productData : AnyObject?
    var quantity : Int?
    var store : Store?
    var storeId : Int?
    var storeItemId : Int?
    var storeOrderId : Int?
    var totAddonPrice : Int?
    var totalItemPrice : Double?
    var userId : Int?
    var cartaddon : [Cartaddon]?

    

    required init?(map: Map){}
    
    func mapping(map: Map) {
        
        companyId <- map["company_id"]
        id <- map["id"]
        itemPrice <- map["item_price"]
        note <- map["note"]
        product <- map["product"]
        productData <- map["product_data"]
        quantity <- map["quantity"]
        store <- map["store"]
        storeId <- map["store_id"]
        storeItemId <- map["store_item_id"]
        storeOrderId <- map["store_order_id"]
        totAddonPrice <- map["tot_addon_price"]
        totalItemPrice <- map["total_item_price"]
        userId <- map["user_id"]
        cartaddon <- map["cartaddon"]

    }
}

struct Cartaddon : Mappable {
    var id : Int?
    var store_cart_id : Int?
    var store_cart_item_id : Int?
    var store_item_addons_id : Int?
    var store_addon_id : Int?
    var company_id : Int?
    var addon_price : Int?
    var addon_name : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        store_cart_id <- map["store_cart_id"]
        store_cart_item_id <- map["store_cart_item_id"]
        store_item_addons_id <- map["store_item_addons_id"]
        store_addon_id <- map["store_addon_id"]
        company_id <- map["company_id"]
        addon_price <- map["addon_price"]
        addon_name <- map["addon_name"]
    }
    
}



