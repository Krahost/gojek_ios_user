//
//  DeliveryChargeTableViewCell.swift
//  GoJekUser
//
//  Created by Thiru on 11/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class DeliveryChargeTableViewCell: UITableViewCell {
    
    //Static Label
    @IBOutlet weak var staticDeliveryChargeLabel: UILabel!
    @IBOutlet weak var staticCouponLabel: UILabel!
    @IBOutlet weak var staticTotalChargeLabel: UILabel!
    @IBOutlet weak var staticDiscountLabel: UILabel!
    
    @IBOutlet weak var discountView: UIView!
    @IBOutlet weak var discountValueLabel: UILabel!
    //Dynamic Label
    @IBOutlet weak var deliveryChargeLabel: UILabel!
    @IBOutlet weak var couponLabel: UILabel!
    @IBOutlet weak var totalChargeLabel: UILabel!
    
    @IBOutlet weak var couponView: UIView!
    @IBOutlet weak var chargeOuterView: UIView!
    @IBOutlet weak var totalView: UIView!
    @IBOutlet weak var staticStorePackageAmount: UILabel!
    @IBOutlet weak var storePackageAmt: UILabel!
    @IBOutlet weak var staticTax: UILabel!
    @IBOutlet weak var taxAmt: UILabel!
    
    @IBOutlet weak var itemTotalValueLabel: UILabel!
    @IBOutlet weak var itemTotalLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialLoads()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.chargeOuterView.addDashLine(strokeColor: .red, lineWidth: 1.0)
    }
}

//MARK: - Methods

extension DeliveryChargeTableViewCell {
    private func initialLoads() {
        itemTotalLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        itemTotalValueLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        discountValueLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        staticDiscountLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        staticDeliveryChargeLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        staticCouponLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        staticTotalChargeLabel.font = UIFont.setCustomFont(name: .bold, size: .x14)
        deliveryChargeLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        couponLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        totalChargeLabel.font = UIFont.setCustomFont(name: .bold, size: .x14)
        taxAmt.font = UIFont.setCustomFont(name: .medium, size: .x14)
        staticTax.font = UIFont.setCustomFont(name: .medium, size: .x14)
        storePackageAmt.font = UIFont.setCustomFont(name: .medium, size: .x14)
        staticStorePackageAmount.font = UIFont.setCustomFont(name: .medium, size: .x14)
        staticDiscountLabel.text = FoodieConstant.totalDiscount.localized

        staticDeliveryChargeLabel.textColor = .lightGray
        couponLabel.textColor = .lightGray
        staticCouponLabel.textColor = .lightGray
        staticTax.textColor = .lightGray
        staticStorePackageAmount.textColor = .lightGray
        storePackageAmt.textColor = .lightGray
        taxAmt.textColor = .lightGray
        deliveryChargeLabel.textColor = .lightGray
        chargeOuterView.backgroundColor = .boxColor
        staticDiscountLabel.textColor = .lightGray
        discountValueLabel.textColor = .lightGray
        
        itemTotalValueLabel.textColor = .lightGray
        itemTotalLabel.textColor = .lightGray
        
        couponLabel.textColor = .foodieColor
        totalView.backgroundColor = .foodieColor
        
        staticDeliveryChargeLabel.text = FoodieConstant.deliveryCharge.localized
        staticTotalChargeLabel.text = FoodieConstant.totalCharge.localized
        staticCouponLabel.text = FoodieConstant.coupon.localized
        staticStorePackageAmount.text = FoodieConstant.storePackage.localized
        staticTax.text = FoodieConstant.taxAmount.localized
        itemTotalLabel.text = FoodieConstant.itemTotal.localized
        
        if CommonFunction.checkisRTL() {
            deliveryChargeLabel.textAlignment = .left
            discountValueLabel.textAlignment =  .left
            itemTotalValueLabel.textAlignment = .left
            couponLabel.textAlignment = .left
            totalChargeLabel.textAlignment = .left
            taxAmt.textAlignment = .left
            storePackageAmt.textAlignment = .left
            
        }else {
            deliveryChargeLabel.textAlignment = .right
            discountValueLabel.textAlignment =  .right
            itemTotalValueLabel.textAlignment = .right
            couponLabel.textAlignment = .right
            totalChargeLabel.textAlignment = .right
            taxAmt.textAlignment = .right
            storePackageAmt.textAlignment = .right
        }
      
    }
}
