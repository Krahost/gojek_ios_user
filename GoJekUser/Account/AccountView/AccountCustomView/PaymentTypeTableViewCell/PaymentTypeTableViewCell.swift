//
//  PaymentTypeTableViewCell.swift
//  GoJekProvider
//
//  Created by apple on 16/05/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class PaymentTypeTableViewCell: UITableViewCell {

    //MARK: - IBOutlet
    @IBOutlet weak var cardTypeImageView: UIImageView!
    @IBOutlet weak var cardBakgroundView: UIView!
    @IBOutlet weak var cardNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        cardNameLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        cardNameLabel.textColor = .black
        self.backgroundColor = .veryLightGray
        cardBakgroundView.setCornerRadiuswithValue(value: 5.0)
        setDarkMode()
    }
    
    func setPaymentValue(payment: PaymentDetails) {
        self.cardNameLabel.text = payment.name?.uppercased()
        
        switch payment.name?.uppercased() {
        case Constant.cash.uppercased():
            self.cardTypeImageView.image = PaymentType.CASH.image
        default:
            self.cardTypeImageView.image = PaymentType.CARD.image
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setDarkMode(){
        self.backgroundColor = .backgroundColor
        self.cardBakgroundView.backgroundColor = .boxColor
        self.cardNameLabel.textColor = .blackColor
    }

}
