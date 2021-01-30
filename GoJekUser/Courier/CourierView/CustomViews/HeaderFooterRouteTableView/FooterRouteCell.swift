//
//  FooterRouteCell.swift
//  GoJekUser
//
//  Created by Sudar on 10/06/20.
//  Copyright © 2020 Appoets. All rights reserved.
//

import UIKit

class FooterRouteCell: UITableViewCell {
    
    @IBOutlet weak var addAddressButton: UIButton!
    
    var tapOnAddress : (()->Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setFont()
    }
    
    private func setFont()
    {
        
        addAddressButton.setTitle(CourierConstant.addAddress, for: .normal)
        addAddressButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x14)
        addAddressButton.addTarget(self, action: #selector(tapOnAddress(sender:)), for: .touchUpInside)

    }
    
    @IBAction func tapOnAddress(sender:UIButton){
        
        tapOnAddress?()
        
        
    }
    
}
