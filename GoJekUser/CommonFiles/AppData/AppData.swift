//
//  swift
//  GoJekUser
//
//  Created by apple on 18/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

var deviceTokenString: String = ""
var guestAccountCity: String = ""
var isGuestAccount: Bool = false

struct AppEnvironment {
    
    static var env = Environment.Dev
    
}

struct APPConstant {
    
    //App Detail
    static let appName = "Opus X"
    static let salt_key = "MQ=="
    static let defaultMapLocation = LocationCoordinate(latitude: 13.0617, longitude: 80.2544)
    
    //Base Detail
    static let googleKey = AppEnvironment.env.mapKey
    static let baseUrl = AppEnvironment.env.baseURL
    static let stripePublishableKey = AppEnvironment.env.stipeKey
    static let socketBaseUrl =  AppEnvironment.env.socketBaseUrl
    
    //Default Url
    static let googleGeocodeURL = "https://maps.googleapis.com/maps/api/geocode/json?latlng="
    static let googleRouteBaseUrl = "https://maps.googleapis.com/maps/api/directions/json?origin="
    static let userAppStoreLink = "https://apps.apple.com/us/app/id1465261707"
}

enum Environment: String {
    case Dev
    case Staging
    
    var baseURL: String {
        switch self {
        case .Dev:      return "https://easyjekapi.ktv1oils.com/base"
        case .Staging:  return "https://easyjekapi.ktv1oils.com/base"
        }
    }
    
    var socketBaseUrl: String {
        switch self {
        case .Dev:        return "https://easyjekapi.ktv1oils.com"
        case .Staging:    return "https://easyjekapi.ktv1oils.com"
        }
    }
    
    var mapKey: String {
        switch self {
        case .Dev:        return "AIzaSyC4YoV-JBT1MjsLk8FZW_DoAFrTVOjCs00"
        case .Staging:    return "AIzaSyC4YoV-JBT1MjsLk8FZW_DoAFrTVOjCs00"
        }
    }
    
    var stipeKey: String {
        switch self {
        case .Dev:        return "pk_test_DbfzA8Pv1MDErUiHakK9XfLe"
        case .Staging:    return "pk_test_DbfzA8Pv1MDErUiHakK9XfLe"
        }
    }
}

//MARK:- Set App basic configuration Details

class AppConfigurationManager
{
    
    var baseConfigModel: BaseEntity!
    var currentService:ServicesList!
    
    static var shared = AppConfigurationManager()
    
    func setBasicConfig(data:BaseEntity) {
        self.baseConfigModel = data
    }
    
    func setServiceType(service:ServicesList) {
        self.currentService  = service
    }
    
    func getBaseUrl () -> String
    {
        if let _ = currentService {
            return currentService.base_url ?? ""
        }
        else if let _ = baseConfigModel {
            return baseConfigModel.responseData?.base_url ?? ""
        }
        return ""
    }
    
}



