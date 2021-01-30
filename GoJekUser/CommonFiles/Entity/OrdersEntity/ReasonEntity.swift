//
//  ReasonEntity.swift
//  GoJekUser
//
//  Created by Ansar on 22/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation
import ObjectMapper

struct ReasonEntity : Mappable {
    var statusCode : String?
    var title : String?
    var message : String?
    var responseData : [ReasonData]?
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

struct ReasonData : Mappable {
    var id : Int?
    var service : String?
    var type : String?
    var reason : String?
    var status : String?
    var created_type : String?
    var created_by : Int?
    var modified_type : String?
    var modified_by : Int?
    var deleted_type : String?
    var deleted_by : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        service <- map["service"]
        type <- map["type"]
        reason <- map["reason"]
        status <- map["status"]
        created_type <- map["created_type"]
        created_by <- map["created_by"]
        modified_type <- map["modified_type"]
        modified_by <- map["modified_by"]
        deleted_type <- map["deleted_type"]
        deleted_by <- map["deleted_by"]
    }
    
}
