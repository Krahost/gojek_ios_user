//
//  HomeViewController.swift
//  GoJekUser
//
//  Created by apple on 20/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var locationHeaderView: UIView!
    @IBOutlet weak var staticLocationLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationIconImageView: UIImageView!
    @IBOutlet weak var dropDownImageView: UIImageView!
    
    var serviceListCollection: ServiceListCollection?
    var isAppPresentTapOnPush:Bool = false 
    var promoCodeListArr:[PromocodeData] = []
    var featuredService: [ServicesDetails]?
    var isFromOrderChat: Bool = false
    var isFromServiceChat: Bool = false
    private var selectedLanguage: Language = .english {
        didSet {
            LocalizeManager.share.setLocalization(language: selectedLanguage)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadingIndicator.show()
        self.initialLoads()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showTabBar()
        
        // isAppPresentTapOnPush == false
        navigationController?.isNavigationBarHidden = true
        isAppPresentTapOnPush = false
        
        ChatPushClick.shared.clear()
        staticLocationLabel.text = HomeConstant.location.localized
        BackGroundRequestManager.share.stopBackGroundRequest()
        isFromServiceChat = false
        isFromOrderChat = false
        if !isGuestAccount {
            guestAccountCity = .empty
            self.loadHomeDetil(cityId: .empty)
        }
        
        addNotificationObservers()
        DispatchQueue.main.async {
            let btnTitle = self.serviceListCollection?.showMoreButton.isSelected ?? false ? HomeConstant.showLess.localized : HomeConstant.showMore.localized
            self.serviceListCollection?.showMoreButton.setTitle(btnTitle, for: .normal)
            self.homeTableView.reloadData()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

// MARK: - LocalMethod
extension HomeViewController {
    
    func initialLoads() {
        loadServiceListNib()
        defaultIconSetup()
        addGestureForMoreButton()
        guestAccountLoadFirstCtiy()
        setDarkMode()
    }
    
    
    private func setDarkMode(){
        homeTableView.backgroundColor = .backgroundColor
        self.view.backgroundColor = .backgroundColor
        self.locationHeaderView.backgroundColor = .boxColor
    }
    
    private func guestAccountLoadFirstCtiy() {
        if isGuestAccount {
            let baseEntity = AppConfigurationManager.shared.baseConfigModel.responseData
            let countryArray = AppManager.shared.getCountries()
            let countryCode = AppManager.shared.getUserDetails()?.country?.id ?? baseEntity?.appsetting?.country
            let cityArray = countryArray?.filter({$0.id == countryCode}).first
            locationLabel.text = cityArray?.city?.first?.city_name
            guard let cityId = cityArray?.city?.first?.id else {
                return
            }
            guestAccountCity = "\(cityId)"
            loadHomeDetil(cityId: "\(cityId)")
        }
    }
    
    //Controller Basic Custom Methods
    private func addGestureForMoreButton() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapLocation))
        self.locationHeaderView.addGestureRecognizer(gesture)
    }
    
    private func defaultIconSetup() {
        self.view.backgroundColor = .veryLightGray
        self.tabBarController?.tabBar.tintColor = .appPrimaryColor
        
        locationIconImageView.image = UIImage(named: Constant.ic_location_pin)
        locationIconImageView.imageTintColor(color1: .appPrimaryColor)
        
        dropDownImageView.image = UIImage(named: Constant.ic_downarrow)
        dropDownImageView.imageTintColor(color1: .lightGray)
        staticLocationLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        locationLabel.font = UIFont.setCustomFont(name: .medium, size: .x12)
        
        staticLocationLabel.text = HomeConstant.location.localized
        staticLocationLabel.textColor = .appPrimaryColor
    }
    
    func addNotificationObservers() {
        // push redirection
        NotificationCenter.default.addObserver(self, selector: #selector(isTransportRedirection), name: Notification.Name(rawValue: pushNotificationType.transport.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(isServicePushRedirection), name: Notification.Name(rawValue: pushNotificationType.service.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(isFoodiePushRedirection), name: Notification.Name(pushNotificationType.order.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(isTransportChatRedirection), name: Notification.Name(rawValue: pushNotificationType.chat_transport.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(isFoodieChatPushRedirection), name: Notification.Name(rawValue: pushNotificationType.chat_order.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(isServiceChatPushRedirection), name: Notification.Name(rawValue: pushNotificationType.chat_servce.rawValue), object: nil)
    }
    
    private func loadServiceListNib() {
        self.homeTableView.register(UINib(nibName: HomeConstant.OfferCouponCell, bundle: nil), forCellReuseIdentifier: HomeConstant.OfferCouponCell)
        self.homeTableView.register(UINib(nibName: HomeConstant.RecommendedTableCell, bundle: nil), forCellReuseIdentifier: HomeConstant.RecommendedTableCell)
        if serviceListCollection == nil, let serviceListCollection = Bundle.main.loadNibNamed(HomeConstant.ServiceListCollection, owner: self, options: [:])?.first as? ServiceListCollection {
            self.serviceListCollection = serviceListCollection
            self.serviceListCollection?.delegate = self
            self.homeTableView.tableHeaderView =  serviceListCollection
        }
    }
    
    @objc func tapLocation() {
        if isGuestAccount
        {
            ToastManager.show(title: HomeConstant.guestLocationAlert.localized , state: .error)
        }
        else
        {
        let changeCityVC = LoginRouter.loginStoryboard.instantiateViewController(withIdentifier: LoginConstant.CountryCodeViewController) as! CountryCodeViewController
        changeCityVC.pickerType = .cityList
        let baseEntity = AppConfigurationManager.shared.baseConfigModel.responseData
        let countryArray = AppManager.shared.getCountries()
        let countryCode = AppManager.shared.getUserDetails()?.country?.id ?? baseEntity?.appsetting?.country
        let cityArray = countryArray?.filter({$0.id == countryCode})
        changeCityVC.cityListEntity = cityArray?.first?.city ?? [CityData]()
        changeCityVC.selectedCity = { [weak self] cityDetail in
            guard let self = self else {
                return
            }
            self.userCityDetails(cityID: "\(cityDetail.id!)")
            self.locationLabel.text = cityDetail.city_name
        }
        navigationController?.pushViewController(changeCityVC, animated: true)
      }
    }
    
    private func userCityDetails(cityID: String) {
        if isGuestAccount {
            guestAccountCity = cityID
            loadHomeDetil(cityId: cityID)
        } else {
            guestAccountCity = .empty
            let param: Parameters = [LoginConstant.city_id: cityID]
            homePresenter?.userCity(param: param)
        }
    }
    
    private func loadHomeDetil(cityId: String) {
        let param: Parameters = [LoginConstant.city_id: cityId]
        homePresenter?.getHomeDetails(param: param)
    }
    
    private func xuberRedirect() {
        if isGuestAccount {
            xuberSelectionViewRedirect()
        }else {
            homePresenter?.getXuberRequest()
        }
    }
    
    private func showCourierRequest(){
        if isGuestAccount {
            let vc = CourierRouter.createCourierModule()
            vc.hidesBottomBarWhenPushed = true
            UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
        }else{
            homePresenter?.checkCourierRequest()
        }
    }
    
    private func xuberSelectionViewRedirect() {
        let vc = XuberRouter.createXuberServiceModule()
        let serviceDetail = AppManager.shared.getSelectedServices()
        SendRequestInput.shared.mainServiceId = serviceDetail?.menu_type_id ?? 0
        SendRequestInput.shared.mainSelectedService = serviceDetail?.title ?? ""
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func foodieRedirect() {
        if isGuestAccount {
            let vc = FoodieRouter.createFoodieModule()
            vc.hidesBottomBarWhenPushed = true
            UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
        }else {
            homePresenter?.getCheckRequest()
        }
    }
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if featuredService?.count == 0 {
            return 1
        }else{
            return (featuredService?.count ?? 0) + 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView == homeTableView ? 0 : 25
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = self.homeTableView.dequeueReusableCell(withIdentifier: HomeConstant.OfferCouponCell, for: indexPath) as! OfferCouponCell
            cell.setCouponCellData(couponData: promoCodeListArr)
            if featuredService?.count == 0 {
                cell.recommendedLabel.isHidden = true
            }else{
                cell.recommendedLabel.isHidden = false
            }
            return cell
        }else {
            guard let data = featuredService else {
                return UITableViewCell()
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeConstant.RecommendedTableCell, for: indexPath) as! RecommendedTableCell
            cell.setRecommendedData(dataSource: data, indexPath: indexPath)
            return cell
            
        }
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  indexPath.row == 0 ? 300 : 130 //UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            if featuredService?.count != 0 {
                let index = indexPath.row - 1
                let selectedService = featuredService?[index]
                AppManager.shared.setSelectedServices(service: selectedService!)
                
                switch selectedService?.service?.admin_service_name ?? "" {
                case MasterServices.Transport.rawValue:
                    let vc = TaxiRouter.createTaxiModule(rideTypeId: selectedService?.menu_type_id ?? 0)
                    vc.hidesBottomBarWhenPushed = true
                    navigationController?.pushViewController(vc, animated: true)
                case MasterServices.Order.rawValue:
                    foodieRedirect()
                case MasterServices.Service.rawValue:
                    xuberRedirect()
                default:
                    break
                }
            }
        }
    }
}

// push redirection methods

extension HomeViewController {
    
    // For Transport push redirection
    @objc func isTransportRedirection() {
        if isAppPresentTapOnPush == false {
            isAppPresentTapOnPush = true
            let taxiHomeViewController = TaxiRouter.createTaxiModule(rideTypeId: 0)
            navigationController?.pushViewController(taxiHomeViewController, animated: true)
        }
    }
    
    //For service push redirection
    @objc func isServicePushRedirection() {
        if isAppPresentTapOnPush == false {
            isAppPresentTapOnPush = true
            isFromServiceChat = false
            homePresenter?.getXuberRequest()
        }
    }
    
    //For foodie(order) push redirection
    @objc func isFoodiePushRedirection() {
        if isAppPresentTapOnPush == false {
            isAppPresentTapOnPush = true
            isFromOrderChat = false
            homePresenter?.getCheckRequest()
        }
    }
    @objc func isTransportChatRedirection() {
        if ChatPushClick.shared.isPushClick == false {
            ChatPushClick.shared.isPushClick = true
            let taxiHomeViewController = TaxiRouter.createTaxiModuleChat(rideTypeId: 0)
            taxiHomeViewController.hidesBottomBarWhenPushed = true
            UIApplication.topViewController()?.navigationController?.pushViewController(taxiHomeViewController, animated: true)
        }
    }
    @objc func isFoodieChatPushRedirection() {
        if  ChatPushClick.shared.isOrderPushClick == false {
            ChatPushClick.shared.isOrderPushClick = true
            isFromOrderChat = true
            homePresenter?.getCheckRequest()
            
        }
    }
    @objc func isServiceChatPushRedirection() {
        if  ChatPushClick.shared.isServicePushClick == false {
            ChatPushClick.shared.isServicePushClick = true
            isFromServiceChat = true
            homePresenter?.getXuberRequest()
        }
    }
    
    
}

//MARK:- HomeAddMoreDelegate
extension HomeViewController: HomeAddMoreDelegate {
    
    func callCheckRequest(isFlowRequest: String) {
        if Flow.foodie == isFlowRequest {
            foodieRedirect()
        }else if Flow.service == isFlowRequest {
            xuberRedirect()
        }else if Flow.courier == isFlowRequest {
            showCourierRequest()
        }
        
    }
    
    func tapShowMore(height: Double) {
        UIView.animate(withDuration: 1.0, animations: {
            self.homeTableView.tableHeaderView?.frame.size.height = CGFloat(height)
            
            DispatchQueue.main.async {
                self.homeTableView.reloadData()
                self.homeTableView.layoutIfNeeded()
                self.homeTableView.contentOffset = CGPoint.zero
            }
        } )
    }
}

//MARK:- HomePresenterToHomeViewProtocol
extension HomeViewController: HomePresenterToHomeViewProtocol {
    
    func checkCourierRequest(requestEntity: Request) {
        if requestEntity.responseData?.data?.count == 0 {
            let vc = CourierRouter.createCourierModule()
            vc.hidesBottomBarWhenPushed = true
            UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
        }else{
            let courierHomeVC = CourierRouter.createCourierHomeModule()
            courierHomeVC.hidesBottomBarWhenPushed = true
            UIApplication.topViewController()?.navigationController?.pushViewController(courierHomeVC, animated: true)
        }
    }
    
    func showUserProfileDtails(details: UserProfileResponse) {
        var userDetails:UserProfileEntity = UserProfileEntity()
        userDetails = details.responseData ?? UserProfileEntity()
        
        DispatchQueue.main.async {
            self.locationLabel.text = (userDetails.city?.city_name ?? "") + " ," + (userDetails.country?.country_code ?? "")
            if !CommonFunction.checkisRTL() {
                UserDefaults.standard.set(userDetails.language, forKey: AccountConstant.language)
                self.localizable()
            }
        }
        AppManager.shared.setUserDetails(details: userDetails)
        homePresenter?.getSavedAddress()
    }
    
    // get address for saved locations
    func savedAddressSuccess(addressEntity: SavedAddressEntity) {
        LoadingIndicator.hide()
        
        if let address = addressEntity.responseData {
            AppManager.shared.setSavedAddress(address: address)
        }
    }
    
    private func localizable() {
        if let languageStr = UserDefaults.standard.value(forKey: AccountConstant.language) as? String, let language = Language(rawValue: languageStr) {
            LocalizeManager.share.setLocalization(language: language)
            selectedLanguage = language
            
        }else {
            LocalizeManager.share.setLocalization(language: .english)
        }
        if !CommonFunction.isAppAlreadyLaunchedOnce() {
            if self.selectedLanguage == .arabic {
                self.view.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                
            }else {
                view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
            DispatchQueue.main.async {
                let btnTitle = self.serviceListCollection?.showMoreButton.isSelected ?? false ? HomeConstant.showLess.localized : HomeConstant.showMore.localized
                self.serviceListCollection?.showMoreButton.setTitle(btnTitle, for: .normal)
                self.homeTableView.reloadData()
            }
        }
        if !CommonFunction.checkisRTL() {
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        showTabBar()
    }
    
    func showHomeDetails(details: HomeEntity) {
        if let serviceListView = homeTableView.tableHeaderView as? ServiceListCollection {
            let menuservice = details.responseData?.services ?? [ServicesDetails]()
            promoCodeListArr = details.responseData?.promocodes ?? []
            serviceListView.setServiceDataSource(services:menuservice )
            featuredService = menuservice.filter({$0.is_featured ?? 0 == 1})
            DispatchQueue.main.async {
                self.homeTableView.reloadData()
            }
        }
        homePresenter?.fetchUserProfileDetails()
    }
    
    func showUserCity(selectedCityDetails: UserCity) {
        loadHomeDetil(cityId: .empty)
    }
    
    func getCheckRequestResponse(checkRequestEntity: FoodieCheckRequestEntity) {
        let vc = FoodieRouter.createFoodieModule()
        vc.hidesBottomBarWhenPushed = true
        UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func xuberCheckRequest(xuberReesponse: XuberRequestEntity) {
        if (xuberReesponse.request?.data?.count ?? 0) > 0 {
            let vc = XuberRouter.createXuberModule(isChat: isFromServiceChat)
            vc.hidesBottomBarWhenPushed = true
            UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
        }else {
            xuberSelectionViewRedirect()
        }
    }
}

