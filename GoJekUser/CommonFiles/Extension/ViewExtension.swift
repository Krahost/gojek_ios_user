//
//  ViewExtension.swift
//  GoJekUser
//
//  Created by Ansar on 20/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation
import UIKit

enum Transition {
    
    case top
    case bottom
    case right
    case left
    
    var type: String {
        
        switch self {
        case .top :
            return CATransitionSubtype.fromBottom.rawValue
        case .bottom :
            return CATransitionSubtype.fromTop.rawValue
        case .right :
            return CATransitionSubtype.fromLeft.rawValue
        case .left :
            return CATransitionSubtype.fromRight.rawValue
            
        }
    }
}

public let kShapeDashed : String = "kShapeDashed"


extension UIView {
    
    func setRadiusWithShadow(_ radius: CGFloat? = nil) {
        self.layer.cornerRadius = radius ?? self.frame.width / 2
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        self.layer.shadowRadius = 1.0
        self.layer.shadowOpacity = 0.7
        self.layer.masksToBounds = false
    }
    
    func addTransparent(with view: UIView) {
        let transparentView = UIView(frame: self.frame)
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        transparentView.addSubview(view)
        self.addSubview(transparentView)
    }
    
    
    func removeDashedBorder(_ view: UIView) {
        view.layer.sublayers?.forEach {
            if kShapeDashed == $0.name {
                $0.removeFromSuperlayer()
            }
        }
    }
    
    func addDashedBorder(width: CGFloat? = nil, height: CGFloat? = nil, lineWidth: CGFloat = 2, lineDashPattern:[NSNumber]? = [5,5], strokeColor: UIColor = UIColor.red, fillColor: UIColor = UIColor.clear) {
        
        
        var fWidth: CGFloat? = width
        var fHeight: CGFloat? = height
        
        if fWidth == nil {
            fWidth = self.frame.width
        }
        
        if fHeight == nil {
            fHeight = self.frame.height
        }
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        
        let shapeRect = CGRect(x: 0, y: 0, width: fWidth!, height: fHeight!)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: fWidth!/2, y: fHeight!/2)
        shapeLayer.fillColor = fillColor.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = lineDashPattern
        shapeLayer.name = kShapeDashed
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
    

    //Show view with animation
    
    func show(with transition: Transition, duration: CFTimeInterval = 0.5, completion: (()->())?) {
        
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.push
        animation.subtype = CATransitionSubtype(rawValue: transition.type)
        animation.duration = duration
        
        self.layer.add(animation, forKey: CATransitionType.push.rawValue)
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            completion?()
        }
    }
    
    // Dismiss view
    
    func dismissView(with duration : TimeInterval = 0.35, onCompletion completion : (()->Void)?){
        
        UIView.animate(withDuration: duration, animations: {
            self.frame.origin.y += self.frame.height
        }) { (_) in
            self.removeFromSuperview()
            completion?()
        }
    }
    
    func drawCircle() {
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: self.frame.width,y: 100), radius: CGFloat(20), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        //change the fill color
        shapeLayer.fillColor = UIColor.clear.cgColor
        //you can change the stroke color
        shapeLayer.strokeColor = UIColor.clear.cgColor
        //you can change the line width
        shapeLayer.lineWidth = 3.0
        
        self.layer.addSublayer(shapeLayer)
    }
    
    func applyCircleShadow(shadowRadius: CGFloat = 2,
                           shadowOpacity: Float = 0.3,
                           shadowColor: CGColor = UIColor.black.cgColor,
                           shadowOffset: CGSize = CGSize.zero) {
        layer.cornerRadius = frame.size.height / 2
        layer.masksToBounds = false
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = shadowOpacity
    }
    
    //Corner Radius
    
    func setCornerRadius() {
        self.clipsToBounds  =  true
        self.layer.cornerRadius = self.frame.height/2
    }
    
    func setRoundCircle() {
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.height/2
        self.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMinYCorner,.layerMaxXMinYCorner,.layerMinXMaxYCorner]
        self.maskToBounds = false
    }
    
    func setOneSideCorner(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    //Set view corner radius with given value
    func setCornerRadiuswithValue(value: CGFloat) {
        self.maskToBounds = true
        self.layer.cornerRadius = value
    }
    
    //View Press animation
    
    func addPressAnimation(with duration: TimeInterval = 0.2, transform: CGAffineTransform = CGAffineTransform(scaleX: 0.95, y: 0.95)) {
        UIView.animate(withDuration: duration, animations: {
            self.transform = transform
            
        })
        { (bool) in
            UIView.animate(withDuration: duration, animations: {
                self.transform = .identity
            })
        }
    }
    
    //Top Half Corner in signin & signup
    
    func roundedTop(desiredCurve: CGFloat?){
        let offset:CGFloat =  self.frame.width/(desiredCurve ?? 0.0)
        let bounds: CGRect = self.bounds
        let rectBounds: CGRect = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.size.width, height: bounds.size.height / 2)
        let rectPath: UIBezierPath = UIBezierPath(rect: rectBounds)
        let ovalBounds: CGRect = CGRect(x:bounds.origin.x - offset / 2,y: bounds.origin.y, width : bounds.size.width + offset, height :bounds.size.height)
        let ovalPath: UIBezierPath = UIBezierPath(ovalIn: ovalBounds)
        rectPath.append(ovalPath)
        let maskLayer: CAShapeLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = rectPath.cgPath
        self.layer.mask = maskLayer
    }
    
    func endEditing() {
        self.endEditing(true)
    }
    
    //Set view border
    func setBorder(width: Float, color: UIColor) {
        self.borderLineWidth = CGFloat(width)
        self.borderColor = color
    }
    
    //Dashed Lines
    func addDashLine(strokeColor: UIColor, lineWidth: CGFloat) {
        self.layoutIfNeeded()
        self.setNeedsLayout()
        
        if let layers  =  self.layer.sublayers {
            for layerName in  layers where  layerName.name  ==  "DashLayer" {
                layerName.removeFromSuperlayer()
            }
        }
        
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        shapeLayer.name = "DashLayer"
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        
        shapeLayer.lineDashPattern = [5,5] // adjust to your liking
        shapeLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: shapeRect.width, height:shapeRect.height), cornerRadius: self.layer.cornerRadius).cgPath
        self.layer.addSublayer(shapeLayer)
    }
    
    //Dashed Lines
    func removeDashLine(strokeColor: UIColor, lineWidth: CGFloat) {
        self.layoutIfNeeded()
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        
        shapeLayer.lineDashPattern = [5,5] // adjust to your liking
        shapeLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: shapeRect.width, height:shapeRect.height), cornerRadius: self.layer.cornerRadius).cgPath
        
        self.layer.removeFromSuperlayer()
    }
    
    func addSingleLineDash(color:UIColor,width:CGFloat) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = width
        shapeLayer.lineDashPattern = [6,6]
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: 0),
                                CGPoint(x: self.frame.width, y: 0)])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
    
    func addShadow(color: UIColor, radius: CGFloat = 1,fillColor: UIColor) {
        var shadowLayer: CAShapeLayer!
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
            shadowLayer.fillColor = fillColor.cgColor
            shadowLayer.shadowColor = color.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            shadowLayer.shadowOpacity = 0.2
            shadowLayer.shadowRadius = 3
            
            self.layer.insertSublayer(shadowLayer, at: 0)
        }
    }
    
    func addShadow(radius: CGFloat,color:UIColor) {
        self.layer.cornerRadius = CGFloat(radius)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowColor = color.cgColor
    }
    
    func addShadowWithRadius(shadowColor: UIColor, shadowOpacity: Float, shadowRadius: CGFloat, shadowOffset: CGSize) {
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOffset = shadowOffset
    }
    
    
    @IBInspectable
    var cornerRadius : CGFloat {
        
        get{
            return self.layer.cornerRadius
        }
        
        set(newValue) {
            self.layer.cornerRadius = newValue
        }
    }
    
    
    //MARK:- Setting bottom Line
    
    @IBInspectable
    var borderLineWidth : CGFloat {
        get {
            return self.layer.borderWidth
        }
        set(newValue) {
            self.layer.borderWidth = newValue
        }
    }
    
    
    //MARK:- Setting border color
    
    @IBInspectable
    var borderColor : UIColor {
        
        get {
            
            return UIColor(cgColor: self.layer.borderColor ?? UIColor.clear.cgColor)
        }
        set(newValue) {
            self.layer.borderColor = newValue.cgColor
        }
        
    }
    
    
    //MARK:- Shadow Offset
    
    @IBInspectable
    var offsetShadow : CGSize {
        
        get {
            return self.layer.shadowOffset
        }
        set(newValue) {
            self.layer.shadowOffset = newValue
        }
        
        
    }
    
    
    
    
    //MARK:- Shadow Opacity
    @IBInspectable
    var opacityShadow : Float {
        
        get{
            return self.layer.shadowOpacity
        }
        set(newValue) {
            self.layer.shadowOpacity = newValue
        }
        
    }
    
    //MARK:- Shadow Color
    @IBInspectable
    var colorShadow : UIColor? {
        
        get{
            return UIColor(cgColor: self.layer.shadowColor ?? UIColor.clear.cgColor)
        }
        set(newValue) {
            self.layer.shadowColor = newValue?.cgColor
        }
    }
    
    //MARK:- Shadow Radius
    @IBInspectable
    var radiusShadow : CGFloat {
        get {
            return self.layer.shadowRadius
        }
        set(newValue) {
            
            self.layer.shadowRadius = newValue
        }
    }
    
    //MARK:- Mask To Bounds
    
    @IBInspectable
    var maskToBounds : Bool {
        get {
            return self.layer.masksToBounds
        }
        set(newValue) {
            
            self.layer.masksToBounds = newValue
            
        }
    }
}


class HalfOvalCircle: UIView {
    
    var radius: CGFloat = 100 {
        didSet {
            updateMask()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateMask()
    }
    
    private func updateMask() {
        let path = UIBezierPath()
        path.move(to: bounds.origin)
        let center = CGPoint(x: bounds.midX, y: bounds.minY)
        path.addArc(withCenter: center, radius: radius, startAngle: .pi, endAngle: 0, clockwise: false)
        path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.minY))
        path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
        path.addLine(to: CGPoint(x: bounds.minX, y: bounds.maxY))
        path.close()
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}


