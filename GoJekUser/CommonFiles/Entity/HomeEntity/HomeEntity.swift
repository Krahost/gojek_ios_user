//
//  HomeEntity.swift
//  GoJekUser
//
//  Created by apple on 20/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import ObjectMapper

class HomeEntity: Mappable {
    var statusCode : String?
    var title : String?
    var message : String?
    var responseData : HoneResponseData?
    var error : [String]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        statusCode <- map["statusCode"]
        title <- map["title"]
        message <- map["message"]
        responseData <- map["responseData"]
        error <- map["error"]
    }
}


struct HoneResponseData : Mappable {
    var services : [ServicesDetails]?
    var promocodes : [PromocodeData]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        services <- map["services"]
        promocodes <- map["promocodes"]
    }
    
}

struct Service : Mappable {
    var id : Int?
    var admin_service_name : String?
    var display_name : String?
    var base_url : String?
    var status : Int?
    var service_name:String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        admin_service_name <- map["admin_service"]
        display_name <- map["display_name"]
        base_url <- map["base_url"]
        status <- map["status"]
        service_name <- map["service_name"]
    }
    
}

struct ServicesDetails : Mappable {
    var id : Int?
    var bg_color : String?
    var icon : String?
    var is_featured : Int?
    var featured_image : String?
    var title : String?
    var admin_service_id : Int?
    var menu_type_id : Int?
    var service : Service?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        bg_color <- map["bg_color"]
        icon <- map["icon"]
        is_featured <- map["is_featured"]
        featured_image <- map["featured_image"]
        title <- map["title"]
        admin_service_id <- map["admin_service"]
        menu_type_id <- map["menu_type_id"]
        service <- map["service"]
    }
    
}

struct UserCity : Mappable {
    var statusCode : String?
    var title : String?
    var message : String?
    var responseData : [String]?
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
