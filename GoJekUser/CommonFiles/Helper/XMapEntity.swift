//
//  XMapEntity.swift
//  GoJekProvider
//
//  Created by apple on 10/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import ObjectMapper

class Place: Mappable {
    
    var results: [Address]?
    var status: String?
    var error_message: String?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        results <- map["results"]
        status <- map["status"]
        error_message <- map["error_message"]
    }
}

class Address: Mappable {
    
    var address_components: [AddressComponent]?
    var formatted_address: String?
    var geometry: Geometry?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        address_components <- map["address_components"]
        formatted_address <- map["formatted_address"]
        geometry <- map["geometry"]
    }
}

class AddressComponent: Mappable {
    
    var long_name: String?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        long_name <- map["long_name"]
    }
}

class Geometry: Mappable {
    
    var location: Location?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        location <- map["location"]
    }
}

class Location: Mappable {
    
    var lat: Double?
    var lng: Double?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        lat <- map["lat"]
        lng <- map["lng"]
    }
}

class MapPath: Mappable {
    
    var routes: [Route]?
    var errorMsg: String?
    var status: String?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        routes <- map["routes"]
        errorMsg <- map["error_message"]
        status <- map["status"]
    }
}

class Route: Mappable {
    
    var overview_polyline: OverView?
    var legs : [LegsObject]?

    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        overview_polyline <- map["overview_polyline"]
        legs <- map["legs"]

    }
}

class LegsObject : Mappable {
    var duration : DurationObject?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        duration <- map["duration"]
    }
}
class DurationObject : Mappable {
    var text : String?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        text <- map["text"]
    }
}

class OverView: Mappable {
    
    var points: String?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        points <- map["points"]
    }
}
