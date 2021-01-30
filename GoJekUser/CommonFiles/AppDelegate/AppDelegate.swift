//
//  AppDelegate.swift
//  GoJekUser
//
//  Created by apple on 18/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import GoogleMaps
import GooglePlaces
import GoogleSignIn
import UserNotifications
import IQKeyboardManagerSwift
import FBSDKCoreKit
import FirebaseCore
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
      if #available(iOS 13.0, *) {
          if UITraitCollection.current.userInterfaceStyle == .dark {
              isDarkMode = true
          }
          else {
              isDarkMode = false
          }
      }
        registerPush(forApp: application)
         
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//        XSocketIOManager.sharedInstance.closeSocketConnection()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        if #available(iOS 13.0, *) {
            if UITraitCollection.current.userInterfaceStyle == .dark {
                isDarkMode = true
            }
            else {
                isDarkMode = false
            }
        }
        else{
            isDarkMode = false
        }

    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if #available(iOS 13.0, *) {
            if UITraitCollection.current.userInterfaceStyle == .dark {
                isDarkMode = true
            }
            else {
                isDarkMode = false
            }
        }
        else{
            isDarkMode = false
        }
//        XSocketIOManager.sharedInstance.establishSocketConnection()
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "GoJekUser")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    private func didFinishLaunchingSetup() {
        
        localizable()
        startNetworkMonitoring()
        IQKeyboardManager.shared.enable = true
        UNUserNotificationCenter.current().delegate = self
        FirebaseApp.configure()
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        //setInitialController()
        let splash = LoginRouter.createLoginModule()
        let navigationController = UINavigationController()
        navigationController.viewControllers = [splash]
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    private func localizable() {
        
        if let languageStr = UserDefaults.standard.value(forKey: AccountConstant.language) as? String, let language = Language(rawValue: languageStr) {
            LocalizeManager.share.setLocalization(language: language)
        }else {
            LocalizeManager.share.setLocalization(language: .english)
        }
    }
    
    // Register Push
    private func registerPush(forApp application : UIApplication){
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.alert, .sound]) { (granted, error) in
            
            if granted {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
        }
         didFinishLaunchingSetup()
    }
    
    private func startNetworkMonitoring() {
        let reachability = Reachability()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.reachabilityChanged),
                                               name: ReachabilityChangedNotification,
                                               object: reachability)
        do {
            try reachability?.startNotifier()
        } catch {
            print("Could not start reachability notifier")
        }
    }
    
    @objc func reachabilityChanged(notification: Notification) {
        let reachability = notification.object as! Reachability
        switch reachability.currentReachabilityStatus {
        case .notReachable:
            guard let topVC = UIApplication.topViewController() else { return  }
            AppAlert.shared.simpleAlert(view: topVC, title: LoginConstant.networkConnection.localized, message: nil)
            
        case .reachableViaWiFi:
            print("Network reachable through WiFi")
            
        case .reachableViaWWAN:
            print("Network reachable through Cellular Data")
            
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance()?.handle(url) ?? false  || ApplicationDelegate.shared.application(app, open: url, options: options)
    }
    
    private func setInitialController() {
            let walkThrough = CourierRouter.courierStoryboard.instantiateViewController(withIdentifier: CourierConstant.ChoosenDeliveryTypeController)
            CommonFunction.changeRootController(controller: walkThrough)
    }
    
}

//MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Pass device token to auth
        deviceTokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("Apn Token ", deviceToken.map { String(format: "%02.2hhx", $0) }.joined())
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void) {
        
        print(response)
        
        let json = response.notification.request.content.userInfo
        if let theJSONData = try?  JSONSerialization.data(withJSONObject: json,options: .prettyPrinted),let theJSONText = String(data: theJSONData,encoding: String.Encoding.ascii) {
            print("JSON string = \n\(theJSONText)")
        }
        
        let notification = json["message"] as? [String:Any]
        let notificationType =  notification!["topic"] as? String
        
        // For transport
        if notificationType == pushNotificationType.transport.rawValue {
            UIApplication.topViewController()?.navigationController?.popViewController(animated: true)
            NotificationCenter.default.post(name: Notification.Name(rawValue: pushNotificationType.transport.rawValue), object: nil)
        }
        if notificationType == pushNotificationType.chat_transport.rawValue {
            NotificationCenter.default.post(name: Notification.Name(pushNotificationType.chat_transport.rawValue), object: nil)
        }
        // For Service
        if notificationType == pushNotificationType.service.rawValue {
            UIApplication.topViewController()?.navigationController?.popViewController(animated: true)
            NotificationCenter.default.post(name: Notification.Name(pushNotificationType.service.rawValue), object: nil)
        }
        if notificationType == pushNotificationType.chat_servce.rawValue {
            if(isChatOpened == false){
            NotificationCenter.default.post(name: Notification.Name(pushNotificationType.chat_servce.rawValue), object: nil)
            }
        }
        // For Order
        if notificationType == pushNotificationType.order.rawValue {
            UIApplication.topViewController()?.navigationController?.popViewController(animated: true)
            NotificationCenter.default.post(name: NSNotification.Name(pushNotificationType.order.rawValue), object: nil)
        }
        if notificationType == pushNotificationType.chat_order.rawValue {
            NotificationCenter.default.post(name: Notification.Name(pushNotificationType.chat_order.rawValue), object: nil)
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print("Error in Notification  \(error.localizedDescription)")
    }
}
