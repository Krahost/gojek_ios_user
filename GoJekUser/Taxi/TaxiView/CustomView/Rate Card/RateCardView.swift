//
//  RateCardView.swift
//  GoJekUser
//
//  Created by Ansar on 28/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class RateCardView: UIView {
    
    @IBOutlet weak var halfCircleView:HalfOvalCircle!
    @IBOutlet weak var topView:UIView!
    @IBOutlet weak var serviceImage:UIImageView!
    
    //Static Label
    @IBOutlet weak var baseFareStringLable:UILabel!
    @IBOutlet weak var fareStringLable:UILabel!
    @IBOutlet weak var fareTypeStringLable:UILabel!
    @IBOutlet weak var capacityStringLable:UILabel!
    
    //Dynamic Label
    @IBOutlet weak var baseFareLable:UILabel!
    @IBOutlet weak var fareLable:UILabel!
    @IBOutlet weak var fareTypeLable:UILabel!
    @IBOutlet weak var capacityLable:UILabel!
    @IBOutlet weak var distanceFareView: UIStackView!
    @IBOutlet weak var timeFareView: UIStackView!
    
    //Static Label
    @IBOutlet weak var doneButton:UIButton!
    
    var tapDone:(()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialLoads()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        topView.setCornerRadius()
        self.serviceImage.makeRounded()

    }
}

//MARK: - Methods
extension RateCardView {
    
    private func initialLoads() {
        halfCircleView.radius = 50 //Radius is Default,if its change - need to change constaint of topview
        DispatchQueue.main.async {
//            self.serviceImage.setCornerRadius()
            self.doneButton.cornerRadius = 5.0
        }
        setColorAndLocalize()
        doneButton.addTarget(self, action: #selector(tapDoneButton), for: .touchUpInside)
        setDarkMode()
    }
    
    
    private func setDarkMode(){
        self.topView.backgroundColor = .boxColor
        self.halfCircleView.backgroundColor = .boxColor
        
    }
    
    private func setColorAndLocalize() {
        baseFareStringLable.textColor = .blackColor
        fareStringLable.textColor = .blackColor
        fareTypeStringLable.textColor = .blackColor
        capacityStringLable.textColor = .blackColor
        baseFareLable.textColor = .darkGray
        fareLable.textColor = .darkGray
        fareTypeLable.textColor = .darkGray
        capacityLable.textColor = .darkGray
        doneButton.backgroundColor = .taxiColor
        doneButton.setTitle(Constant.SDone.localized.uppercased(), for: .normal)
        doneButton.setTitleColor(.white, for: .normal)
        
        baseFareStringLable.text = TaxiConstant.baseFare.localized
        fareStringLable.text = TaxiConstant.fareString.localized
        fareTypeStringLable.text = TaxiConstant.fareType.localized
        capacityStringLable.text = TaxiConstant.capacity.localized
        
        setFont()
    }
    
    private func setFont() {
        baseFareStringLable.font = .setCustomFont(name: .bold, size: .x16)
        fareStringLable.font = .setCustomFont(name: .bold, size: .x16)
        fareTypeStringLable.font = .setCustomFont(name: .bold, size: .x16)
        capacityStringLable.font = .setCustomFont(name: .bold, size: .x16)
        
        baseFareLable.font = .setCustomFont(name: .bold, size: .x14)
        fareLable.font = .setCustomFont(name: .bold, size: .x14)
        fareTypeLable.font = .setCustomFont(name: .bold, size: .x14)
        capacityLable.font = .setCustomFont(name: .bold, size: .x14)
        
        doneButton.titleLabel?.font = .setCustomFont(name: .bold, size: .x18)
    }
    
    @objc func tapDoneButton() {
        tapDone?()
    }
    
    func setValues(serviceData: Services) {        
        serviceImage.sd_setImage(with:  URL(string: serviceData.vehicle_image ?? ""), placeholderImage:#imageLiteral(resourceName: "ImagePlaceHolder"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
         // Perform operation.
            if (error != nil) {
                // Failed to load image
                self.serviceImage.image = #imageLiteral(resourceName: "ImagePlaceHolder")
            } else {
                // Successful in loading image
                self.serviceImage.image = image
            }
        })
        
        let getProfileApi = AppManager.shared.getUserDetails()
        baseFareLable.text = (getProfileApi?.currency ?? "")  + "\(serviceData.price_details?.fixed ?? 0)"
        capacityLable.text = "\(serviceData.capacity ?? 1)"
        
        // distance base
        if serviceData.price_details?.calculator == invoiceCalculator.distance.rawValue {
            
            fareLable.text = (getProfileApi?.currency ?? "") + "\(serviceData.price_details?.price ?? 0) /km"
            timeFareView.isHidden = true
            return
        }
            // min base
        else if serviceData.price_details?.calculator == invoiceCalculator.min.rawValue {
            distanceFareView.isHidden = true
            fareTypeLable.text = (getProfileApi?.currency ?? "") + "\(serviceData.price_details?.minute ?? 0) /min"
            return
        }
            
            // hour base
        else if serviceData.price_details?.calculator == invoiceCalculator.hour.rawValue {
            distanceFareView.isHidden = true
            fareTypeLable.text = (getProfileApi?.currency ?? "") + "\(serviceData.price_details?.hour ?? 0) /hr"
            return
        }
            // distance with min base
        else if serviceData.price_details?.calculator == invoiceCalculator.distancemin.rawValue {
            distanceFareView.isHidden = false
            timeFareView.isHidden = false
            fareLable.text = (getProfileApi?.currency ?? "") + "\(serviceData.price_details?.price ?? 0) /km"
            fareTypeLable.text = (getProfileApi?.currency ?? "") + "\(serviceData.price_details?.minute ?? 0) /min"
            return
        }
            
            // distance with hour base
        else if serviceData.price_details?.calculator == invoiceCalculator.distancehour.rawValue {
            distanceFareView.isHidden = false
            timeFareView.isHidden = false
            fareLable.text = (getProfileApi?.currency ?? "") + "\(serviceData.price_details?.price ?? 0) /km"
            fareTypeLable.text = (getProfileApi?.currency ?? "") + "\(serviceData.price_details?.hour ?? 0) /hr"
            return
        }
    }
}


extension UIImageView {

    func makeRounded() {
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        self.contentMode = .scaleAspectFit
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
