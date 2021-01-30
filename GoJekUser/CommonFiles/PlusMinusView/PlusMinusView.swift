//
//  PlusMinusView.swift
//  GoJekSample
//
//  Created by Ansar on 20/02/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class PlusMinusView: UIView {
    
    var plusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var minusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    
    var countLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var buttonColor: UIColor!
    
    var isDisable:Bool?
    
    var currentType:MasterServices = .Order
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ minusButton,countLabel,plusButton])
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 3.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var count = 0 {
        didSet {
            if count <= 0 {
                count = 0
            }
            countLabel.text = count.toString()
        }
    }
    
    var delegate:PlusMinusDelegates?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = self.frame.height/2
        self.addSubview(stackView)
        plusButton.setTitle("+", for: .normal)
        minusButton.setTitle("-", for: .normal)
        plusButton.backgroundColor = self.buttonColor
        minusButton.backgroundColor = .veryLightGray
        minusButton.setTitleColor(self.buttonColor, for: .normal)
        plusButton.setTitleColor(.veryLightGray, for: .normal)
        plusButton.addTarget(self, action: #selector(tapPlus), for: .touchUpInside)
        minusButton.addTarget(self, action: #selector(tapMinus), for: .touchUpInside)
        count = 0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
        
        if CommonFunction.checkisRTL() {
            plusButton.setRadiusLeft()
            minusButton.setRadiusRight()
        }else {
            plusButton.setRadiusRight()
            minusButton.setRadiusLeft()
        }
    }
    
    @objc func tapMinus() {
        
        if count > 0 {
            countLabel.animate()
        }
        if currentType == .Service {
            count -= 1
        }
        minusButton.setTitleColor(buttonColor, for: .normal)
        plusButton.setTitleColor(.white, for: .normal)
        delegate?.countChange(count: count, tag: self.tag, isplus: false)
    }
    
    @objc func tapPlus() {
        
        if let isdisable = isDisable, isdisable {
            delegate?.countChange(count: -1, tag: self.tag, isplus: true)
            return
        }
        if currentType == .Service {
            count += 1
        }
        countLabel.animate()
        minusButton.setTitleColor(buttonColor, for: .normal)
        plusButton.setTitleColor(.white, for: .normal)
        delegate?.countChange(count: count,tag: self.tag, isplus: true)
    }
    
    @IBAction func tapAdd() {
        minusButton.setTitleColor(buttonColor, for: .normal)
        plusButton.setTitleColor(.white, for: .normal)
        count += 1
        countLabel.text = "\(count)"
        delegate?.countChange(count: count,tag: self.tag, isplus: true)
    }
}

extension PlusMinusView {
    
    func setupLayout() {
        // Stack View
        
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        stackView.isHidden = false
    }
}

extension UIButton {
    
    func setRadiusLeft()  {
        self.clipsToBounds = true
        if #available(iOS 11.0, *){
            self.roundCorners([.layerMinXMinYCorner, .layerMinXMaxYCorner], radius: self.frame.height/2)
        }else{
            self.roundCornersBelow10([.topLeft, .bottomLeft], radius: self.frame.height/2)
        }
    }
    
    func setRadiusRight()  {
        self.clipsToBounds = false
        if #available(iOS 11.0, *){
            self.roundCorners([.layerMaxXMinYCorner, .layerMaxXMaxYCorner], radius: self.frame.height/2)
        }else{
            self.roundCornersBelow10([.topRight, .bottomRight], radius: self.frame.height/2)
        }
    }
    
    func roundCorners(_ corners:CACornerMask, radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = corners
    }
    
    func roundCornersBelow10(_ corners:UIRectCorner, radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    }
}

protocol PlusMinusDelegates {
    
    func countChange(count: Int, tag: Int,isplus: Bool)
}


