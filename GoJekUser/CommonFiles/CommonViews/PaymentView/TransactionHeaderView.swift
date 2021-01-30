//
//  TransactionHeaderView.swift
//  GoJekUser
//
//  Created by Ansar on 08/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation
import UIKit

class TransactionHeaderView: UIView {
    
    @IBOutlet weak var staticTransactionIdLabel: UILabel!
    @IBOutlet weak var staticAmountLabel: UILabel!
    @IBOutlet weak var staticStatusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialLoads()
    }
}

extension TransactionHeaderView {
    private func initialLoads() {
        staticTransactionIdLabel.font = UIFont.setCustomFont(name: .bold, size: .x16)
        staticAmountLabel.font = UIFont.setCustomFont(name: .bold, size: .x16)
        staticStatusLabel.font = UIFont.setCustomFont(name: .bold, size: .x16)
        localize()
        
    }
    
    private func localize() {
        staticStatusLabel.text = AccountConstant.status.localized
        staticAmountLabel.text = AccountConstant.staticamount.localized
        staticTransactionIdLabel.text = AccountConstant.transactionID.localized
    }
    
}
