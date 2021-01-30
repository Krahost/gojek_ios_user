//
//  ServiceTypeCell.swift
//  GoJekUser
//
//  Created by Ansar on 26/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class ServiceTypeCell: UICollectionViewCell {
    
    @IBOutlet weak var etaLabel:UILabel!
    @IBOutlet weak var serviceImage:UIImageView!
    @IBOutlet weak var serviceNameLabel:UILabel!
    
    var isCurrentService = false {
        didSet {
            etaLabel.textColor = isCurrentService ? .darkGray : UIColor.darkGray.withAlphaComponent(0.8)
            serviceNameLabel.textColor = isCurrentService ? .white : .darkGray
            serviceNameLabel.backgroundColor = isCurrentService ? .darkGray : .veryLightGray
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialLoads()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async {
            self.serviceNameLabel.maskToBounds = true
            self.serviceNameLabel.cornerRadius = 5.0
            self.serviceImage.setRoundCorner()
        }
    }
    
}


//MARK: - Methods

extension ServiceTypeCell {
    private func initialLoads() {
        DispatchQueue.main.async {
            self.serviceNameLabel.maskToBounds = true
            self.serviceNameLabel.cornerRadius = 5.0
        }
        self.setFont()
    }
    
    private func setFont() {
        etaLabel.font = .setCustomFont(name: .medium, size: .x14)
        serviceNameLabel.font = .setCustomFont(name: .medium, size: .x14)
    }
}
