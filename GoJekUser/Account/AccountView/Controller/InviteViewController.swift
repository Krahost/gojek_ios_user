//
//  InviteViewController.swift
//  GoJekUser
//
//  Created by CSS01 on 21/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class InviteViewController: UIViewController {

    @IBOutlet weak var inviteView: UIView!
    @IBOutlet weak var inviteReferralCodeView: UIView!
    @IBOutlet weak var referralDetailView: UIView!
    @IBOutlet weak var referralView: UIView!
    @IBOutlet weak var giftImageView: UIImageView!
    @IBOutlet weak var shareButtonView: RoundedView!
    
    @IBOutlet weak var inviteReferalMessageLabel: UILabel!
    @IBOutlet weak var inviteReferCodeHeadLabel: UILabel!
    @IBOutlet weak var referalCodeLabel: UILabel!
    @IBOutlet weak var staticReferalCountLabel: UILabel!
    @IBOutlet weak var staticReferalAmountLabel: UILabel!
    
    @IBOutlet weak var referalCountValueLabel: UILabel!
    @IBOutlet weak var referalAmountValueLabel: UILabel!
    
    //104 225 203
    var accountPresenter: AccountViewToAccountPresenterProtocol?
    
    var inviteColor: UIColor = UIColor(red: 104/255.0, green: 225/255.0, blue: 203/255.0, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        uiDesigning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar()
    }
    
    private func setNavigationBar() {
        self.setNavigationTitle()
        self.setLeftBarButtonWith(color: .blackColor)
        self.title = AccountConstant.inviteReferral.localized
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    private func setDarkMode(){
        self.view.backgroundColor = .backgroundColor
        self.inviteReferralCodeView.backgroundColor = .boxColor
        self.inviteView.backgroundColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1)
        self.referralView.backgroundColor = .boxColor
        self.referralDetailView.backgroundColor = .boxColor
    }
    
    func uiDesigning() {
        shareButtonView.backgroundColor = .appPrimaryColor
        shareButtonView.setCenterImage = UIImage(named: Constant.shareImage)?.imageTintColor(color1: .white)
        shareButtonView.addShadow(radius: 3.0, color: .lightGray)
        
        inviteView.layer.masksToBounds = true
        inviteView.layer.cornerRadius = 5
        
        inviteReferralCodeView.layer.masksToBounds = true
        inviteReferralCodeView.layer.cornerRadius = 5
        
        referralView.setCornerRadiuswithValue(value: 5)
        
        let shareGesture =  UITapGestureRecognizer(target: self, action: #selector(tapShare))
        shareButtonView.addGestureRecognizer(shareGesture)
        
        giftImageView.image = UIImage(named: AccountConstant.referFriend)
        giftImageView.imageTintColor(color1: inviteColor)
        self.view.backgroundColor = .veryLightGray
        
        referralDetailView.layer.masksToBounds = true
        referralDetailView.layer.cornerRadius = 5
        customLocalize()
        setCustomFont()
        setCustomColor()
        
        if CommonFunction.checkisRTL() {
         inviteReferalMessageLabel.textAlignment = .right
        }
        setDarkMode()
    }
    
    private func setCustomColor() {
        shareButtonView.backgroundColor = .appPrimaryColor
        inviteView.backgroundColor = .black
        inviteReferralCodeView.backgroundColor = .white
        referalCodeLabel.textColor = .gray
    }
    
    private func customLocalize() {
        let currency = AppManager.shared.getUserDetails()?.currency_symbol ?? ""
        let referalCode = AppManager.shared.getUserDetails()?.referral?.referral_code
        let referalCount = AppManager.shared.getUserDetails()?.referral?.referral_count
        let referalAmount = AppManager.shared.getUserDetails()?.referral?.referral_amount
        let userReferalCount = AppManager.shared.getUserDetails()?.referral?.user_referral_count
        let userReferalAmount = AppManager.shared.getUserDetails()?.referral?.user_referral_amount
        
        let inviteFriend = AccountConstant.inviteFriend.localized
        let referalAmt = " \(currency)\(referalAmount?.toString() ?? "") "
        let messageStr1 = inviteFriend + referalAmt
        let forEvery = AccountConstant.forEvery.localized
        let referalCnt = " \(referalCount?.toString() ?? "") "
        let messageStr2 = forEvery + referalCnt + AccountConstant.newUser.localized
        inviteReferalMessageLabel.textColor = .white
        inviteReferalMessageLabel.attributeString(string: (messageStr1+"\n\n"+messageStr2), range1: NSRange(location: AccountConstant.inviteFriend.count, length: referalAmt.count), range2: NSRange(location: messageStr1.count+forEvery.count+2, length: referalCnt.count), color: inviteColor)
        
        referalCodeLabel.text = referalCode
        referalCountValueLabel.text = " \(userReferalCount?.toString() ?? "") "
        referalAmountValueLabel.text = (currency)+(userReferalAmount?.toString() ?? "0")
        
        //Static
        inviteReferCodeHeadLabel.text = AccountConstant.yourRefferalcode.localized
        staticReferalCountLabel.text = AccountConstant.referralCount.localized
        staticReferalAmountLabel.text = AccountConstant.referralAmount.localized
    }
    
    private func setCustomFont() {
        inviteReferalMessageLabel.font = .setCustomFont(name: .bold, size: .x14)
        referalCodeLabel.font = .setCustomFont(name: .light, size: .x16)
        referalCountValueLabel.font = .setCustomFont(name: .light, size: .x16)
        referalAmountValueLabel.font = .setCustomFont(name: .light, size: .x16)
        
        //Static
        inviteReferCodeHeadLabel.font = .setCustomFont(name: .bold, size: .x16)
        staticReferalCountLabel.font = .setCustomFont(name: .bold, size: .x16)
        staticReferalAmountLabel.font = .setCustomFont(name: .bold, size: .x16)
    }

    @objc func tapShare()  {
        var message = AccountConstant.inviteContent + referalCodeLabel.text! + "\n"
        message += APPConstant.userAppStoreLink + "\n"
        message += AccountConstant.haveGoodDay
        let activityViewController = UIActivityViewController(activityItems: [message], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        present(activityViewController, animated: true, completion: nil)
    }
    
    func setCurrency(amount:Double,currency:String) -> String  {
        return currency+amount.roundOff(2)
    }
}
