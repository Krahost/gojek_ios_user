//
//  HeaderRouteCell.swift
//  GoJekUser
//
//  Created by Sudar on 10/06/20.
//  Copyright © 2020 Appoets. All rights reserved.
//

import UIKit

class HeaderRouteCell: UITableViewCell {
    
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var lineView: UIView!

    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var sourceLocationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setFont()
    }
    
    private func setFont(){
        fromLabel.font = .setCustomFont(name: .medium, size: .x14)
        redLabel.backgroundColor = .green
        fromLabel.text = CourierConstant.from.localized
        fromLabel.textColor = .lightGray
        lineView.backgroundColor = .lightGray
        
        toLabel.font = .setCustomFont(name: .medium, size: .x14)
        toLabel.text = CourierConstant.to
        toLabel.textColor = .lightGray
        
        sourceLocationLabel.font = .setCustomFont(name: .medium, size: .x14)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
