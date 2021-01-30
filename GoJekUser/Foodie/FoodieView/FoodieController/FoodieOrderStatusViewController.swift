//
//  FoodieOrderStatusViewController.swift
//  GoJekUser
//
//  Created by Thiru on 09/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

var orderRequestId = 0


class FoodieOrderStatusViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var orderIDLabel:UILabel!
    @IBOutlet weak var otpLabel:UILabel!
    @IBOutlet weak var orderStatusTableView:UITableView!
    
    @IBOutlet weak var cancelButton: UIButton!
    var ratingView: FoodieRatingView!
    var foodieCurrentRequest:FoodieOrderDetailEntity?
    var phoneNumber:String? = "" //Phone number for user and restaurent
    var isHome = false
    var tableView: CustomTableView?
    var cancelReasonData: [ReasonData]?
    var isFromOrderPage = false
      var OrderfromChatNotification: Bool? = false
      var isAppFrom =  false
    
     //For chat_order
     var isAppPresentTapOnPush:Bool = false // avoiding multiple screens redirectns,if same push comes multiple times
     var isChatAlreadyPresented:Bool = false
    var orderStatus: foodieOrderStatus = .none {
        didSet {
            if orderStatus == .completed {
                self.showRatingView()
            }
        }
    }
    var cellHeights: [IndexPath : CGFloat] = [:]
    var delegate : UpdateOrderHistoryDelegate?
    var lat = 0.0
    var long = 0.0
    
    
    //ViewLifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
         isAppFrom = true
        initialLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden  = true
        self.hideTabBar()
        ChatPushClick.shared.isOrderPushClick = true
        NotificationCenter.default.addObserver(self, selector: #selector(enterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        BackGroundRequestManager.share.stopBackGroundRequest()
        isAppPresentTapOnPush = false
        self.isChatAlreadyPresented = false
        orderIDLabel.adjustsFontSizeToFitWidth = true
        //For chat_order
        NotificationCenter.default.addObserver(self, selector: #selector(isChatPushRedirection), name: Notification.Name(pushNotificationType.chat_order.rawValue), object: nil)
        
        
        FLocationManager.shared.start { (info) in
            print(info.longitude ?? 0.0)
            print(info.latitude ?? 0.0)
            self.lat = info.latitude ?? 0.0
            self.long = info.longitude ?? 0.0
        }
        
        if OrderfromChatNotification == true {
            OrderfromChatNotification = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                if self.isAppPresentTapOnPush == false {
                    self.isAppPresentTapOnPush = true
                    self.isChatAlreadyPresented = false
                }
                else {
                    self.isChatAlreadyPresented = true
                }
                self.tapMessage()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
         FLocationManager.shared.stop()
     }
    
    
    func socketAndBgTaskSetUp() {
        if let requestData = foodieCurrentRequest?.responseData {
            BackGroundRequestManager.share.startBackGroundRequest(type: .ModuleWise, roomId: SocketUtitils.construtRoomKey(requestID: "\(requestData.id ?? 0)", serviceType: .order), listener: .Order)
            BackGroundRequestManager.share.requestCallback =  { [weak self] in
                guard let self = self else {
                    return
                }
                self.checkOrderDetailsApi()
            }
        } else {
            checkOrderDetailsApi()
        }
    }
    
    func checkOrderDetailsApi() {
        foodiePresenter?.getOrderStatus(Id: orderRequestId)
    }
}

extension FoodieOrderStatusViewController {
    
    private func initialLoad() {
        self.socketAndBgTaskSetUp()
        LoadingIndicator.show()
        self.foodiePresenter?.getReasons(param: [XuberInput.type: ServiceType.orders.currentType])
        self.cancelButton.isHidden = true
        otpLabel.adjustsFontSizeToFitWidth = true
        self.orderStatusTableView.register(UINib(nibName: FoodieConstant.FoodieOrderStatusTableViewCell, bundle: nil), forCellReuseIdentifier: FoodieConstant.FoodieOrderStatusTableViewCell)
        self.orderStatusTableView.register(UINib(nibName: FoodieConstant.FoodieDelvieryPersonTableViewCell, bundle: nil), forCellReuseIdentifier: FoodieConstant.FoodieDelvieryPersonTableViewCell)
        self.orderStatusTableView.register(UINib(nibName: FoodieConstant.FoodieOrderDetailTableViewCell,bundle: nil), forCellReuseIdentifier: FoodieConstant.FoodieOrderDetailTableViewCell)
        self.orderStatusTableView.register(UINib(nibName: FoodieConstant.DeliveryChargeTableViewCell,bundle: nil), forCellReuseIdentifier: FoodieConstant.DeliveryChargeTableViewCell)
        self.orderStatusTableView.register(UINib(nibName: FoodieConstant.ShopDetailTableViewCell,bundle: nil), forCellReuseIdentifier: FoodieConstant.ShopDetailTableViewCell)
        setFont()
        backButton.addTarget(self, action: #selector(tapBack), for: .touchUpInside)
        cancelButton.setTitleColor(.foodieColor, for: .normal)
        cancelButton.setTitle(FoodieConstant.OCancel.localized.uppercased(), for: .normal)
        cancelButton.addTarget(self, action: #selector(tapCancelButton), for: .touchUpInside)
        if CommonFunction.checkisRTL() {
            backButton.imageView?.transform = backButton.transform.rotated(by: .pi)
        }
        setDarkMode()
    }
    
    private func setDarkMode(){
        self.view.backgroundColor = .backgroundColor
        self.navigationView.backgroundColor = .boxColor
        self.backButton.tintColor = .blackColor
//        orderIDLabel.textColor = .blackColor
    
    }
    
    @objc private func enterForeground() {
           isAppFrom = false
        if let _ = foodieCurrentRequest {
            foodieCurrentRequest = nil
            
        }
        BackGroundRequestManager.share.resetBackGroudTask()
        socketAndBgTaskSetUp()
    }
    
    private func setFont(){
        self.orderIDLabel.font = UIFont.setCustomFont(name: .medium, size: .x16)
        self.otpLabel.font = UIFont.setCustomFont(name: .medium, size: .x16)
        cancelButton.titleLabel?.font =  UIFont.setCustomFont(name: .bold, size: .x14)
    }
    @objc func tapCancelButton(){
        showCancelTable()
    }
    
    @objc func tapBack() {
        ChatPushClick.shared.clear()

        if isFromOrderPage {
            self.navigationController?.popViewController(animated: true)
        }else{
            let appDelegate = UIApplication.shared.delegate! as! AppDelegate
            appDelegate.window?.rootViewController = TabBarController().listTabBarController()
            appDelegate.window?.makeKeyAndVisible()
        }
        
    }
    
    func showRatingView() {
        if self.ratingView == nil, let ratingView = Bundle.main.loadNibNamed(Constant.FoodieRatingView, owner: self, options: [:])?.first as? FoodieRatingView {
            ratingView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.frame.width, height: self.view.frame.height))
            self.ratingView = ratingView
            self.ratingView.setValues(color: .foodieColor)
            self.view.addSubview(ratingView)
            ratingView.show(with: .bottom, completion: nil)
        }
        DispatchQueue.main.async {
            let name = (self.foodieCurrentRequest?.responseData?.provider?.first_name ?? "") + (self.foodieCurrentRequest?.responseData?.provider?.last_name ?? "")
            self.ratingView?.userNameLabel.text = name
         
            
            self.ratingView.userNameImage.sd_setImage(with: URL(string: self.foodieCurrentRequest?.responseData?.provider?.picture ?? ""), placeholderImage: UIImage(named: Constant.userPlaceholderImage),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                       // Perform operation.
                       if (error != nil) {
                           // Failed to load image
                           self.ratingView.userNameImage.image = UIImage(named: Constant.userPlaceholderImage)
                       } else {
                           // Successful in loading image
                           self.ratingView.userNameImage.image = image
                       }
                   })
            
            if self.foodieCurrentRequest?.responseData?.order_type == "TAKEAWAY" {
                self.ratingView?.providerRateView.isHidden = true
                self.ratingView?.ratingProviderView.isHidden = true
                self.ratingView?.rateDriverLabel.isHidden = true
            }else{
                self.ratingView?.providerRateView.isHidden = false
                self.ratingView?.ratingProviderView.isHidden = false
                self.ratingView?.rateDriverLabel.isHidden = false
            }
            self.ratingView?.ratingCountLabel.text = (self.foodieCurrentRequest?.responseData?.provider?.rating?.rounded(.awayFromZero))?.toString()
        }
        self.ratingView?.onClickSubmit = { [weak self] (rating, comments, shopRating) in
            guard let self = self else {
                return
            }
            self.ratingView?.dismissView(onCompletion: {
                self.ratingView = nil
                var comment = ""
                if comments == Constant.leaveComment.localized {
                    comment = ""
                }
                else {
                    comment = comments
                }
                let param: Parameters = [FoodieConstant.PRequestId: self.foodieCurrentRequest?.responseData?.id ?? 0,
                                         FoodieConstant.Prating:rating,
                                         FoodieConstant.Pcomment: comment,
                                         FoodieConstant.Pshopid: self.foodieCurrentRequest?.responseData?.store?.id ?? 0,
                                         FoodieConstant.Pshoprating:shopRating]
                
                self.foodiePresenter?.userRatingParam(param: param)
                
            })
        }
    }
}

//MARK: - TableViewDataSources
extension FoodieOrderStatusViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if self.foodieCurrentRequest?.responseData != nil {
            
            if self.foodieCurrentRequest?.responseData?.order_type == "TAKEAWAY"  {
                count = 4
                return count
            }
            if self.foodieCurrentRequest?.responseData?.provider == nil {
                count = 3
                return count
            }
            if self.foodieCurrentRequest?.responseData?.provider != nil {
                count = 4
                return count
            }
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0  {
            let cell = tableView.dequeueReusableCell(withIdentifier: FoodieConstant.FoodieOrderStatusTableViewCell, for: indexPath) as! FoodieOrderStatusTableViewCell
            cell.orderType = self.foodieCurrentRequest?.responseData?.order_type ?? ""
            cell.orderReadystatus = self.foodieCurrentRequest?.responseData?.order_ready_status ?? 0
            cell.orderStatus = self.orderStatus
            return cell
        } else {
            if self.foodieCurrentRequest?.responseData?.order_type == "TAKEAWAY" {
                if indexPath.row == 1 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: FoodieConstant.ShopDetailTableViewCell, for: indexPath) as! ShopDetailTableViewCell
                    cell.shopNameLabel.text = self.foodieCurrentRequest?.responseData?.store?.store_name
                    cell.shopAddressLabel.text = self.foodieCurrentRequest?.responseData?.pickup?.store_location
                    cell.callButton.setTitle(self.foodieCurrentRequest?.responseData?.pickup?.contact_number, for: .normal)
                    
                    cell.onTapMatTrack = { [weak self] in
                        guard let self = self else {
                            return
                        }
                        self.redirectToGoogleMap()
                    }
                    // cell.mapTrackButton.isHidden = true
                    cell.callButton.addTarget(self, action: #selector(self.tapCall), for: .touchUpInside)
                    return cell
                }else if indexPath.row == 2  {
                    let cell = tableView.dequeueReusableCell(withIdentifier: FoodieConstant.FoodieOrderDetailTableViewCell, for: indexPath) as! FoodieOrderDetailTableViewCell
                    
                    cell.orderItem = self.foodieCurrentRequest?.responseData?.invoice?.items ?? []
                    if (self.foodieCurrentRequest?.responseData?.delivery_date ?? "") == ""{
                        cell.deliveryDateLabel.text = ""
                    }
                    else{
                        let deliveryDate = self.foodieCurrentRequest?.responseData?.delivery_date ?? ""
                        cell.deliveryDateLabel.text = deliveryDate + " : " + FoodieConstant.delivery_Date.localized
                    }
                    return cell
                }
                else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: FoodieConstant.DeliveryChargeTableViewCell, for: indexPath) as! DeliveryChargeTableViewCell
                    let data = self.foodieCurrentRequest?.responseData?.invoice
                    cell.deliveryChargeLabel.text = (data?.delivery_amount ?? 0)?.setCurrency()
                    if data?.promocode_id == 0 {
                        cell.couponView.isHidden = true
                    }else{
                        cell.couponView.isHidden = false
                        
                    }
                    cell.couponLabel.text = "- " + (data?.promocode_amount ?? 0).setCurrency()
                    cell.totalChargeLabel.text = (data?.payable ?? 0)?.setCurrency()
                    cell.taxAmt.text = (data?.tax_amount ?? 0)?.setCurrency()
                    cell.storePackageAmt.text = (data?.store_package_amount ?? 0)?.setCurrency()
                    if data?.discount == 0 {
                        cell.discountView.isHidden = true
                    }else{
                        cell.discountView.isHidden = false
                        
                    }
                    cell.itemTotalValueLabel.text = (data?.item_price ?? 0)?.setCurrency()
                    cell.discountValueLabel.text = "- " + ((data?.discount ?? 0)?.setCurrency() ?? String.empty)
                    return cell
                }
                
            }else if self.foodieCurrentRequest?.responseData?.provider == nil {
                if indexPath.row == 1  {
                    let cell = tableView.dequeueReusableCell(withIdentifier: FoodieConstant.FoodieOrderDetailTableViewCell, for: indexPath) as! FoodieOrderDetailTableViewCell
                    
                    cell.orderItem = self.foodieCurrentRequest?.responseData?.invoice?.items ?? []
                    if (self.foodieCurrentRequest?.responseData?.delivery_date ?? "") == ""{
                        cell.deliveryDateLabel.text = ""
                    }
                    else{
                        let deliveryDate = self.foodieCurrentRequest?.responseData?.delivery_date ?? ""
                        cell.deliveryDateLabel.text = deliveryDate + " : " + FoodieConstant.delivery_Date.localized
                    }
                    return cell
                }
                else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: FoodieConstant.DeliveryChargeTableViewCell, for: indexPath) as! DeliveryChargeTableViewCell
                    let data = self.foodieCurrentRequest?.responseData?.invoice
                    cell.deliveryChargeLabel.text = (data?.delivery_amount ?? 0)?.setCurrency()
                    if data?.promocode_id == 0 {
                        cell.couponView.isHidden = true
                    }else{
                        cell.couponView.isHidden = false
                        
                    }
                    cell.couponLabel.text = "- " + ((data?.promocode_amount ?? 0)?.setCurrency() ?? String.empty)
                    cell.totalChargeLabel.text = (data?.payable ?? 0)?.setCurrency()
                    cell.taxAmt.text = (data?.tax_amount ?? 0)?.setCurrency()
                    cell.storePackageAmt.text = (data?.store_package_amount ?? 0)?.setCurrency()
                    if data?.discount == 0 {
                        cell.discountView.isHidden = true
                    }else{
                        cell.discountView.isHidden = false
                        
                    }
                    cell.discountValueLabel.text = "- " + ((data?.discount ?? 0)?.setCurrency() ?? String.empty)
                    cell.itemTotalValueLabel.text = (data?.item_price ?? 0)?.setCurrency()
                    
                    return cell
                }
            }else{
                if indexPath.row == 1 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: FoodieConstant.FoodieDelvieryPersonTableViewCell, for: indexPath) as! FoodieDelvieryPersonTableViewCell
                    
                    let name = (self.foodieCurrentRequest?.responseData?.provider?.first_name ?? "") + (self.foodieCurrentRequest?.responseData?.provider?.last_name ?? "")
                    cell.deliveryPersonNameLabel.text = name
                    cell.timeLabel.text = (self.foodieCurrentRequest?.responseData?.store?.estimated_delivery_time ?? "") + FoodieConstant.Mins.localized
                    cell.phoneButton.setTitle(self.foodieCurrentRequest?.responseData?.provider?.mobile, for: .normal)
                    
                    
                    cell.profileImageView.sd_setImage(with: URL(string:  self.foodieCurrentRequest?.responseData?.provider?.picture ?? ""), placeholderImage: UIImage(named: Constant.userPlaceholderImage),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                        // Perform operation.
                        if (error != nil) {
                            // Failed to load image
                            cell.profileImageView.image = UIImage(named: Constant.userPlaceholderImage)
                        } else {
                            // Successful in loading image
                            cell.profileImageView.image = image
                        }
                    })
                    let dateFormatter1 = DateFormatter()
                    dateFormatter1.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let date: Date? = dateFormatter1.date(from: UTCToLocal(date: self.foodieCurrentRequest?.responseData?.created_at ?? ""))
                    cell.onTapMatTrack = { [weak self] in
                        guard let self = self else {
                            return
                        }
                        let vc = FoodieRouter.foodieStoryboard.instantiateViewController(withIdentifier: FoodieConstant.FoodieTrackingController) as! FoodieTrackingController
                        vc.foodieCurrentRequest = self.foodieCurrentRequest
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    if let date = date {
                        cell.dateLabel.text = dateFormatter1.string(from: date)
                        
                        
                    }
                    cell.phoneButton.addTarget(self, action: #selector(self.tapCall), for: .touchUpInside)
                    cell.msgButton.addTarget(self, action: #selector(self.tapMessage), for: .touchUpInside)
                    return cell
                }else if indexPath.row == 2  {
                    let cell = tableView.dequeueReusableCell(withIdentifier: FoodieConstant.FoodieOrderDetailTableViewCell, for: indexPath) as! FoodieOrderDetailTableViewCell
                    cell.orderItem = self.foodieCurrentRequest?.responseData?.invoice?.items ?? []
                    if (self.foodieCurrentRequest?.responseData?.delivery_date ?? "") == ""{
                        cell.deliveryDateLabel.text = ""
                    }
                    else{
                        cell.deliveryDateLabel.text = "\(self.foodieCurrentRequest?.responseData?.delivery_date ?? "") : Delivery Date"
                    }
                    return cell
                }
                else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: FoodieConstant.DeliveryChargeTableViewCell, for: indexPath) as! DeliveryChargeTableViewCell
                    let data = self.foodieCurrentRequest?.responseData?.invoice
                    cell.deliveryChargeLabel.text = (data?.delivery_amount ?? 0)?.setCurrency()
                    if data?.promocode_id == 0 {
                        cell.couponView.isHidden = true
                    }else{
                        cell.couponView.isHidden = false
                    }
                    cell.couponLabel.text = "- " + ((data?.promocode_amount ?? 0)?.setCurrency() ?? String.empty)
                    cell.totalChargeLabel.text = (data?.payable ?? 0)?.setCurrency()
                    cell.taxAmt.text = (data?.tax_amount ?? 0)?.setCurrency()
                    cell.storePackageAmt.text = (data?.store_package_amount ?? 0)?.setCurrency()
                    if data?.discount == 0 {
                        cell.discountView.isHidden = true
                    }else{
                        cell.discountView.isHidden = false
                    }
                    cell.discountValueLabel.text = "- " + ((data?.discount ?? 0)?.setCurrency() ?? String.empty)
                    cell.itemTotalValueLabel.text = (data?.item_price ?? 0)?.setCurrency()
                    return cell
                }
            }
        }
    }
    
    //Redirect to google map
    private func redirectToGoogleMap() {
        let baseUrl = "comgooglemaps-x-callback://"
        if UIApplication.shared.canOpenURL(URL(string: baseUrl)!) {
           
            let directionsRequest = "comgooglemaps://?saddr=\(lat),\(long)&daddr=\(foodieCurrentRequest?.responseData?.pickup?.latitude ?? 0.0),\(foodieCurrentRequest?.responseData?.pickup?.longitude ?? 0.0)&directionsmode=driving"
            if let url = URL(string: directionsRequest) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        else {
            ToastManager.show(title: Constant.googleConstant.localized, state: .error)
        }
    }

    
    @objc func tapCall() {
        guard let _ = self.phoneNumber else {
            return
        }
        AppUtils.shared.call(to: self.phoneNumber)
    }
    //For chat
    @objc func isChatPushRedirection() {
        if isAppPresentTapOnPush == false {
            if isAppFrom == true {
                
                if self.isAppPresentTapOnPush == false {
                    self.isAppPresentTapOnPush = true
                    self.isChatAlreadyPresented = false
                }
                else {
                    self.isChatAlreadyPresented = true
                }
                self.tapMessage()
            }else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    if self.isAppPresentTapOnPush == false {
                        self.isAppPresentTapOnPush = true
                        self.isChatAlreadyPresented = false
                    }
                    else {
                        self.isChatAlreadyPresented = true
                    }
                    //  self.isChatAlreadyPresented = true
                    self.tapMessage()
                }
            }
        }else{
            
        }
    }
    
    @objc func tapMessage(){
        let checkRequestDetail = self.foodieCurrentRequest?.responseData
        let providerDetail = checkRequestDetail?.provider
        let userDetail = checkRequestDetail?.user
        let chatView = ChatViewController()
        chatView.requestId = "\((checkRequestDetail?.id ?? 0))"
        chatView.chatRequestFrom = MasterServices.Order.rawValue
        chatView.userId = "\((userDetail?.id ?? 0))"
        chatView.userName = "\( userDetail?.first_name ?? "")" + " " + "\(userDetail?.last_name ?? "")"
        chatView.providerId = "\((providerDetail?.id ?? 0))"
        chatView.providerName = "\(providerDetail?.first_name ?? "")" + " " + "\(providerDetail?.last_name ?? "")"
        chatView.adminServiceId = "\(checkRequestDetail?.admin_service_id ?? "")"
        self.navigationController?.pushViewController(chatView, animated: true)
    }
}

//MARK: - UITableViewDelegate
extension FoodieOrderStatusViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let height = cellHeights[indexPath] else { return 260.0 }
        
        return height
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0{
            if self.foodieCurrentRequest?.responseData?.order_type == "TAKEAWAY" {
                return 190 //60*3
            }else{
                return 320 //60*3
            }
            
        }else {
            if self.foodieCurrentRequest?.responseData?.order_type == "TAKEAWAY" {
                if indexPath.row == 1{
                    return 190 //(self.view.frame.height/100)*25
                }else if indexPath.row == 2 {
                    let numberOfItem = self.foodieCurrentRequest?.responseData?.invoice?.items?.count ?? 0
                    return CGFloat((numberOfItem+1)*55) // number of items
                }else if indexPath.row == 3 {
                    let data = self.foodieCurrentRequest?.responseData?.invoice
                    if data?.promocode_id == 0 {
                        return 312
                    }else{
                        return 345
                    }
                }
            }else if self.foodieCurrentRequest?.responseData?.provider == nil {
                if indexPath.row == 1 {
                    let numberOfItem = self.foodieCurrentRequest?.responseData?.invoice?.items?.count ?? 0
                    return CGFloat((numberOfItem+1)*55) // number of items
                }else if indexPath.row == 2 {
                    let data = self.foodieCurrentRequest?.responseData?.invoice
                    if data?.promocode_id == 0 {
                        return 312
                    }else{
                        return 345
                    }
                }
            }else{
                if indexPath.row == 1{
                    return 250 //(self.view.frame.height/100)*25
                }else if indexPath.row == 2 {
                    let numberOfItem = self.foodieCurrentRequest?.responseData?.invoice?.items?.count ?? 0
                    return CGFloat((numberOfItem+1)*55) // number of items
                }else if indexPath.row == 3 {
                    let data = self.foodieCurrentRequest?.responseData?.invoice
                    if data?.promocode_id == 0 {
                        return 312
                    }else{
                        return 345
                    }
                }
            }
        }
        return UITableView.automaticDimension
    }
}

extension FoodieOrderStatusViewController {
    //MARK:- checkForProviderStatus
    
    func updateProvierDetails() {
        if self.foodieCurrentRequest?.responseData?.status == nil {
            self.orderStatus = .none
        }
        else {
            let invoiceId = self.foodieCurrentRequest?.responseData?.store_order_invoice_id ?? ""
            let otp = self.foodieCurrentRequest?.responseData?.order_otp ?? ""
            self.orderIDLabel.attributeString(string: FoodieConstant.orderId.localized+invoiceId, range: NSRange(location: FoodieConstant.orderId.count, length: invoiceId.count), color: .lightGray)
            self.otpLabel.attributeString(string: FoodieConstant.otp+otp, range: NSRange(location: FoodieConstant.otp.count, length: otp.count), color: .foodieColor)
            self.orderStatus = foodieOrderStatus(rawValue: self.foodieCurrentRequest?.responseData?.status ?? "") ?? .none
            
            if self.orderStatus == .ordered || self.orderStatus == .storeCancelled {
                self.cancelButton.isHidden = false
            }else{
                self.cancelButton.isHidden = true
            }
            
            if self.orderStatus == .cancelled {
                if self.isHome == true {
                    self.navigationController?.popViewController(animated: true)
                }else if self.isFromOrderPage {
                    self.delegate?.onRefreshOrderHistory(tag: self.isFromOrderPage)
                    self.navigationController?.popViewController(animated: true)
                }else{
                    
                    for vc in self.navigationController?.viewControllers ?? [UIViewController()] {
                        if let myViewCont = vc as? HomeViewController
                        {
                            self.navigationController?.popToViewController(myViewCont, animated: true)
                        }
                    }
                }
            }
            
            if self.foodieCurrentRequest?.responseData?.order_type == "TAKEAWAY" {
                self.phoneNumber = self.foodieCurrentRequest?.responseData?.pickup?.contact_number
            }else{
                self.phoneNumber = self.foodieCurrentRequest?.responseData?.provider?.mobile
            }
            
            DispatchQueue.main.async {
                self.orderStatusTableView.reloadData()
                self.orderStatusTableView.beginUpdates()
                self.orderStatusTableView.endUpdates()
            }
        }
    }
}

//MARK: - FoodiePresenterToFoodieViewProtocol
extension FoodieOrderStatusViewController: FoodiePresenterToFoodieViewProtocol {
    
    func getUserRatingResponse(getUserRatingResponse: SuccessEntity){
        BackGroundRequestManager.share.resetBackGroudTask()
        ToastManager.show(title: Constant.RatingToast, state: .success)
        if isFromOrderPage {
            self.delegate?.onRefreshOrderHistory(tag: self.isFromOrderPage)
            
            self.navigationController?.popViewController(animated: true)
        }else{
            
            for vc in self.navigationController?.viewControllers ?? [UIViewController()] {
                if let myViewCont = vc as? HomeViewController
                {
                    self.navigationController?.popToViewController(myViewCont, animated: true)
                }
            }
        }
    }
    
    func foodieOrderStatusResponse(orderStatus: FoodieOrderDetailEntity){
        if let requetsId = orderStatus.responseData?.id {
            orderRequestId = requetsId
            self.foodieCurrentRequest = orderStatus
            self.socketAndBgTaskSetUp()
           //self.otpLabel.isHidden = orderStatus.responseData?.self.foodieCurrentRequest?.re
            DispatchQueue.main.async {
                self.updateProvierDetails()
            }
        }
    }
    
    func getReasons(reasonEntity: ReasonEntity) {
        self.cancelReasonData = reasonEntity.responseData ?? []
        LoadingIndicator.hide()
    }
    func getCancelRequest(cancelEntity: SuccessEntity) {
    
        BackGroundRequestManager.share.resetBackGroudTask()
        ToastManager.show(title: cancelEntity.message ?? "", state: .success)
        LoadingIndicator.hide()
        
        if isFromOrderPage {
            self.delegate?.onRefreshOrderHistory(tag: self.isFromOrderPage)
            
            self.navigationController?.popViewController(animated: true)
        }else{
            
            for vc in self.navigationController?.viewControllers ?? [UIViewController()] {
                if let myViewCont = vc as? HomeViewController
                {
                    self.navigationController?.popToViewController(myViewCont, animated: true)
                }
            }
        }
    }
    
}

extension FoodieOrderStatusViewController {
    
    func showCancelTable() {
        if self.tableView == nil, let tableView = Bundle.main.loadNibNamed(Constant.CustomTableView, owner: self, options: [:])?.first as? CustomTableView {
            
            let height = (self.view.frame.height/100)*35
            tableView.frame = CGRect(x: 20, y: (self.view.frame.height/2)-(height/2), width: self.view.frame.width-40, height: height)
            tableView.heading = Constant.chooseReason.localized
            self.tableView = tableView
            self.tableView?.setCornerRadiuswithValue(value: 10.0)
            var reasonArr:[String] = []
            for reason in self.cancelReasonData ?? [] {
                reasonArr.append(reason.reason ?? "")
            }
            if !reasonArr.contains(Constant.other) {
                reasonArr.append(Constant.other)
            }
            tableView.values = reasonArr
            tableView.show(with: .bottom, completion: nil)
            showDimView(view: tableView)
        }
        self.tableView?.onClickClose = { [weak self] in
            guard let self = self else {
                return
            }
            self.tableView?.superview?.dismissView(onCompletion: {
                self.tableView = nil
            })
        }
        self.tableView?.selectedItem = { [weak self] (selectedReason) in
            guard let self = self else {
                return
            }
            self.callCancelAPI(reason: selectedReason)
        }
    }
    
    func callCancelAPI(reason: String?) {
        var param:Parameters = [FoodieConstant.Pid : self.foodieCurrentRequest?.responseData?.id ??  0]
        if reason !=  nil {
            param[FoodieConstant.PCancelReason] = reason
        }
        LoadingIndicator.show()
        self.foodiePresenter?.cancelRequest(param: param)
    }
    
    func showDimView(view: UIView) {
        let dimView = UIView(frame: self.view.frame)
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        dimView.addSubview(view)
        self.view.addSubview(dimView)
    }
}


