//
//  OffersCollectionCell.swift
//  GoJekUser
//
//  Created by Ansar on 07/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class OffersCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var offerImage: UIImageView!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var offerDescLabel: UILabel!
    @IBOutlet weak var couponCodeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        outerView.layer.cornerRadius = 8
        outerView.layer.masksToBounds = true
        offerDescLabel.font = .setCustomFont(name: .bold, size: .x16)
        couponCodeLabel.font = .setCustomFont(name: .bold, size: .x16)
        setDarkMode()
    }
    
    
    private func setDarkMode(){
          self.outerView.backgroundColor = .boxColor
      }
    
}
