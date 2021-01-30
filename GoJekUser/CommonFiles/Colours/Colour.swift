//
//  Colour.swift
//  GoJekUser
//
//  Created by apple on 18/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

//MARK: - App Base Color
extension UIColor {
    
    // Primary Color
    static var appPrimaryColor: UIColor {
        return UIColor(red: 0/255, green: 94/255, blue: 50/255, alpha: 1)
    }
    
    // Taxi Color
    static var taxiColor: UIColor {
        return UIColor(red: 255/255, green: 162/255, blue: 0/255, alpha: 1)
    }
    
    // Foodie Color
    static var foodieColor: UIColor {
        return UIColor(red: 252/255, green: 58/255, blue: 20/255, alpha: 1)
    }
    
    // Xuber Color
    static var xuberColor: UIColor
    {
        return UIColor(red: 4/255, green: 94/255, blue: 171/255, alpha: 1)
    }
        
    //Light Greay color
    static var veryLightGray: UIColor
    {
        return UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
    }
    static var courierColor: UIColor
    {
        return UIColor(red: 237/255, green: 119/255, blue: 90/255, alpha: 0.9)
    }
    
//    static var backgroundColor: UIColor
//    {
//        if(isDarkMode){
//            return UIColor.black
//        }
//        else{
//            return UIColor(red: 240/255, green: 240/255, blue: 245/255, alpha: 1)
//        }
//    }
//    
//    
//    static var boxColor: UIColor
//    {
//        if(isDarkMode){
//            return UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1)
//        }
//        else{
//            return UIColor.white
//        }
//    }
//    
//    static var blackColor: UIColor
//    {
//        if(isDarkMode){
//            return UIColor.white
//        }
//        else{
//            return UIColor.black
//        }
//    }
//    
//    static var whiteColor: UIColor
//    {
//        if(isDarkMode){
//            return UIColor.black
//        }
//        else{
//            return UIColor.white
//        }
//    }
    
    public class var backgroundColor : UIColor{
        return  UIColor(named: "backgroundColor") ?? UIColor.white
    }
    
    public class var boxColor : UIColor{
        return  UIColor(named: "boxColor") ?? UIColor.white
    }
    
    public class var blackColor : UIColor{
        return  UIColor(named: "blackColor") ?? UIColor.white
    }

    public class var whiteColor : UIColor{
        return  UIColor(named: "whiteColor") ?? UIColor.white
    }
    
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
