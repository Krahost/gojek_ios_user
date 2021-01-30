//
//  FoodiePresenter.swift
//  GoJekUser
//
//  Created by apple on 20/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire


class FoodiePresenter: FoodieViewToFoodiePresenterProtocol {
   
    var foodieView: FoodiePresenterToFoodieViewProtocol?
    var foodieInteractor: FoodiePresenterToFoodieInteractorProtocol?
    var foodieRouter: FoodiePresenterToFoodieRouterProtocol?
    
    func getListOfStores(Id: Int, param: Parameters) {
        foodieInteractor?.getListOfStores(Id: Id, param: param)
    }
    func getPromoCodeList(param: Parameters) {
        foodieInteractor?.getPromoCodeList(param: param)
    }
    func searchRestaurantList(id: Int,type: String,searchStr: String,param: Parameters) {
        foodieInteractor?.searchRestaurantList(id: id,type: type,searchStr: searchStr,param: param)
    }
    func getCusineList(Id: Int){
        foodieInteractor?.getCusineList(Id: Id)
    }
    func getCartList(){
        foodieInteractor?.getCartList()
    }

   
    func getFilterRestaurant(Id: Int,filter: String,qFilter: String,param: Parameters){
        foodieInteractor?.getFilterRestaurant(Id: Id, filter: filter, qFilter: qFilter,param: param)

    }
    func userRatingParam(param: Parameters){
        foodieInteractor?.userRatingParam(param: param)
    }


    func getStoresDetail(with Id: Int, param: Parameters) {
        foodieInteractor?.getStoresDetail(with: Id, param: param)
    }
    
    func postAddToCart(param: Parameters) {
        foodieInteractor?.postAddToCart(param: param)
    }
    
    func getCartList(param: Parameters) {
        foodieInteractor?.getCartList(param: param)
    }
    
    func postRemoveCart(param: Parameters) {
        foodieInteractor?.postRemoveCart(param: param)
    }
    
    func postOrderCheckout(param: Parameters) {
        foodieInteractor?.postOrderCheckout(param: param)
    }
    
    func getSavedAddress() {
        foodieInteractor?.getSavedAddress()
    }
    func getOrderStatus(Id: Int){
        foodieInteractor?.getOrderStatus(Id: Id)

    }
    func getPromoCodeCartList(promoCodeStr: String){
        foodieInteractor?.getPromoCodeCartList(promoCodeStr: promoCodeStr)

    }
    
    func getReasons(param: Parameters) {
        foodieInteractor?.getReasons(param: param)
    }
    
    
    func cancelRequest(param: Parameters) {
        foodieInteractor?.cancelRequest(param: param)
    }

}

extension FoodiePresenter: FoodieInteractorToFoodiePresenterProtocol {
    func getCancelError(response: Any) {
        foodieView?.getCancelError(response: response)
    }
    func postPromoCodeCartResponse(cartListEntity: FoodieCartListEntity) {
        foodieView?.postPromoCodeCartResponse(cartListEntity: cartListEntity)
    }
    func getCancelRequest(cancelEntity: SuccessEntity) {
        foodieView?.getCancelRequest(cancelEntity: cancelEntity)
    }
    
    func getReasons(reasonEntity: ReasonEntity) {
        foodieView?.getReasons(reasonEntity: reasonEntity)
    }
    
    func foodieOrderStatusResponse(orderStatus: FoodieOrderDetailEntity){
        foodieView?.foodieOrderStatusResponse(orderStatus: orderStatus)
    }
    
    
    func getUserRatingResponse(getUserRatingResponse: SuccessEntity) {
        foodieView?.getUserRatingResponse(getUserRatingResponse: getUserRatingResponse)
    }
    
    func getFilterRestaurantResponse(getFilterRestaurantResponse: StoreListEntity) {
        foodieView?.getFilterRestaurantResponse(getFilterRestaurantResponse: getFilterRestaurantResponse)
    }
    
   
    func searchRestaturantResponse(getSearchRestuarantResponse: SearchEntity) {
        foodieView?.searchRestaturantResponse(getSearchRestuarantResponse: getSearchRestuarantResponse)
    }
    
    func getPromoCodeResponse(getPromoCodeResponse: PromocodeEntity) {
        foodieView?.getPromoCodeResponse(getPromoCodeResponse: getPromoCodeResponse)
    }
    
    
    func getListOfStoresResponse(getStoreResponse: StoreListEntity) {
        foodieView?.getListOfStoresResponse(getStoreResponse: getStoreResponse)
    }
    
    func getStoresDetailResponse(foodieDetailEntity: FoodieDetailEntity) {
        foodieView?.getStoresDetailResponse(foodieDetailEntity: foodieDetailEntity)
    }
    
    func postAddToCartResponse(addCartEntity: FoodieCartListEntity) {
         foodieView?.postAddToCartResponse(addCartEntity: addCartEntity)
    }
  
    func cusineListResponse(getCusineListResponse: CusineListEntity){
        foodieView?.cusineListResponse(getCusineListResponse: getCusineListResponse)
    }
 
    func postRemoveCartResponse(cartListEntity: FoodieCartListEntity) {
        foodieView?.postRemoveCartResponse(cartListEntity: cartListEntity)
    }
    
    func getCartListResponse(cartListEntity: FoodieCartListEntity) {
        foodieView?.getCartListResponse(cartListEntity: cartListEntity)
    }
    
    func postOrderCheckoutResponse(checkoutEntity: FoodieCheckoutEntity) {
        foodieView?.postOrderCheckoutResponse(checkoutEntity: checkoutEntity)
    }
    
    func getSavedAddressResponse(addressList: SavedAddressEntity) {
        foodieView?.getSavedAddressResponse(addressList: addressList)
    }
    
}
