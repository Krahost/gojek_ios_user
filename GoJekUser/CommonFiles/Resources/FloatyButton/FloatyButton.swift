//
//  FloatyButton.swift
//  Demo
//
//  Created by Ansar on 10/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class FloatyButton: UIButton {
    
    private let buttonOne = UIButton()
    private let buttonTwo = UIButton()
    private let floatyView = UIView()
    
    var onTapButtonOne:(() -> Void)?
    var onTapButtonTwo:(() -> Void)?
    
    var buttonOneImage = UIImage() {
        didSet {
            buttonOne.setImage(self.buttonOneImage, for: .normal)
        }
    }
    
    var buttonTwoImage = UIImage() {
        didSet {
            buttonTwo.setImage(self.buttonTwoImage, for: .normal)
        }
    }
    
    var bgColor = UIColor() {
        didSet {
            buttonOne.backgroundColor = bgColor
            buttonTwo.backgroundColor = bgColor
            buttonOne.tintColor = .white
            buttonTwo.tintColor = .white
        }
    }


    override init(frame: CGRect) {
        super.init(frame: frame)
        setButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setButton()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setCornerRadius()
    }
    
    
}

//MARK: Methods

extension FloatyButton {
    private func setButton() {
        let menuImage = UIImageView()
        menuImage.image = UIImage.init(named: Constant.moreCrossImage)
        menuImage.image?.withRenderingMode(.alwaysTemplate)
        menuImage.imageTintColor(color1: .white)
        menuImage.contentMode = .scaleAspectFit
        self.accessibilityIdentifier = "more"
        self.addTarget(self, action: #selector(menuButtonAction(_:)), for: .touchUpInside)
        self.backgroundColor = .black
        self.setImage(menuImage.image, for: .normal)
        buttonOne.addTarget(self, action: #selector(buttonOneAction(_:)), for: .touchUpInside)
        buttonTwo.addTarget(self, action: #selector(buttonTwoAction(_:)), for: .touchUpInside)
    }
    
    @objc func menuButtonAction(_ sender: UIButton) {
        if self.accessibilityIdentifier == "more" {
            floatyView.frame = CGRect(x: 0, y: 0, width: self.superview?.frame.width ?? 0, height: self.superview?.frame.height ?? 0)
            floatyView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            self.superview?.addSubview(floatyView)
            self.superview?.bringSubviewToFront(self)
            self.accessibilityIdentifier = ""
            
            buttonOne.frame = CGRect(x: self.frame.minX, y: self.frame.minY - self.frame.height - 20, width: 40, height: 40)
            buttonOne.setCornerRadius()
            floatyView.addSubview(buttonOne)
            
            buttonTwo.frame = CGRect(x: self.frame.minX, y: buttonOne.frame.minY - buttonOne.frame.height - 20, width: 40, height: 40)
            buttonTwo.setCornerRadius()
            floatyView.addSubview(buttonTwo)
            
            buttonOne.transform = CGAffineTransform(scaleX: 0.70, y: 0.70)
            buttonTwo.transform = CGAffineTransform(scaleX: 0.70, y: 0.70)
            UIView.animate(withDuration: 2.0, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 6.0,options: .allowUserInteraction, animations: {
                self.buttonTwo.transform = .identity
                self.buttonOne.transform = .identity
                }, completion: nil)
        }else{
            self.accessibilityIdentifier = "more"
            self.removeView()
        }
    }
    
    
    @objc func buttonOneAction(_ sender: UIButton) {
        self.removeView()
        self.onTapButtonOne?()
    }
    
    @objc func buttonTwoAction(_ sender: UIButton) {
        self.removeView()
        self.onTapButtonTwo?()
    }
    
    private func removeView() {
        UIView.animate(withDuration: 2.0, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 6.0,options: .allowUserInteraction, animations: {
            self.floatyView.removeFromSuperview()
            }, completion: nil)
    }
}
