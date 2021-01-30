//
//  CourierRouter.swift
//  GoJekUser
//
//  Created by Sudar on 17/01/20.
//  Copyright © 2020 Appoets. All rights reserved.
//

import UIKit


class CourierRouter: CourierPresenterToCourierRouterProtocol {
    
     static func createCourierModule() -> UIViewController {
        let view  = courierStoryboard.instantiateViewController(withIdentifier: CourierConstant.ChoosenDeliveryTypeController) as! ChoosenDeliveryTypeController
        let courierPresenter: CourierViewToCourierPresenterProtocol & CourierInterectorToCourierPresenterProtocol = CourierPresenter()
        let courierInteractor: CourierPresentorToCourierInterectorProtocol = CourierInteractor()
        let courierRouter: CourierPresenterToCourierRouterProtocol = CourierRouter()

        view.courierPresenter = courierPresenter
        courierPresenter.courierView = view
        courierPresenter.courierRouter = courierRouter
        courierPresenter.courierInterector = courierInteractor
        courierInteractor.courierPresenter = courierPresenter
        return view
    }
    
    static func createCourierHomeModule() -> UIViewController {
          
          let courierHomeViewController  = courierStoryboard.instantiateViewController(withIdentifier: CourierConstant.CourierHomeController) as! CourierHomeController
         let courierPresenter: CourierViewToCourierPresenterProtocol & CourierInterectorToCourierPresenterProtocol = CourierPresenter()
                 let courierInteractor: CourierPresentorToCourierInterectorProtocol = CourierInteractor()
                 let courierRouter: CourierPresenterToCourierRouterProtocol = CourierRouter()
          
          courierHomeViewController.courierPresenter = courierPresenter
          courierPresenter.courierView = courierHomeViewController
          courierPresenter.courierRouter = courierRouter
          courierPresenter.courierInterector = courierInteractor
          courierInteractor.courierPresenter = courierPresenter
          return courierHomeViewController
      }
    
    static var courierStoryboard: UIStoryboard {
        return UIStoryboard(name:CourierConstant.courier,bundle: Bundle.main)
    }
}
