//
//  XuberProviderReviewEntity.swift
//  GoJekUser
//
//  Created by Ansar on 25/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation
import ObjectMapper

struct XuberProviderReviewEntity : Mappable {
    var statusCode : String?
    var title : String?
    var message : String?
    var responseData : ResponseReview?
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


struct ResponseReview : Mappable {
    var total_records : Int?
    var review : [Review]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        total_records <- map["total_records"]
        review <- map["review"]
    }
    
}

struct Review : Mappable {
    var id : Int?
    var admin_service_id : Int?
    var user_id : Int?
    var provider_id : Int?
    var provider_rating : Int?
    var provider_comment : String?
    var user_comment:String?
    var created_at : String?
    var user : User? //Reuse from login User Entity
    var user_rating: Int?

    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        admin_service_id <- map["admin_service"]
        user_id <- map["user_id"]
        provider_id <- map["provider_id"]
        provider_rating <- map["provider_rating"]
        provider_comment <- map["provider_comment"]
        user <- map["user"]
        created_at <- map["created_at"]
        user_comment <- map["user_comment"]
        user_rating <- map["user_rating"]

    }
    
}
