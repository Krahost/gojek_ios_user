//
//  OrdersInteractor.swift
//  GoJekUser
//
//  Created by apple on 20/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

class OrderInteractor: OrderPresenterToOrderInteractorProtocol {
    
    var orderPresenter: OrderInteractorToOrderPresenterProtocol?
    
    func getOrder(isHideLoader: Bool,serviceType:ServiceType, parameter: Parameters) {
        let url = OrderAPI.getOrderHistory+"/"+serviceType.currentType
        WebServices.shared.requestToApi(type: OrdersEntity.self, with: url, urlMethod: .get, showLoader: isHideLoader,params:parameter,encode : URLEncoding.default) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.orderPresenter?.getOrder(orderHistoryEntity: response)
            }
        }
    }
    
    func getOrderDetail(id: String,type: String) {
        WebServices.shared.requestToApi(type: OrderDetailEntity.self, with: OrderAPI.getOrderHistory+"/"+type+"/"+id, urlMethod: .get, showLoader: true, encode: URLEncoding.default) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.orderPresenter?.getOrderDetail(orderDetailEntity: response)
            }
        }
    }
    
    func getDisputeList(type:String) {
        let url = OrderAPI.getDisputeList + type + OrderConstant.Pdispute 
        WebServices.shared.requestToApi(type: DisputeListEntity.self, with: url, urlMethod: .get, showLoader: true, encode: URLEncoding.default) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.orderPresenter?.getDisputeList(disputeList: response)
            }
        }
    }
    
    func addDispute(param: Parameters,type:ServiceType) {
        var url = ""
        if type == .trips {
            url = OrderAPI.addDispute
        }else if type == .orders {
            url = OrderAPI.addDisputeOrder
        }else if type == .delivery {
            url = OrderAPI.addDisputeDelivery
        }else{
            url = OrderAPI.addDisputeService
        }
        WebServices.shared.requestToApi(type: SuccessEntity.self, with: url, urlMethod: .post, showLoader: true, params:  param) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.orderPresenter?.addDispute(disputeEntity: response)
            }
        }
    }
    
    func addLostItem(param: Parameters) {
        WebServices.shared.requestToApi(type: SuccessEntity.self, with: OrderAPI.addLostItem, urlMethod: .post, showLoader: true, params:  param) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.orderPresenter?.addLostItem(disputeEntity: response)
            }
        }
    }
    
    func getUpcoming(isHideLoader: Bool, serviceType: ServiceType, parameter: Parameters) {
        let url = OrderAPI.getOrderHistory+"/"+serviceType.currentType
        WebServices.shared.requestToApi(type: OrdersEntity.self, with: url, urlMethod: .get, showLoader: isHideLoader,params:parameter,encode : URLEncoding.default) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.orderPresenter?.getUpcoming(upcomingEntity: response)
            }
        }
    }
    
    func getUpcomingDetail(id: String, type: String) {
        WebServices.shared.requestToApi(type: OrderDetailEntity.self, with: OrderAPI.upcomingDetail+type+"/"+id, urlMethod: .get, showLoader: true, encode: URLEncoding.default) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.orderPresenter?.getUpcomingDetail(upcomingEntity: response)
            }
        }
    }
    
    func getReasons(param: Parameters) {
        WebServices.shared.requestToApi(type: ReasonEntity.self, with: OrderAPI.getReason, urlMethod: .get, showLoader: true,params: param, encode: URLEncoding.default) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.orderPresenter?.getReasons(reasonEntity: response)
            }
        }
    }
    
    func cancelRequest(param: Parameters,type:String) {
        let url = "/user/" + type + "/cancel/request"
        WebServices.shared.requestToApi(type: SuccessEntity.self, with: url, urlMethod: .post, showLoader: true, params:  param) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.orderPresenter?.getCancelRequest(reasonEntity: response)
            }
        }
    }
    
    func getFoodieOrderList(isHideLoader: Bool, serviceType: ServiceType, parameter: Parameters) {
        let url = OrderAPI.getOrderHistory+"/"+serviceType.currentType
        WebServices.shared.requestToApi(type: FoodieHistoryEntity.self, with: url, urlMethod: .get, showLoader: isHideLoader,params:parameter,encode : URLEncoding.default) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.orderPresenter?.getFoodieOrderList(foodieEntity: response)
            }
        }
    }
}

