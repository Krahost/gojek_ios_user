//
//  KeyboardManager.swift
//  GoJekProvider
//
//  Created by Rajes on 01/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

public final class KeyboardManager {
    
    public static let shared = KeyboardManager()
    var isKeyboardAppear = false
    var view: UIView?
    private weak var tempScrollView: UIScrollView?
    private var sourceViewMinY:CGFloat?
    
    public func keyBoardShowHide(view : UIView){
        self.view = view
        
        hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func moveSourceViewFrame(sourceView: UIView,keyboardSize:CGRect) {
        
        if self.view?.frame.minY != 0 {
            sourceViewMinY = self.view?.frame.minY
        }
        var point = sourceView.convert(sourceView.frame, to: nil)
        if self.view?.subviews.last?.frame != UIScreen.main.bounds {
            for sView in view!.subviews where sView.isKind(of: UIScrollView.self) {
                
                if let scroll = sView as? UIScrollView{
                    if !sView.isKind(of: UITextView.self) {
                        tempScrollView = scroll
                    }
                    
                }
                
                if let scroll = tempScrollView {
                    if point.maxY > keyboardSize.minY {
                    
                         scroll.contentInset.top = keyboardSize.height + 10
                    }
                }
            }
        }
        
        if let stack = sourceView.superview,stack.isKind(of: UIStackView.self) {
            if let checkSuper = sourceView.superview {
                let point2 = sourceView.convert(checkSuper.frame, to: nil)
                point.origin.y = point2.origin.y
            }
            
        }
        
        let calculatedValue = point.origin.y + point.size.height
        if keyboardSize.origin.y < calculatedValue {
            if self.view?.frame.origin.y == 0{
                self.view?.frame.origin.y -= (calculatedValue - keyboardSize.origin.y)
            }
            if let _ = sourceViewMinY {
                self.view?.frame.origin.y -= (calculatedValue - keyboardSize.origin.y)
            }
            
        }
        
        
        isKeyboardAppear = true
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if !isKeyboardAppear {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                
                if let activeTextField = UIResponder.currentFirst() as? UITextField {
                    moveSourceViewFrame(sourceView: activeTextField, keyboardSize: keyboardSize)
                }
                if let textView = UIResponder.currentFirst() as? UITextView {
                    moveSourceViewFrame(sourceView: textView, keyboardSize: keyboardSize)
                }
                
            }
            
        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification,view: UIView) {
        if isKeyboardAppear {
            if ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil {
                
                if self.view?.frame.origin.y != 0 {
                    if let yPos = sourceViewMinY {
                        self.view?.frame.origin.y = yPos
                    } else {
                        self.view?.frame.origin.y = 0
                    }
                    
                    if let scroll = tempScrollView {
                        scroll.contentInset.top = 30
                        tempScrollView = nil
                    }
                } else {
                    if let scroll = tempScrollView,scroll.contentInset.top > 0 {
                        scroll.contentInset.top = 0
                        tempScrollView = nil
                    }
                }
            }
            isKeyboardAppear = false
        }
    }
    
    public func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view!.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        self.view!.endEditing(true)
    }
}

public extension UIResponder {
    
    private struct Static {
        static weak var responder: UIResponder?
    }
    
    static func currentFirst() -> UIResponder? {
        Static.responder = nil
        UIApplication.shared.sendAction(#selector(UIResponder._trap), to: nil, from: nil, for: nil)
        return Static.responder
    }
    
    @objc private func _trap() {
        Static.responder = self
    }
}
