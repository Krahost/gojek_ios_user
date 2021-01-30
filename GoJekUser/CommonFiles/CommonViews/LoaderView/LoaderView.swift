//
//  LoaderView.swift
//  GoJekUser
//
//  Created by Ansar on 04/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class LoaderView: UIView {
    
    @IBOutlet weak var cancelRequestButton: UIButton!
    @IBOutlet weak var findDriverLabel: UILabel!
    @IBOutlet weak var halfCircleView: HalfOvalCircle!
    @IBOutlet weak var innerCircelView: UIView!
    @IBOutlet weak var loaderImage: UIImageView!
    
    var onClickCancelRequest:(()->Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        initialLoads()
    }
}

extension LoaderView {
    private func initialLoads() {
        halfCircleView.radius = 50
       findDriverLabel.font = UIFont.setCustomFont(name: .medium, size: .x16)
        findDriverLabel.adjustsFontSizeToFitWidth = true
        cancelRequestButton.setTitle(Constant.cancelRequest.localized.uppercased(), for: .normal)
        cancelRequestButton.addTarget(self, action: #selector(tapCancelRequest), for: .touchUpInside)
        findDriverLabel.text = Constant.findDriver.localized
        DispatchQueue.main.async {
            self.loaderImage.setCornerRadius()
            self.innerCircelView.setCornerRadius()
            self.loaderImage.image = UIImage(named: Constant.searchImage)
        }
        setDarkMode()
    }
    
    private func setDarkMode(){
        halfCircleView.backgroundColor = .boxColor
    }
    
    @objc func tapCancelRequest() {
        self.onClickCancelRequest!()
    }
}
