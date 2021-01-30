//
//  SavedAddressEntity.swift
//  GoJekUser
//
//  Created by Ansar on 04/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation
import ObjectMapper

struct SavedAddressEntity : Mappable {
    
    var statusCode : String?
    var title : String?
    var message : String?
    var responseData : [AddressResponseData]?
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

struct AddressResponseData: Mappable {
    
    var id : Int?
    var user_id : Int?
    var company_id : Int?
    var address_type : String?
    var landmark : String?
    var flat_no : String?
    var street : String?
    var city : String?
    var state : String?
    var county : String?
    var title: String?
    var zipcode : String?
    var latitude : Double?
    var longitude : Double?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        user_id <- map["user_id"]
        company_id <- map["company_id"]
        address_type <- map["address_type"]
        landmark <- map["landmark"]
        flat_no <- map["flat_no"]
        street <- map["street"]
        city <- map["city"]
        state <- map["state"]
        county <- map["county"]
        title <- map["title"]
        zipcode <- map["zipcode"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
    }
    
    func locationAddress() -> String {
        
        var address: String  = ""
        
        if let flat = self.flat_no {
            address = flat + ","
        }
        
        if let landmark = self.landmark {
            address = address + landmark + ",".giveSpace
        }
        
        if let street = self.street {
            address = address + street + ",".giveSpace
        }
        
        if let city = self.city {
            address = address + city + ",".giveSpace
        }
        
        if let state = self.state {
            address = address + state + ",".giveSpace
        }
        
        if let county = self.county {
            address = address + county
        }
        
        var lastChar = address.last
        if lastChar == " " {
            address = String(address.dropLast())
            lastChar = address.last
        }
        if lastChar == "," {
            address = String(address.dropLast())
        }
        return address
    }
}
