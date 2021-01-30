//
//  NotificationInteractor.swift
//  GoJekUser
//
//  Created by apple on 20/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

class NotificationInteractor: NotificationPresenterToNotificationInteractorProtocol {
    
    var notificationPresenter: NotificationInteractorToNotificationPresenterProtocol?
    
    func getNotification(param: Parameters,isHideIndicator:  Bool) {
        
        WebServices.shared.requestToApi(type: NotificationEntity.self, with: NotificationAPI.getNotification, urlMethod: .get, showLoader: isHideIndicator, params: param, encode: URLEncoding.default) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.notificationPresenter?.getNotification(notificationEntity: response)
            }
        }
    }
    
}
