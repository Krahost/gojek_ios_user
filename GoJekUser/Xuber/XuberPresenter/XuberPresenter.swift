//
//  XuberPresenter.swift
//  GoJekUser
//
//  Created by apple on 20/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

class XuberPresenter: XuberViewToXuberPresenterProtocol {
    
    var xuberView: XuberPresenterToXuberViewProtocol?;
    var xuberInterector: XuberPresentorToXuberInterectorProtocol?;
    var xuberRouter: XuberPresenterToXuberRouterProtocol?
    
    
    func getSubCategory(id: String,param: Parameters) {
        xuberInterector?.getSubCategory(id: id, param: param)
    }
    
    func getSavedAddress() {
        xuberInterector?.getSavedAddress()
    }
    
    func getProviderList(param: Parameters) {
        xuberInterector?.getProviderList(param: param)
    }
    
    func getServiceList(id: String,mainId: String, param: Parameters) {
        xuberInterector?.getServiceList(id: id,mainId: mainId, param: param)
    }
    
    func getProviderReview(id: String,pageNo: String) {
        xuberInterector?.getProviderReview(id: id,pageNo: pageNo)
    }
    
    func getReasons(param: Parameters) {
        xuberInterector?.getReasons(param: param)
    }
    
    func cancelRequest(param: Parameters) {
        xuberInterector?.cancelRequest(param: param)
    }
    
    func getRating(param: Parameters) {
        xuberInterector?.getRating(param: param)
    }
    
    func sendRequest(param: Parameters,imageData:[String:Data]?) {
        xuberInterector?.sendRequest(param: param, imageData:imageData)
    }
    
    func getPromocode(param: Parameters) {
        xuberInterector?.getPromocode(param: param)
    }
    
    func updatePayment(param: Parameters) {
        xuberInterector?.updatePayment(param: param)
    }
    
    func nonCashPayment(param: Parameters) {
        xuberInterector?.nonCashPayment(param: param)
    }
    
    func getRequest() {
        xuberInterector?.getRequest()
    }
}

extension XuberPresenter: XuberInterectorToXuberPresenterProtocol {
    
    func getSubCategory(subCategoryEntity: XuberSubCategoryEntity) {
        xuberView?.getSubCategory(subCategoryEntity: subCategoryEntity)
    }
    
    func getSavedAddress(addressEntity: SavedAddressEntity) {
        xuberView?.getSavedAddress(addressEntity: addressEntity)
    }
    
    func getProviderList(providerListEntity: XuberProviderEntity) {
        xuberView?.getProviderList(providerListEntity: providerListEntity)
    }
    
    func getServiceList(serviceEntity: XuberServiceEntity) {
        xuberView?.getServiceList(serviceEntity: serviceEntity)
    }
    
    func getProviderReview(reviewEntity: XuberProviderReviewEntity) {
        xuberView?.getProviderReview(reviewEntity: reviewEntity)
    }
    
    func getReasons(reasonEntity: ReasonEntity) {
        xuberView?.getReasons(reasonEntity: reasonEntity)
    }
    
    func getCancelRequest(cancelEntity: SuccessEntity) {
        xuberView?.getCancelRequest(cancelEntity: cancelEntity)
    }
    
    func getRating(ratingEntity: SuccessEntity) {
        xuberView?.getRating(ratingEntity: ratingEntity)
    }
    
    func sendRequest(requestEntity: XuberRequestEntity) {
        xuberView?.sendRequest(requestEntity: requestEntity)
    }
    
    func getPromocode(promocodeEntity: PromocodeEntity) {
        xuberView?.getPromocode(promocodeEntity: promocodeEntity)
    }
    
    func getUpdatePayment(paymentEntity: SuccessEntity) {
        xuberView?.getUpdatePayment(paymentEntity: paymentEntity)
    }
    
    func nonCashPayment(paymentEntity: SuccessEntity) {
        xuberView?.nonCashPayment(paymentEntity: paymentEntity)
    }
    
    func xuberCheckRequest(request: XuberRequestEntity) {
        xuberView?.xuberCheckRequest(request: request)
    }
    func getCancelError(response: Any) {
        xuberView?.getCancelError(response: response)
    }
}
