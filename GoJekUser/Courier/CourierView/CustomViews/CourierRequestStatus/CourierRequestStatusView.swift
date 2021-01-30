//
//  CourierRequestStatusView.swift
//  GoJekUser
//
//  Created by Chan Basha on 12/06/20.
//  Copyright © 2020 Appoets. All rights reserved.
//

import UIKit
import SDWebImage

class CourierRequestStatusView: UIView {
    
    @IBOutlet weak var invoiceButton: UIButton!
    @IBOutlet weak var OTPBGView: UIView!
    @IBOutlet weak var labelOTP: UILabel!
    @IBOutlet weak var labelOTPValue: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imageProvider: UIImageView!
    @IBOutlet weak var labelProviderName: UILabel!
    @IBOutlet weak var labelRating: UILabel!
    @IBOutlet weak var labelVehicleType: UILabel!
    @IBOutlet weak var labelVehicleNumber: UILabel!
    @IBOutlet weak var buttonCall: UIButton!
    @IBOutlet weak var buttonMessage: UIButton!
    @IBOutlet weak var labelService: UILabel!
    @IBOutlet weak var overView: UIStackView!

    var tapOnCall : (()->Void)?
    var tapOnChat : (()->Void)?
    var tapOnInvoice : (()-> Void)?
    var status: CourierRequestStatus  = .none
    
    override func awakeFromNib(){
        initiaLoads()
        
    }
    override func layoutSubviews() {
        imageProvider.setRoundCorner()
        OTPBGView.setCornerRadiuswithValue(value: 8)
        overView.setCornerRadiuswithValue(value: 10)
        invoiceButton.layer.cornerRadius = 6
    }
    
    private func initiaLoads() {
        self.setFont()
        self.buttonMessage.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
        self.buttonCall.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
        self.invoiceButton.addTarget(self, action: #selector(invoiceAction), for: .touchUpInside)
        setFont()
        setText()
        setDarkMode()
    }
    
    private func setDarkMode(){
        self.overView.backgroundColor = .boxColor
        self.OTPBGView.backgroundColor = .boxColor
        self.backgroundColor = .clear
        self.invoiceButton.backgroundColor = .courierColor
    }
    
    private func setFont(){
        labelOTP.font  = .setCustomFont(name: .light, size: .x16)
        labelOTPValue.font = .setCustomFont(name: .bold, size: .x16)
        labelProviderName.font = .setCustomFont(name: .bold, size: .x16)
        labelVehicleType.font = .setCustomFont(name: .light, size: .x14)
        labelVehicleNumber.font =  .setCustomFont(name: .light, size: .x14)
        buttonCall.titleLabel?.font = .setCustomFont(name: .bold, size: .x16)
        buttonMessage.titleLabel?.font = .setCustomFont(name: .bold, size: .x16)
        invoiceButton.titleLabel?.font = .setCustomFont(name: .bold, size: .x12)
        labelService.font = .setCustomFont(name: .bold, size: .x16)
    }
    
    private func setText(){
        invoiceButton.setTitle(CourierConstant.invoice.uppercased().localized, for: .normal)
    }
    
    @objc func invoiceAction(){
        self.tapOnInvoice?()
    }
    
    func set(values:RequestData){
        status = CourierRequestStatus(rawValue: values.deliveries?.first?.status ?? "") ?? .none
        if (status == CourierRequestStatus.accepted) || (status == CourierRequestStatus.started) || (status == CourierRequestStatus.processing) {
            invoiceButton.isHidden = true
        }
        else{
            invoiceButton.isHidden = false
        }
//        let baseModel = AppConfigurationManager.shared.baseConfigModel
       // self.OTPBGView.isHidden = baseModel?.responseData?.appsetting?.ride_otp == 0
        self.labelOTPValue.text =  "\(values.deliveries?.first?.otp  ?? "")"
        self.labelProviderName.text = "\(values.provider?.first_name ?? "") \(values.provider?.last_name ?? "")"
        self.labelRating.text = values.provider?.rating?.roundOff(1)
        // service
        self.labelVehicleNumber.text = values.service_type?.vehicle?.vehicle_no ?? ""
        self.labelVehicleType.text = values.service_type?.vehicle?.vehicle_make ?? ""
        // self.serviceTypeLabel.text = values.service_type?.vehicle?.vehicle_model ?? ""
        
        imageProvider.sd_setImage(with: URL(string: values.provider?.picture ?? ""), placeholderImage:#imageLiteral(resourceName: "ImagePlaceHolder"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
            // Perform operation.
            if (error != nil) {
                // Failed to load image
                self.imageProvider.image = #imageLiteral(resourceName: "ImagePlaceHolder")
            } else {
                // Successful in loading image
                self.imageProvider.image = image
            }
        })
        
        if status  == .dropped {
         //   OTPBGView.isHidden = true
        }
        
    }
    @IBAction func buttonAction(sender:UIButton){
        print("dhfdf")
        if sender.tag == 0{
            self.tapOnCall?()
        }else if sender.tag == 1{
            self.tapOnChat?()
        }
    }
}
