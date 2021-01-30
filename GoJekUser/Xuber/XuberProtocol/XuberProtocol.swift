//
//  XuberProtocol.swift
//  GoJekUser
//
//  Created by apple on 20/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

import UIKit
import Alamofire

var xuberPresenterObject: XuberViewToXuberPresenterProtocol?

//MARK:- Xuber presenter to Xuber viewcontroller
//Backward process
protocol XuberPresenterToXuberViewProtocol: class {
    
    func getSubCategory(subCategoryEntity: XuberSubCategoryEntity)
    func getSavedAddress(addressEntity: SavedAddressEntity)
    func getProviderList(providerListEntity: XuberProviderEntity)
    func getServiceList(serviceEntity: XuberServiceEntity)
    func getProviderReview(reviewEntity: XuberProviderReviewEntity)
    func getReasons(reasonEntity: ReasonEntity)
    func getCancelRequest(cancelEntity: SuccessEntity)
    func getCancelError(response: Any)
    func getRating(ratingEntity: SuccessEntity)
    func sendRequest(requestEntity: XuberRequestEntity)
    func getPromocode(promocodeEntity:PromocodeEntity)
    func getUpdatePayment(paymentEntity:SuccessEntity)
    func nonCashPayment(paymentEntity:SuccessEntity)
    func xuberCheckRequest(request: XuberRequestEntity)
}

extension XuberPresenterToXuberViewProtocol {
    
    var xuberPresenter: XuberViewToXuberPresenterProtocol? {
        get {
            xuberPresenterObject?.xuberView = self
            return xuberPresenterObject
        }
        set(newValue) {
            xuberPresenterObject = newValue
        }
    }
    
    func getSubCategory(subCategoryEntity: XuberSubCategoryEntity) { return }
    func getSavedAddress(addressEntity: SavedAddressEntity) { return }
    func getProviderList(providerListEntity: XuberProviderEntity) { return }
    func getServiceList(serviceEntity: XuberServiceEntity) { return }
    func getProviderReview(reviewEntity: XuberProviderReviewEntity) { return }
    func getReasons(reasonEntity: ReasonEntity) { return }
    func getCancelRequest(cancelEntity: SuccessEntity) { return }
    func getCancelError(response: Any) { return }
    func getRating(ratingEntity: SuccessEntity) { return }
    func sendRequest(requestEntity: XuberRequestEntity) { return }
    func getPromocode(promocodeEntity:PromocodeEntity)  { return }
    func getUpdatePayment(paymentEntity:SuccessEntity) { return }
    func nonCashPayment(paymentEntity:SuccessEntity) { return }
    func xuberCheckRequest(request: XuberRequestEntity) { return }
}

//MARK:- Xuber interector to Xuber presenter
//Backward process
protocol XuberInterectorToXuberPresenterProtocol: class {
    
    func getSubCategory(subCategoryEntity: XuberSubCategoryEntity)
    func getSavedAddress(addressEntity: SavedAddressEntity)
    func getProviderList(providerListEntity: XuberProviderEntity)
    func getServiceList(serviceEntity: XuberServiceEntity)
    func getProviderReview(reviewEntity: XuberProviderReviewEntity)
    func getReasons(reasonEntity: ReasonEntity)
    func getCancelRequest(cancelEntity: SuccessEntity)
    func getCancelError(response: Any)
    func getRating(ratingEntity: SuccessEntity)
    func sendRequest(requestEntity: XuberRequestEntity)
    func getPromocode(promocodeEntity:PromocodeEntity)
    func getUpdatePayment(paymentEntity:SuccessEntity)
    func nonCashPayment(paymentEntity:SuccessEntity)
    func xuberCheckRequest(request: XuberRequestEntity)
}

//MARK:- Xuber presenter to Xuber interector
//Forward process
protocol XuberPresentorToXuberInterectorProtocol: class {
    var xuberPresenter: XuberInterectorToXuberPresenterProtocol? {get set}
    
    func getSubCategory(id: String,param: Parameters)
    func getSavedAddress()
    func getProviderList(param: Parameters)
    func getServiceList(id: String, mainId: String, param: Parameters)
    func getProviderReview(id: String,pageNo: String)
    func getReasons(param: Parameters)
    func cancelRequest(param: Parameters)
    func getRating(param: Parameters)
    func sendRequest(param: Parameters,imageData:[String:Data]?)
    func getPromocode(param: Parameters)
    func updatePayment(param: Parameters)
    func nonCashPayment(param: Parameters)
    func getRequest()
}

//MARK:- Xuber view to Xuber presenter
//Forward process
protocol XuberViewToXuberPresenterProtocol: class {
    var xuberView: XuberPresenterToXuberViewProtocol? {get set}
    var xuberInterector: XuberPresentorToXuberInterectorProtocol? {get set}
    var xuberRouter: XuberPresenterToXuberRouterProtocol? {get set}
    
    func getSubCategory(id: String,param: Parameters)
    func getSavedAddress()
    func getProviderList(param: Parameters)
    func getServiceList(id: String, mainId: String, param: Parameters)
    func getProviderReview(id: String,pageNo: String)
    func getReasons(param: Parameters)
    func cancelRequest(param: Parameters)
    func getRating(param: Parameters)
    func sendRequest(param: Parameters,imageData:[String:Data]?)
    func getPromocode(param: Parameters)
    func updatePayment(param: Parameters)
    func nonCashPayment(param: Parameters)
    func getRequest()
}

//MARK:- Xuber presenter to Xuber router
//Forward process
protocol XuberPresenterToXuberRouterProtocol {
    static func createXuberModule(isChat: Bool) -> UIViewController
}

