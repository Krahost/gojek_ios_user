//
//  XuberInteractor.swift
//  GoJekUser
//
//  Created by apple on 20/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

class XuberInteractor: XuberPresentorToXuberInterectorProtocol{

    //MARK:- Presenter
    var xuberPresenter: XuberInterectorToXuberPresenterProtocol?
    
    
    func getSubCategory(id: String,param: Parameters) {
        let url  = XuberAPI.getSubServiceCategory+"/"+id
        WebServices.shared.requestToApi(type: XuberSubCategoryEntity.self, with: url, urlMethod: .get,showLoader: true, params: param, encode: URLEncoding.default) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.xuberPresenter?.getSubCategory(subCategoryEntity: response)
            }
        }
    }
    
    func getSavedAddress() {
        WebServices.shared.requestToApi(type: SavedAddressEntity.self, with: XuberAPI.getAddress, urlMethod: .get, showLoader: true, encode: URLEncoding.default) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.xuberPresenter?.getSavedAddress(addressEntity: response)
            }
        }
    }
    
    func getProviderList(param: Parameters) {
        WebServices.shared.requestToApi(type: XuberProviderEntity.self, with: XuberAPI.getProviderList, urlMethod: .get, showLoader: true, params: param, encode: URLEncoding.default) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.xuberPresenter?.getProviderList(providerListEntity: response)
            }
        }
    }
    
    func getServiceList(id: String, mainId: String, param: Parameters) {
        let url  = XuberAPI.getService+"/"+mainId+"/"+id
        WebServices.shared.requestToApi(type: XuberServiceEntity.self, with: url, urlMethod: .get, showLoader: true, params: param, encode: URLEncoding.default) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.xuberPresenter?.getServiceList(serviceEntity: response)
            }
        }
    }
    
    func getProviderReview(id: String,pageNo: String) {
        let url = XuberAPI.getProviderReview+"/"+id + "?page=" + pageNo
        WebServices.shared.requestToApi(type: XuberProviderReviewEntity.self, with: url, urlMethod: .get, showLoader: true,params: nil, encode: URLEncoding.default) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.xuberPresenter?.getProviderReview(reviewEntity: response)
            }
        }
    }
    
    func getReasons(param: Parameters) {
        WebServices.shared.requestToApi(type: ReasonEntity.self, with: HomeAPI.reason, urlMethod: .get, showLoader: true,params: param, encode: URLEncoding.default) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.xuberPresenter?.getReasons(reasonEntity: response)
            }
        }
    }
    
    func cancelRequest(param: Parameters) {
        WebServices.shared.requestToApi(type: SuccessEntity.self, with: XuberAPI.cancelRequest, urlMethod: .post, showLoader: true,params: param) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.xuberPresenter?.getCancelRequest(cancelEntity: response)
            }
            else if response?.error != nil {
                self.xuberPresenter?.getCancelError(response: response as Any)
            }
        }
    }
    
    func getRating(param: Parameters) {
        WebServices.shared.requestToApi(type: SuccessEntity.self, with: XuberAPI.rating, urlMethod: .post, showLoader: true,params: param) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.xuberPresenter?.getRating(ratingEntity: response)
            }
        }
    }
    
    func sendRequest(param: Parameters, imageData:[String:Data]?) {
        WebServices.shared.requestToImageUpload(type: XuberRequestEntity.self, with: XuberAPI.sendRequest, imageData: imageData, showLoader: true,params: param) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                 self.xuberPresenter?.sendRequest(requestEntity: response)
            }
        }
    }
    
    func getPromocode(param: Parameters) {
        WebServices.shared.requestToApi(type: PromocodeEntity.self, with: XuberAPI.getPromocode, urlMethod: .get, showLoader: true,params: param, encode: URLEncoding.default) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.xuberPresenter?.getPromocode(promocodeEntity: response)
            }
        }
    }
    
    func updatePayment(param: Parameters) {
        WebServices.shared.requestToApi(type: SuccessEntity.self, with: XuberAPI.updatePayment, urlMethod: .post, showLoader: true,params: param) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.xuberPresenter?.getUpdatePayment(paymentEntity: response)
            }
        }
    }
    
    func nonCashPayment(param: Parameters) {
        WebServices.shared.requestToApi(type: SuccessEntity.self, with: XuberAPI.payment, urlMethod: .post, showLoader: true, params: param) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.xuberPresenter?.nonCashPayment(paymentEntity: response)
            }
        }
    }
    
    func getRequest() {
        WebServices.shared.requestToApi(type: XuberRequestEntity.self, with: XuberAPI.checkRequest, urlMethod: .get, showLoader: false) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.xuberPresenter?.xuberCheckRequest(request: response)
            }
        }
    }
}
