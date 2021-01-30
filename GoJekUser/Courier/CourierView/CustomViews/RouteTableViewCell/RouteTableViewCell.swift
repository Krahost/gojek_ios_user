//
//  RouteTableViewCell.swift
//  GoJekUser
//
//  Created by Sudar on 10/06/20.
//  Copyright © 2020 Appoets. All rights reserved.
//

import UIKit

class RouteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var deliveryAddressLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
     @IBOutlet weak var buttonRemove: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setFont()
    }
    private func setFont(){
        deliveryAddressLabel.font = .setCustomFont(name: .medium, size: .x14)
        redLabel.backgroundColor = .red
        lineView.backgroundColor = .lightGray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
