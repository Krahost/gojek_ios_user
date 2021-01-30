//
//  ServiceTypeCell.swift
//  GoJekUser
//
//  Created by Ansar on 26/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class CourierServiceTypeCell: UICollectionViewCell {
    
    @IBOutlet weak var serviceImage:UIImageView!
    @IBOutlet weak var serviceNameLbl: UILabel!
    @IBOutlet weak var estimationtimeLbl: UILabel!
    
    var isCurrentService = false
    {
        didSet {
            estimationtimeLbl.textColor = isCurrentService ? .courierColor : .darkGray
            serviceNameLbl.textColor = isCurrentService ? .white : .darkGray
            serviceNameLbl.backgroundColor = isCurrentService ? .courierColor : .boxColor
        }
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        initialLoads()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.serviceImage.makeRounded()
        serviceNameLbl.layer.cornerRadius = 4
        serviceNameLbl.clipsToBounds = true
    }
    
}


//MARK: - Methods

extension CourierServiceTypeCell {
    private func initialLoads() {
        self.serviceImage.contentMode = .scaleAspectFill
        serviceNameLbl.font = UIFont.setCustomFont(name: .medium, size: .x16)
        estimationtimeLbl.font = .setCustomFont(name: .medium, size: .x14)

        serviceNameLbl.layer.cornerRadius = 4
        setDarkMode()
    }
    
    func setDarkMode(){
        self.backgroundColor = .backgroundColor
        self.serviceNameLbl.backgroundColor = .boxColor
    }
    
    
}
