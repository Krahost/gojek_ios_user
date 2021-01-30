//
//  FoodieDetailEntity.swift
//  GoJekUser
//
//  Created by apple on 02/05/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import ObjectMapper

class FoodieDetailEntity: Mappable {
    
    var error : [AnyObject]?
    var message : String?
    var responseData : ShopDetail?
    var statusCode : String?
    var title : String?
    
    required init?(map: Map){}
    
    func mapping(map: Map) {
        error <- map["error"]
        message <- map["message"]
        responseData <- map["responseData"]
        statusCode <- map["statusCode"]
        title <- map["title"]
    }
}


class ShopDetail: Mappable {
    
    var categories : [Categories]?
    var companyId : Int?
    var estimatedDeliveryTime : String?
    var freeDelivery : Int?
    var id : Int?
    var isVeg : String?
    var latitude : Float?
    var longitude : Float?
    var offerMinAmount : String?
    var offerPercent : Int?
    var picture : String?
    var products : [FoodieDetailProduct]?
    var rating : Int?
    var shopstatus : String?
    var shop_status : String?
    var storeLocation : String?
    var storeName : String?
    var storeTypeId : Int?
    var totalstorecart : Int?
    var usercart : Int?
    var storetype : Storetype?
    var itemStatus : String?

   
    required init?(map: Map){}
    
    func mapping(map: Map) {
        categories <- map["categories"]
        companyId <- map["company_id"]
        estimatedDeliveryTime <- map["estimated_delivery_time"]
        freeDelivery <- map["free_delivery"]
        id <- map["id"]
        isVeg <- map["is_veg"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        offerMinAmount <- map["offer_min_amount"]
        offerPercent <- map["offer_percent"]
        picture <- map["picture"]
        products <- map["products"]
        rating <- map["rating"]
        shopstatus <- map["shopstatus"]
        storeLocation <- map["store_location"]
        storeName <- map["store_name"]
        storeTypeId <- map["store_type_id"]
        totalstorecart <- map["totalstorecart"]
        usercart <- map["usercart"]
        storetype <- map["storetype"]
        itemStatus <- map["item_status"]
        shop_status <- map["shop_status"]

    }
}

class FoodieDetailProduct: Mappable {
    
    var companyId : Int?
    var id : Int?
    var isAddon : Int?
    var isVeg : String?
    var itemDescription : String?
    var itemDiscount : String?
    var itemDiscountType : String?
    var itemName : String?
    var itemPrice : Double?
    var offer: Int?
    var shop_status: String?
    var itemcart : [Itemcart]?
    var itemsaddon : [Itemsaddon]?
    var picture : String?
    var status : Int?
    var storeCategoryId : Int?
    var storeId : Int?
    var unit : Unit?
    var quantity : Int?
    var product_offer: Double?
    var itemStatus : String?
    
    required init?(map: Map){}
    
    func mapping(map: Map) {
        companyId <- map["company_id"]
        id <- map["id"]
        isAddon <- map["is_addon"]
        isVeg <- map["is_veg"]
        itemDescription <- map["item_description"]
        itemDiscount <- map["item_discount"]
        itemDiscountType <- map["item_discount_type"]
        itemName <- map["item_name"]
        itemPrice <- map["item_price"]
        itemcart <- map["itemcart"]
        itemsaddon <- map["itemsaddon"]
        picture <- map["picture"]
        status <- map["status"]
        storeCategoryId <- map["store_category_id"]
        storeId <- map["store_id"]
        offer <- map["offer"]
        product_offer <- map["product_offer"]
        unit <- map["unit"]
        quantity <- map["quantity"]
        itemStatus <- map["item_status"]
        shop_status <- map["shop_status"]

    }
}

class Itemsaddon: Mappable{
    
    var addonName : String?
    var companyId : Int?
    var id : Int?
    var price : Int?
    var storeAddonId : Int?
    var storeId : Int?
    var storeItemId : Int?
    
    required init?(map: Map){}
    
    func mapping(map: Map)
    {
        addonName <- map["addon_name"]
        companyId <- map["company_id"]
        id <- map["id"]
        price <- map["price"]
        storeAddonId <- map["store_addon_id"]
        storeId <- map["store_id"]
        storeItemId <- map["store_item_id"]
    }
}

class Itemcart: Mappable{
    
    var userId : Int?
    var storeItemId : Int?
    var id : Int?
    var storeId : Int?
    var storeOrderId : Int?
    var companyId : Int?
    var quantity : Int?
    var itemPrice : Int?
    var totalItemPrice : Int?
    var totAddonPrice : Int?
    var note : Int?
    var productData : Int?
    
    required init?(map: Map){}
    
    func mapping(map: Map)
    {
        userId <- map["user_id"]
        storeItemId <- map["store_item_id"]
        id <- map["id"]
        storeId <- map["store_id"]
        storeOrderId <- map["store_order_id"]
        companyId <- map["company_id"]
        quantity <- map["quantity"]
        itemPrice <- map["item_price"]
        totalItemPrice <- map["total_item_price"]
        totAddonPrice <- map["tot_addon_price"]
        note <- map["note"]
        productData <- map["product_data"]
    }
}

