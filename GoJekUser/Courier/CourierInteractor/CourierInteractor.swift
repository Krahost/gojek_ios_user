//
//  CourierInteractor.swift
//  GoJekUser
//
//  Created by Sudar on 17/01/20.
//  Copyright © 2020 Appoets. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation

class CourierInteractor: CourierPresentorToCourierInterectorProtocol{
    //MARK:- Presenter
    var courierPresenter: CourierInterectorToCourierPresenterProtocol?
    
    func checkCourierRequest(){
        WebServices.shared.requestToApi(type: Request.self, with: CourierAPI.checkRequest, urlMethod: .get, showLoader: false, encode: URLEncoding.default) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response  = response?.value {
                self.courierPresenter?.checkCourierRequest(requestEntity: response)
            }
        }
    }
    
    func getServiceList(coordinates: CLLocationCoordinate2D, id: Int?){
        let url = "\(CourierAPI.serviceList)?type=\(id ?? 0)&latitude=\(coordinates.latitude )&longitude=\(coordinates.longitude)"
        WebServices.shared.requestToApi(type: ServiceListEntity.self, with: url, urlMethod: .get,showLoader: false, encode: URLEncoding.default) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value  {
                self.courierPresenter?.getServiceList(serviceEntity: response)
            }
        }
    }
    
    // get estimate fare
    func getEstimateFare(param: Parameters) {
        WebServices.shared.requestToApi(type: CourierEstimateEntity.self, with: CourierAPI.estimateFare, urlMethod: .post,showLoader: true, params: param) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value  {
                self.courierPresenter?.getEstimateFareResponse(estimateEntity: response)
            }
        }
    }
    
    //cancel Request
      func cancelRequest(param: Parameters) {
          WebServices.shared.requestToApi(type: Request.self, with: CourierAPI.cancelRequest, urlMethod: .post,showLoader: true, params: param) { [weak self] (response) in
              guard let self = self else {
                  return
              }
              if let response = response?.value  {
                  self.courierPresenter?.cancelRequestSuccess(requestEntity: response)
              }
              else {
                  self.courierPresenter?.failureResponse(failureData: (response?.data)!)
              }
          }
          
      }
    
    // get Cancel Reasons
    
    func getReasons(param: Parameters) {
        WebServices.shared.requestToApi(type: ReasonEntity.self, with: OrderAPI.getReason, urlMethod: .get, showLoader: true, params: param, encode : URLEncoding.default) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
               self.courierPresenter?.getReasonsResponse(reasonEntity: response)
            }
        }
    }
    
    
    // Send Request
    func sendRequest(param: Parameters) {
        
        WebServices.shared.requestToApi(type: Request.self, with: CourierAPI.sendRequest, urlMethod: .post, showLoader: true, params: param) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value  {
                self.courierPresenter?.sendRequestSuccess(requestEntity: response)
            }
        }
    }
        
    // invoice payment
    func invoicePayment(param: Parameters) {
        
        WebServices.shared.requestToApi(type: Request.self, with: CourierAPI.invoicePayment, urlMethod: .post,showLoader: true, params: param) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value  {
                self.courierPresenter?.invoicePaymentSuccess(requestEntity: response)
            }
        }
    }
    
    //Rate to provider
    func ratingToProvider(param: Parameters) {
        WebServices.shared.requestToApi(type: Request.self, with: CourierAPI.rateProvider, urlMethod: .post,showLoader: true, params: param) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value  {
                self.courierPresenter?.ratingToProviderSuccess(requestEntity: response)
            }
        }
    }
    
    func getCourierPackageList(){
        WebServices.shared.requestToApi(type: CourierPackagesList.self, with: CourierAPI.packageList, urlMethod: .get, showLoader: true, encode: URLEncoding.default) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response  = response?.value {
                self.courierPresenter?.courierPackageListSuccess(requestEntity: response)
            }
        }
    }
    
    func getDeliveryList(){
        WebServices.shared.requestToApi(type: CourierPackagesList.self, with: CourierAPI.deliveryTypeList, urlMethod: .get, showLoader: true, encode: URLEncoding.default) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response  = response?.value {
                self.courierPresenter?.courierDeliveryTypeListSuccess(requestEntity: response)
            }
        }
    }
    
    func sendRequestWithImage(param: Parameters, imageData: [String : Data]) {
        WebServices.shared.requestToImageUpload(type: Request.self, with:CourierAPI.sendRequest, imageData: imageData, showLoader: true, params: param, accessTokenAdd: true) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let responseValue = response?.value
            {
                self.courierPresenter?.sendRequestSuccess(requestEntity: responseValue)
                
            }
        }
    }
}
