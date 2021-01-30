//
//  TransactionTableCell.swift
//  GoJekUser
//
//  Created by Ansar on 08/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class TransactionTableCell: UITableViewCell {
    
    enum TransactionType: String {
        case C
        case D
        case none
        
        var code: String {
            switch self {
            case .C: return "Credited"
            case .D: return "Debited"
            case .none: return ""
            }
        }
        
        var color:UIColor {
            switch self {
            case .C:
                return .green
            case .D:
                return .red
            default:
                return .black
            }
        }
    }

    @IBOutlet weak var transactionIDLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialLoads()
    }
    
    private func setDarkMode(){
        transactionIDLabel.textColor = .blackColor
         self.contentView.backgroundColor = .boxColor
     }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setValues(values: TransactionList) {
        self.transactionIDLabel.text = values.transaction_desc
        self.amountLabel.text = values.amount?.setCurrency()

        if let type = TransactionType(rawValue: values.type ?? "") {
            self.statusLabel.text = type.code
            self.statusLabel.textColor = type.color
        }
    }
    
}

extension TransactionTableCell {
    private func initialLoads() {
        transactionIDLabel.font = UIFont.setCustomFont(name: .medium, size: .x12)
        amountLabel.font = UIFont.setCustomFont(name: .medium, size: .x12)
        statusLabel.font = UIFont.setCustomFont(name: .medium, size: .x12)
        setDarkMode()
    }
}
