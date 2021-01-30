//
//  FilterView.swift
//  MySample
//
//  Created by CSS01 on 20/02/19.
//  Copyright © 2019 CSS01. All rights reserved.
//

import UIKit

class FilterView: UIView {
    
    //Outlets
    @IBOutlet weak var filterTitleLabel: UILabel!
    
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var tripButton: UIButton!
    @IBOutlet weak var orderButton: UIButton!
    @IBOutlet weak var serviceButton: UIButton!
    @IBOutlet weak var deliveryButton: UIButton!

    
    var selectedType: Int = 0 { // 1 - Trip 2 - Order 3 - Service
        didSet {
            let tripColor: UIColor = selectedType == 1 ? .appPrimaryColor : .lightGray
            let orderColor: UIColor = selectedType == 3 ? .appPrimaryColor : .lightGray
            let serviceColor: UIColor = selectedType == 2 ? .appPrimaryColor : .lightGray
            let deliveryColor: UIColor = selectedType == 4 ? .appPrimaryColor : .lightGray

            
            tripButton.backgroundColor = tripColor.withAlphaComponent(0.1)
            orderButton.backgroundColor = orderColor.withAlphaComponent(0.1)
            serviceButton.backgroundColor = serviceColor.withAlphaComponent(0.1)
            deliveryButton.backgroundColor = deliveryColor.withAlphaComponent(0.1)

            tripButton.setTitleColor(selectedType == 1 ? .appPrimaryColor : .blackColor, for: .normal)
            orderButton.setTitleColor(selectedType == 3 ? .appPrimaryColor : .blackColor, for: .normal)
            serviceButton.setTitleColor(selectedType == 2 ? .appPrimaryColor : .blackColor, for: .normal)
            deliveryButton.setTitleColor(selectedType == 4 ? .appPrimaryColor : .blackColor, for: .normal)

        }
    }
    
    var onTapServices:((ServiceType)->Void)?
    
    //ViewLifeCycles
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initialLoads()
    }
    
    override func layoutSubviews() {
        superview?.layoutSubviews()
        DispatchQueue.main.async {
            self.applyButton.setCornerRadius()
            self.tripButton.setCornerRadius()
            self.orderButton.setCornerRadius()
            self.serviceButton.setCornerRadius()
            self.deliveryButton.setCornerRadius()

        }
    }
    
    func initialLoads() {
        self.filterTitleLabel.text = OrderConstant.filterBy.localized
        applyButton.backgroundColor = .appPrimaryColor
        resetButton.textColor(color: .appPrimaryColor)
        resetButton.setTitle(OrderConstant.reset.localized, for: .normal)
        applyButton.setTitle(OrderConstant.apply.localized, for: .normal)
        
        tripButton.titleLabel?.adjustsFontSizeToFitWidth = true
        orderButton.titleLabel?.adjustsFontSizeToFitWidth = true
        serviceButton.titleLabel?.adjustsFontSizeToFitWidth = true
        deliveryButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        tripButton.setTitle(ServiceType.trips.rawValue.localized, for: .normal)
        orderButton.setTitle(ServiceType.orders.rawValue.localized, for: .normal)
        serviceButton.setTitle(ServiceType.service.rawValue.localized, for: .normal)
        deliveryButton.setTitle(ServiceType.delivery.rawValue.localized, for: .normal)

        tripButton.addTarget(self, action: #selector(tapServiceType(_:)), for: .touchUpInside)
        orderButton.addTarget(self, action: #selector(tapServiceType(_:)), for: .touchUpInside)
        serviceButton.addTarget(self, action: #selector(tapServiceType(_:)), for: .touchUpInside)
        deliveryButton.addTarget(self, action: #selector(tapServiceType(_:)), for: .touchUpInside)

        resetButton.addTarget(self, action: #selector(tapReset), for: .touchUpInside)
        applyButton.addTarget(self, action: #selector(tapApply), for: .touchUpInside)
       // self.selectedType = 1
        setFont()
        setDarkMode()
    }
    
    private func setDarkMode(){
        self.backgroundColor = .boxColor
    }
    
    private func setFont() {
        self.filterTitleLabel.font = UIFont.setCustomFont(name: .bold, size: .x18)
        self.resetButton.titleLabel?.font = UIFont.setCustomFont(name: .medium, size: .x14)
        self.applyButton.titleLabel?.font = UIFont.setCustomFont(name: .medium, size: .x14)
        self.tripButton.titleLabel?.font = UIFont.setCustomFont(name: .medium, size: .x14)
        self.orderButton.titleLabel?.font = UIFont.setCustomFont(name: .medium, size: .x14)
        self.serviceButton.titleLabel?.font = UIFont.setCustomFont(name: .medium, size: .x14)
        self.deliveryButton.titleLabel?.font = UIFont.setCustomFont(name: .medium, size: .x14)

        
    }
    
    @objc func tapServiceType(_ sender: UIButton) {
        self.selectedType = sender.tag
    }
    
    @objc func tapReset() {
        self.selectedType = -1
    }
    
    @objc func tapApply() {
        
        
        if self.selectedType < 0 {
            ToastManager.show(title: OrderConstant.selectType.localized, state: .error)
            return
        }
        let selectedService = ServiceType.allCases[self.selectedType-1].rawValue
        if let currentService = ServiceType(rawValue: selectedService) {
            self.onTapServices!(currentService)
        }
    }
    
}
