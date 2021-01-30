//
//  HomeConstant.swift
//  GoJekUser
//
//  Created by apple on 21/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

enum HomeConstant {
    
    //Viewcontroller Identifier
    static let VHomeViewController  = "HomeViewController"
    static let VOfferTableViewCell  = "OfferTableViewCell"
    static let ServicesListCell = "ServicesListCells"
    static let ServiceListCollection = "ServiceListCollection"
    static let OfferCouponCell = "OfferCouponCell"
    static let OffersCollectionCell = "OffersCollectionCell"
    static let RecommendedTableCell = "RecommendedTableCell"
    static let TaxiHomeController = "TaxiHomeController"
    static let FoodieHomeViewController = "FoodieHomeViewController"
    static let SaveLocationController = "SaveLocationController"
    static let CouponViewController = "CouponViewController"
    static let ServicesListCells = "ServicesListCell"
    
    
    //Viewcontrolle Title
    static let THome = "Home"
    static let location = "Location"
    static let nofeatureService = "No Feature Service Found"
    static let nocoupons = "No coupons Found"
    
    //ImageName
    static let Iratings1 = "Ratings1"
    static let Icourier = "courier"
    static let Idrinks = "drinks"
    static let discountVoucher = "discount_voucher"
    static let noFetaureImage = "gear"
    
    //Sting
    static let showMore = "Show More"
    static let showLess = "Show Less"
    static let offerCoupons = "Offers / Coupons"
    static let recommendedService = "Recommended Services"
    static let viewMore = "View More"
    static let savedLocation = "Saved Location"
    static let currentLocation = "Current Location"
    static let enableLocation = "Enable Location Service"
    static let FeaturedServices = "Featured Services"
    
    //XIB
    static let LocationTableViewCell = "LocationTableViewCell"
    static let noServices = "No Services Available in the city"
    
    //Newly Added
    static let guestLocationAlert = "This feature is not available for guest login"


}

enum Flow{
    static let taxi = "Taxi"
    static let service = "Service"
    static let courier = "Courier"
    static let foodie = "Foodie"

}

enum HomeAPI{
    
    static let getHomeDetails = "/user/menus"
    static let checkRequest = "/user/store/check/request"
    static let promocode = "/user/promocode"
    static let reason = "/user/reasons"

}


class ChatPushClick {
    
static var shared = ChatPushClick()
    
private init() {}
    
    var isPushClick:Bool = false
    var isOrderPushClick:Bool = false
    var isServicePushClick:Bool = false
    
    func clear() {
        isPushClick = false
        isOrderPushClick = false
        isServicePushClick = false
    }

}
