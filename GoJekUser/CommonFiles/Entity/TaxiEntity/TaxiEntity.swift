//
//  TaxiEntity.swift
//  GoJekUser
//
//  Created by apple on 20/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation
import ObjectMapper

class TaxiReuqestEntity: Mappable {
    
    var use_wallet : Int?
    var schedule_date : String?
    var schedule_time : String?
    var someone: Int?
    var someone_name: String?
    var someone_email: String?
    var someone_mobile: String?
    var wheel_chair: Int?
    var child_seat: Int?
    var distance: Double?
    var promocode_id: Int?
    var isSchedule: Bool?
    var s_latitude: Double?
    var s_longitude: Double?
    var service_type:Int?
    var d_latitude: Double?
    var d_longitude: Double?
    var payment_mode: String?
    var s_address: String?
    var d_address: String?
    var rideTypeId: Int?
    var card_id: String?
    var max_amount : Int?
    var percentage : Int?
    
    
    required convenience init?(map: Map) {
        self.init()
    }
    
     func mapping(map: Map) {
        
        use_wallet <- map["use_wallet"]
        schedule_date <- map["schedule_date"]
        schedule_time <- map["schedule_time"]
        someone <- map["someone"]
        someone_email <- map["someone_email"]
        someone_name  <- map["someone_name"]
        wheel_chair <- map["wheel_chair"]
        child_seat <- map["child_seat"]
        distance <- map["distance"]
        s_latitude <- map["s_latitude"]
        s_longitude <- map["s_longitude"]
        service_type <- map["service_type"]
        d_latitude <- map["d_latitude"]
        d_longitude <- map["d_longitude"]
        payment_mode <- map["payment_mode"]
        max_amount <- map["max_amount"]
        percentage <- map["percentage"]
    }
}
