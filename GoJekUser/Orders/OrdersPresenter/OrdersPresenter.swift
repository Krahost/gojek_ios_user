//
//  OrdersPresenter.swift
//  GoJekUser
//
//  Created by apple on 20/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

class OrderPresenter: OrderViewToOrderPresenterProtocol {
    
    var orderView: OrderPresenterToOrderViewProtocol?
    
    var orderInteractor: OrderPresenterToOrderInteractorProtocol?
    
    var orderRouter: OrderPresenterToOrderRouterProtocol?
    
    
    func getOrder(isHideLoader: Bool,serviceType:ServiceType, parameter: Parameters) {
        orderInteractor?.getOrder(isHideLoader: isHideLoader,serviceType:serviceType, parameter: parameter)
    }
    
    func getOrderDetail(id: String, type: String) {
        orderInteractor?.getOrderDetail(id: id, type: type)
    }
    
    func getDisputeList(type:String) {
        orderInteractor?.getDisputeList(type: type)
    }
    func addDispute(param: Parameters,type:ServiceType) {
        orderInteractor?.addDispute(param: param,type: type)
    }
    
    func addLostItem(param: Parameters) {
        orderInteractor?.addLostItem(param: param)
    }
    
    func getUpcoming(isHideLoader: Bool, serviceType: ServiceType, parameter: Parameters) {
        orderInteractor?.getUpcoming(isHideLoader: isHideLoader, serviceType: serviceType, parameter: parameter)
    }
    
    func getUpcomingDetail(id: String, type: String) {
        orderInteractor?.getUpcomingDetail(id: id, type: type)
    }
    
    func getReasons(param: Parameters) {
        orderInteractor?.getReasons(param: param)
    }
    
    func cancelRequest(param: Parameters,type:String) {
        orderInteractor?.cancelRequest(param: param,type:type)
    }
    
    func getFoodieOrderList(isHideLoader: Bool, serviceType: ServiceType, parameter: Parameters) {
        orderInteractor?.getFoodieOrderList(isHideLoader: isHideLoader, serviceType: serviceType, parameter: parameter)
    }
    
}

extension OrderPresenter: OrderInteractorToOrderPresenterProtocol {
    
    func getOrder(orderHistoryEntity: OrdersEntity) {
        orderView?.getOrder(orderHistoryEntity: orderHistoryEntity)
    }
    func getOrderDetail(orderDetailEntity: OrderDetailEntity) {
        orderView?.getOrderDetail(orderDetailEntity: orderDetailEntity)
    }
    
    func getDisputeList(disputeList: DisputeListEntity) {
        orderView?.getDisputeList(disputeList: disputeList)
    }
    
    func addDispute(disputeEntity: SuccessEntity) {
        orderView?.addDispute(disputeEntity: disputeEntity)
    }
    
    func addLostItem(disputeEntity: SuccessEntity) {
        orderView?.addLostItem(disputeEntity: disputeEntity)
    }
    
    func getUpcoming(upcomingEntity: OrdersEntity) {
        orderView?.getUpcoming(upcomingEntity: upcomingEntity)
    }
    
    func getUpcomingDetail(upcomingEntity: OrderDetailEntity) {
        orderView?.getUpcomingDetail(upcomingEntity: upcomingEntity)
    }
    
    func getReasons(reasonEntity: ReasonEntity) {
        orderView?.getReasons(reasonEntity: reasonEntity)
    }
    
    func getCancelRequest(reasonEntity: SuccessEntity) {
        orderView?.getCancelRequest(reasonEntity: reasonEntity)
    }
    
    func getFoodieOrderList(foodieEntity: FoodieHistoryEntity) {
        orderView?.getFoodieOrderList(foodieEntity: foodieEntity)
    }
}
