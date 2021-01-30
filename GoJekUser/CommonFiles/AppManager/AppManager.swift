//
//  AppManager.swift
//  GoJekUser
//
//  Created by Ansar on 01/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation

enum MasterServices: String {
    case Transport = "TRANSPORT"
    case Order = "ORDER"
    case Service = "SERVICE"
    case Delivery = "DELIVERY"
}

class AppManager {
    
    static var shared = AppManager()
    
    private var userDetails:UserProfileEntity!
    
    private var selectedService: ServicesDetails!
    
    private var userSaveAddress:[AddressResponseData]!
    
    private var countriesList:[CountryData]!
    
    public var accessToken: String?
    
    
    //MARK:- User Details Getter and Setter
    func setUserDetails(details:UserProfileEntity) {
        self.userDetails =  details
    }
    
    func getUserDetails() -> UserProfileEntity? {
        return  userDetails
    }
    
    //MARK:- Service Type Getter and Setter
    func setSelectedServices(service:ServicesDetails) {
        self.selectedService = service
    }
    
    func getSelectedServices() -> ServicesDetails? {
        
        return selectedService
    }
    
    //MARK:- User Address Getter and Settrt
    func setSavedAddress(address:[AddressResponseData]) {
        self.userSaveAddress = address
    }
    
    func getSavedAddress() -> [AddressResponseData]? {
        
        return userSaveAddress
    }
    
    func saveCountries(countries:[CountryData]) {
        self.countriesList = countries
    }
    
    func getCountries() -> [CountryData]? {
        return countriesList
    }
    
    func setSignUpDetail(service:ServicesDetails) {
        self.selectedService = service
    }
    
    func getSignUpDetail() -> ServicesDetails? {
        
        return selectedService
    }
}



