//
//  OrdersProtocol.swift
//  GoJekUser
//
//  Created by apple on 20/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

var ordersPresenterObject: OrderViewToOrderPresenterProtocol?
// MARK:- Order Presenter to Order View Protocol

protocol OrderPresenterToOrderViewProtocol: class {
    
    func getOrder(orderHistoryEntity: OrdersEntity)
    func getOrderDetail(orderDetailEntity: OrderDetailEntity)
    func getDisputeList(disputeList: DisputeListEntity)
    func addDispute(disputeEntity: SuccessEntity)
    func addLostItem(disputeEntity: SuccessEntity)
    func getUpcoming(upcomingEntity: OrdersEntity)
    func getUpcomingDetail(upcomingEntity: OrderDetailEntity)
    func getReasons(reasonEntity: ReasonEntity)
    func getCancelRequest(reasonEntity: SuccessEntity)
    func getFoodieOrderList(foodieEntity: FoodieHistoryEntity)
}

extension OrderPresenterToOrderViewProtocol {
    var ordersPresenter: OrderViewToOrderPresenterProtocol? {
        get {
            ordersPresenterObject?.orderView = self
            return ordersPresenterObject
        }
        set(newValue) {
            ordersPresenterObject = newValue
        }
    }
    func getOrder(orderHistoryEntity: OrdersEntity) { return }
    func getOrderDetail(orderDetailEntity: OrderDetailEntity) { return }
    func getDisputeList(disputeList: DisputeListEntity)  { return }
    func addDispute(disputeEntity: SuccessEntity) { return }
    func addLostItem(disputeEntity: SuccessEntity) { return }
    func getUpcoming(upcomingEntity: OrdersEntity) { return }
    func getUpcomingDetail(upcomingEntity: OrderDetailEntity) { return }
    func getReasons(reasonEntity: ReasonEntity) { return }
    func getCancelRequest(reasonEntity: SuccessEntity) { return }
    func getFoodieOrderList(foodieEntity: FoodieHistoryEntity) { return }
}

//MARK:- Notification Interactor to Notification Presenter Protocol

protocol OrderInteractorToOrderPresenterProtocol: class {
    func getOrder(orderHistoryEntity: OrdersEntity)
    func getOrderDetail(orderDetailEntity: OrderDetailEntity)
    func getDisputeList(disputeList: DisputeListEntity)
    func addDispute(disputeEntity: SuccessEntity)
    func addLostItem(disputeEntity: SuccessEntity)
    func getUpcoming(upcomingEntity: OrdersEntity)
    func getUpcomingDetail(upcomingEntity: OrderDetailEntity)
    func getReasons(reasonEntity: ReasonEntity)
    func getCancelRequest(reasonEntity: SuccessEntity)
    func getFoodieOrderList(foodieEntity: FoodieHistoryEntity)
}


//MARK:- Notification Presenter To Notification Interactor Protocol

protocol OrderPresenterToOrderInteractorProtocol: class{
    
    var orderPresenter: OrderInteractorToOrderPresenterProtocol? { get set }
    
    func getOrder(isHideLoader: Bool,serviceType:ServiceType,parameter: Parameters)
    func getOrderDetail(id:String,type:String)
    func getDisputeList(type:String)
    func addDispute(param: Parameters,type:ServiceType)
    func addLostItem(param: Parameters)
    func getUpcoming(isHideLoader: Bool,serviceType:ServiceType,parameter: Parameters)
    func getUpcomingDetail(id:String,type:String)
    func getReasons(param: Parameters)
    func cancelRequest(param: Parameters,type:String)
    func getFoodieOrderList(isHideLoader: Bool,serviceType:ServiceType,parameter: Parameters)
}

//MARK:- Notification View To Notification Presenter Protocol

protocol OrderViewToOrderPresenterProtocol: class {
    
    var orderView: OrderPresenterToOrderViewProtocol? { get set }
    var orderInteractor: OrderPresenterToOrderInteractorProtocol? { get set }
    var orderRouter: OrderPresenterToOrderRouterProtocol? { get set }
    
    func getOrder(isHideLoader: Bool,serviceType:ServiceType,parameter: Parameters)
    func getOrderDetail(id:String,type:String)
    func getDisputeList(type:String)
    func addDispute(param: Parameters,type:ServiceType)
    func addLostItem(param: Parameters)
    func getUpcoming(isHideLoader: Bool,serviceType:ServiceType,parameter: Parameters)
    func getUpcomingDetail(id:String,type:String)
    func getReasons(param: Parameters)
    func cancelRequest(param: Parameters,type:String)
    func getFoodieOrderList(isHideLoader: Bool,serviceType:ServiceType,parameter: Parameters)
    
}

//MARK:- Notification Presenter To Notification Router Protocol

protocol OrderPresenterToOrderRouterProtocol: class {
    
}


