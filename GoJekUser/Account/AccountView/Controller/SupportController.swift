//
//  SupportController.swift
//  GoJekUser
//
//  Created by Ansar on 22/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import MessageUI

class SupportController: UIViewController {
    
    @IBOutlet weak var stackView:UIStackView!
    
    //static label
    @IBOutlet weak var supportHeadingLabel:UILabel!
    @IBOutlet weak var contactTeamLabel:UILabel!
    @IBOutlet weak var callLabel:UILabel!
    @IBOutlet weak var mailStaticLabel:UILabel!
    @IBOutlet weak var websiteStaticLabel:UILabel!
    
    //dynamic
    @IBOutlet weak var contactView: UIView!
    @IBOutlet weak var websiteView: UIView!
    @IBOutlet weak var mailView: UIView!
    @IBOutlet weak var callView: UIView!
    @IBOutlet weak var supportImage:UIImageView!
    @IBOutlet weak var topView:UIView!
    
    var imagesArr = [AccountConstant.phone,AccountConstant.icmail,AccountConstant.web]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contactView.setCornerRadiuswithValue(value: 8)
        topView.setCornerRadiuswithValue(value: 8)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideTabBar()
        setLocalize()
    }
}

//MARK: - Method

extension SupportController {
    private func initialLoad() {
        setImages()
        setColor()
        self.setNavigationBar()
        font()
        supportImage.image = UIImage(named: AccountConstant.icsupport)?.imageTintColor(color1: .blackColor)
        setDarkMode()
    }
    
    
    private func setDarkMode(){
          self.view.backgroundColor = .backgroundColor
          self.contactView.backgroundColor = .boxColor
      }
    
    private func setNavigationBar() {
        self.setNavigationTitle()
        self.setLeftBarButtonWith(color: .blackColor)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    private func font(){
        supportHeadingLabel.font = .setCustomFont(name: .medium, size: .x14)
        contactTeamLabel.font = .setCustomFont(name: .bold, size: .x16)
        callLabel.font = .setCustomFont(name: .bold, size: .x14)
        mailStaticLabel.font = .setCustomFont(name: .bold, size: .x14)
        websiteStaticLabel.font = .setCustomFont(name: .bold, size: .x14)
    }
    
    private func setColor() {
        self.view.backgroundColor = .veryLightGray
        self.topView.backgroundColor = .boxColor
        self.supportHeadingLabel.textColor = .blackColor
        
        //Static
        self.websiteStaticLabel.textColor = .blackColor
        self.callLabel.textColor = .blackColor
        self.mailStaticLabel.textColor = .blackColor
    }
    
    private func setLocalize() {
        self.supportHeadingLabel.text = AccountConstant.supportDesc.localized
        self.callLabel.text = AccountConstant.call.localized
        self.mailStaticLabel.text = AccountConstant.mail.localized
        self.websiteStaticLabel.text = AccountConstant.website.localized
        self.contactTeamLabel.text = AccountConstant.contactOurTeam.localized
        self.title = AccountConstant.support.localized
    }
    
    private func setImages()  {
        for view in stackView.subviews {
            let viewGesture = UITapGestureRecognizer(target: self, action: #selector(tapSupportContent(_:)))
            viewGesture.view?.tag = view.tag
            
            view.addGestureRecognizer(viewGesture)
            if let innerView = view.subviews.first {
                innerView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
                DispatchQueue.main.async {
                    innerView.setCornerRadius()
                }
                
                for components in innerView.subviews {
                    if let image = components as? UIImageView {
                        image.image = UIImage(named: imagesArr[image.tag])
                        image.imageTintColor(color1: .blackColor)
                    }
                }
            }
        }
    }
    
    @objc private func tapSupportContent(_ sender:UITapGestureRecognizer) {
        
        let baseConfig = AppConfigurationManager.shared.baseConfigModel
        switch sender.view?.tag {
        case 1:
            if let supportCall = baseConfig?.responseData?.appsetting?.supportdetails?.contact_number?.first?.number {
                AppUtils.shared.call(to: supportCall.trimString())
            }
        case 2:
            if let email = baseConfig?.responseData?.appsetting?.supportdetails?.contact_email {
                openMailApp(emailStr: email)
            }
        case 3:
            if let website = baseConfig?.responseData?.appsetting?.cmspage?.help {
                AppUtils.shared.open(url: website)
            }
        default:
            break
        }
    }
    
    private func openMailApp(emailStr: String){
        let subject = "Hi \(APPConstant.appName) Team"
        if MFMailComposeViewController.canSendMail() {
            let mailComposerVC = MFMailComposeViewController()
            mailComposerVC.mailComposeDelegate = self
            mailComposerVC.setToRecipients([emailStr])
            mailComposerVC.setSubject(subject)
            self.present(mailComposerVC, animated: true, completion: nil)
        } else {
            let coded = "mailto:\(emailStr)?subject=\(subject)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            if let emailURL = URL(string: coded ?? "") {
                if UIApplication.shared.canOpenURL(emailURL) {
                    UIApplication.shared.open(emailURL, options: [:], completionHandler: { (result) in
                        if !result {
                            self.sendMailAlert()
                        }
                    })
                }else {
                    sendMailAlert()
                }
            }
        }
    }
    
    private func sendMailAlert() {
        AppAlert.shared.simpleAlert(view: UIApplication.topViewController() ?? UIViewController(), title: LoginConstant.couldnotOpenEmailAttheMoment.localized, message: "")
    }
}

extension SupportController:MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
