//
//  ViewCartView.swift
//  GoJekUser
//
//  Created by Thiru on 07/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class ViewCartView: UIView {
    
    //Outlets
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var extrachargeLabel: UILabel!
    
    @IBOutlet weak var viewCartButton: UIButton!
    @IBOutlet weak var cartView: UIView!

    //Life Cycles
    override func awakeFromNib() {
        super.awakeFromNib()
        initialLoad()
    }
    
}
extension ViewCartView {
    
    private func initialLoad () {
        
        self.initialViewLoad()
        self.setCustomColor()
    }
    
    private func initialViewLoad() {
        
        self.viewCartButton.addTarget(self, action: #selector(ViewCartAction), for: .touchUpInside)
        self.viewCartButton.setImage(UIImage(named: FoodieConstant.ic_cartbag)?.imageTintColor(color1: .white), for: .normal)
     
        
        if CommonFunction.checkisRTL() {
            self.viewCartButton.changeToRight(spacing: -10)
        }else {
            self.viewCartButton.changeToRight(spacing: 10)
        }
        
        self.setCornerRadiuswithValue(value: 5.0)
        
        self.extrachargeLabel.text = FoodieConstant.extraCharge.localized
        self.viewCartButton.setTitle(FoodieConstant.TViewcart.localized.uppercased(), for: .normal)

        self.viewCartButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x14)
        self.priceLabel.font = .setCustomFont(name: .medium, size: .x14)
        self.extrachargeLabel.font = .setCustomFont(name: .light, size: .x12)
        viewCartButton.titleLabel?.adjustsFontSizeToFitWidth = true
        extrachargeLabel.adjustsFontSizeToFitWidth = true
    }
    
    private func setCustomColor() {
        
        self.backgroundColor = .clear
        self.viewCartButton.tintColor = .white
        self.cartView.backgroundColor = .foodieColor
        self.viewCartButton.setTitleColor(.white, for: .normal)
        self.priceLabel.textColor = .white
        self.extrachargeLabel.textColor = .white
    }
    
    @objc func ViewCartAction() {
        
        let foodiecartVC = FoodieRouter.foodieStoryboard.instantiateViewController(withIdentifier: FoodieConstant.FoodieCartViewController)
        UIApplication.topViewController()?.navigationController?.pushViewController(foodiecartVC, animated: true)
        
    }
}
