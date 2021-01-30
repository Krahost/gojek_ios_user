//
//  CouponCollectionViewCell.swift
//  User
//
//  Created by CSS on 17/09/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class CouponCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var couponCodeLabel : UILabel!
    @IBOutlet private weak var couponDescriptionLabel : UILabel!
    @IBOutlet private weak var validityLabel : UILabel!
    @IBOutlet weak var applyButton : UIButton!

    var onClickApply : ((PromocodeData?)->Void)?
    
    private var promoValues: [PromocodeData]?
    
    private var selectedPromo:PromocodeData?
    
    override var isSelected: Bool {
        didSet{
            self.applyButton.setTitle({
                return (!isSelected ?  Constant.useThis.localized :  Constant.remove.localized).uppercased()
            }(), for: .normal)
        }
    }
    
    var isHideApplyButton = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialLoads()
    }

}

extension CouponCollectionViewCell {
    
    private func initialLoads() {
        self.validityLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        self.couponCodeLabel.font = UIFont.setCustomFont(name: .bold, size: .x14)
        self.validityLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        self.applyButton.titleLabel?.font = UIFont.setCustomFont(name: .bold, size: .x14)
        isSelected = false
        self.localize()
        setFont()
        setDarkMode()
    }
    
    private func setDarkMode(){
        self.contentView.backgroundColor = .boxColor
        self.couponCodeLabel.textColor = .blackColor
    }
    
    private func setFont() {
        self.validityLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        self.couponCodeLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        self.validityLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        self.applyButton.titleLabel?.font = UIFont.setCustomFont(name: .medium, size: .x14)
    }
    
    private func localize() {
        self.applyButton.addTarget(self, action: #selector(self.buttonApplyAction), for: .touchUpInside)
        self.couponCodeLabel.textColor = .black
        self.validityLabel.textColor = .lightGray
        self.couponDescriptionLabel.textColor = .gray
    }
    
    func set(values: [PromocodeData]) {
        
        self.promoValues = values
        self.selectedPromo = self.promoValues?.first
        self.couponCodeLabel.text = promoValues?.first?.promo_code
        self.couponDescriptionLabel.text = promoValues?.first?.promo_description
        self.validityLabel.text = promoValues?.first?.expiration?.formatDateFromString(withFormat: DateFormat.ddmmyyyy) 
    }
   
    
    // Button Apply action
    @IBAction private func buttonApplyAction() {
        self.onClickApply!(!isSelected ? selectedPromo! : nil)
    }
}
