//
//  HomeProtocol.swift
//  GoJekUser
//
//  Created by apple on 20/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

var homePresenterObject: HomeViewToHomePresenterProtocol?
// MARK:- Home Presenter to Home View Protocol

protocol HomePresenterToHomeViewProtocol: class {
    
    func showUserProfileDtails(details:UserProfileResponse)
    func savedAddressSuccess(addressEntity: SavedAddressEntity)
    func showHomeDetails(details: HomeEntity)
    func showUserCity(selectedCityDetails:UserCity)
    func getCheckRequestResponse(checkRequestEntity: FoodieCheckRequestEntity)
    func getPromoCodeResponse(getPromoCodeResponse: PromocodeEntity)
    func xuberCheckRequest(xuberReesponse: XuberRequestEntity)
    func getUserChatHistoryResponse(chatEntity: ChatEntity)
    func checkCourierRequest(requestEntity: Request)

}

extension HomePresenterToHomeViewProtocol {
    var homePresenter: HomeViewToHomePresenterProtocol? {
        get {
            homePresenterObject?.homeView = self
            return homePresenterObject
        }
        set(newValue) {
            homePresenterObject = newValue
        }
    }
    
    func showUserProfileDtails(details:UserProfileResponse) { return }
    func savedAddressSuccess(addressEntity: SavedAddressEntity) { return }
    func showHomeDetails(details: HomeEntity) { return }
    func showUserCity(selectedCityDetails:UserCity) { return }
    func getCheckRequestResponse(checkRequestEntity: FoodieCheckRequestEntity) { return }
    func getPromoCodeResponse(getPromoCodeResponse: PromocodeEntity) { return }
    func xuberCheckRequest(xuberReesponse: XuberRequestEntity) { return }
    func getUserChatHistoryResponse(chatEntity: ChatEntity) { return }
    func checkCourierRequest(requestEntity: Request) { return }

}

//MARK:- Home Interactor to Home Presenter Protocol

protocol HomeInteractorToHomePresenterProtocol: class {
    
    func showUserProfileDtails(details:UserProfileResponse)
    func savedAddressSuccess(addressEntity: SavedAddressEntity)
    func showHomeDetails(details: HomeEntity)
    func showUserCity(selectedCityDetails:UserCity)
    func getCheckRequestResponse(checkRequestEntity: FoodieCheckRequestEntity)
    func getPromoCodeResponse(getPromoCodeResponse: PromocodeEntity)
    func xuberCheckRequest(xuberReesponse: XuberRequestEntity) 
    func getUserChatHistoryResponse(chatEntity: ChatEntity)
    func checkCourierRequest(requestEntity: Request) 
}

//MARK:- Home Presenter To Home Interactor Protocol

protocol  HomePresenterToHomeInteractorProtocol: class{
    
    var homePresenter: HomeInteractorToHomePresenterProtocol? { get set }
    
    func fetchUserProfileDetails()
    func getSavedAddress()
    func getHomeDetails(param: Parameters)
    func userCity(param: Parameters)
    func getCheckRequest()
    func getPromoCodeList()
    func getXuberRequest()
    func getUserChatHistory(param: Parameters)
    func checkCourierRequest()
    
}


//MARK:- Home View To Home Presenter Protocol

protocol HomeViewToHomePresenterProtocol: class {
    
    var homeView: HomePresenterToHomeViewProtocol? { get set }
    var homeInteractor: HomePresenterToHomeInteractorProtocol? { get set }
    var homeRouter: HomePresenterToHomeRouterProtocol? { get set }
    
    func fetchUserProfileDetails()
    func getSavedAddress()
    func getHomeDetails(param: Parameters)
    func userCity(param: Parameters)
    func getCheckRequest()
    func getPromoCodeList()
    func getXuberRequest()
    func getUserChatHistory(param: Parameters)
    func checkCourierRequest()
    
}

//MARK:- Home Presenter To Home Router Protocol

protocol HomePresenterToHomeRouterProtocol {
    static func createHomeModule() -> UIViewController
}


