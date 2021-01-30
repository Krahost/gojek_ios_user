//
//  HomeInteractor.swift
//  GoJekUser
//
//  Created by apple on 20/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

class HomeInteractor: HomePresenterToHomeInteractorProtocol {
    
    var homePresenter: HomeInteractorToHomePresenterProtocol?
    
    //MARK:- Get User Details
    func fetchUserProfileDetails() {
        
        WebServices.shared.requestToApi(type: UserProfileResponse.self, with: AccountAPI.getProfile, urlMethod: .get, showLoader: true, encode: URLEncoding.default) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value  {
                self.homePresenter?.showUserProfileDtails(details: response)
            }
        }
    }
    
    //MARK:- get saved address
    func getSavedAddress() {
        
        WebServices.shared.requestToApi(type: SavedAddressEntity.self, with: AccountAPI.getAddress, urlMethod: .get, showLoader: false, encode: URLEncoding.default) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.homePresenter?.savedAddressSuccess(addressEntity: response)
            }
        }
    }
    
    
    //MARK: Get Home Details
    func getHomeDetails(param: Parameters) {
        WebServices.shared.requestToApi(type: HomeEntity.self, with: HomeAPI.getHomeDetails, urlMethod: .get, showLoader: false, params: param, encode: URLEncoding.default) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.homePresenter?.showHomeDetails(details: response)
            }
        }
    }
    
    func userCity(param: Parameters) {
        WebServices.shared.requestToApi(type: UserCity.self, with: AccountAPI.userCity, urlMethod: .post, showLoader: true, params: param) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.homePresenter?.showUserCity(selectedCityDetails: response)
            }
        }
    }
    func getCheckRequest() {
        WebServices.shared.requestToApi(type: FoodieCheckRequestEntity.self, with: HomeAPI.checkRequest, urlMethod: .get, showLoader: true, encode: URLEncoding.default) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.homePresenter?.getCheckRequestResponse(checkRequestEntity: response)
                
            }
        }
    }
    
    func checkCourierRequest(){
           WebServices.shared.requestToApi(type: Request.self, with: CourierAPI.checkRequest, urlMethod: .get, showLoader: true, encode: URLEncoding.default) { [weak self] (response) in
               guard let self = self else {
                   return
               }
               if let response  = response?.value {
                   self.homePresenter?.checkCourierRequest(requestEntity: response)
               }
           }
       }
    
    func getPromoCodeList(){
        WebServices.shared.requestToApi(type: PromocodeEntity.self, with: HomeAPI.promocode, urlMethod: .get, showLoader: false, encode: URLEncoding.default) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.homePresenter?.getPromoCodeResponse(getPromoCodeResponse: response)
            }
        }
    }
    
    //MARK: - Chat
    func getUserChatHistory(param: Parameters) {
        WebServices.shared.requestToApi(type: ChatEntity.self, with: AccountAPI.userChat, urlMethod: .get, showLoader: false, params: param, encode: URLEncoding.default) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.homePresenter?.getUserChatHistoryResponse(chatEntity: response)
            }
        }
    }
    
    func getXuberRequest() {
        WebServices.shared.requestToApi(type: XuberRequestEntity.self, with: XuberAPI.checkRequest, urlMethod: .get, showLoader: true, encode: URLEncoding.default) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.homePresenter?.xuberCheckRequest(xuberReesponse: response)
            }
        }
    }
}
