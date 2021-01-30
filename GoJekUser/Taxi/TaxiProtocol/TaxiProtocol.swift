//
//  TaxiProtocol.swift
//  GoJekUser
//
//  Created by apple on 20/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

var taxiPresenterObject: TaxiViewToTaxiPresenterProtocol?

//MARK:- Taxi presenter to Taxi viewcontroller
//Backward process
protocol TaxiPresenterToTaxiViewProtocol: class {
    
    func getServiceList(serviceEntity: ServiceListEntity)
    func getEstimateFareResponse(estimateEntity: EstimateFareEntity)
    func sendRequestSuccess(requestEntity: Request)
    func cancelRequestSuccess(requestEntity: Request)
    func invoicePaymentSuccess(requestEntity: Request)
    func ratingToProviderSuccess(requestEntity: Request)
    func updatePaymentSuccess(requestEntity: Request)
    func getReasonsResponse(reasonEntity: ReasonEntity)
    func extendTripSuccess(requestEntity: Request)
    func checkTaxiRequest(requestEntity: Request)
    //Failure response
    func failureResponse(failureData: Data)
}

extension TaxiPresenterToTaxiViewProtocol {
    
    var taxiPresenter: TaxiViewToTaxiPresenterProtocol? {
        get {
            taxiPresenterObject?.taxiView = self
            return taxiPresenterObject
        }
        set(newValue) {
            taxiPresenterObject = newValue
        }
    }
    
    func getServiceList(serviceEntity: ServiceListEntity) { return }
    func getEstimateFareResponse(estimateEntity: EstimateFareEntity) { return }
    func sendRequestSuccess(requestEntity: Request) { return }
    func cancelRequestSuccess(requestEntity: Request) { return }
    func invoicePaymentSuccess(requestEntity: Request) { return }
    func ratingToProviderSuccess(requestEntity: Request) { return }
    func updatePaymentSuccess(requestEntity: Request) { return }
    func getReasonsResponse(reasonEntity: ReasonEntity) { return }
    func extendTripSuccess(requestEntity: Request) { return }
    func checkTaxiRequest(requestEntity: Request) { return }
    
    //Failure response
    func failureResponse(failureData: Data) { return }
}

//MARK:- Taxi interector to Taxi presenter
//Backward process
protocol TaxiInterectorToTaxiPresenterProtocol: class {
    
    func getServiceList(serviceEntity: ServiceListEntity)
    func getEstimateFareResponse(estimateEntity: EstimateFareEntity)
    func sendRequestSuccess(requestEntity: Request)
    func cancelRequestSuccess(requestEntity: Request)
    func invoicePaymentSuccess(requestEntity: Request)
    func ratingToProviderSuccess(requestEntity: Request)
    func updatePaymentSuccess(requestEntity: Request)
    func getReasonsResponse(reasonEntity: ReasonEntity)
    func extendTripSuccess(requestEntity: Request)
    func checkTaxiRequest(requestEntity: Request)
    
    //Failure response
    func failureResponse(failureData: Data)
}

//MARK:- Taxi presenter to Taxi interector
//Forward process
protocol TaxiPresentorToTaxiInterectorProtocol: class {
    var taxiPresenter: TaxiInterectorToTaxiPresenterProtocol? {get set}
    
    func getServiceList(param: Parameters)
    func getEstimateFare(param: Parameters)
    func sendRequest(param: Parameters)
    func cancelRequest(param: Parameters)
    func invoicePayment(param: Parameters)
    func ratingToProvider(param: Parameters)
    func updatePayment(param: Parameters)
    func getReasons(param: Parameters)
    func extendTrip(param: Parameters)
    func checkTaxiRequest()
}

//MARK:- Taxi view to Taxi presenter
//Forward process
protocol TaxiViewToTaxiPresenterProtocol: class {
    var taxiView: TaxiPresenterToTaxiViewProtocol? {get set}
    var taxiInterector: TaxiPresentorToTaxiInterectorProtocol? {get set}
    var taxiRouter: TaxiPresenterToTaxiRouterProtocol? {get set}
    
    func getServiceList(param: Parameters)
    func getEstimateFare(param: Parameters)
    func sendRequest(param: Parameters)
    func cancelRequest(param: Parameters)
    func invoicePayment(param: Parameters)
    func ratingToProvider(param: Parameters)
    func updatePayment(param: Parameters)
    func getReasons(param: Parameters)
    func extendTrip(param: Parameters)
    func checkTaxiRequest()
    
}

//MARK:- Taxi presenter to Taxi router
//Forward process

protocol TaxiPresenterToTaxiRouterProtocol {
    static func createTaxiModule(rideTypeId: Int?) -> UIViewController
}
