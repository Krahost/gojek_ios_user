//
//  StringExtension.swift
//  GoJekUser
//
//  Created by Ansar on 22/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation
import UIKit

var currentBundle: Bundle!


extension String {
    
    func isInt() -> Bool {
        return Int(self) != nil
    }
    
    func isDouble() -> Bool {
        return Double(self) != nil
    }
    
    func toDouble() -> Double {
        return Double(self) ?? 0
    }
    
    //Check sting is empty
    static var empty: String {
        return ""
    }
    
    var giveSpace: String {
        return self + " "
    }
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
    //If sting have value or not
    static func removeNil(_ value : String?) -> String{
        return value ?? String.empty
    }
    
    //Validate is number
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
    //Remove white spaces
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
    
    //Change localise language
    func localize()->String{
        return NSLocalizedString(self, bundle: currentBundle!, comment: "")
    }
    
    //Mark:- Localize String varibale
    var localized: String {
        
        guard let path = Bundle.main.path(forResource: LocalizeManager.share.currentlocalization(), ofType: "lproj") else {
            return NSLocalizedString(self, comment: "returns a chosen localized string")
        }
        let bundle = Bundle(path: path)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
        
    }
    
    
    //Make first letter has capital letter
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    //Make first letter capital
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    /**
     true if self contains characters.
     */
    var isNotEmpty: Bool {
        return !isEmpty
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func trimString() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    var isValidPassword: Bool {
        return self.count >= 6
    }
    
    func toDate(withFormat format: String = DateFormat.yyyy_mm_dd_hh_mm_ss)-> Date?{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        return date
        
    }
    
    func formatDateFromString(withFormat format: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = DateFormat.yyyy_mm_dd_hh_mm_ss
        if let date = inputFormatter.date(from: self) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = format
            return outputFormatter.string(from: date)
        }
        return nil
    }
    
    func toDictionary() -> NSDictionary {
        let blankDict : NSDictionary = [:]
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
            } catch {
                print(error.localizedDescription)
            }
        }
        return blankDict
    }
    
    
    func dateDiff() -> String {
        let format:DateFormatter = DateFormatter()
        format.dateFormat = DateFormat.yyyy_mm_dd_hh_mm_ss
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = DateFormat.yyyy_mm_dd_hh_mm_ss
        let showDate = inputFormatter.date(from: self)
        
        let date1:Date = showDate!
        let date2: Date = Date()
        let calendar: Calendar = Calendar.current
        
        let components: DateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date1, to: date2)
        
        let weeks = Int(components.month!)
        let days = Int(components.day!)
        let hours = Int(components.hour!)
        let min = Int(components.minute!)
        let sec = Int(components.second!)
        let year = Int(components.year!)
        
        var timeAgo = ""
        if sec == 0 {
            timeAgo = "just now"
        }else if (sec > 0){
            if (sec >= 2) {
                timeAgo = "\(sec) secs ago"
            } else {
                timeAgo = "\(sec) sec ago"
            }
        }
        
        if (min > 0){
            if (min >= 2) {
                timeAgo = "\(min) mins ago"
            } else {
                timeAgo = "\(min) min ago"
            }
        }
        
        if(hours > 0){
            if (hours >= 2) {
                timeAgo = "\(hours) hrs ago"
            } else {
                timeAgo = "\(hours) hr ago"
            }
        }
        
        if (days > 0) {
            if (days >= 2) {
                timeAgo = "\(days) days ago"
            } else {
                timeAgo = "\(days) day ago"
            }
        }
        
        if(weeks > 0){
            if (weeks >= 2) {
                timeAgo = "\(weeks) months ago"
            } else {
                timeAgo = "\(weeks) month ago"
            }
        }
        
        if(year > 0){
            if (year >= 2) {
                timeAgo = "\(year) years ago"
            } else {
                timeAgo = "\(year) year ago"
            }
        }
        return timeAgo;
    }
    
    func heightOfString(usingFont font: UIFont,width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.height
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.height
    }
    
}

// Conversion of UTC Local
func UTCToLocal(date:String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    
    let dt = dateFormatter.date(from: date)
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    return dateFormatter.string(from: dt ?? Date())
}

//@IBDesignable
class InsetLabel: UILabel {
    
    @IBInspectable var topInset: CGFloat = 0
    @IBInspectable var bottomInset: CGFloat = 0
    @IBInspectable var leftInset: CGFloat = 10.0
    @IBInspectable var rightInset: CGFloat = 10.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
}

