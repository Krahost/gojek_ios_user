//
//  CourierPresenter.swift
//  GoJekUser
//
//  Created by Sudar on 17/01/20.
//  Copyright © 2020 Appoets. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class CourierPresenter: CourierViewToCourierPresenterProtocol {
    
    var courierView: CourierPresenterToCourierViewProtocol?;
    var courierInterector: CourierPresentorToCourierInterectorProtocol?;
    var courierRouter: CourierPresenterToCourierRouterProtocol?
    
    func getServiceList(coordinates: CLLocationCoordinate2D, id: Int?) {
        courierInterector?.getServiceList(coordinates: coordinates, id: id)
    }
    
    func checkCourierRequest() {
        courierInterector?.checkCourierRequest()
    }
    
    func getEstimateFare(param: Parameters) {
        courierInterector?.getEstimateFare(param: param)
    }
    
    func sendRequest(param: Parameters){
        courierInterector?.sendRequest(param: param)
    }
    func sendRequestWithImage(param: Parameters, imageData: [String:Data]) {
           
           courierInterector?.sendRequestWithImage(param: param, imageData: imageData)
           
       }
    
    func invoicePayment(param: Parameters) {
        courierInterector?.invoicePayment(param: param)
    }
      
    func ratingToProvider(param: Parameters) {
        courierInterector?.ratingToProvider(param: param)
    }
    
    func getCourierPackageList(){
        courierInterector?.getCourierPackageList()
    }
    func getReasons(param: Parameters) {
        courierInterector?.getReasons(param: param)
    }
    
    func getDeliveryList(){
      courierInterector?.getDeliveryList()
    }
    func cancelRequest(param: Parameters) {
        courierInterector?.cancelRequest(param: param)
    }
}

extension CourierPresenter: CourierInterectorToCourierPresenterProtocol {
    func getReasonsResponse(reasonEntity: ReasonEntity) {
          courierView?.getReasonsResponse(reasonEntity: reasonEntity)
      }
    func cancelRequestSuccess(requestEntity: Request) {
        courierView?.cancelRequestSuccess(requestEntity: requestEntity)
    }
    
    func courierDeliveryTypeListSuccess(requestEntity: CourierPackagesList){
         courierView?.courierDeliveryTypeListSuccess(requestEntity: requestEntity)
    }
   
    func courierPackageListSuccess(requestEntity: CourierPackagesList) {
        courierView?.courierPackageListSuccess(requestEntity: requestEntity)
    }
    
    func invoicePaymentSuccess(requestEntity: Request) {
        courierView?.invoicePaymentSuccess(requestEntity: requestEntity)
    }
    
    func ratingToProviderSuccess(requestEntity: Request) {
        courierView?.ratingToProviderSuccess(requestEntity: requestEntity)
    }
    
    func sendRequestSuccess(requestEntity: Request){
        courierView?.sendRequestSuccess(requestEntity: requestEntity)
    }
        
    func getEstimateFareResponse(estimateEntity: CourierEstimateEntity){
        courierView?.getEstimateFareResponse(estimateEntity: estimateEntity)
    }
    
    func getServiceList(serviceEntity: ServiceListEntity) {
        courierView?.getServiceList(serviceEntity: serviceEntity)
    }
    
    func checkCourierRequest(requestEntity: Request) {
     courierView?.checkCourierRequest(requestEntity: requestEntity)
    }
    
    //Failure response
    func failureResponse(failureData: Data) {
        courierView?.failureResponse(failureData: failureData)
    }
}

