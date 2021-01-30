//
//  FoodieNavigationView.swift
//  GoJekUser
//
//  Created by Ansar on 21/05/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class FoodieNavigationView: UIView {
    
    @IBOutlet weak var staticTrackLabel: UILabel!
    @IBOutlet weak var orderIDLabel: UILabel!
    
    @IBOutlet weak var backButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.staticTrackLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        self.orderIDLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        backButton.addTarget(self, action: #selector(tapBack), for: .touchUpInside)
        self.backgroundColor = UIColor.foodieColor.withAlphaComponent(0.1)
    }

    @objc func tapBack() {
        UIApplication.topViewController()?.navigationController?.popViewController(animated: true)
    }
}
