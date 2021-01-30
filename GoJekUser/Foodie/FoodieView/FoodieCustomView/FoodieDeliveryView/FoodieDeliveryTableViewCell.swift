//
//  FoodieDeliveryTableViewCell.swift
//  GoJekUser
//
//  Created by CSS on 03/07/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

enum DeliveryViewAction {
    case paymentChange
    case addressChange
    case couponChange
    case deliveryType
    case takeAwayType
    case useWallet
    case showCoupon
    case doorStep
    
}

class FoodieDeliveryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var deliveryChargeView: UIView!
    @IBOutlet weak var couponOuterView: UIView!
    @IBOutlet weak var totalChargeView: UIView!
    @IBOutlet weak var chargeView: UIView!
    @IBOutlet weak var useWalletAmount: UIButton!
//    @IBOutlet weak var couponAmtLabel: UILabel!
//
//    @IBOutlet weak var couponView: UIView!
//    @IBOutlet weak var closeCouponButton: UIButton!
    @IBOutlet weak var discountValueLabel: UILabel!
    @IBOutlet weak var staticDisCount: UILabel!
    @IBOutlet weak var promoCodeView: UIView!
    //static label
    @IBOutlet weak var staticDeliveryChargeLabel: UILabel!
    @IBOutlet weak var staticCouponChargeLabel: UILabel!
    @IBOutlet weak var staticTotalLabel: UILabel!
    @IBOutlet weak var staticAddressLabel: UILabel!
    @IBOutlet weak var staticPaymentLabel: UILabel!
    @IBOutlet weak var deliveryButton: UIButton!
    
    @IBOutlet weak var promoCodeValueLabel: UILabel!
    @IBOutlet weak var staticPromoCodeLabel: UILabel!
    @IBOutlet weak var takeawayButton: UIButton!
    @IBOutlet weak var takeawayImageView: UIImageView!
    @IBOutlet weak var deliveryImageView: UIImageView!
    @IBOutlet weak var takeawayLabel: UILabel!
    @IBOutlet weak var deliveryLabel: UILabel!
    @IBOutlet weak var orderTypeLabel: UILabel!
    @IBOutlet weak var orderType: UIStackView!
    //dynamic label
    @IBOutlet weak var deliveryValueLabel: UILabel!
    @IBOutlet weak var totalValueLabel: UILabel!
    @IBOutlet weak var addressTypeLabel: UILabel!
    @IBOutlet weak var addressStringLabel: UILabel!
    @IBOutlet weak var paymentTypeLabel: UILabel!
    @IBOutlet weak var cardLabel: UILabel!
    @IBOutlet weak var staticStorePackageAmount: UILabel!
    @IBOutlet weak var storePackageAmountValue: UILabel!
    @IBOutlet weak var staticTaxLabel: UILabel!
    
    @IBOutlet weak var offerCouponAmt: UILabel!
    @IBOutlet weak var taxLabelValue: UILabel!
    //Button
    @IBOutlet weak var addressChangeButton: UIButton!
    @IBOutlet weak var paymentChangeButton: UIButton!
    @IBOutlet weak var doorStepButton: UIButton!

    @IBOutlet weak var viewCouponButton: UIButton!
    
    @IBOutlet weak var deliveryAddress: UIStackView!
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var addressImage: UIImageView!
    
    
    @IBOutlet weak var itemstotalVw: UIView!
    @IBOutlet weak var itemtotalLbl: UILabel!
    @IBOutlet weak var itemtotalValueLbl: UILabel!
    
    
    var deliveryViewButtonAction: ((_ action: DeliveryViewAction)->Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
         initialLoads() 
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
//MARK: - Methods
extension FoodieDeliveryTableViewCell {
    private func initialLoads() {
        DispatchQueue.main.async {
            self.chargeView.addShadow(radius: 5.0, color: .lightGray)
        }
        setFont()
        promoCodeView.isHidden = true
        paymentChangeButton.setTitleColor(.foodieColor, for: .normal)
        contentView.backgroundColor = .veryLightGray
        cardImage.image = UIImage(named: Constant.payment)
        cardImage.imageTintColor(color1: .foodieColor)
        addressImage.image = UIImage(named: Constant.ic_delivery_home)
        addressImage.imageTintColor(color1: .foodieColor)
        self.viewCouponButton.setTitleColor(.foodieColor, for: .normal)
        staticPaymentLabel.textColor = .foodieColor
        staticAddressLabel.textColor = .foodieColor
        self.totalChargeView.backgroundColor = .foodieColor
        localize()
        offerCouponAmt.isHidden = true
        staticDisCount.text = FoodieConstant.totalDiscount.localized
        deliveryLabel.text = orderByType.delivery.rawValue.capitalized
        itemtotalLbl.text = FoodieConstant.itemTotal.localized
        takeawayLabel.text = orderByType.takeAway.rawValue.capitalized
        takeawayImageView.image = UIImage(named: Constant.circleImage)?.imageTintColor(color1: .foodieColor)
        deliveryImageView.image = UIImage(named: Constant.circleImage)?.imageTintColor(color1: .foodieColor)
        useWalletAmount.addTarget(self, action: #selector(useAmountButtonAction), for: .touchUpInside)
        offerCouponAmt.font = UIFont.setCustomFont(name: .light, size: .x14)
        offerCouponAmt.text = FoodieConstant.offerAmt.localized
        offerCouponAmt.textColor = .lightGray
        let image = UIImage(named: Constant.sqaureEmpty)?.withRenderingMode(.alwaysTemplate)
        useWalletAmount.setImage(image, for: .normal)
        useWalletAmount.tintColor = .foodieColor
        useWalletAmount.setTitle(FoodieConstant.useWallet.localized, for: .normal)
        
        useWalletAmount.imageEdgeInsets = UIEdgeInsets(top: 4, left: -3, bottom: 4, right: 5)
        useWalletAmount.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        useWalletAmount.imageView?.contentMode = .scaleAspectFit
        useWalletAmount.setTitleColor(UIColor.blackColor, for: .normal)
        doorStepButton.setImage(image, for: .normal)
        doorStepButton.tintColor = .foodieColor
        doorStepButton.setTitle(FoodieConstant.doorStep.localized, for: .normal)
        
        doorStepButton.imageEdgeInsets = UIEdgeInsets(top: 4, left: -3, bottom: 4, right: 5)
        doorStepButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        doorStepButton.imageView?.contentMode = .scaleAspectFit
        
        doorStepButton.setTitleColor(UIColor.black, for: .normal)
        
        doorStepButton.addTarget(self, action: #selector(doorStepButtonAction), for: .touchUpInside)
        
        setDarkMode()
    }
    
    private func setDarkMode(){
        self.contentView.backgroundColor = .backgroundColor
        self.deliveryChargeView.backgroundColor = .boxColor
        self.couponOuterView.backgroundColor = .boxColor
        self.chargeView.backgroundColor = .boxColor
    }
    
    private func localize() {
        orderTypeLabel.text = FoodieConstant.orderBy.localized.uppercased()
        self.staticDeliveryChargeLabel.text = FoodieConstant.deliveryCharge.localized
        self.staticCouponChargeLabel.text = FoodieConstant.coupon.localized
        self.staticTotalLabel.text = FoodieConstant.totalCharge.localized
        self.staticAddressLabel.text = FoodieConstant.deliveryAddress.localized.uppercased()
        self.staticPaymentLabel.text = FoodieConstant.payment.localized.uppercased()
        paymentChangeButton.setTitle(FoodieConstant.change.localized.uppercased(), for: .normal)
        self.viewCouponButton.setTitle(Constant.viewCoupon.localized, for: .normal)
        self.viewCouponButton.addTarget(self, action: #selector(tapCoupon), for: .touchUpInside)
        self.paymentChangeButton.addTarget(self, action: #selector(paymentChangeButtonAction), for: .touchUpInside)
        self.addressChangeButton.addTarget(self, action: #selector(addressChangeButtonAction), for: .touchUpInside)
        deliveryButton.addTarget(self, action: #selector(deliveryButtonAction), for: .touchUpInside)
        takeawayButton.addTarget(self, action: #selector(takeawayButtonAction), for: .touchUpInside)
        staticTaxLabel.font = UIFont.setCustomFont(name: .light, size: .x14)
        storePackageAmountValue.font = UIFont.setCustomFont(name: .light, size: .x14)
        taxLabelValue.font = UIFont.setCustomFont(name: .light, size: .x14)
        
        staticStorePackageAmount.font = UIFont.setCustomFont(name: .light, size: .x14)
        staticDisCount.font = UIFont.setCustomFont(name: .light, size: .x14)
        discountValueLabel.font = UIFont.setCustomFont(name: .light, size: .x14)
        orderTypeLabel.textColor = .foodieColor
        staticStorePackageAmount.text = FoodieConstant.storePackage.localized
        staticTaxLabel.text = FoodieConstant.taxAmount.localized
        staticPromoCodeLabel.text = FoodieConstant.promoCodeAmount.localized
        
        if CommonFunction.checkisRTL() {
            discountValueLabel.textAlignment = .left
            deliveryValueLabel.textAlignment = .left
            totalValueLabel.textAlignment = .left
            storePackageAmountValue.textAlignment = .left
            cardLabel.textAlignment = .left
            taxLabelValue.textAlignment = .left
            viewCouponButton.contentHorizontalAlignment = .left
        }else {
            discountValueLabel.textAlignment = .right
            deliveryValueLabel.textAlignment = .right
            totalValueLabel.textAlignment = .right
            storePackageAmountValue.textAlignment = .right
            cardLabel.textAlignment = .right
            taxLabelValue.textAlignment = .right
            viewCouponButton.contentHorizontalAlignment = .right
        }
        
    }
    
    private func setFont() {
        useWalletAmount.titleLabel?.font = UIFont.setCustomFont(name: .light, size: .x14)
        deliveryLabel.font = UIFont.setCustomFont(name: .light, size: .x14)
        itemtotalLbl.font = UIFont.setCustomFont(name: .light, size: .x14)
        itemtotalValueLbl.font = UIFont.setCustomFont(name: .light, size: .x14)
        takeawayLabel.font = UIFont.setCustomFont(name: .light, size: .x14)
        staticPromoCodeLabel.font = UIFont.setCustomFont(name: .light, size: .x14)
        promoCodeValueLabel.font = UIFont.setCustomFont(name: .light, size: .x14)
        
        staticDeliveryChargeLabel.font = UIFont.setCustomFont(name: .light, size: .x14)
        staticCouponChargeLabel.font = UIFont.setCustomFont(name: .light, size: .x14)
        staticTotalLabel.font = UIFont.setCustomFont(name: .medium, size: .x16)
        staticAddressLabel.font = UIFont.setCustomFont(name: .light, size: .x14)
        staticPaymentLabel.font = UIFont.setCustomFont(name: .light, size: .x14)
        orderTypeLabel.font = UIFont.setCustomFont(name: .medium, size: .x16)
        deliveryValueLabel.font = UIFont.setCustomFont(name: .light, size: .x14)
        addressTypeLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        totalValueLabel.font = UIFont.setCustomFont(name: .medium, size: .x16)
        addressStringLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        paymentTypeLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        cardLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        addressChangeButton.setTitleColor(.foodieColor, for: .normal)
        addressChangeButton.titleLabel?.font = UIFont.setCustomFont(name: .medium, size: .x14)
        paymentChangeButton.titleLabel?.font = UIFont.setCustomFont(name: .medium, size: .x14)
        viewCouponButton.titleLabel?.font = UIFont.setCustomFont(name: .medium, size: .x14)
    }
    
    
}

//MARK: - IBAction
extension FoodieDeliveryTableViewCell {
    
    @objc func paymentChangeButtonAction() {
        deliveryViewButtonAction!(DeliveryViewAction.paymentChange)
    }
    
    @objc func addressChangeButtonAction() {
        deliveryViewButtonAction!(DeliveryViewAction.addressChange)
    }
    
    @objc func tapCloseSchedule() {
        deliveryViewButtonAction!(DeliveryViewAction.couponChange)
    }
    
    @objc func deliveryButtonAction(){
        deliveryViewButtonAction!(DeliveryViewAction.deliveryType)
    }
    @objc func takeawayButtonAction(){
        deliveryViewButtonAction!(DeliveryViewAction.takeAwayType)
    }
    @objc func useAmountButtonAction(){
        deliveryViewButtonAction!(DeliveryViewAction.useWallet)
    }
    @objc func doorStepButtonAction(){
        deliveryViewButtonAction!(DeliveryViewAction.doorStep)

    }
    @objc func tapCoupon() {
        deliveryViewButtonAction!(DeliveryViewAction.showCoupon)
    }
}
