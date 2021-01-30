//
//  sendOtpEntity.swift
//  GoJekUser
//
//  Created by CSS on 18/09/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation
import ObjectMapper



struct sendOtpEntity : Mappable {
    var statusCode : String?
    var title : String?
    var message : String?
    var sendOtpresponseData : sendOtpresponseData?
    var error : [String]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        statusCode <- map["statusCode"]
        title <- map["title"]
        message <- map["message"]
        sendOtpresponseData <- map["responseData"]
        error <- map["error"]
    }
    
}


struct sendOtpresponseData : Mappable {
    var sms : Bool?
    var message : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        sms <- map["sms"]
        message <- map["message"]
    }
    
}
