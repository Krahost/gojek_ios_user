//
//  NotificationRouter.swift
//  GoJekUser
//
//  Created by apple on 20/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class NotificationRouter: NotificationPresenterToNotificationRouterProtocol {
    
    static func createNotificationModule() -> UIViewController {
        let notificationController  = notificationStoryboard.instantiateViewController(withIdentifier: NotificationConstant.NotificationController) as! NotificationController
        let notificationPresenter: NotificationViewToNotificationPresenterProtocol & NotificationInteractorToNotificationPresenterProtocol = NotificationPresenter()
        let notificationinteractor: NotificationPresenterToNotificationInteractorProtocol = NotificationInteractor()
        let notificationRouter: NotificationPresenterToNotificationRouterProtocol = NotificationRouter()
        
        notificationController.notificationPresenter = notificationPresenter
        notificationPresenter.notificationView = notificationController
        notificationPresenter.notificationRouter = notificationRouter
        notificationPresenter.notificationInteractor = notificationinteractor
        notificationinteractor.notificationPresenter = notificationPresenter
        return notificationController
    }
    
    static var notificationStoryboard: UIStoryboard {
        return UIStoryboard(name:"Notification",bundle: Bundle.main)
    }
    
}
