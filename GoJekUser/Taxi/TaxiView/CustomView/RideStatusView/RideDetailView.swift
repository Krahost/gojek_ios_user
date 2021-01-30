//
//  RideDetailView.swift
//  GoJekUser
//
//  Created by Sravani on 06/05/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class RideDetailView: UIView {
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var locationPeakValueLabel: UILabel!
    
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var pointerView: UIView!
    
    @IBOutlet weak var locationReviewButton: UIButton!
    @IBOutlet weak var statusReviewButton: UIButton!
    @IBOutlet weak var extendTripButton: UIButton!
    
    private var request : RequestData?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialLoads()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async {
            self.pointerView.setCornerRadius()
            self.statusView.addDashLine(strokeColor: .taxiColor, lineWidth: 1.0)
        }
    }
}

extension RideDetailView {
    
    func initialLoads() {
        pointerView.backgroundColor = .taxiColor
        statusLabel.textColor = .taxiColor
        locationReviewButton.addTarget(self, action: #selector(tapLocationStatus), for: .touchUpInside)
        statusReviewButton.addTarget(self, action: #selector(tapLocationStatus), for: .touchUpInside)
        setString()
        setFont()
        setDarkMode()
    }
    
    private func setDarkMode(){
        self.statusView.backgroundColor = .boxColor
    }
    
    private func setString() {
        locationPeakValueLabel.text = TaxiConstant.statusDesc.localized
        statusReviewButton.setTitle(TaxiConstant.status.localized, for: .normal)
        locationReviewButton.setTitle(TaxiConstant.location.localized, for: .normal)
        statusLabel.text = TaxiConstant.acceptStatus.localized
    }
    
    private func setFont() {
        statusLabel.font = .setCustomFont(name: .medium, size: .x14)
        locationPeakValueLabel.font = .setCustomFont(name: .medium, size: .x12)
    }
    
    @objc func tapLocationStatus(sender: UIButton){
        //        if sender.tag == 0 {
        //            isStatusTap = true
        //        }else{
        //            isStatusTap = false
        //            
        //        }
        statusChanges(isStatusTap: sender.tag == 0)
    }
    
    func statusChanges(isStatusTap: Bool) {
        pointerView.isHidden = isStatusTap
        statusLabel.isHidden = isStatusTap
        locationReviewButton.setTitleColor(isStatusTap ? .blackColor : .lightGray, for: .normal)
        statusReviewButton.setTitleColor(isStatusTap ? .lightGray : .blackColor, for: .normal)
        locationReviewButton.titleLabel?.font = .setCustomFont(name: isStatusTap ? .bold : .medium, size: .x16)
        statusReviewButton.titleLabel?.font = .setCustomFont(name: isStatusTap ? .medium : .bold, size: .x16)
        if !isStatusTap {
            locationPeakValueLabel.superview?.isHidden = request?.peak == 0
            locationPeakValueLabel.text = TaxiConstant.statusDesc.localized
            extendTripButton.isHidden = true
        }else {
           // extendTripButton.isHidden = TaxiRideStatus(rawValue: request?.status ?? "") ?? .none != .pickedup
            
            extendTripButton.isHidden = true
            locationPeakValueLabel.superview?.isHidden = false
            //            locationPeakValueLabel.isHidden = false
            locationPeakValueLabel.text = request?.d_address ?? ""
        }
    }
    
    func set(values: RequestData) {
        request = values
        let status = TaxiRideStatus(rawValue: values.status ?? "") ?? .none
        statusLabel.text = status.statusString
       // extendTripButton.isHidden = status != .pickedup
         extendTripButton.isHidden = true
        statusChanges(isStatusTap: false)
    }
    
}
