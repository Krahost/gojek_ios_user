//
//  OrdersController.swift
//  GoJekUser
//
//  Created by CSS01 on 20/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class OrdersController: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var ordersTableView: UITableView!
    @IBOutlet weak var filterBtnView: RoundedView!
    @IBOutlet weak var pastOrderButton: UIButton!
    @IBOutlet weak var currentOrderButton: UIButton!
    @IBOutlet weak var upcomingOrderButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    
    //MARK: - LocalVariable
    var filterView: FilterView!
    var isAppPresentTapOnPush:Bool = false
    var orderHistoryData: HistoryResponseData? { //HistoryResponseData
        didSet{
            self.ordersTableView.reloadInMainThread()
        }
    }
    var foodieData: FoodieHistoryResponse?
    var foodieHistoryData: [FoodieHistoryData]? =  []
    
//    var offSet: Int = 0
//    var limit:Int = 10
    var isUpdate:Bool = false
    var nextpageurl = ""
    var currentPage = 1
        
    var historyType:historyType = .past {
        didSet {
            updateUI()
        }
    }
    var selectedServiceType:String = ""
    var currentServiceType:ServiceType = .trips
    
    // View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
          if guestLogin() {
        self.initialLoad()
        }
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        showTabBar()
        setDarkMode()
        currentPage = 1
        if historyType == .upcoming {
            getUpcoming()
        }else{
            
            if currentServiceType == .orders {
                self.getFoodieHistory()
            }else{
                getOrderHistory()
            }
        }
        self.navigationController?.isNavigationBarHidden = false
        addNavigationTitle()
        self.setLocalization()
        
        //Chat Notification
        //              NotificationCenter.default.addObserver(self, selector: #selector(isTransportChatRedirection), name: Notification.Name(rawValue: pushNotificationType.chat_transport.rawValue), object: nil)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 13.0, *) {
            if UITraitCollection.current.userInterfaceStyle == .dark {
                isDarkMode = true
            }
            else {
                isDarkMode = false
            }
        }
        else{
            isDarkMode = false
        }
        setDarkMode()
    }
    
}

//MARK: - LocalMethod
extension OrdersController {
    
    func initialLoad() {
        self.ordersTableView.register(nibName: OrderConstant.VOrderTableViewCell)
        let recong = UITapGestureRecognizer(target: self, action: #selector(filterAction))
        self.filterBtnView.addGestureRecognizer(recong)
        filterBtnView.layer.cornerRadius = 50/2

        filterBtnView.layer.masksToBounds = false
        filterBtnView.backgroundColor = .white

        let image = UIImage(named: OrderConstant.icfilter)?.withRenderingMode(.alwaysTemplate)
        filterButton.setImage(image, for: .normal)
        filterButton.tintColor = UIColor.appPrimaryColor
        historyType = .past
        ordersTableView.contentInsetAdjustmentBehavior = .never
    }
    
    private func setDarkMode(){
        self.view.backgroundColor = .backgroundColor
        self.filterBtnView.backgroundColor = .boxColor
        if(isDarkMode){
            filterBtnView.borderColor = .blackColor
            filterBtnView.layer.borderWidth = 1
            filterBtnView.addShadowWithRadius(shadowColor: UIColor.lightGray, shadowOpacity: 0.0, shadowRadius:0.0, shadowOffset: CGSize(width: CGFloat(0.0), height: CGFloat(0.2)))
        }
        else{
        filterBtnView.borderColor = .blackColor
        filterBtnView.layer.borderWidth = 0
        filterBtnView.addShadowWithRadius(shadowColor: UIColor.lightGray, shadowOpacity: 3.0, shadowRadius:8.0, shadowOffset: CGSize(width: CGFloat(0.0), height: CGFloat(0.2)))
        }
    }
    
    private func addNavigationTitle(){
        self.navigationItem.setTwoLineTitle(lineOne: OrderConstant.history.localized, lineTwo: currentServiceType.currentType.capitalized)
    }
    
    private func setLocalization() {
        
        self.pastOrderButton.setTitle(OrderConstant.past.localized, for: .normal)
        self.currentOrderButton.setTitle(OrderConstant.current.localized, for: .normal)
        self.upcomingOrderButton.setTitle(OrderConstant.upComing.localized, for: .normal)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        pastOrderButton.setBothCorner()
        currentOrderButton.setBothCorner()
        upcomingOrderButton.setBothCorner()
    }
    
    private func updateUI() {
        let currentColor = historyType == .ongoing ? UIColor.appPrimaryColor : UIColor.boxColor
        let pastColor = historyType == .past ? UIColor.appPrimaryColor : UIColor.boxColor
        let upcomingColor = historyType == .upcoming ? UIColor.appPrimaryColor : UIColor.boxColor
        let currentTextColor = historyType == .ongoing ? UIColor.white : UIColor.blackColor
        let pastTextColor = historyType == .past ? UIColor.white : UIColor.blackColor
        let upcomingTextColor = historyType == .upcoming ? UIColor.white : UIColor.blackColor
        currentOrderButton.setBorderwithColor(borderColor: currentColor, textColor: currentTextColor, backGroundColor: currentColor, borderWidth: 1)
        pastOrderButton.setBorderwithColor(borderColor: pastColor, textColor: pastTextColor, backGroundColor: pastColor, borderWidth: 1)
        upcomingOrderButton.setBorderwithColor(borderColor: upcomingColor, textColor: upcomingTextColor, backGroundColor: upcomingColor, borderWidth: 1)
    }
    
    private func getOrderHistory() {
        
        ordersPresenter?.getOrder(isHideLoader: true, serviceType: currentServiceType, parameter: [OrderConstant.PPage:currentPage,OrderConstant.type: self.historyType.currentType])
    }
    
    private func getUpcoming() {
        ordersPresenter?.getUpcoming(isHideLoader: true, serviceType: currentServiceType, parameter: [OrderConstant.PPage:currentPage, OrderConstant.type: self.historyType.currentType])
    }
    
    private func getFoodieHistory()  {
        ordersPresenter?.getFoodieOrderList(isHideLoader: true, serviceType: .orders, parameter: [OrderConstant.PPage:currentPage, OrderConstant.type: self.historyType.currentType])
    }
}

//MARK:- Actions

extension OrdersController {
    
    @IBAction func pastOrderButtonAction(_ sender: Any) {
        historyType = .past
        currentPage = 1

        if currentServiceType == .orders {
            getFoodieHistory()

        }else{

        getOrderHistory()
        }
    }
    
    @IBAction func currentOrderButtonAction(_ sender: Any) {
        historyType = .ongoing
        currentPage = 1

        if currentServiceType == .orders {
            getFoodieHistory()
            
        }else{
            
            getOrderHistory()
        }
    }
    
    @IBAction func upcomingOrderButton(_ sender: Any) {
        historyType = .upcoming
        getUpcoming()
    }
    
}


//MARK: - IBAction
extension OrdersController{
    
    @objc func filterAction() {        
        if self.filterView == nil {
            self.filterView = Bundle.main.loadNibNamed(Constant.VFilterView, owner: self, options: [:])?.first as? FilterView
            let height = (self.view.frame.height/100)*25
            self.filterView.frame = CGRect(x: 0, y: self.view.frame.height-height-50, width: self.view.frame.width, height: height)
            for index in 0..<ServiceType.allCases.count {
                    if self.orderHistoryData?.type == ServiceType.allCases[index].currentType {
                        self.filterView.selectedType = index+1
                    }
                
                    if self.foodieData?.type == ServiceType.allCases[index].currentType {
                        self.filterView.selectedType = index+1
                    }
            }
            self.filterView?.show(with: .bottom, completion: nil)
            self.showDimView(view: self.filterView)
        }
        self.filterView.onTapServices = { [weak self] serviceType in
            
            
            guard let self = self else {
                return
            }
            self.selectedServiceType = serviceType.currentType
            self.navigationItem.setTwoLineTitle(lineOne: OrderConstant.history.localized, lineTwo:serviceType.currentType)
            self.currentPage = 1

            self.currentServiceType = serviceType
            if serviceType == .trips && serviceType == .service {
                if self.historyType == .upcoming {
                    self.getUpcoming()
                }
            }else{
                if serviceType == .orders {
                    self.upcomingOrderButton.isHidden = true
                    self.getFoodieHistory()
                }else{
                    self.upcomingOrderButton.isHidden = false
                    self.getOrderHistory()
                }
            }
            self.filterView.superview?.dismissView(onCompletion: {
                self.filterView = nil
            })
        }
    }
    
    private func showDimView(view: UIView) {
        let dimView = UIView(frame: self.view.frame)
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        dimView.addSubview(view)
        self.view.addSubview(dimView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.filterView != nil {
            self.filterView.superview?.dismissView(onCompletion: {
                self.filterView = nil
            })
        }
    }
    
    //Chat redirection
    
    func navigateToChat(orderHistoryData:HistoryResponseData, currentType:ServiceType, chatRequestFrom:MasterServices) {
        
        var checkRequestDetail:Transport?
        
        if currentType == .trips {
            checkRequestDetail = orderHistoryData.transport?.data?.first
        }else {
            checkRequestDetail = orderHistoryData.service?.data?.first
        }
        let providerDetail = checkRequestDetail?.provider
        let userDetail = checkRequestDetail?.user
        
        let chatView = ChatViewController()
        chatView.requestId = "\((checkRequestDetail?.id ?? 0))"
        chatView.chatRequestFrom = chatRequestFrom.rawValue
        chatView.userId = "\((userDetail?.id ?? 0))"
        chatView.userName = "\( userDetail?.firstName ?? "")" + " " + "\(userDetail?.lastName ?? "")"
        chatView.providerId = "\((providerDetail?.id ?? 0))"
        chatView.providerName = "\(providerDetail?.first_name ?? "")" + " " + "\(providerDetail?.last_name ?? "")"
        chatView.adminServiceId = currentType.currentType
        self.navigationController?.pushViewController(chatView, animated: true)
    }
}

//MARK: - UITableViewDataSource
extension OrdersController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if historyType == .past {
            if currentServiceType == .trips {
                count = self.orderHistoryData?.transport?.data?.count ?? 0
                if self.orderHistoryData?.transport?.data?.count == 0 {
                    self.ordersTableView.setBackgroundImageAndTitle(imageName: OrderConstant.noHistoryImage, title: OrderConstant.noPastTrip.localized,tintColor: .blackColor)
                }else{
                    self.ordersTableView.backgroundView = nil
                }
            }else if currentServiceType == .service {
                count = self.orderHistoryData?.service?.data?.count ?? 0
                if self.orderHistoryData?.service?.data?.count == 0 {
                    self.ordersTableView.setBackgroundImageAndTitle(imageName: OrderConstant.noHistoryImage, title: OrderConstant.noPastService.localized,tintColor: .blackColor)
                }else{
                    self.ordersTableView.backgroundView = nil
                }
            } else if currentServiceType == .delivery {
                count = orderHistoryData?.delivery?.data?.count ?? 0
                if count == 0{
                    self.ordersTableView.setBackgroundImageAndTitle(imageName: OrderConstant.noHistoryImage, title: OrderConstant.noPastDelivery.localized,tintColor: .blackColor)
                }
                else{
                    ordersTableView.backgroundView = nil
                }
            }
            else{
                count = self.foodieHistoryData?.count ?? 0
                if count == 0 {
                    self.ordersTableView.setBackgroundImageAndTitle(imageName: OrderConstant.noHistoryImage, title: OrderConstant.noPastOrder.localized,tintColor: .blackColor)
                }else{
                    self.ordersTableView.backgroundView = nil
                }
            }
        }else if historyType == .ongoing{
            if currentServiceType == .trips {
                count = self.orderHistoryData?.transport?.data?.count ?? 0
                if self.orderHistoryData?.transport?.data?.count == 0 {
                    self.ordersTableView.setBackgroundImageAndTitle(imageName: OrderConstant.noHistoryImage, title: OrderConstant.noCurrentTrip.localized,tintColor: .blackColor)
                    
                }else{
                    self.ordersTableView.backgroundView = nil
                }
            }else  if currentServiceType == .service {
                count = self.orderHistoryData?.service?.data?.count ?? 0
                if self.orderHistoryData?.service?.data?.count == 0 {
                    self.ordersTableView.setBackgroundImageAndTitle(imageName: OrderConstant.noHistoryImage, title: OrderConstant.noCurrentService.localized,tintColor: .blackColor)
                }else{
                    self.ordersTableView.backgroundView = nil
                }
            }
                
            else if currentServiceType == .delivery
            {
                count = orderHistoryData?.delivery?.data?.count ?? 0
                if count == 0 {
                    self.ordersTableView.setBackgroundImageAndTitle(imageName: OrderConstant.noHistoryImage, title: OrderConstant.noCurrentDelivery.localized,tintColor: .blackColor)         }
                else
                {
                    ordersTableView.backgroundView = nil
                }
            }
            else {
                count = self.foodieHistoryData?.count ?? 0
                if count == 0 {
                    self.ordersTableView.setBackgroundImageAndTitle(imageName: OrderConstant.noHistoryImage, title: OrderConstant.noCurrentOrder.localized,tintColor: .blackColor)
                }else{
                    self.ordersTableView.backgroundView = nil
                }
            }
        }else if historyType == .upcoming{
            if currentServiceType == .trips {
                count = self.orderHistoryData?.transport?.data?.count ?? 0
                if self.orderHistoryData?.transport?.data?.count == 0 {
                    self.ordersTableView.setBackgroundImageAndTitle(imageName: OrderConstant.noHistoryImage, title: OrderConstant.noUpComingTrip.localized,tintColor: .blackColor)
                }else{
                    self.ordersTableView.backgroundView = nil
                }
            }else if currentServiceType  == .service {
                count = self.orderHistoryData?.service?.data?.count ?? 0
                if self.orderHistoryData?.service?.data?.count == 0 {
                    self.ordersTableView.setBackgroundImageAndTitle(imageName: OrderConstant.noHistoryImage, title: OrderConstant.noUpComingService.localized,tintColor: .blackColor)
                }else{
                    self.ordersTableView.backgroundView = nil
                }
            }
            else if currentServiceType == .delivery
            {
                count = orderHistoryData?.delivery?.data?.count ?? 0
                if count == 0
                {
                    self.ordersTableView.setBackgroundImageAndTitle(imageName: OrderConstant.noHistoryImage, title: OrderConstant.noUpComingDelivery.localized,tintColor: .blackColor)
                }
                else{
                    ordersTableView.backgroundView = nil
                }
            }
            else{
                count = self.foodieHistoryData?.count ?? 0
                if count == 0 {
                    self.ordersTableView.setBackgroundImageAndTitle(imageName: OrderConstant.noHistoryImage, title: OrderConstant.noUpComingOrder.localized,tintColor: .blackColor)
                }else{
                    self.ordersTableView.backgroundView = nil
                }
            }
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.ordersTableView.dequeueReusableCell(withIdentifier: OrderConstant.VOrderTableViewCell, for: indexPath) as! OrderTableViewCell
        
        cell.historyType = self.historyType
        cell.restaurantRatingView.isHidden = true//historyType != .past
        cell.ratingOuterView.isHidden = historyType != .past
        cell.orderTypeOuterView.isHidden = self.historyType != .past
      //  cell.trackOuterView.isHidden = self.historyType != .ongoing
        cell.chatOuterView.isHidden = self.historyType != .ongoing
     cell.trackOuterView.isHidden = true
        cell.onTapCall = { [weak self] in
            guard let self = self else {
                return
            }
            if self.currentServiceType ==  .trips {
                if (self.orderHistoryData?.transport?.data?.count ?? 0) > indexPath.row {
                    if let mobile = self.orderHistoryData?.transport?.data?[indexPath.row].provider?.mobile{
                        AppUtils.shared.call(to: mobile)
                    }
                }
            }else if self.currentServiceType == .service{
                if (self.orderHistoryData?.service?.data?.count ?? 0) > indexPath.row {
                    if let mobile = self.orderHistoryData?.service?.data?[indexPath.row].provider?.mobile{
                        AppUtils.shared.call(to: mobile)
                    }
                }
            }else if self.currentServiceType == .orders{
                if (self.foodieHistoryData?.count ?? 0) > indexPath.row {
                    if let mobile = self.foodieHistoryData?[indexPath.row].provider?.mobile {
                        AppUtils.shared.call(to: mobile)
                    }
                }
            }else if self.currentServiceType == .delivery{
                if (self.orderHistoryData?.delivery?.data?.count ?? 0) > indexPath.row {
                    if let mobile = self.orderHistoryData?.delivery?.data?[indexPath.row].provider?.mobile {
                        AppUtils.shared.call(to: mobile)
                    }
                }
            }else{
                if (self.orderHistoryData?.delivery?.data?.count ?? 0) > indexPath.row {
                    if let mobile = self.orderHistoryData?.delivery?.data?[indexPath.row].provider?.mobile {
                      AppUtils.shared.call(to: mobile)
                    }
                
                }
            }
        }
        
        cell.onTapChat = { [weak self] in
            guard let self = self else {
                return
            }
            if self.currentServiceType ==  .trips {
                self.navigateToChat(orderHistoryData: (self.orderHistoryData)!, currentType: self.currentServiceType,chatRequestFrom: MasterServices.Transport)
            }else if self.currentServiceType == .service {
                self.navigateToChat(orderHistoryData: (self.orderHistoryData)!, currentType: self.currentServiceType, chatRequestFrom:MasterServices.Service)
            }else if self.currentServiceType == .delivery {
                let checkRequestDetail = self.orderHistoryData?.delivery?.data?.first
                let providerDetail = checkRequestDetail?.provider
                let userDetail = checkRequestDetail?.user
                
                let chatView = ChatViewController()
                chatView.requestId = "\((checkRequestDetail?.id ?? 0))"
                chatView.chatRequestFrom = MasterServices.Delivery.rawValue
                chatView.userId = "\((userDetail?.id ?? 0))"
                chatView.userName = "\( userDetail?.first_name ?? "")" + " " + "\(userDetail?.last_name ?? "")"
                chatView.providerId = "\((providerDetail?.id ?? 0))"
                chatView.providerName = "\(providerDetail?.first_name ?? "")" + " " + "\(providerDetail?.last_name ?? "")"
                chatView.adminServiceId = self.currentServiceType.currentType
                
                self.navigationController?.pushViewController(chatView, animated: true)
            }else {
                let checkRequestDetail = self.foodieHistoryData?.first
                let providerDetail = checkRequestDetail?.provider
                let userDetail = checkRequestDetail?.user
                
                let chatView = ChatViewController()
                chatView.requestId = "\((checkRequestDetail?.id ?? 0))"
                chatView.chatRequestFrom = MasterServices.Order.rawValue
                chatView.userId = "\((userDetail?.id ?? 0))"
                chatView.userName = "\( userDetail?.firstName ?? "")" + " " + "\(userDetail?.lastName ?? "")"
                chatView.providerId = "\((providerDetail?.id ?? 0))"
                chatView.providerName = "\(providerDetail?.first_name ?? "")" + " " + "\(providerDetail?.last_name ?? "")"
                chatView.adminServiceId = self.currentServiceType.currentType
                
                self.navigationController?.pushViewController(chatView, animated: true)
            }
        }
        
        cell.onTapTrack = {
            
        }
        
        if currentServiceType ==  .trips {
            if let values = self.orderHistoryData?.transport?.data?[indexPath.row] {
                cell.setTransportValues(values: values,type: self.currentServiceType)
            }
        }else if currentServiceType == .service{
            if let values = self.orderHistoryData?.service?.data?[indexPath.row] {
                cell.setTransportValues(values: values,type: self.currentServiceType)
            }
        }else if currentServiceType == .orders{
            if let values = self.foodieHistoryData?[indexPath.row] {
                cell.setOrderValues(values: values,historyType: self.historyType)
            }
        }else{
            if let values = self.orderHistoryData?.delivery?.data?[indexPath.row]{
                cell.setCourierValues(values: values)
            }
        }
        return cell
    }
    
    
    
}

//MARK: - UITableViewDelegate
extension OrdersController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if historyType == .past {
            if currentServiceType == .trips || currentServiceType == .service
            {
                if ((self.orderHistoryData?.transport?.data?[indexPath.row].status != OrderConstant.cancelled) && (self.orderHistoryData?.service?.data?[indexPath.row].status != OrderConstant.cancelled))  {
                    
                    let vc = OrderRouter.orderStoryboard.instantiateViewController(withIdentifier: OrderConstant.VOrderDetailController) as! OrderDetailController
                    if currentServiceType == .trips {
                        vc.tripId = self.orderHistoryData?.transport?.data?[indexPath.row].id ?? 0
                    }else{
                        vc.tripId = self.orderHistoryData?.service?.data?[indexPath.row].id ?? 0
                    }
                    vc.selectedServiceType = self.currentServiceType
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }else if currentServiceType == .delivery {
                
                if self.orderHistoryData?.delivery?.data?[indexPath.row].status != OrderConstant.cancelled {
                    let vc = OrderRouter.orderStoryboard.instantiateViewController(withIdentifier: OrderConstant.VOrderDetailController) as! OrderDetailController
                    vc.tripId = self.orderHistoryData?.delivery?.data?[indexPath.row].id ?? 0
                    vc.selectedServiceType = self.currentServiceType
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                
            } else{
                if self.foodieHistoryData?[indexPath.row].status != OrderConstant.cancelled {
                    let vc = OrderRouter.orderStoryboard.instantiateViewController(withIdentifier: OrderConstant.VOrderDetailController) as! OrderDetailController
                    vc.tripId = self.foodieHistoryData?[indexPath.row].id ?? 0
                    vc.selectedServiceType = self.currentServiceType
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }else if historyType == .upcoming  {
            let vc = OrderRouter.orderStoryboard.instantiateViewController(withIdentifier: OrderConstant.OrderUpcomingDetailController) as! OrderUpcomingDetailController
            if currentServiceType == .trips {
                vc.selectedId = self.orderHistoryData?.transport?.data?[indexPath.row].id ?? 0
            }else if currentServiceType == .delivery {
                vc.selectedId = self.orderHistoryData?.delivery?.data?[indexPath.row].id ?? 0
            }else{
                vc.selectedId = self.orderHistoryData?.service?.data?[indexPath.row].id ?? 0
                
            }
            vc.selectedServiceType = self.currentServiceType
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            if self.currentServiceType == .trips {
                if let vc = TaxiRouter.createTaxiModule(rideTypeId: 0) as? TaxiHomeViewController {
                    vc.isFromOrderPage = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }else if self.currentServiceType == .service {
                let vc = XuberRouter.xuberStoryboard.instantiateViewController(withIdentifier: XuberConstant.XuberHomeController) as! XuberHomeController
                vc.isFromOrderPage = true
                self.navigationController?.pushViewController(vc, animated: true)
            }else if self.currentServiceType == .delivery {
                if let vc = CourierRouter.createCourierHomeModule() as? CourierHomeController {
                    vc.isFromOrderPage = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }else {
                if let vc =  FoodieRouter.createFoodieOrderStatusModule(isHome: false, orderId: self.foodieHistoryData?[indexPath.row].id ?? 0, isChat: false,isFromOrder: true) as? FoodieOrderStatusViewController {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if currentServiceType == .trips {
            if self.orderHistoryData?.transport?.data?.count ?? 0 > 10 {
                let lastCell  = (self.orderHistoryData?.transport?.data?.count ?? 0) - 3
                if indexPath.row == lastCell {
                    if nextpageurl != "" {
                    self.isUpdate = true
                    currentPage = currentPage + 1
                    self.getOrderHistory()
                    }
                }
            }
        }else if currentServiceType == .service {
            if self.orderHistoryData?.service?.data?.count ?? 0 > 10 {
                let lastCell  = (self.orderHistoryData?.service?.data?.count ?? 0) - 3
                if indexPath.row == lastCell {
                    if nextpageurl != "" {

                    self.isUpdate = true
                    currentPage = currentPage + 1
                    self.getOrderHistory()
                    }
                }
            }
        }else if currentServiceType == .delivery {
            if self.orderHistoryData?.delivery?.data?.count ?? 0 > 10 {
                let lastCell  = (self.orderHistoryData?.delivery?.data?.count ?? 0) - 3
                if indexPath.row == lastCell {
                    if nextpageurl != "" {

                    self.isUpdate = true
                    currentPage = currentPage + 1
                    self.getOrderHistory()
                    }
                }
            }
        }else{
            if self.foodieHistoryData?.count ?? 0 > 10 {
                let lastCell  = (self.foodieHistoryData?.count ?? 0) - 3
                if indexPath.row == lastCell {
                    if nextpageurl != "" {

                    self.isUpdate = true
                    currentPage = currentPage + 1
                    self.getOrderHistory()
                    }
                }
            }
        }
    }
}


extension OrdersController:  OrderPresenterToOrderViewProtocol {
    func getOrder(orderHistoryEntity: OrdersEntity) {
        self.orderHistoryData?.transport?.data?.removeAll()
        self.orderHistoryData?.service?.data?.removeAll()
        self.orderHistoryData?.delivery?.data?.removeAll()

        if self.isUpdate  {
            if self.currentServiceType == .trips {
                if (self.orderHistoryData?.transport?.data?.count ?? 0) > 0
                {
                    self.nextpageurl = orderHistoryEntity.responseData?.transport?.next_page_url ?? ""
                    for i in 0..<(orderHistoryData?.transport?.data?.count ?? 0)
                    {
                        if let dict = orderHistoryEntity.responseData?.transport?.data?[i] {
                            self.orderHistoryData?.transport?.data?.append(dict)
                        }
                    }
                }
            }else if self.currentServiceType == .service {
                if (self.orderHistoryData?.service?.data?.count ?? 0) > 0
                {
                    self.nextpageurl = orderHistoryEntity.responseData?.service?.next_page_url ?? ""

                    for i in 0..<(orderHistoryData?.service?.data?.count ?? 0)
                    {
                        if let dict = orderHistoryEntity.responseData?.service?.data?[i] {
                            self.orderHistoryData?.service?.data?.append(dict)
                        }
                    }
                }
            }else if self.currentServiceType == .delivery {
                if (self.orderHistoryData?.delivery?.data?.count ?? 0) > 0
                {
                    self.nextpageurl = orderHistoryEntity.responseData?.delivery?.next_page_url ?? ""

                    for i in 0..<(orderHistoryData?.delivery?.data?.count ?? 0)
                    {
                        if let dict = orderHistoryEntity.responseData?.delivery?.data?[i] {
                            self.orderHistoryData?.delivery?.data?.append(dict)
                        }
                    }
                }
            }
        }else{
            self.foodieData = nil
            self.orderHistoryData = orderHistoryEntity.responseData
        }
    }
    
    func getUpcoming(upcomingEntity: OrdersEntity) {
        self.foodieData = nil
        self.orderHistoryData = upcomingEntity.responseData
        if self.isUpdate  {
            if (self.orderHistoryData?.transport?.data?.count ?? 0) > 0
            {
                self.nextpageurl = upcomingEntity.responseData?.transport?.next_page_url ?? ""

                for i in 0..<(orderHistoryData?.transport?.data?.count ?? 0)
                {
                    if let dict = upcomingEntity.responseData?.transport?.data?[i] {
                        self.orderHistoryData?.transport?.data?.append(dict)
                    }
                }
            }
        }
    }
    
    func getFoodieOrderList(foodieEntity: FoodieHistoryEntity) {
        self.foodieData = foodieEntity.responseData
        self.orderHistoryData = nil
        self.foodieHistoryData = foodieEntity.responseData?.order?.data ?? []
        self.nextpageurl = foodieEntity.responseData?.order?.next_page_url ?? ""

        if self.isUpdate  {
            if (self.foodieHistoryData?.count ?? 0) > 0
            {
                for i in 0..<(self.foodieHistoryData?.count ?? 0)
                {
                    if let dict = self.foodieHistoryData?[i] {
                        self.foodieHistoryData?.append(dict)
                    }
                }
            }
        }
        self.ordersTableView.reloadInMainThread()
    }
}
extension OrdersController: UpdateOrderHistoryDelegate {
    func onRefreshOrderHistory(tag: Bool) {
        if tag {
            getFoodieHistory()

        }
    }
    
    
}
/*
//MARK: CHAT NOTIFICATION
extension OrdersController {
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


protocol UpdateOrderHistoryDelegate: class {
    func onRefreshOrderHistory(tag: Bool)
}
