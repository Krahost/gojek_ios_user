//
//  FoodieProtocol.swift
//  GoJekUser
//
//  Created by apple on 20/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

var foodiePresenterObject: FoodieViewToFoodiePresenterProtocol?

//MARK:- Foodie presenter Foodie view protocol

protocol FoodiePresenterToFoodieViewProtocol: class {
    
    func getListOfStoresResponse(getStoreResponse: StoreListEntity)
    func getStoresDetailResponse(foodieDetailEntity: FoodieDetailEntity)
    func postAddToCartResponse(addCartEntity: FoodieCartListEntity)
    func getCartListResponse(cartListEntity: FoodieCartListEntity)
    func postRemoveCartResponse(cartListEntity: FoodieCartListEntity)
    func postOrderCheckoutResponse(checkoutEntity: FoodieCheckoutEntity)
    func getPromoCodeResponse(getPromoCodeResponse: PromocodeEntity)
    func searchRestaturantResponse(getSearchRestuarantResponse: SearchEntity)
    func cusineListResponse(getCusineListResponse: CusineListEntity)
    func getFilterRestaurantResponse(getFilterRestaurantResponse: StoreListEntity)
    func getUserRatingResponse(getUserRatingResponse: SuccessEntity)
    func getSavedAddressResponse(addressList: SavedAddressEntity)
    func foodieOrderStatusResponse(orderStatus: FoodieOrderDetailEntity)
    func postPromoCodeCartResponse(cartListEntity: FoodieCartListEntity)
    func getReasons(reasonEntity: ReasonEntity)
    func getCancelRequest(cancelEntity: SuccessEntity)
    func getCancelError(response: Any)


}

extension FoodiePresenterToFoodieViewProtocol {
    
    var foodiePresenter: FoodieViewToFoodiePresenterProtocol? {
        get {
            foodiePresenterObject?.foodieView = self
            return foodiePresenterObject
        }
        set(newValue) {
            foodiePresenterObject = newValue
        }
    }
    
    func getListOfStoresResponse(getStoreResponse: StoreListEntity) { return }
    func getStoresDetailResponse(foodieDetailEntity: FoodieDetailEntity) { return }
    func postAddToCartResponse(addCartEntity: FoodieCartListEntity) { return }
    func postRemoveCartResponse(cartListEntity: FoodieCartListEntity) { return }
    func getCartListResponse(cartListEntity: FoodieCartListEntity) { return }
    func postOrderCheckoutResponse(checkoutEntity: FoodieCheckoutEntity) { return }
    func getPromoCodeResponse(getPromoCodeResponse: PromocodeEntity) { return }
    func searchRestaturantResponse(getSearchRestuarantResponse: SearchEntity) { return }
    func cusineListResponse(getCusineListResponse: CusineListEntity) { return }
    func getFilterRestaurantResponse(getFilterRestaurantResponse: StoreListEntity) { return }
    func getUserRatingResponse(getUserRatingResponse: SuccessEntity) { return }
    func getSavedAddressResponse(addressList: SavedAddressEntity) { return }
     func foodieOrderStatusResponse(orderStatus: FoodieOrderDetailEntity) { return }
    func postPromoCodeCartResponse(cartListEntity: FoodieCartListEntity) { return }
    func getReasons(reasonEntity: ReasonEntity) { return }
    func getCancelRequest(cancelEntity: SuccessEntity) { return }
    func getCancelError(response: Any) { return }


}

//MARK:- Foodie Interactor to Foodie Presenter Protocol

protocol FoodieInteractorToFoodiePresenterProtocol: class {
    
    func getListOfStoresResponse(getStoreResponse: StoreListEntity)
    func getStoresDetailResponse(foodieDetailEntity: FoodieDetailEntity)
    func postAddToCartResponse(addCartEntity: FoodieCartListEntity)
    func getCartListResponse(cartListEntity: FoodieCartListEntity)
    func postRemoveCartResponse(cartListEntity: FoodieCartListEntity)
    func postOrderCheckoutResponse(checkoutEntity: FoodieCheckoutEntity)
    func getPromoCodeResponse(getPromoCodeResponse: PromocodeEntity)
    func searchRestaturantResponse(getSearchRestuarantResponse: SearchEntity)
    func cusineListResponse(getCusineListResponse: CusineListEntity)
    func getFilterRestaurantResponse(getFilterRestaurantResponse: StoreListEntity)
    func getUserRatingResponse(getUserRatingResponse: SuccessEntity)
    func getSavedAddressResponse(addressList: SavedAddressEntity)
    func foodieOrderStatusResponse(orderStatus: FoodieOrderDetailEntity)
    func postPromoCodeCartResponse(cartListEntity: FoodieCartListEntity)
    func getReasons(reasonEntity: ReasonEntity)
    func getCancelRequest(cancelEntity: SuccessEntity)
    func getCancelError(response: Any)


}

//MARK:- Foodie Presenter to Foodie Interactor Protocol

protocol FoodiePresenterToFoodieInteractorProtocol: class {
    
    var foodiePresenter: FoodieInteractorToFoodiePresenterProtocol? { get set }
    
    func getListOfStores(Id: Int, param: Parameters)
    func getStoresDetail(with Id: Int, param: Parameters)
    func postAddToCart(param: Parameters)
    func getCartList(param: Parameters)
    func getCartList()
    func postRemoveCart(param: Parameters)
    func postOrderCheckout(param: Parameters)
    func getPromoCodeList(param: Parameters)
    func searchRestaurantList(id: Int,type: String,searchStr: String,param: Parameters)
    func getCusineList(Id: Int)
    func getFilterRestaurant(Id: Int,filter: String,qFilter: String,param: Parameters)
    func userRatingParam(param: Parameters)
    func getSavedAddress()
    func getOrderStatus(Id: Int)
    func getPromoCodeCartList(promoCodeStr: String)
    func getReasons(param: Parameters)
    func cancelRequest(param: Parameters)

}

//MARK:- Foodie view to Foodie presenter protocol

protocol FoodieViewToFoodiePresenterProtocol: class {
    
    var foodieView: FoodiePresenterToFoodieViewProtocol? { get set}
    var foodieInteractor: FoodiePresenterToFoodieInteractorProtocol? { get set }
    var foodieRouter: FoodiePresenterToFoodieRouterProtocol? { get set }
    
    func getListOfStores(Id: Int, param: Parameters)
    func getStoresDetail(with Id: Int, param: Parameters)
    func postAddToCart(param: Parameters)
    func getCartList(param: Parameters)
    func getCartList()
    func postRemoveCart(param: Parameters)
    func postOrderCheckout(param: Parameters)
    func getPromoCodeList(param: Parameters)
    func searchRestaurantList(id: Int,type: String,searchStr: String,param: Parameters)
    func getCusineList(Id: Int)
    func getFilterRestaurant(Id: Int,filter: String,qFilter: String,param: Parameters)
    func userRatingParam(param: Parameters)
    func getSavedAddress()
    func getOrderStatus(Id: Int)
    func getPromoCodeCartList(promoCodeStr: String)
    func getReasons(param: Parameters)
    func cancelRequest(param: Parameters)
}

//MARK:- Foodie Presenter to Foodie Router Protocol

protocol FoodiePresenterToFoodieRouterProtocol {
    static func createFoodieModule() -> UIViewController    
}



