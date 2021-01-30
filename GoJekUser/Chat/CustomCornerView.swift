//
//  CustomCornerView.swift
//  GoJekUser
//
//  Created by CSS15 on 11/05/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class CustomCornerView: UIView {
    
    var cornerRadii: CGFloat = 0
    
    var corners: UIRectCorner?
    
    override init(frame: CGRect) {
        super.init(frame: frame) // calls designated initializer
    }
    
    convenience init(backgroundColor: UIColor, radius: CGFloat, cornerValue: UIRectCorner) {
        
        self.init(frame: CGRect.zero) // calls the initializer above
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.clipsToBounds = true
        
        self.backgroundColor = backgroundColor
        
        self.cornerRadii = radius

        self.corners = cornerValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners!, cornerRadii: CGSize(width: cornerRadii, height: cornerRadii))
        
        let maskLayer = CAShapeLayer()
        
        maskLayer.frame = self.bounds
        
        maskLayer.path = maskPath.cgPath
        
        self.layer.mask = maskLayer
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.draw(self.bounds)
    }
}

class ScreenConstants {
    
    static let SCREEN_WIDTH  = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    
    class func proportionalValueForValue(value: CGFloat) -> CGFloat {
        
        let ratio = (value / 414)
        
        return ScreenConstants.SCREEN_WIDTH * ratio
    }
}
