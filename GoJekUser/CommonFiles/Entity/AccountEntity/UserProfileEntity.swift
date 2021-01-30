//
//  UserProfileEntity.swift
//  GoJekUser
//
//  Created by Rajes on 26/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation
import ObjectMapper

class UserProfileResponse:Mappable {
    
    var message : String?
    var responseData : UserProfileEntity?
    var statusCode : String?
    var title : String?
    var error : Any?
    
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


class UserProfileEntity: Mappable {
    
    var id: Int?
    var first_name: String?
    var last_name: String?
    var payment_mode: String?
    var user_type: String?
    var iso2 : String?
    var email: String?
    var mobile: String?
    var gender: String?
    var country_code: String?
    var picture: String?
    var login_by : String?
    var latitude: Double?
    var longitude: Double?
    var wallet_balance: Double?
    var rating: Double?
    var language: String?
    var country_id: Int?
    var created_at: String?
    var currency: String?
    var country: CountryEntityData?
    var city: CityEntityData?
    var referral: ReferralData?
    var currency_symbol : String?
    var company_id : Int?
    var qrcode_url: String?

    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        iso2 <- map["iso2"]
        id <- map["id"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        payment_mode <- map["payment_mode"]
        user_type <- map["user_type"]
        email <- map["email"]
        mobile <- map["mobile"]
        gender <- map["gender"]
        login_by <- map["login_by"]
        country_code <- map["country_code"]
        picture <- map["picture"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        wallet_balance <- map["wallet_balance"]
        rating <- map["rating"]
        language <- map["language"]
        country_id <- map["country_id"]
        created_at <- map["created_at"]
        currency <- map["currency_symbol"]
        country <- map["country"]
        city <- map["city"]
        referral <- map["referral"]
        currency_symbol <- map["currency_symbol"]
        company_id <- map["company_id"]
        qrcode_url <- map["qrcode_url"]
    }
}

class CityEntityData: Mappable {
   
    var id: Int?
    var state_id: Int?
    var city_name: String?
    var status: Any?
    
    required convenience init?(map: Map) {
       self.init()
    }
    
     func mapping(map: Map) {
        
        id <- map["id"]
        state_id <- map["state_id"]
        city_name <- map["city_name"]
        status <- map["status"]
    }
    
}

class CountryEntityData: Mappable {
    
    var id: Int?
    var country_name: String?
    var country_code: String?
    var country_phonecode: String?
    var country_currency: String?
    var country_symbol: String?
    
    
    required convenience init?(map: Map) {
       self.init()
    }
    
    func mapping(map: Map) {
       id <- map["id"]
        country_name <- map["country_name"]
        country_code <- map["country_code"]
        country_phonecode <- map["country_phonecode"]
        country_currency <- map["country_currency"]
        country_symbol <- map["country_symbol"]
        
    }
    
}


class ReferralData: Mappable {
    var referral_amount : Double?
    var referral_count : Int?
    var user_referral_count : Int?
    var user_referral_amount : Double?
    var referral_code: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        referral_code <- map["referral_code"]
        referral_amount <- map["referral_amount"]
        referral_count <- map["referral_count"]
        user_referral_count <- map["user_referral_count"]
        user_referral_amount <- map["user_referral_amount"]
    }
    
}
