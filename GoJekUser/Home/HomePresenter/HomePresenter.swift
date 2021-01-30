//
//  HomePresenter.swift
//  GoJekUser
//
//  Created by apple on 20/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

class HomePresenter: HomeViewToHomePresenterProtocol {
   
    
    var homeView: HomePresenterToHomeViewProtocol?
    
    var homeInteractor: HomePresenterToHomeInteractorProtocol?
    
    var homeRouter: HomePresenterToHomeRouterProtocol?
    
    func fetchUserProfileDetails() {
        
        homeInteractor?.fetchUserProfileDetails()
    }
    
    func getSavedAddress() {
        homeInteractor?.getSavedAddress()
    }
    
    func getHomeDetails(param: Parameters) {
        homeInteractor?.getHomeDetails(param: param)
    }
    
    func userCity(param: Parameters) {
        homeInteractor?.userCity(param: param)
    }
    func getCheckRequest(){
        homeInteractor?.getCheckRequest()
        
    }
    func getPromoCodeList() {
        homeInteractor?.getPromoCodeList()
    }
    
    func getXuberRequest() {
        homeInteractor?.getXuberRequest()
    }
    
    func getUserChatHistory(param: Parameters) {
        homeInteractor?.getUserChatHistory(param: param)
    }
    func checkCourierRequest() {
        homeInteractor?.checkCourierRequest()
       }
       
}

extension HomePresenter: HomeInteractorToHomePresenterProtocol {
    func checkCourierRequest(requestEntity: Request) {
        homeView?.checkCourierRequest(requestEntity: requestEntity)
    }
        
    func getPromoCodeResponse(getPromoCodeResponse: PromocodeEntity) {
        homeView?.getPromoCodeResponse(getPromoCodeResponse: getPromoCodeResponse)
    }
    
    func getCheckRequestResponse(checkRequestEntity: FoodieCheckRequestEntity) {
        homeView?.getCheckRequestResponse(checkRequestEntity: checkRequestEntity)
    }
    func showHomeDetails(details: HomeEntity) {
        homeView?.showHomeDetails(details: details)
    }
    
   
    func showUserProfileDtails(details: UserProfileResponse) {
        homeView?.showUserProfileDtails(details: details)
    }
    
    func savedAddressSuccess(addressEntity: SavedAddressEntity) {
        homeView?.savedAddressSuccess(addressEntity: addressEntity)
    }
    
    func showUserCity(selectedCityDetails: UserCity) {
        homeView?.showUserCity(selectedCityDetails: selectedCityDetails)
    }
    
    func xuberCheckRequest(xuberReesponse: XuberRequestEntity) {
        homeView?.xuberCheckRequest(xuberReesponse: xuberReesponse)
    }
    
    func getUserChatHistoryResponse(chatEntity: ChatEntity) {
        homeView?.getUserChatHistoryResponse(chatEntity: chatEntity)
    }
}
