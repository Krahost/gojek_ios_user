//
//  UserData+CoreDataProperties.swift
//  GoJekUser
//
//  Created by Ansar on 03/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//
//

import Foundation
import CoreData


extension UserData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserData> {
        return NSFetchRequest<UserData>(entityName: "UserData")
    }

    @NSManaged public var cityId: Int64
    @NSManaged public var countryId: Int64
    @NSManaged public var currency: String?
    @NSManaged public var firstName: String?
    @NSManaged public var gender: String?
    @NSManaged public var id: Int64
    @NSManaged public var lastName: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var mobile: String?
    @NSManaged public var paymentMode: String?
    @NSManaged public var picture: String?
    @NSManaged public var rating: Double
    @NSManaged public var userType: String?
    @NSManaged public var walletBalance: Int64
    @NSManaged public var language: String?
    @NSManaged public var cityName: String?
    @NSManaged public var countryName: String?

}
