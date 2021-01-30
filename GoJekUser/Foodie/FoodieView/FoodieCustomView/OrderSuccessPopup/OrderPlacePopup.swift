//
//  OrderPlacePopup.swift
//  GoJekUser
//
//  Created by Thiru on 07/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class OrderPlacePopup: UIView {

    @IBOutlet weak var okeyButton: UIButton!
    @IBOutlet weak var orderplaceBGView: UIView!
    @IBOutlet weak var orderPlaceMessageLabel: UILabel!
    
     var onClickClose:(()->Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initialLoad()
    }
   
}
extension OrderPlacePopup {
    
    private func initialLoad() {
        orderPlaceMessageLabel.font = UIFont.setCustomFont(name: .medium, size: .x16)
        DispatchQueue.main.async {
            self.orderplaceBGView.setCornerRadiuswithValue(value: 5)
        }
        okeyButton.backgroundColor = .foodieColor
        okeyButton.setTitle(Constant.SOk.localized, for: .normal)
        self.okeyButton.setCornerRadius()
        okeyButton.setTitleColor(UIColor.white, for: .normal)
        self.okeyButton.titleLabel?.font = UIFont.setCustomFont(name: .bold, size: .x16)
        
        self.okeyButton.addTarget(self, action: #selector(okButtonAction(_:)), for: .touchUpInside)

        setDarkMode()
    }
    
    func setDarkMode(){
        orderplaceBGView.backgroundColor = .boxColor
    }
    
    func showMessage(orderID:String) {
        self.orderPlaceMessageLabel.attributeString(string:  FoodieConstant.order.localized + " (" + orderID + ") " + FoodieConstant.placeSuccesfully.localized, range: NSRange(location: FoodieConstant.order.localized.count+1, length: orderID.count+1),color: .foodieColor)
    }
    @objc func okButtonAction(_ sender: UIButton) {
        self.onClickClose!()

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.onClickClose!()
    }
}
