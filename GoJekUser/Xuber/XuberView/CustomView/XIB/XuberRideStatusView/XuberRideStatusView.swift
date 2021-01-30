//
//  XuberRideNowView.swift
//  GoJekUser
//
//  Created by  on 12/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
//import Floaty
import SDWebImage
class XuberRideStatusView: UIView {
    
    @IBOutlet weak var topView: UIStackView!
    @IBOutlet weak var overView: UIView!
    @IBOutlet weak var otpLabel: UILabel! //OTP and Timer both
    @IBOutlet weak var providerNameLabel:UILabel!
    @IBOutlet weak var ratingLabel:UILabel!
    @IBOutlet weak var serviceLabel:UILabel!
    @IBOutlet weak var subServiceLabel:UILabel!
    
    @IBOutlet weak var providerImage: UIImageView!
    
    @IBOutlet weak var statusButton:UIButton!
    @IBOutlet weak var infoButton:UIButton! //viewing before image
    
    @IBOutlet weak var otpView:UIView! //OTP and Timer
//    @IBOutlet weak var floatyButton: Floaty!
    
    @IBOutlet weak var statusHeightConstraint: NSLayoutConstraint!

    var onTapStatusButton:(()->Void)?
    var onTapInfoButton:(()->Void)?
    var startedAt = ""
    
    var status : XuberRideStatus = .none
    var timer: Timer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialLoads()
//        self.floatyButton.removeFromSuperview()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async {
            self.providerImage.setRoundCorner()
            self.otpView.addDashLine(strokeColor: .xuberColor, lineWidth: 1.0)
            self.overView.setCornerRadiuswithValue(value: 8)
        }
    }
    
    func setValues(value: XuberRequestData){
        DispatchQueue.main.async {
            self.startedAt  = value.started_at ?? ""
            self.providerNameLabel.text = value.provider?.first_name ?? "" + (value.provider?.last_name ?? "")
            self.ratingLabel.text = value.provider?.rating?.roundOff(1)
           
            
            self.providerImage.sd_setImage(with: URL(string: value.provider?.picture ?? "")  , placeholderImage: UIImage(named: Constant.userPlaceholderImage),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                       // Perform operation.
                       if (error != nil) {
                           // Failed to load image
                           self.providerImage.image = UIImage(named: Constant.userPlaceholderImage)
                       } else {
                           // Successful in loading image
                           self.providerImage.image = image
                       }
                   })
            self.serviceLabel.text = value.service?.service_name
            self.subServiceLabel.text = value.category?.service_category_name
            self.status = XuberRideStatus(rawValue: value.status ?? "") ?? .none

            if self.status == XuberRideStatus.PICKEDUP {
                if let _ = value.started_at {
                    self.otpView.isHidden = false
                    self.topView.isHidden = false
                    self.showStartTimer()
                }
                else{
                    self.topView.isHidden = true
                    self.otpView.isHidden = true // Hide if some service not need Timer view
                }
            }else{
                self.timer?.invalidate()
                self.timer = nil
            }
            self.infoButton.isHidden = value.before_image == nil
        }
    }
}

extension XuberRideStatusView {
    private func initialLoads() {
        otpLabel.textColor = .xuberColor
        infoButton.setImage(UIImage(named: Constant.infoImage), for: .normal)
        statusButton.setTitleColor(.xuberColor, for: .normal)
        statusButton.setTitle(Constant.SCancel.localized.uppercased(), for: .normal)
        statusButton.addTarget(self, action: #selector(tapStatusButton), for: .touchUpInside)
        infoButton.addTarget(self, action: #selector(tapInfoButton), for: .touchUpInside)
        setFont()
        self.providerImage.layer.borderColor = UIColor.lightGray.cgColor
        self.providerImage.layer.borderWidth = 1
        setDarkMode()
    }
    
    
    private func setDarkMode(){
        self.overView.backgroundColor = .boxColor
        self.otpView.backgroundColor = .boxColor

    }
    private func setFont(){
        otpLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        providerNameLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        ratingLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        serviceLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        subServiceLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        statusButton.titleLabel?.font = UIFont.setCustomFont(name: .medium, size: .x18)
    }
    
    // set Start Timer
    private func showStartTimer(){
        guard let _ = timer else {
            self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.countDownDate), userInfo: nil, repeats: true)
            return
        }
    }
    
    // count down for timer
    @objc func countDownDate() {
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date: Date? = dateFormatter1.date(from: UTCToLocal(date: startedAt))
        var startTimeStr: String? = nil
        if let date = date {
            startTimeStr = dateFormatter1.string(from: date)
        }
        let nowstr = dateFormatter1.string(from: Date())
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let startDate: Date? = formatter.date(from: startTimeStr ?? "")
        let endDate: Date? = formatter.date(from: nowstr)
        
        var timeDifference: TimeInterval? = nil
        if let startDate = startDate {
            timeDifference = endDate?.timeIntervalSince(startDate)
        }
        var seconds = Int(timeDifference ?? 0)
        
        let hours: Int = seconds / 3600
        let minutes: Int = (seconds % 3600) / 60
        seconds = (seconds % 3600) % 60
        otpLabel.text = String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
   
   
    @objc func tapStatusButton() {
        self.onTapStatusButton!()
    }
    
    @objc func tapInfoButton() {
        self.onTapInfoButton!()
    }
}
