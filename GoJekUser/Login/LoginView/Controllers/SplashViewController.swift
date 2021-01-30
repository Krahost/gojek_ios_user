//
//  SplashViewController.swift
//  GoJekUser
//
//  Created by Rajes on 06/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire
import GoogleMaps
import GooglePlaces
import Stripe
import NVActivityIndicatorView

class SplashViewController: UIViewController {
    
    @IBOutlet weak var retryButton:UIButton!
    var activityIndicatorView: NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginPresenter?.getBaseURL(param: [LoginConstant.salt_key: APPConstant.salt_key])
        retryButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x16)
        retryButton.addTarget(self, action: #selector(tapRetry), for: .touchUpInside)
        retryButton.isHidden = true
        retryButton.setTitle("Please try again", for: .normal)
        // While launching splash if any internet problem means, once app comes to foreground this api will work
        NotificationCenter.default.addObserver(self, selector: #selector(appComesForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        addGifLoader()
    }
    
     @objc func tapRetry() {
        loginPresenter?.getBaseURL(param: [LoginConstant.salt_key: APPConstant.salt_key])

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func appComesForeground(notification: NSNotification) {
         loginPresenter?.getBaseURL(param: [LoginConstant.salt_key: APPConstant.salt_key])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    func addGifLoader(){
       
   activityIndicatorView =  NVActivityIndicatorView(frame:  CGRect(x: self.view.frame.size.width/2 - 50, y:  self.view.frame.height - 80, width: 80, height: 80), type: .ballPulse, color: .white, padding: 20)
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
     }
    func checkAlreadyLogin() -> Bool {
        let fetchData = try! PersistentManager.shared.context.fetch(LoginData.fetchRequest()) as? [LoginData]
        if (fetchData?.count ?? 0) <= 0 {
            return false
        }
        AppManager.shared.accessToken = fetchData?.first?.access_token
        print(fetchData?.first?.access_token ?? "")
        return (fetchData?.count ?? 0) > 0
    }
    func getCountries() {
        let param: Parameters = [LoginConstant.salt_key : APPConstant.salt_key]
       loginPresenter?.getCountries(param: param)
    }
    
}

extension SplashViewController: LoginPresenterToLoginViewProtocol {
    
    func getBaseURLResponse(baseEntity: BaseEntity) {
        activityIndicatorView.stopAnimating()
        AppConfigurationManager.shared.baseConfigModel = baseEntity
        AppConfigurationManager.shared.setBasicConfig(data: baseEntity)
        getCountries()
        CommonFunction.setDynamicMapStripeKey()
        if checkAlreadyLogin() {
            retryButton.isHidden = true

            let appDelegate = UIApplication.shared.delegate! as! AppDelegate
            appDelegate.window?.rootViewController = TabBarController().listTabBarController()
            appDelegate.window?.makeKeyAndVisible()
        } else {
            retryButton.isHidden = false

            let walkThroughViewcontroller =  LoginRouter.loginStoryboard.instantiateViewController(withIdentifier: LoginConstant.WalkThroughController)
            navigationController?.pushViewController(walkThroughViewcontroller, animated: true)
        }
        
//           let walkThrough = CourierRouter.courierStoryboard.instantiateViewController(withIdentifier: CourierConstant.DeliveryTypeViewController)
//          navigationController?.pushViewController(walkThrough, animated: true)
    }
    
    
    
    func getCountries(countryEntity: CountryEntity) {
        AppManager.shared.saveCountries(countries: countryEntity.countryData ?? [CountryData]())
    }
    
    func failureResponse(failureData: Data) {
        retryButton.isHidden = false
        let walkThroughViewcontroller =  LoginRouter.loginStoryboard.instantiateViewController(withIdentifier: LoginConstant.WalkThroughController)
        navigationController?.pushViewController(walkThroughViewcontroller, animated: true)
    }
}
