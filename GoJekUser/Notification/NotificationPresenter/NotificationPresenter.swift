//
//  NotificationPresenter.swift
//  GoJekUser
//
//  Created by apple on 20/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

class NotificationPresenter: NotificationViewToNotificationPresenterProtocol {
    
    var notificationView: NotificationPresenterToNotificationViewProtocol?
    
    var notificationInteractor: NotificationPresenterToNotificationInteractorProtocol?
    
    var notificationRouter: NotificationPresenterToNotificationRouterProtocol?
    
   
    func getNotification(param: Parameters, isHideIndicator: Bool) {
        notificationInteractor?.getNotification(param: param, isHideIndicator: isHideIndicator)
    }
    
}

extension NotificationPresenter: NotificationInteractorToNotificationPresenterProtocol {
    
    func getNotification(notificationEntity: NotificationEntity) {
        notificationView?.getNotification(notificationEntity: notificationEntity)
    }
    
}
