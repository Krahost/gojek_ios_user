//
//  CouponViewController.swift
//  GoJekUser
//
//  Created by CSS15 on 24/05/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class CouponViewController: UIViewController {
    
    @IBOutlet weak var couponImage: UIImageView!
    @IBOutlet weak var rideOfferLabel: UILabel!
    @IBOutlet weak var offerLabel: UILabel!
    @IBOutlet weak var dateOfferLabel: UILabel!
    
    var promo_description:String = ""
    var expiration:String = ""
    var promo_code:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initalLoads()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
}

extension CouponViewController {
    
    private func initalLoads(){
        setNavigationBar()
        setUpIntial()
        setFont()
        setColor()
        hideTabBar()
        setDarkMode()
    }
    
    private func setDarkMode(){
        self.view.backgroundColor = .backgroundColor
    }
    
    private func setNavigationBar() {
        self.setNavigationTitle()
        self.setLeftBarButtonWith(color: .blackColor)
        title = LoginConstant.coupon.localized
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    private func setUpIntial() {
        couponImage.image = UIImage(named: LoginConstant.couponImage)
        rideOfferLabel.textAlignment = .center
        offerLabel.textAlignment = .center
        dateOfferLabel.textAlignment = .center
        rideOfferLabel.text = promo_code
        offerLabel.text = promo_description
        dateOfferLabel.text = LoginConstant.expiredOffer.localized + expiration
        dateOfferLabel.adjustsFontSizeToFitWidth = true
    }
    
    private func setFont() {
        rideOfferLabel.font = .setCustomFont(name: .bold, size: .x28)
        offerLabel.font = .setCustomFont(name: .bold, size: .x20)
        dateOfferLabel.font = .setCustomFont(name: .bold, size: .x14)
    }
    
    private func setColor() {
        rideOfferLabel.textColor = .white
        offerLabel.textColor = .white
        dateOfferLabel.textColor = .white
    }
    
}
