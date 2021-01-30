//
//  ExtraChargeView.swift
//  GoJekUser
//
//  Created by Ansar on 29/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class ExtraChargeView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    var onTapClose:(()->Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        closeButton.addTarget(self, action: #selector(tapClose), for: .touchUpInside)
        closeButton.isUserInteractionEnabled = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
    @objc func tapClose()  {
        self.onTapClose!()
    }
}
