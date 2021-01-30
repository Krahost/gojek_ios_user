//
//  FoodieInteractor.swift
//  GoJekUser
//
//  Created by apple on 20/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

class FoodieInteractor: FoodiePresenterToFoodieInteractorProtocol {
  
    var foodiePresenter: FoodieInteractorToFoodiePresenterProtocol?
    
    func getListOfStores(Id: Int, param: Parameters) {
        
        WebServices.shared.requestToApi(type: StoreListEntity.self, with: "\(FoodieAPI.storeList)/\(Id)", urlMethod: .get, showLoader: true, params: param,encode: URLEncoding.default) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.foodiePresenter?.getListOfStoresResponse(getStoreResponse: response)
            }
        }
    }
    
    func getStoresDetail(with Id: Int, param: Parameters) {
        
        WebServices.shared.requestToApi(type: FoodieDetailEntity.self, with: "\(FoodieAPI.storeDetail)\(Id)", urlMethod: .get, showLoader: true, params: param, encode: URLEncoding.default) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.foodiePresenter?.getStoresDetailResponse(foodieDetailEntity: response)
            }
        }
    }
    
    func postAddToCart(param: Parameters) {
        
        WebServices.shared.requestToApi(type: FoodieCartListEntity.self, with: FoodieAPI.addCart, urlMethod: .post, showLoader: true,  params: param) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.foodiePresenter?.postAddToCartResponse(addCartEntity: response)
            }
        }
    }
    
    func getCartList(param: Parameters) {
        
        WebServices.shared.requestToApi(type: FoodieCartListEntity.self, with: FoodieAPI.cartList, urlMethod: .get, showLoader: true, params: param, encode: URLEncoding.default) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.foodiePresenter?.getCartListResponse(cartListEntity: response)
            }
        }
    }
    
    func postRemoveCart(param: Parameters) {
        WebServices.shared.requestToApi(type: FoodieCartListEntity.self, with: FoodieAPI.removeCart, urlMethod: .post, showLoader: true, params: param) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.foodiePresenter?.postRemoveCartResponse(cartListEntity: response)
            }
        }
    }
    
    func postOrderCheckout(param: Parameters) {
        
        WebServices.shared.requestToApi(type: FoodieCheckoutEntity.self, with: FoodieAPI.orderCheckout, urlMethod: .post, showLoader: true,  params: param) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.foodiePresenter?.postOrderCheckoutResponse(checkoutEntity: response)
            }
        }
    }
    
    func getPromoCodeList(param: Parameters){
        WebServices.shared.requestToApi(type: PromocodeEntity.self, with: FoodieAPI.promocode, urlMethod: .get, showLoader: true, params: param, encode: URLEncoding.default) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.foodiePresenter?.getPromoCodeResponse(getPromoCodeResponse: response)
            }
        }
    }
    func searchRestaurantList(id: Int,type: String,searchStr: String,param: Parameters) {
        let url =  FoodieAPI.foodieSearch + "/" + id.toString()
        let urlString = "?q=" + searchStr + "&t=" + type
        let WeburlString = url + urlString
        WebServices.shared.requestToApi(type: SearchEntity.self, with: WeburlString, urlMethod: .get, showLoader: true, params: param, encode: URLEncoding.default) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.foodiePresenter?.searchRestaturantResponse(getSearchRestuarantResponse: response)
            }
        }
    }
    func getCusineList(Id: Int) {
        WebServices.shared.requestToApi(type: CusineListEntity.self, with: "\(FoodieAPI.cusineList)/\(Id)", urlMethod: .get, showLoader: true, encode: URLEncoding.default) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.foodiePresenter?.cusineListResponse(getCusineListResponse: response)
            }
        }
    }
  
    func getFilterRestaurant(Id: Int, filter: String, qFilter: String,param: Parameters) {
        let url =  FoodieAPI.storeList + "/" + Id.toString()
            let urlString =  "?filter=" + filter + "&qfilter=" + qFilter
        let WeburlString = url + urlString
        WebServices.shared.requestToApi(type: StoreListEntity.self, with:WeburlString, urlMethod: .get, showLoader: true, params: param, encode: URLEncoding.default) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.foodiePresenter?.getFilterRestaurantResponse(getFilterRestaurantResponse: response)
            }
        }
    }
    func userRatingParam(param: Parameters) {
        WebServices.shared.requestToApi(type: SuccessEntity.self, with: FoodieAPI.rating, urlMethod: .post, showLoader: true, params: param) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.foodiePresenter?.getUserRatingResponse(getUserRatingResponse: response)
            }
        }
    }
    
    func getSavedAddress() {
        WebServices.shared.requestToApi(type: SavedAddressEntity.self, with: AccountAPI.getAddress, urlMethod: .get, showLoader: true, encode: URLEncoding.default) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.foodiePresenter?.getSavedAddressResponse(addressList: response)
            }
        }
    }
    func getOrderStatus(Id: Int) {
        WebServices.shared.requestToApi(type: FoodieOrderDetailEntity.self, with: "\(FoodieAPI.orderDetail)/\(Id)", urlMethod: .get, showLoader: false, encode: URLEncoding.default) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.foodiePresenter?.foodieOrderStatusResponse(orderStatus: response)
            }
        }
    }
    func getPromoCodeCartList(promoCodeStr: String) {
        let promoCodeCartUrl = FoodieAPI.cartList + "?&promocode_id=" + promoCodeStr + "&wallet=0"
        WebServices.shared.requestToApi(type: FoodieCartListEntity.self, with: promoCodeCartUrl, urlMethod: .get, showLoader: true, encode: URLEncoding.default) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.foodiePresenter?.postPromoCodeCartResponse(cartListEntity: response)
            }
        }
    }
    func getReasons(param: Parameters) {
        WebServices.shared.requestToApi(type: ReasonEntity.self, with: HomeAPI.reason, urlMethod: .get, showLoader: true, params: param, encode: URLEncoding.default) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.foodiePresenter?.getReasons(reasonEntity: response)
            }
        }
    }
    
    func cancelRequest(param: Parameters) {
        WebServices.shared.requestToApi(type: SuccessEntity.self, with: FoodieAPI.cancelRequest, urlMethod: .post, showLoader: true, params: param) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.foodiePresenter?.getCancelRequest(cancelEntity: response)
            }
            else if response?.error != nil {
                self.foodiePresenter?.getCancelError(response: response as Any)
            }
        }
    }
    func getCartList(){
        WebServices.shared.requestToApi(type: FoodieCartListEntity.self, with: FoodieAPI.cartList, urlMethod: .get, showLoader: true, params: nil, encode: URLEncoding.default) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.foodiePresenter?.getCartListResponse(cartListEntity: response)
            }
        }
    }
    
}

