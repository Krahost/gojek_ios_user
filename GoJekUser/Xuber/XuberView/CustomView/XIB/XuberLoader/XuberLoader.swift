//
//  XuberLoader.swift
//  GoJekUser
//
//  Created by Ansar on 12/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class XuberLoader: UIView {
    
    @IBOutlet weak var pulseView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var lookingProviderLabel: UILabel!
    
    let pulsator = Pulsator()
    
    var onClickCancel:(()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialLoads()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        pulsator.position = self.center//pulseView.layer.position
    }
}

extension XuberLoader {
    private func initialLoads() {
        lookingProviderLabel.font = UIFont.setCustomFont(name: .bold, size: .x16)
        cancelButton.backgroundColor = .xuberColor
        cancelButton.titleLabel?.font = UIFont.setCustomFont(name: .bold, size: .x14)
        cancelButton.setTitle(Constant.SCancel.localized, for: .normal)
        self.lookingProviderLabel.text = XuberConstant.lookingProvider.localized
        DispatchQueue.main.async {
            self.pulseView.backgroundColor = .xuberColor
            self.pulseView.alpha = 0.4
            self.pulseView.setCornerRadius()
        }
        
        self.pulseView.layer.superlayer?.insertSublayer(self.pulsator, below: self.pulseView.layer)
        pulsator.radius = 150
        pulsator.animationDuration = 1
        pulsator.backgroundColor = UIColor.xuberColor.cgColor
        pulsator.start()
        self.cancelButton.addTarget(self, action: #selector(tapCancel), for: .touchUpInside)
    }
    
    
    
    @objc func tapCancel() {
        self.onClickCancel!()
    }
    
}
