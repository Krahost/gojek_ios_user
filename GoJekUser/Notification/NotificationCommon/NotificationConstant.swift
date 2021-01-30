//
//  NotificationConstant.swift
//  GoJekUser
//
//  Created by CSS01 on 22/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation

enum  NotificationConstant {
    
    static let TNotification = "Notification"
    static let read = "Read"
    static let unRead = "Unread"
    static let notificationEmpty = "No Notification Found"
    
    //Images
    static let noNotification = "ic_no_notification"
    
    static let NotificationTableViewCell = "NotificationTableViewCell"
    static let NotificationController = "NotificationController"
    
    ///Parameter
    static let limit = "limit"
    static let offset = "offset"
    static let PPage = "page"
}

enum NotificationAPI {
    
    static let getNotification = "/user/notification"
}
