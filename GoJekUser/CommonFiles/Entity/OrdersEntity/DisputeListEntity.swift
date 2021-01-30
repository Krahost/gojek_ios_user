//
//  DisputeListEntity.swift
//  GoJekUser
//
//  Created by Ansar on 17/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation
import ObjectMapper

struct DisputeListEntity : Mappable {
    var statusCode : String?
    var title : String?
    var message : String?
    var responseData : [DisputeListData]?
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

struct DisputeListData: Mappable {
    var id : Int?
    var dispute_name : String?
    var service: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        dispute_name <- map["dispute_name"]
        service <-  map["service"]
    }
    
}
