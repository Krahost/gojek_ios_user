//
//  FoodieRouter.swift
//  GoJekUser
//
//  Created by apple on 20/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class FoodieRouter: FoodiePresenterToFoodieRouterProtocol {
    
    static func createFoodieModule() -> UIViewController {
        let foodieDetailViewController  = foodieStoryboard.instantiateViewController(withIdentifier: FoodieConstant.FoodieHomeViewController) as! FoodieHomeViewController
        let foodiePresenter: FoodieViewToFoodiePresenterProtocol & FoodieInteractorToFoodiePresenterProtocol = FoodiePresenter()
        let foodieInteractor: FoodiePresenterToFoodieInteractorProtocol = FoodieInteractor()
        let foodieRouter: FoodiePresenterToFoodieRouterProtocol = FoodieRouter()
        foodieDetailViewController.foodiePresenter = foodiePresenter
        foodiePresenter.foodieView = foodieDetailViewController
        foodiePresenter.foodieRouter = foodieRouter
        foodiePresenter.foodieInteractor = foodieInteractor
        foodieInteractor.foodiePresenter = foodiePresenter
        return foodieDetailViewController
    }
    
    static func createFoodieOrderStatusModule(isHome: Bool?, orderId: Int?,isChat: Bool?,isFromOrder: Bool) -> UIViewController {
           
           let foodieOrderStatusViewController  = foodieStoryboard.instantiateViewController(withIdentifier: FoodieConstant.FoodieOrderStatusViewController) as! FoodieOrderStatusViewController
           let foodiePresenter: FoodieViewToFoodiePresenterProtocol & FoodieInteractorToFoodiePresenterProtocol = FoodiePresenter()
           let foodieInteractor: FoodiePresenterToFoodieInteractorProtocol = FoodieInteractor()
           let foodieRouter: FoodiePresenterToFoodieRouterProtocol = FoodieRouter()
           foodieOrderStatusViewController.foodiePresenter = foodiePresenter
           foodiePresenter.foodieView = foodieOrderStatusViewController
           foodiePresenter.foodieRouter = foodieRouter
           foodiePresenter.foodieInteractor = foodieInteractor
           foodieInteractor.foodiePresenter = foodiePresenter
            foodieOrderStatusViewController.isFromOrderPage = isFromOrder
           foodieOrderStatusViewController.isHome = isHome ?? false
           orderRequestId = orderId ?? 0
           foodieOrderStatusViewController.OrderfromChatNotification = isChat ?? false
           return foodieOrderStatusViewController
       }
    
    static var foodieStoryboard: UIStoryboard {
        return UIStoryboard(name:"Foodie",bundle: Bundle.main)
    }
}



