//
//  LanguageController.swift
//  GoJekProvider
//
//  Created by CSS on 04/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

class LanguageController: UIViewController {
    @IBOutlet weak var languageTableView: UITableView!

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var selectLanguageLabel: UILabel!
    
    var languageArr:[Languages] = []
    
    var selectedRow = -1
    
    var selectlanguage = ""
    
    private var selectedLanguage: Language = .english {
        didSet {
            LocalizeManager.share.setLocalization(language: selectedLanguage)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initalLoads()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.hideTabBar()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Hide show tabbar
        self.hideTabBar()
        self.navigationController?.isNavigationBarHidden = false
        self.accountPresenter?.fetchUserProfileDetails()

    }
}
extension LanguageController {
    private func initalLoads(){
        if isGuestAccount {
            localizable()
        }
        localization()
        setNavigationBar()
        
        self.languageTableView.register(nibName: AccountConstant.LanguageTableViewCell)
        setColor()
        self.saveButton.titleLabel?.font = UIFont.setCustomFont(name: .medium, size: .x18)
        selectLanguageLabel.font = UIFont.setCustomFont(name: .light, size: .x16)
        
        selectLanguageLabel.text = AccountConstant.selectLanguage.localized
        
        self.saveButton.backgroundColor = .appPrimaryColor
        saveButton.setTitle(Constant.SSave.localized, for: .normal)
        saveButton.tintColor = UIColor.white
        saveButton.addTarget(self, action: #selector(updateLanguages), for: .touchUpInside)
        DispatchQueue.main.async {
            self.saveButton.setCornerRadius()
        }
        let baseDetail = AppConfigurationManager.shared.baseConfigModel
        languageArr = baseDetail?.responseData?.appsetting?.languages ?? []
        self.languageTableView.reloadData()
        setDarkMode()
    }

    private func setDarkMode(){
        self.view.backgroundColor = .backgroundColor
        self.languageTableView.backgroundColor = .backgroundColor
    }
    
    private func setNavigationBar() {
       
        self.setNavigationTitle()
        self.setLeftBarButtonWith(color: .blackColor)
        self.title = AccountConstant.language.localized
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    private func setColor(){
        self.view.backgroundColor = .veryLightGray
        self.languageTableView.backgroundColor = .veryLightGray
    }
    
    @objc func updateLanguages(_ sender:UIButton) {
        if isGuestAccount {
            
            UserDefaults.standard.set(self.selectedLanguage.rawValue, forKey: AccountConstant.language)
            
            if let languageStr = UserDefaults.standard.value(forKey: AccountConstant.language) as? String, let language = Language(rawValue: languageStr) {
                LocalizeManager.share.setLocalization(language: language)
            }else {
                LocalizeManager.share.setLocalization(language: .english)
            }
            
            switchLanguagePage()
            localization()
        }else{
            let param:Parameters = [AccountConstant.Language: selectlanguage]
            self.accountPresenter?.updateLanguage(param: param)
        }
        
    }
    private func  localization() {
        
        self.title = AccountConstant.language.localized
        self.selectLanguageLabel.text = AccountConstant.selectLanguage.localized
        self.selectLanguageLabel.textColor = .blackColor
     
    }
}

// Tableview Delegate and DataSource
extension LanguageController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languageArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:LanguageTableViewCell = self.languageTableView.dequeueReusableCell(withIdentifier: AccountConstant.LanguageTableViewCell, for: indexPath) as! LanguageTableViewCell
       
        let languagedict = languageArr[indexPath.row]
        cell.languageNameLabel.text = languagedict.name?.localized
        if selectlanguage == languagedict.key {
            cell.languageNameLabel.textColor = .blackColor
            cell.radioImageView.image = UIImage(named: Constant.circleFullImage)
        }
        else {
            cell.languageNameLabel.textColor = .lightGray
            cell.radioImageView.image = UIImage(named: Constant.circleImage)
        }
        cell.radioImageView.setImageColor(color: .blackColor)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        if (tableView == self.languageTableView)
        {
            cell.backgroundColor = .white
            let radius = 8.0
            //Top Left Right Corners
            let maskPathTop = UIBezierPath(roundedRect: cell.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: radius, height: radius))
            let shapeLayerTop = CAShapeLayer()
            shapeLayerTop.frame = cell.bounds
            shapeLayerTop.path = maskPathTop.cgPath
            
            //Bottom Left Right Corners
            let maskPathBottom = UIBezierPath(roundedRect: cell.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: radius, height: radius))
            let shapeLayerBottom = CAShapeLayer()
            shapeLayerBottom.frame = cell.bounds
            shapeLayerBottom.path = maskPathBottom.cgPath
            
            //All Corners
            let maskPathAll = UIBezierPath(roundedRect: cell.bounds, byRoundingCorners: [.topLeft, .topRight, .bottomRight, .bottomLeft], cornerRadii: CGSize(width: radius, height: radius))
            let shapeLayerAll = CAShapeLayer()
            shapeLayerAll.frame = cell.bounds
            shapeLayerAll.path = maskPathAll.cgPath
            let count = Language.allCases.count
            if (indexPath.row == 0 && indexPath.row == count-1)
            {
                cell.layer.mask = shapeLayerAll
            }
            else if (indexPath.row == 0)
            {
                cell.layer.mask = shapeLayerTop
            }
            else if (indexPath.row == count-1)
            {
                cell.layer.mask = shapeLayerBottom
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = languageTableView.cellForRow(at: indexPath) as! LanguageTableViewCell
        let languagedict = languageArr[indexPath.row]
        let language = Language.allCases[indexPath.row]
        selectedLanguage = language
        if cell.radioImageView.image?.isEqual(to: UIImage(named: Constant.circleImage) ?? UIImage()) ?? false {
            selectlanguage = languagedict.key ?? .empty
            cell.radioImageView.image = UIImage(named: Constant.circleFullImage)
        }
        else {
            cell.radioImageView.image = UIImage(named: Constant.circleImage)
        }
        languageTableView.reloadData()
    }
}

extension LanguageController: AccountPresenterToAccountViewProtocol {
    
    func updateLanguageSuccess(updateLanguageEntity: LogoutEntity) {
        UserDefaults.standard.set(self.selectedLanguage.rawValue, forKey: AccountConstant.language)
        if let languageStr = UserDefaults.standard.value(forKey: AccountConstant.language) as? String, let language = Language(rawValue: languageStr) {
            LocalizeManager.share.setLocalization(language: language)
        }else {
            LocalizeManager.share.setLocalization(language: .english)
        }
        
        switchLanguagePage()
         localization()
        ToastManager.show(title: AccountConstant.languageSuccess.localized, state: .success)


    }
    
    func showUserProfileDtails(details: UserProfileResponse) {
        print(details)
        selectlanguage = details.responseData?.language ?? ""
    
        UserDefaults.standard.set(self.selectlanguage, forKey: AccountConstant.language)
      
         localizable()
        self.languageTableView.reloadData()
        self.localization()
    }
    
    private func switchLanguagePage() {
        self.navigationController?.isNavigationBarHidden = true
        guard let transitionView = self.navigationController?.view else {return}
        let settingVc = AccountRouter.accountStoryboard.instantiateViewController(withIdentifier:AccountConstant.LanguageController)
        
        UIView.beginAnimations("anim", context: nil)
        UIView.setAnimationDuration(0.8)
        UIView.setAnimationCurve(.easeInOut)
        UIView.setAnimationTransition(self.selectedLanguage == .arabic ? .flipFromLeft : .flipFromRight, for: transitionView, cache: false)
        self.navigationController?.pushViewController(settingVc, animated: true)
        self.navigationController?.isNavigationBarHidden = false
    
        UIView.commitAnimations()
        if (navigationController?.viewControllers.count ?? 0) > 2 {
            self.navigationController?.viewControllers.remove(at: 1)
        }
    }
   
    private func localizable() {
        
        if let languageStr = UserDefaults.standard.value(forKey: AccountConstant.language) as? String, let language = Language(rawValue: languageStr) {
            LocalizeManager.share.setLocalization(language: language)
            self.selectedLanguage = language
            selectlanguage = language.code
        }else {
            LocalizeManager.share.setLocalization(language: .english)
            selectlanguage = "en"
        }
    }
}
