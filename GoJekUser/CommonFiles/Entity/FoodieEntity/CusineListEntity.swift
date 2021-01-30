//
//  CusineListEntity.swift
//  GoJekUser
//
//  Created by CSS on 03/05/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation
import ObjectMapper

struct CusineListEntity : Mappable {
    var statusCode : String?
    var title : String?
    var message : String?
    var responseData : [CusineResponseData]?
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

struct CusineResponseData : Mappable {
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
