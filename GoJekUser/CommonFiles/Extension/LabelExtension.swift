//
//  LabelExtension.swift
//  GoJekSample
//
//  Created by Ansar on 20/02/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import UIKit

extension UILabel{
    func animate() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            // moves label up 100 units in the y axis
            self.transform = CGAffineTransform(translationX: 0, y: -25)
        }) { finished in
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                // move label back down to its original position
                self.transform = CGAffineTransform(translationX: 0, y: 0)
            }) { finished in
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                    // move label back down to its original position
                    self.transform = CGAffineTransform(translationX: 0, y: -2)
                }) { finished in
                    UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                        // move label back down to its original position
                        self.transform = CGAffineTransform(translationX: 0, y: 0)
                    })
                }
            }
        }
    }
    
    func attributeString(string:String,range:NSRange,color:UIColor) {
        let attributeStr: NSMutableAttributedString = NSMutableAttributedString(string: string)
        attributeStr.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        self.attributedText = attributeStr
    }
    
    func attributeString(string: String,range1:NSRange,range2:NSRange?,color:UIColor) {
        
        let attributedString = NSMutableAttributedString(string: string)
        
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 50 // Whatever line spacing you want in points
        
        // *** Apply attribute to string ***
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:range1)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range1)
        if (range2 != nil) {
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range2!)
        }
        // *** Set Attributed String to your label ***
        self.attributedText = attributedString
    }
}
