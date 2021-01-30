//
//  VerifyOtpEntity.swift
//  GoJekUser
//
//  Created by CSS on 18/09/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation
import ObjectMapper

struct VerifyOtpEntity : Mappable {
    var statusCode : String?
    var title : String?
    var message : String?
    var VerifyOtpresponseData : VerifyOtpResponseData?
    var error : [String]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        statusCode <- map["statusCode"]
        title <- map["title"]
        message <- map["message"]
        VerifyOtpresponseData <- map["responseData"]
        error <- map["error"]
    }
    
}

struct VerifyOtpResponseData : Mappable {
    var verify : Bool?
    var message : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        verify <- map["verify"]
        message <- map["message"]
    }
    
}
