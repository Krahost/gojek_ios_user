//
//  AddAmountEntity.swift
//  GoJekUser
//
//  Created by Ansar on 16/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation
import ObjectMapper

struct AddAmountEntity : Mappable {
    var statusCode : String?
    var title : String?
    var message : String?
    var responseData : AddAmountData?
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


struct AddAmountData : Mappable {
    var wallet_balance : Double?
    var message : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        wallet_balance <- map["wallet_balance"]
        message <- map["message"]
    }
    
}
