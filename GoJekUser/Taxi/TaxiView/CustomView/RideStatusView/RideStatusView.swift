//
//  RideStatusView.swift
//  GoJekUser
//
//  Created by Ansar on 04/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
//import Floaty
import SDWebImage

class RideStatusView: UIView {
    
    
    @IBOutlet weak var otpLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var ratingsLabel: UILabel!
    @IBOutlet weak var carNumberLabel: UILabel!
    @IBOutlet weak var carModelLabel: UILabel!
    @IBOutlet weak var serviceTypeLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var otpView: UIView!
    @IBOutlet weak var separatorRoundView: UIView!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var providerRatingImage: UIImageView!
    
    var status: TaxiRideStatus  = .none
    
    var onClickCancelOrShareRide:((Bool)->Void)? //Bool is used to isCancel or ShareRide

    var statusCount = 0
    
    private var request : Request?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialLoads()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async {
            self.userImage.setRoundCorner()
        }
    }
    
}

extension RideStatusView {
    
    private func initialLoads() {
        //    buttonSOS.isHidden = false
        
        DispatchQueue.main.async {
            self.otpView.addDashLine(strokeColor: .black, lineWidth: 1.0)
            
        }
        cancelButton.addTarget(self, action: #selector(tapCancel), for: .touchUpInside)
        cancelButton.backgroundColor = .taxiColor
        
        providerRatingImage.image = #imageLiteral(resourceName: "Ratings1")
        
        // let gesture = UITapGestureRecognizer(target: self, action: #selector(tapService(_:)))
        //  statusView.addGestureRecognizer(gesture)
        
        separatorRoundView.backgroundColor = .taxiColor
        
        setFont()
        setString()
        setDarkMode()
    }
    
    private func setDarkMode(){
        self.outerView.backgroundColor = .boxColor
        self.otpView.backgroundColor = .boxColor
        
    }
    
    private func setString() {
        //statusLabel.text = TaxiConstant.status
        cancelButton.setTitle(Constant.SCancel.localized.uppercased(), for: .normal)
    }
    
    
    func setFont() {
        cancelButton.titleLabel?.font = .setCustomFont(name: .bold, size: .x18)
    }
    
    @objc func tapCancel() {
        if status == .pickedup  {
            self.onClickCancelOrShareRide?(false)
        }else{
            self.onClickCancelOrShareRide?(true)
        }
        
    }
    
    
    func set(values: RequestData) {
//        let baseModel = AppConfigurationManager.shared.baseConfigModel
        status = TaxiRideStatus(rawValue: values.status ?? "") ?? .none
        self.otpView.isHidden = values.ride_otp == 0
        self.otpLabel.text =  "\(TaxiConstant.OTP) \(values.otp  ?? "")"
        self.userNameLabel.text = "\(values.provider?.first_name ?? "")    \(values.provider?.last_name ?? "")"
        self.ratingsLabel.text = values.provider?.rating?.roundOff(1)
        // service
        self.carNumberLabel.text = values.service_type?.vehicle?.vehicle_no ?? ""
        self.carModelLabel.text = values.service_type?.vehicle?.vehicle_make ?? ""
        self.serviceTypeLabel.text = values.service_type?.vehicle?.vehicle_model ?? ""
        
        
        userImage.sd_setImage(with: URL(string: values.provider?.picture ?? ""), placeholderImage:#imageLiteral(resourceName: "ImagePlaceHolder"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
            // Perform operation.
            if (error != nil) {
                // Failed to load image
                self.userImage.image = #imageLiteral(resourceName: "ImagePlaceHolder")
            } else {
                // Successful in loading image
                self.userImage.image = image
            }
        })
        carImage.sd_setImage(with:  URL(string: values.ride?.vehicle_image ?? ""), placeholderImage:#imageLiteral(resourceName: "ImagePlaceHolder"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
            // Perform operation.
            if (error != nil) {
                // Failed to load image
                self.carImage.image = #imageLiteral(resourceName: "ImagePlaceHolder")
            } else {
                // Successful in loading image
                self.carImage.image = image
            }
        })
        if status == .pickedup {
            self.cancelButton.setTitle(TaxiConstant.shareRide.localized.uppercased(), for: .normal)
        }else{
            self.cancelButton.setTitle(Constant.SCancel.localized.uppercased(), for: .normal)
        }
        //        self.cancelButton.isHidden = status  == .pickedup
        if status  == .pickedup {
            otpView.isHidden = true
        }
    }
}


