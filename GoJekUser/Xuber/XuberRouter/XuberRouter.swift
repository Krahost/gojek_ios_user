//
//  XuberRouter.swift
//  GoJekUser
//
//  Created by apple on 20/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class XuberRouter: XuberPresenterToXuberRouterProtocol {
    
    static var xuberStoryboard: UIStoryboard {
        return UIStoryboard(name:"Xuber",bundle: Bundle.main)
    }
    
    static func createXuberModule(isChat: Bool) -> UIViewController {
        
        let xuberHomeViewController  = xuberStoryboard.instantiateViewController(withIdentifier: XuberConstant.XuberHomeController) as! XuberHomeController
        let xuberPresenter: XuberViewToXuberPresenterProtocol & XuberInterectorToXuberPresenterProtocol = XuberPresenter()
        let xuberInteractor: XuberPresentorToXuberInterectorProtocol = XuberInteractor()
        let xuberRouter: XuberPresenterToXuberRouterProtocol = XuberRouter()
        
        xuberHomeViewController.xuberPresenter = xuberPresenter
        xuberPresenter.xuberView = xuberHomeViewController
        xuberPresenter.xuberRouter = xuberRouter
        xuberPresenter.xuberInterector = xuberInteractor
        xuberInteractor.xuberPresenter = xuberPresenter
        xuberHomeViewController.isfromServiceChat = isChat 
        return xuberHomeViewController
    }
    
    static func createXuberServiceModule() -> UIViewController {
        
        let xuberViewController  = xuberStoryboard.instantiateViewController(withIdentifier: XuberConstant.XuberServiceSelectionController) as! XuberServiceSelectionController
        let xuberPresenter: XuberViewToXuberPresenterProtocol & XuberInterectorToXuberPresenterProtocol = XuberPresenter()
        let xuberInteractor: XuberPresentorToXuberInterectorProtocol = XuberInteractor()
        let xuberRouter: XuberPresenterToXuberRouterProtocol = XuberRouter()
        
        xuberViewController.xuberPresenter = xuberPresenter
        xuberPresenter.xuberView = xuberViewController
        xuberPresenter.xuberRouter = xuberRouter
        xuberPresenter.xuberInterector = xuberInteractor
        xuberInteractor.xuberPresenter = xuberPresenter
        
        return xuberViewController
    }
    
}
