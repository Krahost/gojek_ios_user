//
//  XuberSubCategoryEntity.swift
//  GoJekUser
//
//  Created by Ansar on 19/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation
import ObjectMapper

struct XuberSubCategoryEntity : Mappable {
    var statusCode : String?
    var title : String?
    var message : String?
    var responseData : [XuberSubServiceList]?
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

struct XuberSubServiceList : Mappable {
    var id : Int?
    var service_category_id : Int?
    var company_id : Int?
    var service_subcategory_name : String?
    var picture : String?
    var service_subcategory_order : Int?
    var service_subcategory_status : Int?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        service_category_id <- map["service_category_id"]
        company_id <- map["company_id"]
        service_subcategory_name <- map["service_subcategory_name"]
        picture <- map["picture"]
        service_subcategory_order <- map["service_subcategory_order"]
        service_subcategory_status <- map["service_subcategory_status"]
    }
    
}
