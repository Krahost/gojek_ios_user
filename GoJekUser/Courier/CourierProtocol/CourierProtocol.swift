//
//  CourierProtocol.swift
//  GoJekUser
//
//  Created by Sudar on 17/01/20.
//  Copyright © 2020 Appoets. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation

var courierPresenterObject: CourierViewToCourierPresenterProtocol?

//MARK:- Courier presenter to Courier viewcontroller
//Backward process
protocol CourierPresenterToCourierViewProtocol: class {
    
    func getServiceList(serviceEntity: ServiceListEntity)
    func checkCourierRequest(requestEntity: Request)
    func getEstimateFareResponse(estimateEntity: CourierEstimateEntity)
    func sendRequestSuccess(requestEntity: Request)
    func invoicePaymentSuccess(requestEntity: Request)
    func ratingToProviderSuccess(requestEntity: Request)
    func courierPackageListSuccess(requestEntity: CourierPackagesList)
    func courierDeliveryTypeListSuccess(requestEntity: CourierPackagesList)
    func cancelRequestSuccess(requestEntity: Request)
    func getReasonsResponse(reasonEntity: ReasonEntity)
    
    //Failure response
    func failureResponse(failureData: Data)
}

extension CourierPresenterToCourierViewProtocol {
    
    var courierPresenter: CourierViewToCourierPresenterProtocol? {
        get {
            courierPresenterObject?.courierView = self
            return courierPresenterObject
        }
        set(newValue) {
            courierPresenterObject = newValue
        }
    }
    
    func getServiceList(serviceEntity: ServiceListEntity) {return}
    func checkCourierRequest(requestEntity: Request) {return}
    func getEstimateFareResponse(estimateEntity: CourierEstimateEntity) {return}
    func sendRequestSuccess(requestEntity: Request){return}
    func invoicePaymentSuccess(requestEntity: Request){return}
    func ratingToProviderSuccess(requestEntity: Request){return}
    func courierPackageListSuccess(requestEntity: CourierPackagesList){return}
    func courierDeliveryTypeListSuccess(requestEntity: CourierPackagesList){return}
    func cancelRequestSuccess(requestEntity: Request){return}
    func getReasonsResponse(reasonEntity: ReasonEntity){return}

    
    //Failure response
    func failureResponse(failureData: Data) { return }
}

//MARK:- Courier interector to Courier presenter
//Backward process
protocol CourierInterectorToCourierPresenterProtocol: class {
    

    func getServiceList(serviceEntity: ServiceListEntity)
    func checkCourierRequest(requestEntity: Request)
    func getEstimateFareResponse(estimateEntity: CourierEstimateEntity)
    func sendRequestSuccess(requestEntity: Request)
    func invoicePaymentSuccess(requestEntity: Request)
    func ratingToProviderSuccess(requestEntity: Request)
    func courierPackageListSuccess(requestEntity: CourierPackagesList)
    func courierDeliveryTypeListSuccess(requestEntity: CourierPackagesList)
    func cancelRequestSuccess(requestEntity: Request)
    func getReasonsResponse(reasonEntity: ReasonEntity)

    
    //Failure response
    func failureResponse(failureData: Data)
}

//MARK:- Courier presenter to Courier interector
//Forward process
protocol CourierPresentorToCourierInterectorProtocol: class {
    
    
    
    var courierPresenter: CourierInterectorToCourierPresenterProtocol? {get set}
    
    func getServiceList(coordinates:CLLocationCoordinate2D,id:Int?)
    func checkCourierRequest()
    func getEstimateFare(param: Parameters)
    func sendRequest(param: Parameters)
    func sendRequestWithImage(param:Parameters,imageData : [String:Data] )
    func invoicePayment(param: Parameters)
    func ratingToProvider(param: Parameters)
    func cancelRequest(param: Parameters)
    func getCourierPackageList()
    func getDeliveryList()
    func getReasons(param: Parameters)

}

//MARK:- Courier view to Courier presenter
//Forward process
protocol CourierViewToCourierPresenterProtocol: class {
    
    
    
    var courierView: CourierPresenterToCourierViewProtocol? {get set}
    var courierInterector: CourierPresentorToCourierInterectorProtocol? {get set}
    var courierRouter: CourierPresenterToCourierRouterProtocol? {get set}
    
    func getServiceList(coordinates:CLLocationCoordinate2D,id:Int?)
    func checkCourierRequest()
    func getEstimateFare(param: Parameters)
    func sendRequest(param: Parameters)
    func sendRequestWithImage(param:Parameters,imageData : [String:Data] )
    func invoicePayment(param: Parameters)
    func ratingToProvider(param: Parameters)
    func cancelRequest(param: Parameters)
    func getCourierPackageList()
    func getDeliveryList()
    func getReasons(param: Parameters)
    
}

//MARK:- Courier presenter to Courier router
//Forward process
protocol CourierPresenterToCourierRouterProtocol: class {
    
    static func createCourierModule() -> UIViewController
}
