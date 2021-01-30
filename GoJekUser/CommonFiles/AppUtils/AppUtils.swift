//
//  AppUtils.swift
//  GoJekUser
//
//  Created by apple on 18/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import MessageUI

class AppUtils: NSObject {
    
    //Singleton class
    static let shared = AppUtils()
    
    //Email Validation
    func isValidEmail(emailStr: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailStr)
    }
    
    //Make Call
    func call(to number : String?) {
        
        if let phoneNumber = number, let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            AppAlert.shared.simpleAlert(view: UIApplication.topViewController() ?? UIViewController(), title: LoginConstant.cannotMakeCallAtThisMoment.localized, message: "")
        }
    }
    
    // Send Email
    func sendEmail(to mailId : [String], from view : UIViewController & MFMailComposeViewControllerDelegate,subject:String) {
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = view
            mail.setToRecipients(mailId)
            mail.setSubject(subject)
            view.present(mail, animated: true)
        } else {
            AppAlert.shared.simpleAlert(view: UIApplication.topViewController() ?? UIViewController(), title: LoginConstant.couldnotOpenEmailAttheMoment.localized, message: "")
        }
    }
    
    //Open Url
    func open(url urlString: String) {
        if let  url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    //Get Countries from JSON
    func getCountries()->[Country]{
        var source: [Country] = []
        if let data = NSData(contentsOfFile: Bundle.main.path(forResource: "countryCodes", ofType: "json") ?? "") as Data? {
            do{
                source = try JSONDecoder().decode([Country].self, from: data)
            } catch let err {
                print(err.localizedDescription)
            }
        }
        return source
    }
    
    // Method to convert JSON String to Dictionary
    func stringToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    //Date convet to required format
    func dateToString(dateStr: String, dateFormatTo: String, dateFormatReturn: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormatTo
        let dateFromString = dateFormatter.date(from: dateStr)
        guard let currentDate = dateFromString else {
            return ""
        }
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = dateFormatReturn
        let stringFromDate = dateFormatter2.string(from: currentDate)
        return stringFromDate
    }
}



