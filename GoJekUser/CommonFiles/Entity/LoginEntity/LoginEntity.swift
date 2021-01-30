//
//  LoginEntity.swift
//  GoJekProvider
//
//  Created by apple on 28/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import ObjectMapper

//MARK: - LoginEntity

class LoginEntity: Mappable {
    
    var error : Any?
    var message : String?
    var responseData : LoginResponseData?
    var statusCode : String?
    var title : String?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        error <- map["error"]
        message <- map["message"]
        responseData <- map["responseData"]
        statusCode <- map["statusCode"]
        title <- map["title"]
    }
}

//MARK: - Login Response data

class LoginResponseData: Mappable {
    
    var token_type : String?
    var expires_in : Int?
    var access_token : String?
    var user : User?
    var currency : String?
    var sos : String?
    var contact_number : [Contact_number]?
    var measurement : String?
    var otp: Int?

    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        
        token_type <- map["token_type"]
        expires_in <- map["expires_in"]
        access_token <- map["access_token"]
        user <- map["user"]
        currency <- map["currency"]
        sos <- map["sos"]
        contact_number <- map["contact_number"]
        measurement <- map["measurement"]
        otp <- map["otp"]

    }
}

//MARK: - User Entity

class User: Mappable{
    
    var cityId : Int?
    var countryId : Int?
    var createdAt : String?
    var firstName : String?
    var gender : String?
    var id : Int?
    var lastName : String?
    var latitude : Double?
    var longitude : Double?
    var mobile : String?
    var paymentMode : String?
    var picture : String?
    var rating : Double?
    var stateId : Int?
    var userType : String?
    var walletBalance : Int?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        cityId <- map["city_id"]
        countryId <- map["country_id"]
        createdAt <- map["created_at"]
        firstName <- map["first_name"]
        gender <- map["gender"]
        id <- map["id"]
        lastName <- map["last_name"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        mobile <- map["mobile"]
        paymentMode <- map["payment_mode"]
        picture <- map["picture"]
        rating <- map["rating"]
        stateId <- map["state_id"]
        userType <- map["user_type"]
        walletBalance <- map["wallet_balance"]
        
    }
}

struct Contact_number : Mappable {
    var number : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        number <- map["number"]
    }
    
}
