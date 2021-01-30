//
//  XuberPaymentSelectionCell.swift
//  GoJekUser
//
//  Created by Ansar on 19/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class XuberPaymentSelectionCell: UITableViewCell {
    
    @IBOutlet weak var staticPaymentLabel: UILabel!
    @IBOutlet weak var cardOrCashLabel: UILabel!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var paymentImage: UIImageView!
    
    @IBOutlet weak var walletButton: UIButton!
    
//    @IBOutlet weak var walletCircleImage: UIImageView!
    
    var isWalletSelect:Bool = false  {
        didSet {
            walletButton.setImage(UIImage(named: isWalletSelect ? Constant.circleFullImage : Constant.circleImage), for: .normal)
        }
    }
    
    var onTapWallet:(()->Void)?
    var onTapChange:(()->Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        staticPaymentLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        cardOrCashLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        changeButton.titleLabel?.font = UIFont.setCustomFont(name: .medium, size: .x14)
        walletButton.titleLabel?.font = UIFont.setCustomFont(name: .medium, size: .x14)
        walletButton.setTitle(Constant.wallet.localized, for: .normal)
        changeButton.setTitle(Constant.change.localized, for: .normal)
        self.changeButton.backgroundColor = UIColor.xuberColor.withAlphaComponent(0.3)
        self.changeButton.setTitleColor(.xuberColor, for: .normal)
        self.changeButton.addTarget(self, action: #selector(tapChangePayment), for: .touchUpInside)
        self.walletButton.addTarget(self, action: #selector(tapWallet), for: .touchUpInside)
        self.walletButton.setImageTitle(spacing: 10)
        self.walletButton.imageEdgeInsets = UIEdgeInsets(top: 4, left: -10, bottom: 4, right: 6)
        self.walletButton.imageView?.contentMode = .scaleAspectFit
        self.isWalletSelect = false
        setDarkMode()
    }
    
    private func setDarkMode(){
        self.contentView.backgroundColor = .boxColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func tapWallet() {
        isWalletSelect = !isWalletSelect
        SendRequestInput.shared.useWallet = isWalletSelect
    }
    
    @objc func tapChangePayment() {
        self.onTapChange!()
    }
}
