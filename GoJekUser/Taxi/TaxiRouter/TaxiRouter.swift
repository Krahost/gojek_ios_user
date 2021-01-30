//
//  TaxiRouter.swift
//  GoJekUser
//
//  Created by apple on 20/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class TaxiRouter: TaxiPresenterToTaxiRouterProtocol {
    
    static func createTaxiModule(rideTypeId: Int?) -> UIViewController {
        let taxiHomeViewController  = taxiStoryboard.instantiateViewController(withIdentifier: TaxiConstant.TaxiHomeViewController) as! TaxiHomeViewController
        let taxiPresenter: TaxiViewToTaxiPresenterProtocol & TaxiInterectorToTaxiPresenterProtocol = TaxiPresenter()
        let taxiInteractor: TaxiPresentorToTaxiInterectorProtocol = TaxiInteractor()
        let taxiRouter: TaxiPresenterToTaxiRouterProtocol = TaxiRouter()
        
        taxiHomeViewController.taxiPresenter = taxiPresenter
        taxiPresenter.taxiView = taxiHomeViewController
        taxiPresenter.taxiRouter = taxiRouter
        taxiPresenter.taxiInterector = taxiInteractor
        taxiInteractor.taxiPresenter = taxiPresenter
        taxiHomeViewController.rideTypeId = rideTypeId
        return taxiHomeViewController
    }
    static func createTaxiModuleChat(rideTypeId: Int?) -> UIViewController {
        let taxiHomeViewController  = taxiStoryboard.instantiateViewController(withIdentifier: TaxiConstant.TaxiHomeViewController) as! TaxiHomeViewController
        let taxiPresenter: TaxiViewToTaxiPresenterProtocol & TaxiInterectorToTaxiPresenterProtocol = TaxiPresenter()
        let taxiInteractor: TaxiPresentorToTaxiInterectorProtocol = TaxiInteractor()
        let taxiRouter: TaxiPresenterToTaxiRouterProtocol = TaxiRouter()
        
        taxiHomeViewController.taxiPresenter = taxiPresenter
        taxiPresenter.taxiView = taxiHomeViewController
        taxiPresenter.taxiRouter = taxiRouter
        taxiPresenter.taxiInterector = taxiInteractor
        taxiInteractor.taxiPresenter = taxiPresenter
        taxiHomeViewController.rideTypeId = rideTypeId
        taxiHomeViewController.fromChatNotification = true
        return taxiHomeViewController
    }
    static var taxiStoryboard: UIStoryboard {
        return UIStoryboard(name:"Taxi",bundle: Bundle.main)
    }
}
