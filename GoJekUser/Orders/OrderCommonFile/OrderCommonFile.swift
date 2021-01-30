//
//  OrderCommonFile.swift
//  GoJekUser
//
//  Created by apple on 22/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

enum OrderConstant {
    
    //Title
    static let history = "History"
    
    //OrderDetail
    static let source = "Source"
    static let status = "Status"
    static let destination = "Destination"
    static let paymentVia = "Payment Via"
    static let commentsfor = "Comments For "
    static let commentsforOrder = "Comments For Order"
    static let items = "Items"
    static let didyoulosesomething = "Did you lose something ?"
    static let knowLostItemStatus = "Know the Lost item status"
    static let presstheicon = "Press the icon to mention the lost item"
    static let dispute = "Dispute"
    static let disputeStatus = "Dispute Status"
    static let lostItemStatus = "Lost Item Status"
    static let viewReceipt = "View Receipt"
    static let call = "Call"
    static let cm = "CM"
    static let deliveryType = "Delivery Type"
    static let kg = "KG"
    static let cancel = "Cancel"
    static let help = "Help"
    static let height = "Height"
    static let breadth = "Breadth"
    static let packageType = "Package Type"
    static let commission = "Commission"
    static let length = "Length"
    static let weightFare = "Weight Fare"

    static let chat = "Chat"
    static let reset = "Reset"
    static let apply = "Apply"
    static let filterBy = "Filter By"
    static let trips = "Trips"
    static let orders = "Orders"
    static let service = "Services"
    static let selectType = "Please select one type"
    static let others = "Others"
    static let lostItem = "Lost Item"
    static let selectDispute = "Please select one dispute type"
    static let enterComment = "Enter your comment"
    static let you  = "You"
    static let receipt = "Receipt"
    static let receiverName = "Receiver Name"
    static let receiverMobile = "Receiver Mobile"
    static let baseFare = "Base Fare"
    static let taxFare = "Tax Fare"
    static let hourFare = "Hourly Fare"
    static let wallet = "Wallet"
    static let discountApplied = "Discount Applied"
    static let tips = "Tips"
    static let total = "Total"
    static let roundOff = "Round Off"
    static let waiting = "Waiting Time"
    static let peakCharge = "Peak Charge"
     static let itemTotal = "Item Total"
    static let taxAmount = "Tax Amount"
     static let waitingFare = "Waiting Fare"
    static let distanceFare = "Distance Fare"
    static let extraCharge = "Extra Charge"
    static let packageCharge = "Package Charge"
    static let deliveryCharge = "Delivery Charge"
    static let noComment = "No Comments"
    static let cancelled = "CANCELLED"
    static let tollCharge = "Toll Charge"
    static let Pdispute = "/dispute"
    static let itemDiscount = "Item Discount"
    static let payableAmount = "Total Payable"
    static let cardSubTotalFare = "Card Subtotal"
    static let viewDetails = "View Details"
    static let liveTrack = "Live Track"
    static let noPastOrder = "You have no Orders"
    static let noCurrentOrder = "You have no Ongoing Orders"
    static let noCurrentDelivery = "You have no Ongoing Deliveries"
    static let noPastDelivery = "You have no Deliveries"
    static let weight = "Weight"

    static let noUpComingOrder = "You have no Upcoming Orders"
    static let noPastTrip = "You have no Trips"
    static let noCurrentTrip = "You have no Ongoing Trips"
    static let noUpComingTrip = "You have no Upcoming Trips"
    static let noUpComingDelivery = "You have no Upcoming Deliveries"

    static let noPastService = "You have no Service"
    static let noCurrentService = "You have no Ongoing Service"
    static let noUpComingService = "You have no Upcoming Service"
    static let null = "null"
    
    static let past = "Past"
    static let current = "Current"
    static let upComing = "Upcoming"
    
    static let disputeCreatedMsg = "Dispute created Successfully"
    static let lostItemCreatedMsg = "Lost item created Successfully"
    static let cancelMsg = "Your trip cancelled successfully"
    //Identifier
    static let VOrderTableViewCell = "OrderTableViewCell"
    static let VFilterCollectionViewCell = "FilterCollectionViewCell"
    static let VOrdersController = "OrdersController"
    static let VOrderDetailController  = "OrderDetailController"
    static let AddCardViewController = "AddCardViewController"
    static let OrderUpcomingDetailController = "OrderUpcomingDetailController"
    static let DisputeViewController = "DisputeViewController"
    static let ViewDetailOrderCell = "ViewDetailOrderCell"
    static let ViewDetailOrderController = "ViewDetailOrderController"
    static let SourceDestinationCell = "SourceDestinationCell"
    static let SourceTableViewCell = "SourceTableViewCell"
    static let ProfileCell = "ProfileCell"
    static let DetailOrderCell = "DetailOrderCell"
    
    //CustomView
    static let DisputeLostItemView = "DisputeLostItemView"
    static let DisputeCell = "DisputeCell"
    static let DisputeReceiverCell = "DisputeReceiverCell"
    static let DisputeSenderCell = "DisputeSenderCell"
    static let DisputeStatusView = "DisputeStatusView"
    static let ReceiptView = "ReceiptView"
    
    //Image name
    static let icfilter = "ic_order_filter"
    static let alertImage = "ic_alert"
    static let helpImage = "ic_help"
    static let noHistoryImage = "ic_no_history"
    ///Parameter
    static let limit = "limit"
    static let offSet = "offset"
    static let type = "type"
    static let id = "id"
    static let dispute_type = "dispute_type"
    static let provider_id = "provider_id"
    static let dispute_name = "dispute_name"
    static let lost_item_name = "lost_item_name"
    static let reason = "reason"
    static let store_order_id = "store_id"
    static let user_id = "user_id"
    static let dispute_id = "dispute_id"
    static let PPage = "page"
    static let delivery = "Delivery"
    static let ic_dispute = "ic_dispute"
}

struct OrderAPI {
    static let getOrderHistory = "/user/trips-history"
    static let getDisputeList = "/user/"
    static let addDispute = "/user/ride/dispute"
    static let addLostItem = "/user/ride/lostitem"
    static let upcoming = "/user/upcoming/trips"
    static let upcomingDetail = "/user/trips-history/"
    static let getReason = "/user/reasons"
    static let cancelTransportRequest = "/user/transport/cancel/request"
    static let cancelServiceRequest = "/user/service/cancel/request"
    static let addDisputeOrder = "/user/order/dispute"
    static let addDisputeService = "/user/service/dispute"
    static let addDisputeDelivery = "/user/delivery/dispute"

}


enum tripStatus: String  {

    case SEARCHING = "SEARCHING"
    case CANCELLED = "CANCELLED"
    case ACCEPTED = "ACCEPTED"
    case STARTED = "STARTED"
    case ARRIVED = "ARRIVED"
    case PICKEDUP = "PICKEDUP"
    case DROPPED = "DROPPED"
    case COMPLETED = "COMPLETED"
    case SCHEDULED = "SCHEDULED"
    
    var statusString:String {
        switch self {
        case .SEARCHING:
            return "Searching"
        case .CANCELLED:
            return "Cancelled"
        case .ACCEPTED:
            return "Accepted"
        case .STARTED, .ARRIVED, .PICKEDUP, .DROPPED :
            return "On Trip"
            
        case .COMPLETED:
            return "Completed"
        default:
            return ""
        }
    }
}


enum historyType:String {
    case past = "Past"
    case ongoing = "Current"
    case upcoming = "Up Coming"
    
    var currentType: String {
        switch self {
        case .past:
            return "past"
        case .ongoing:
            return "Current"
        case .upcoming:
            return "upcoming"
        }
    }
}

enum ServiceType:String,CaseIterable {
    case trips = "Transport"
    case service = "Services"
    case orders = "Orders"
    case delivery = "Delivery"
   
    var currentType: String {
        switch self {
        case .trips:
            return "transport"
        case .orders:
            return "order"
        case .service:
            return "service"
        case .delivery:
            return "delivery"
        }
    }
}
