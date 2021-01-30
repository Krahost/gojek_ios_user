//
//  TaxiInteractor.swift
//  GoJekUser
//
//  Created by apple on 20/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

class TaxiInteractor: TaxiPresentorToTaxiInterectorProtocol {
    
    //MARK:- Presenter
    var taxiPresenter: TaxiInterectorToTaxiPresenterProtocol?
    
    func checkTaxiRequest() {
        
        WebServices.shared.requestToApi(type: Request.self, with: TaxiAPI.checkRequest, urlMethod: .get, showLoader: false, encode: URLEncoding.default) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response  = response?.value {
                self.taxiPresenter?.checkTaxiRequest(requestEntity: response)
            }
        }
    }
   
    func getServiceList(id: String) {
        WebServices.shared.requestToApi(type: ServiceListEntity.self, with: TaxiAPI.serviceList+"/"+id, urlMethod: .get,showLoader: false, encode: URLEncoding.default) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value  {
                self.taxiPresenter?.getServiceList(serviceEntity: response)
            }
        }
    }
    
    
    func getServiceList(param: Parameters) {
      
        WebServices.shared.requestToApi(type: ServiceListEntity.self, with: TaxiAPI.serviceList, urlMethod: .get,showLoader: false, params: param, encode: URLEncoding.default) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value  {
                self.taxiPresenter?.getServiceList(serviceEntity: response)
            }
        }
    }
    
    // get estimate fare
    func getEstimateFare(param: Parameters) {
        WebServices.shared.requestToApi(type: EstimateFareEntity.self, with: TaxiAPI.estimateFare, urlMethod: .post,showLoader: true, params: param) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value  {
                self.taxiPresenter?.getEstimateFareResponse(estimateEntity: response)
            }
        }
    }
    
    // Send Request
    func sendRequest(param: Parameters) {
        
        WebServices.shared.requestToApi(type: Request.self, with: TaxiAPI.sendRequest, urlMethod: .post, showLoader: true, params: param) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value  {
                self.taxiPresenter?.sendRequestSuccess(requestEntity: response)
            }
        }
    }
    
    //Check Request
    func cancelRequest(param: Parameters) {
        WebServices.shared.requestToApi(type: Request.self, with: TaxiAPI.cancelRequest, urlMethod: .post,showLoader: true, params: param) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value  {
                self.taxiPresenter?.cancelRequestSuccess(requestEntity: response)
            }
            else {
                self.taxiPresenter?.failureResponse(failureData: (response?.data)!)
            }
        }
        
    }
    
    // invoice payment
    func invoicePayment(param: Parameters) {
        
        WebServices.shared.requestToApi(type: Request.self, with: TaxiAPI.invoicePayment, urlMethod: .post,showLoader: true, params: param) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value  {
                self.taxiPresenter?.invoicePaymentSuccess(requestEntity: response)
            }
        }
    }
    
    //Rate to provider
    
    func ratingToProvider(param: Parameters) {
        
        WebServices.shared.requestToApi(type: Request.self, with: TaxiAPI.rateProvider, urlMethod: .post,showLoader: true, params: param) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value  {
                self.taxiPresenter?.ratingToProviderSuccess(requestEntity: response)
            }
        }
    }
    
    // update payment in invoice
    func updatePayment(param: Parameters) {
        
        WebServices.shared.requestToApi(type: Request.self, with: TaxiAPI.updatePayment, urlMethod: .post,showLoader: false, params: param) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value  {
                self.taxiPresenter?.updatePaymentSuccess(requestEntity: response)
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
               self.taxiPresenter?.getReasonsResponse(reasonEntity: response)
            }
        }
    }
    
    // extendTrip
    
    func extendTrip(param: Parameters) {
        WebServices.shared.requestToApi(type: Request.self, with: TaxiAPI.extendTrip, urlMethod: .post,showLoader: false, params: param) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value  {
                self.taxiPresenter?.extendTripSuccess(requestEntity: response)
            }
        }
    }
}
