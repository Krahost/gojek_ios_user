//
//  TaxiPresenter.swift
//  GoJekUser
//
//  Created by apple on 20/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

class TaxiPresenter: TaxiViewToTaxiPresenterProtocol {
   
    var taxiView: TaxiPresenterToTaxiViewProtocol?
    var taxiInterector: TaxiPresentorToTaxiInterectorProtocol?
    var taxiRouter: TaxiPresenterToTaxiRouterProtocol?
    
    func getServiceList(param: Parameters) {
        taxiInterector?.getServiceList(param: param)
    }
    
    func getEstimateFare(param: Parameters) {
        taxiInterector?.getEstimateFare(param: param)
    }
    
    func sendRequest(param: Parameters) {
        taxiInterector?.sendRequest(param: param)
    }
    
    func cancelRequest(param: Parameters) {
        taxiInterector?.cancelRequest(param: param)
    }
    
    func invoicePayment(param: Parameters) {
        taxiInterector?.invoicePayment(param: param)
    }
    
    func ratingToProvider(param: Parameters) {
        taxiInterector?.ratingToProvider(param: param)
    }
    
    func updatePayment(param: Parameters) {
        taxiInterector?.updatePayment(param: param)
    }
    
    func getReasons(param: Parameters) {
        taxiInterector?.getReasons(param: param)
    }
    
    func extendTrip(param: Parameters) {
        taxiInterector?.extendTrip(param: param)
    }
    
    func checkTaxiRequest() {
        taxiInterector?.checkTaxiRequest()
    }
}

extension TaxiPresenter: TaxiInterectorToTaxiPresenterProtocol {
    
    func checkTaxiRequest(requestEntity: Request) {
        taxiView?.checkTaxiRequest(requestEntity: requestEntity)
    }
    
    func getServiceList(serviceEntity: ServiceListEntity) {
        taxiView?.getServiceList(serviceEntity: serviceEntity)
    }
    
    func getEstimateFareResponse(estimateEntity: EstimateFareEntity) {
        taxiView?.getEstimateFareResponse(estimateEntity: estimateEntity)
    }
    
    func sendRequestSuccess(requestEntity: Request) {
        taxiView?.sendRequestSuccess(requestEntity: requestEntity)
    }
    
    func cancelRequestSuccess(requestEntity: Request) {
        taxiView?.cancelRequestSuccess(requestEntity: requestEntity)
    }
    
    func invoicePaymentSuccess(requestEntity: Request) {
        taxiView?.invoicePaymentSuccess(requestEntity: requestEntity)
    }
    
    func ratingToProviderSuccess(requestEntity: Request) {
        taxiView?.ratingToProviderSuccess(requestEntity: requestEntity)
    }
    
    func updatePaymentSuccess(requestEntity: Request) {
        taxiView?.updatePaymentSuccess(requestEntity: requestEntity)
    }
    
    func getReasonsResponse(reasonEntity: ReasonEntity) {
        taxiView?.getReasonsResponse(reasonEntity: reasonEntity)
    }
    
    func extendTripSuccess(requestEntity: Request) {
        taxiView?.extendTripSuccess(requestEntity: requestEntity)
    }
    //Failure response
    func failureResponse(failureData: Data) {
        taxiView?.failureResponse(failureData: failureData)
    }
}
