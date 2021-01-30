//
//  FoodieCommon.swift
//  GoJekUser
//
//  Created by Thiru on 27/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

enum FoodieConstant {
    
    //String
    static let Txjekfood = "GOX FOOD"
    static let deliveryDates = "delivery Date"
    static let TOffers = "Offers"
    static let TGetupTo = "Get up To"
    static let TShopNow = "Shop Now"
    static let TShop = "Shops"
    static let TDishes = "Dishes"
    static let itemAvailbale = "Items Available"
    static let deliveryCharge = "Delivery Charge"
    static let coupon = "Coupon Amount"
    static let view = "View"
    static let totalCharge = "Total Charge"
    static let deliveryAddress = "Delivery Address"
    static let change = "Change"
    static let homeAddress = "Home"
    static let payment = "Payment"
    static let scheduleAt = "Schedule At"
    static let orderProcess = "Order Processed"
    static let orderAssign = "Delivery Person Assigned"
    static let orderAssignDesc = "Your Order is assigned to Delivery Person"
    static let orderReach = "Reached Shop"
    static let orderReachDesc = "Delivery Person reached shop"
    static let orderProcessDesc = "Order is getting processed"
    static let orderOndway = "Order Picked up"
    static let orderOndwayDesc = "Delivery Person picked up your order"
    static let orderDeliver = "Order Delivery"
    static let orderDeliverDesc = "Order is delivered Successfully"
    static let deliveryPersonDetail = "Delivery person details"
    static let shopDetail = "Shop details"
    static let name = "Name"
    static let eta = "ETA"
    static let cart = "Cart"
    static let mapTrack = "Map Track"
    static let orderDetails = "Order Details"
    static let otp = "OTP:"
    static let removeNote = "Remove Note"
    static let addNote = "Add Note"
    static let plsuaddOns = "+ Addons"
    static let cuisine = "Cuisine"
    static let category = "Category"
    static let filter = "Filter"
    static let reset = "Reset"
    static let pfilter = "filter"
    static let search = "search"
    static let veg = "Veg"
    static let nonVeg = "Non Veg"
    static let timeing = "Timing"
    static let rating = "Rating"
    static let price = "Price"
    static let viewCart = "View Cart"
    static let item = "Item"
    static let extraCharge = "Extra charges may apply"
    static let itemId = "item_id"
    static let repeatVal = "repeat"
    static let Pcustomize = "customize"
    static let cartId = "cart_id"
    static let qty = "qty"
    static let addons = "addons"
    static let action = "action"
    static let addnew = "addnew"
    static let offerPercent = "% off on all orders"
    static let foodieHome = "Go-X Food"
    static let mins = "Mins"
    static let applyFilter = "apply filter"
    static let showShops = "SHOW SHOPS WITH"
    static let closed = "CLOSED"
    static let store = "store"
    static let dishes = "dish"
    static let items = "item"
    static let searchRestaurant = "Search for Shops or Dishes"
    static let pureVeg = "Pure Veg"
    static let freeDelivery = "Free Delivery"
    static let storePackage = "Shop Package Charge"
    static let taxAmount = "Tax Amount"
    static let cash = "CASH"
    static let emptyCart = "No item in cart"
    static let orderBy = "Order By"
    static let Address = "Please Select Delivery Address"
    static let StoreDetail = "No Items Available"
    static let useWallet = "Use Wallet Amount"
    static let doorStep = "doorstep delivery"
    static let delivery_Date = "Delivery Date"

    static let Addons = "Add ons"
    static let promoCode = "PromoCode"
    static let isApplied = "PromoCode Applied"
    static let promoCodeAmount = "PromoCode Discount"
    static let Mins = "Mins"
    static let Customizable = "Customizable"
    static let itemNotAvailable = "Item Not Available"
    static let totalDiscount = "Shop Discount"
    static let customize = "CUSTOMIZED +"
    static let all = "All"
    static let food = "FOOD"
    static let mapTrackTitle = "Map Track"
    static let chat = "Chat"
    static let orderedStatus = "Waiting for Shop Approval"
    static let recievedStatus = "Your order is accepted by shop"
    static let pickupStatus = "Your order is Ready for the Pickup"
    static let add = "add"
    static let placeOrder = "place order"
    static let OCancel = "Order Cancel"
    static let SAdd = "Add +"
    static let offerAmt = "Offer applied on the bill"
    static let itemNotAvail = "Item Not Available"
    
    static let itemTotal = "Item Total"
    static let noRestaurant = "No near by shops to show"
    static let cardId = "card_id"
    static let couponError = "No PromoCode List"
    
    //Order placed
    static let placeSuccesfully = "Placed Successfully"
    static let order = "Order"
    static let writeNote = "Write Notes"
    static let orderId = "Order ID:"
    static let searchError = "No result found."
    static let searchRestaurantError = "No result found. Please check the spelling or Try a different search"
    static let cartEmpty = "Your cart is empty. Add something from the menu"
    static let anotherRestaurant = "Your cart contains items from another Shop. Do you want to discard the selection and add items from this Shop?"
    static let repeatLast = "Repeat last used customizations?"
    static let itemnotavail = "Item not available"
    //Restaurant items View
    static let TViewcart = "View Cart"
    static let checkoutItem = "Please remove the items in cart proceed to check out"
    
    //ScheduleTimeView
    static let Tscheduledateandtime = "SCHEDULE YOUR DATE AND TIME"
    static let TDate = "CHOOSE DATE"
    static let TTime = "CHOOSE TIME"
    static let TSchedule = "SCHEDULE"
    static let TItems = "items"
    static let Pwallet = "wallet"
    static let Pleave_at_door = "leave_at_door"
    
    //XIB
    static let HomeBannerView = "HomeBannerView"
    static let HomeBannerCollectionViewCell = "HomeBannerCollectionViewCell"
    static let RestaurantTableViewCell = "RestaurantTableViewCell"
    static let FoodieSearchTableViewCell = "FoodieSearchTableViewCell"
    static let FoodieItemsTableViewCell = "FoodieItemsTableViewCell"
    static let RestaurantDetailView = "RestaurantDetailView"
    static let ViewCartView = "ViewCartView"
    static let CartpageHeaderView = "CartpageHeaderView"
    static let FoodieAddNoteView = "FoodieAddNoteView"
    static let OrderPlacePopup = "OrderPlacePopup"
    static let FoodieDeliveryView = "FoodieDeliveryView"
    static let FoodieOrderStatusTableViewCell = "FoodieOrderStatusTableViewCell"
    static let FoodieDelvieryPersonTableViewCell = "FoodieDelvieryPersonTableViewCell"
    static let FoodieOrderDetailTableViewCell = "FoodieOrderDetailTableViewCell"
    static let DeliveryChargeTableViewCell = "DeliveryChargeTableViewCell"
    static let FoodieFilterTableViewCell = "FoodieFilterTableViewCell"
    static let OrderDetailListCell = "OrderDetailListCell"
    static let OrderStatusCell = "OrderStatusCell"
    static let FoodieAddOnsCell = "FoodieAddOnsCell"
    static let FoodieAddOns = "FoodieAddOns"
    static let FoodieNavigationView = "FoodieNavigationView"
    static let ShopDetailTableViewCell = "ShopDetailTableViewCell"
    static let FoodieItemsCell = "FoodieItemsCell"
    static let CategoryListCollectionViewCell = "CategoryListCollectionViewCell"

    //Controller
    static let FoodieHomeViewController = "FoodieHomeViewController"
    static let FoodieSearchViewController = "FoodieSearchViewController"
    static let FoodieItemsViewController = "FoodieItemsViewController"
    static let FoodieCartViewController = "FoodieCartViewController"
    static let FoodieOrderStatusViewController = "FoodieOrderStatusViewController"
    static let FoodieFilterController = "FoodieFilterController"
    static let FoodieTrackingController = "FoodieTrackingController"
    static let FoodieDeliveryTableViewCell = "FoodieDeliveryTableViewCell"
    static let CartPageTableViewCell = "CartPageTableViewCell"
    static let EmptyShopTableCell = "EmptyShopTableCell"
    
    // image names
    static let ic_filter = "ic_filter"
    static let ic_calendar = "ic_calendar"
    static let ic_clock = "ic_clock"
    static let ic_cartbag = "ic_cartbag"
    static let ic_veg = "ic_veg"
    static let ic_nonveg = "ic_nonveg"
    static let ic_delivery = "ic_delivery"
    static let ic_ondway = "ic_ondway"
    static let ic_process = "ic_process"
    static let ic_downarrow = "ic_downarrow"
    static let ic_plate = "ic_plate"
    static let PRequestId = "request_id"
    static let Prating = "rating"
    static let Pcomment = "comment"
    static let Pshopid = "shopid"
    static let Pshoprating = "shoprating"
    static let ic_starfilled = "ic_starfilled"
    static let ic_resFav = "ic_resFav"
    static let imagePlaceHolder = "ImagePlaceHolder"
    static let ic_leftarrow = "ic_leftarrow"
    static let promocodeId = "promocode_id"
    static let wallet = "wallet Deduction"
    static let paymentMode = "payment_mode"
    static let userAddressId = "user_address_id"
    static let deliveryDate = "delivery_date"
    static let orderType = "order_type"
    static let cauldron = "cauldron"
    static let orderEmpty = "no_order"
    static let scooterImage = "scooter"
    static let cateringImage = "catering"
    static let deliveryBoyImage = "ic_delivery_boy"
    static let ic_offer = "ic_offer"
    static let error_coupon = "coupon"
    static let ic_delete = "delete"
    static let ic_navigation = "navigation"
    
    static let Pid = "id"
    static let PCancelReason = "cancel_reason"
    static let Pqfilter = "qfilter"

    
}


enum OrderStatus: String, CaseIterable {
    
    case process = "process"
    case ondway = "ondway"
    case delivery = "delivery"
}


struct FoodieAPI {
    
    static let storeList = "/user/store/list"
    static let storeDetail = "/user/store/details/"
    static let addCart = "/user/store/addcart"
    static let removeCart = "/user/store/removecart"
    static let cartList = "/user/store/cartlist"
    static let orderCheckout = "/user/store/checkout"
    static let showAddons = "/user/store/show-addons/1"
    static let promocode = "/user/promocode/Order"
    static let cusineList = "/user/store/cusines"
    static let orderDetail = "/user/store/order"
    static let foodieSearch = "/user/order/search"
    static let rating = "/user/store/order/rating"
    static let cancelRequest = "/user/order/cancel/request"
    
}

enum RestaurantType: String {
    case veg = "pure-veg"
    case nonveg = "non-veg"
    case freedelivery = "freedelivery"
    case all = ""
}

enum orderByType: String {
    case delivery = "DELIVERY"
    case takeAway = "TAKEAWAY"
}


enum foodieOrderStatus : String, CaseIterable {
    
    case ordered = "ORDERED"
    case processing = "PROCESSING"
    case searching = "SEARCHING"
    case accepted = "ACCEPTED"
    case started = "STARTED"
    case reached = "REACHED"
    case arrived = "ARRIVED"
    case pickedup = "PICKEDUP"
    case completed = "COMPLETED"
    case cancelled = "CANCELLED"
    case storeCancelled = "STORECANCELLED"
    case received = "RECEIVED"
    case none
    
    var index:Int {
        switch self {
        case .accepted:
            return 0
        case .processing:
            return 1
        case .started:
            return 1
        case .reached:
            return 2
        case .searching,.ordered:
            return 0
        case .pickedup:
            return 3
        case .arrived,.completed:
            return 4
        case .received:
            return 0
        default:
            return 0
        }
    }
    
    var statusStr:String {
        switch self {
        case .accepted:
            return "Order Accepted by shop"
        case .processing:
            return "Delivery Person Accepted the Order"
        case .started:
            return "Delivery Person Started Towards Shop"
        case .reached:
            return "Delivery Person reached shop"
        case .searching,.ordered:
            return "Order is been processing"
        case .pickedup:
            return "Delivery Person picked up your order"
        case .arrived,.completed:
            return "Order Delivered Successfully"
        case .received:
            return "Shop Received your Order"
        case .storeCancelled:
            return "Please Wait we are processing your Order"
        default:
            return ""
        }
    }
}
