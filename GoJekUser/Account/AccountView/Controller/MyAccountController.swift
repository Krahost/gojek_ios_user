//
//  MyAccountController.swift
//  GoJekUser
//
//  Created by Ansar on 22/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class MyAccountController: UIViewController {
    
    @IBOutlet weak var accountCollectionView: UICollectionView!
    
    let actionSheet = AppActionSheet.shared
    var isAppPresentTapOnPush:Bool = false
    var accountImageArr = [AccountConstant.icprofile,
                           Constant.ic_location_pin,
                           Constant.payment,
                           Constant.walletSmall,
                           AccountConstant.icprivacyPolicy,
                           AccountConstant.icsupport,
                           AccountConstant.languageImage]
    
    var accountNameArr = [AccountConstant.profile.localized,
                          AccountConstant.manageAddress.localized,
                          AccountConstant.payment.localized,
                          AccountConstant.wallet.localized,
                          AccountConstant.privacyPolicy.localized,
                          AccountConstant.support.localized,
                          AccountConstant.language.localized]
    
    private var selectedLanguage: Language = .english {
        didSet {
            LocalizeManager.share.setLocalization(language: selectedLanguage)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoads()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showTabBar()
        self.title = AccountConstant.account.localized
        setupLanguage()
        self.accountCollectionView.reloadData()
        // Chat Notification
      //  NotificationCenter.default.addObserver(self, selector: #selector(isTransportChatRedirection), name: Notification.Name(rawValue: pushNotificationType.chat_transport.rawValue), object: nil)
    }
    
    
    private func setDarkMode(){
        self.view.backgroundColor = .backgroundColor
        self.accountCollectionView.backgroundColor = .backgroundColor
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
}

//MARK: - Methods

extension MyAccountController {
    
    private func initialLoads() {
        setNavigationTitle()
        self.view.backgroundColor = .veryLightGray
        setDarkMode()
        self.accountCollectionView.register(nibName: AccountConstant.AccountCollectionViewCell)
        let baseConfig = AppConfigurationManager.shared.baseConfigModel
        if !isGuestAccount {
            if (baseConfig?.responseData?.appsetting?.referral ?? 0) == 1 {
                accountImageArr.insert(AccountConstant.referFriend, at: 4)
                accountNameArr.insert(AccountConstant.inviteReferral, at: 4)
            }
        }
    }
    
    private func setupLanguage() {

        if let languageStr = UserDefaults.standard.value(forKey: AccountConstant.language) as? String, let language = Language(rawValue: languageStr) {
            LocalizeManager.share.setLocalization(language: language)
            selectedLanguage = language
        }else {
            LocalizeManager.share.setLocalization(language: .english)
        }
        
        if !isGuestAccount {
        
        if self.selectedLanguage == .arabic {
            let rightBarButton = UIBarButtonItem(image: UIImage(named: AccountConstant.logoutImage)?.imageFlippedForRightToLeftLayoutDirection(), style: .plain, target: self, action: #selector(tapMore))
            self.navigationItem.rightBarButtonItem  = rightBarButton
        }else {
            let rightBarButton = UIBarButtonItem(image: UIImage(named: AccountConstant.logoutImage), style: .plain, target: self, action: #selector(tapMore))
            self.navigationItem.rightBarButtonItem  = rightBarButton
        }
        self.navigationItem.rightBarButtonItem?.tintColor = .blackColor
        }
        //self.accountCollectionView.reloadInMainThread()
    }

    private func push(id: String)  {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: id)
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @objc private func tapMore() {
        actionSheet.showActionSheet(viewController: self,message: AccountConstant.logoutMsg.localized, buttonOne: AccountConstant.logout.localized)
        actionSheet.onTapAction = { [weak self] tag in
            guard let self = self else {
                return
            }
            if isGuestAccount {
                self.logOutProcess()
            }else {
                self.accountPresenter?.toLogout()
            }
        }
    }
    
    private func pushPrivacyPolicy() {
        let vc = WebViewController()
        if let privacyUrl = AppConfigurationManager.shared.baseConfigModel.responseData?.appsetting?.cmspage?.privacypolicy {
            vc.urlString = privacyUrl
        }
        vc.navTitle = AccountConstant.privacyPolicy.localized
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func logOutProcess() {
        AppConfigurationManager.shared.baseConfigModel = nil
         AppManager.shared.accessToken = ""
        PersistentManager.shared.delete(entityName: CoreDataEntity.loginData.rawValue)
        PersistentManager.shared.delete(entityName: CoreDataEntity.userData.rawValue)
        BackGroundRequestManager.share.stopBackGroundRequest()
        let walkThrough = LoginRouter.loginStoryboard.instantiateViewController(withIdentifier: LoginConstant.SplashViewController)
        CommonFunction.changeRootController(controller: walkThrough)
    }
}


//MARK: - Collectionview delegate

extension MyAccountController:UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let baseConfig = AppConfigurationManager.shared.baseConfigModel
        var isReferalEnable = false
        if isGuestAccount {
            isReferalEnable = false
        }else{
            isReferalEnable = (baseConfig?.responseData?.appsetting?.referral ?? 0) == 1
        }
        switch indexPath.row {
        case 0:
            self.push(id: AccountConstant.MyProfileController)
        case 1:
            self.push(id: AccountConstant.ManageAddressController)
        case 2:
            self.push(id: AccountConstant.PaymentSelectViewController)
        case 3:
            self.push(id: AccountConstant.PaymentController)
        case 4:
            if isReferalEnable {
                self.push(id: AccountConstant.InviteController)
            }else {
                pushPrivacyPolicy()
            }
        case 5:
            if isReferalEnable {
                pushPrivacyPolicy()
            }else {
                self.push(id: AccountConstant.SupportController)
            }
        case 6:
            if isReferalEnable {
                self.push(id: AccountConstant.SupportController)
            }else {
                self.push(id: AccountConstant.LanguageController)
            }
        case 7:
            self.push(id: AccountConstant.LanguageController)
        default:
            break
        }
    }
}

//MARK: - Collectionview datasource

extension MyAccountController:UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return accountNameArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:AccountCollectionViewCell = self.accountCollectionView.dequeueReusableCell(withReuseIdentifier: AccountConstant.AccountCollectionViewCell, for: indexPath) as! AccountCollectionViewCell
        cell.setValues(name: accountNameArr[indexPath.item].localized, imageString: accountImageArr[indexPath.item])
        cell.layoutIfNeeded()
        return cell
    }
}

extension MyAccountController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let width:CGFloat = (self.accountCollectionView.frame.size.width - space) / 2.0
        let height:CGFloat = (self.accountCollectionView.frame.size.width - space) / 2.5
       
        return CGSize(width: width, height: height)
    }
}

//MARK: API

extension MyAccountController: AccountPresenterToAccountViewProtocol {
    
    func getLogoutSuccess(logoutEntity: LogoutEntity) {
        
        self.logOutProcess()
    }
}

/*
//MARK: CHAT NOTIFICATION
extension MyAccountController {
@objc func isTransportChatRedirection() {
           if isAppPresentTapOnPush == false {
               isAppPresentTapOnPush = true
               print("idPush")
               let taxiHomeViewController = TaxiRouter.createTaxiModuleChat(rideTypeId: 0)
               navigationController?.pushViewController(taxiHomeViewController, animated: true)
          }
}
}
*/
