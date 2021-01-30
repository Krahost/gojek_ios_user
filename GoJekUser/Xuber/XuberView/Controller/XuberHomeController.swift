//
//  XuberHomeController.swift
//  GoJekUser
//
//  Created by Ansar on 06/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
//import Floaty
import SDWebImage

class XuberHomeController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusValueLabel: UILabel!
    @IBOutlet weak var currentLocationView: UIView!
    var floatyButton: FloatyButton?
    
    var loaderView: LoaderView!
    var xuberRideStatusView: XuberRideStatusView!
    var ratingView:RatingView!
    var xuberInvoice:XuberInvoice!
    var tableView: CustomTableView?
    var isfromServiceChat: Bool = false
    var isAppFrom =  false
    var isAppPresentTapOnPush:Bool = false // avoiding multiple screens redirectns,if same push comes multiple times
    var isChatAlreadyPresented:Bool = false
    var reasonData: [ReasonData]?
    var currentRequest: XuberRequestData?
    var Serveotp: String = ""
    var selectedCard: CardResponseData?
    var providerLastLocation = LocationCoordinate()
    
    var xmapView: XMapView?
    
    var isInvoiceShowed:Bool = false
    
    var count = 0
    
    var rideStatus:XuberRideStatus = .none {
        didSet {
            updateUI()
        }
    }
    
    var extraNotes:String = ""
    var isFromOrderPage = false
    
    var sourceLocationDetail: SourceDestinationLocation?
    var destinationLocationDetail: SourceDestinationLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideTabBar()
        initialLoads()
        isAppFrom = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewWillAppearCustom()
        ChatPushClick.shared.isServicePushClick = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        xmapView?.frame = mapView.bounds
        if xuberInvoice !=  nil {
            xuberInvoice.totalInvoiceView.addDashLine(strokeColor: .xuberColor, lineWidth: 1.5)
        }
        currentLocationView.setRadiusWithShadow()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        XCurrentLocation.shared.latitude = 0.0
        XCurrentLocation.shared.longitude = 0.0
        removeMapView()
    }
}

//MARK:  - Methods

extension XuberHomeController {
    private func initialLoads() {
        view.backgroundColor = .veryLightGray
        backButton.addTarget(self, action: #selector(tapBack), for: .touchUpInside)
        statusLabel.font = .setCustomFont(name: .medium, size: .x14)
        statusValueLabel.font = .setCustomFont(name: .medium, size: .x14)
        statusView.isHidden = true // initial its hide
        localize()
        self.floatyButton?.isHidden = true
        if CommonFunction.checkisRTL() {
            backButton.imageView?.transform = backButton.transform.rotated(by: .pi)
        }
        let locationViewGesture = UITapGestureRecognizer(target: self, action: #selector(tapCurrentLocation(_:)))
        self.currentLocationView.addGestureRecognizer(locationViewGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(enterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        mapView.backgroundColor = .whiteColor

    }
    
    @objc func tapCurrentLocation(_ sender: UITapGestureRecognizer){
          
          self.xmapView?.showCurrentLocation()
      }
      
    
    
    @objc private func enterForeground() {
        if let _ = currentRequest {
            currentRequest = nil
        }
        isAppFrom = true
        BackGroundRequestManager.share.resetBackGroudTask()
        socketAndBgTaskSetUp()
    }
    
    private func setFloatyButton() {
        
        if let _ = getFloatyView() {
            floatyButton?.buttonOneImage = UIImage(named: Constant.phoneImage)?.imageTintColor(color1: .white) ?? UIImage()
            floatyButton?.buttonTwoImage = UIImage(named: Constant.chatImage)?.imageTintColor(color1: .white) ?? UIImage()
            floatyButton?.bgColor = .xuberColor
            floatyButton?.backgroundColor = .xuberColor
            floatyButton?.onTapButtonOne = { [weak self] in
                guard let self = self else {
                    return
                }
                if let phoneNumber = self.currentRequest?.provider?.mobile {
                    AppUtils.shared.call(to: phoneNumber)
                }
            }
            floatyButton?.onTapButtonTwo = { [weak self] in
                guard let self = self else {
                    return
                }
                self.navigateToChatView()
            }
        }
    }
    
    private func getFloatyView() -> FloatyButton? {
        guard let _ = floatyButton else {
            floatyButton = FloatyButton()
            mapView.addSubview(floatyButton ?? UIView())
            floatyButton?.translatesAutoresizingMaskIntoConstraints = false
            floatyButton?.bottomAnchor.constraint(equalTo: xuberRideStatusView.topAnchor, constant: -10).isActive = true
            floatyButton?.rightAnchor.constraint(equalTo: xuberRideStatusView.rightAnchor, constant: -10).isActive = true
            floatyButton?.heightAnchor.constraint(equalTo: xuberRideStatusView.widthAnchor, multiplier: 0.12).isActive = true
            floatyButton?.widthAnchor.constraint(equalTo: xuberRideStatusView.widthAnchor, multiplier: 0.12).isActive = true
            return floatyButton
        }
        return floatyButton
    }
    
    private func viewWillAppearCustom() {
        addMapView()
        
        isAppPresentTapOnPush = false
        self.isChatAlreadyPresented = false
        navigationController?.isNavigationBarHidden = true
        xuberPresenter?.getReasons(param: [XuberInput.type: ServiceType.service.currentType])
        socketAndBgTaskSetUp()
        view.endEditing()
        //For chat_order
//                    NotificationCenter.default.addObserver(self, selector: #selector(isChatPushRedirection), name: Notification.Name(pushNotificationType.chat_servce.rawValue), object: nil)
                    
                    if isfromServiceChat == true {
                           isfromServiceChat = false
                           
                           DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            if self.isAppPresentTapOnPush == false {
                                ChatPushClick.shared.isServicePushClick = true
                                
                                       self.isAppPresentTapOnPush = true
                                       self.isChatAlreadyPresented = false
                                                 }
                                                 else {
                                      self.isChatAlreadyPresented = true
                                                 }
                                self.navigateToChatView()
                           }
                    }
    }
    
    func socketAndBgTaskSetUp() {
        if let requestData = currentRequest {
            BackGroundRequestManager.share.startBackGroundRequest(type: .ModuleWise, roomId: SocketUtitils.construtRoomKey(requestID: "\(requestData.id ?? 0)", serviceType: .service), listener: .Service)
            BackGroundRequestManager.share.requestCallback =  { [weak self] in
                self?.checkRequestAPI()
            }
        } else {
            checkRequestAPI()
        }
        self.showCurrentLocation()
    }
    
    func checkRequestAPI() {
        self.xuberPresenter?.getRequest()
    }
    

    
    private func localize() {
        statusLabel.text = XuberConstant.status.localized
    }
    
    @objc func tapBack() {
        ChatPushClick.shared.clear()
        if isFromOrderPage {
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
    
    func updateUI() {
        DispatchQueue.main.async {
            if self.rideStatus == .none || self.rideStatus == .CANCELLED {
                if self.loaderView !=  nil {
                    self.loaderView.dismissView {
                        self.loaderView = nil
                    }
                }
                if self.xuberRideStatusView != nil {
                    self.xuberRideStatusView.dismissView {
                        self.xuberRideStatusView = nil
                    }
                }
                self.navigationController?.popViewController(animated: true)
            }else if self.rideStatus == .ACCEPTED {
                self.floatyButton?.isHidden = false
                self.statusValueLabel.text = (self.currentRequest?.category?.alias_name ?? "") + self.rideStatus.statusStr
                self.xuberRideStatusView.otpView.isHidden = true
                self.xuberRideStatusView.topView.isHidden = true
                self.statusView.isHidden = false
            }else if self.rideStatus == .ARRIVED  {
                self.floatyButton?.isHidden = false
                self.statusValueLabel.text = (self.currentRequest?.category?.alias_name ?? "") + self.rideStatus.statusStr
                if self.Serveotp  == "1"  {
                    if let otp = self.currentRequest?.otp{
                        self.xuberRideStatusView.otpView.isHidden = false
                        self.xuberRideStatusView.topView.isHidden = false
                        
                        self.xuberRideStatusView.otpLabel.text = Constant.otp.giveSpace + otp
                   }
                }else{
                    self.xuberRideStatusView.topView.isHidden = true
                    self.xuberRideStatusView.otpView.isHidden = true
                }
                self.xuberRideStatusView.statusButton.isHidden = false
                self.xuberRideStatusView.statusHeightConstraint?.constant = 40
            }else if self.rideStatus == .STARTED{
                self.floatyButton?.isHidden = true
                self.floatyButton?.removeFromSuperview()
                self.floatyButton = nil
                self.xuberRideStatusView.statusButton.isHidden = true
                self.xuberRideStatusView.statusHeightConstraint?.constant = 0
            }else if self.rideStatus == .PICKEDUP {
                self.floatyButton?.isHidden = true
                self.floatyButton?.removeFromSuperview()
                self.floatyButton = nil
                self.statusValueLabel.text = self.rideStatus.statusStr
                self.xuberRideStatusView.otpView.isHidden = false
                self.xuberRideStatusView.topView.isHidden = false
                self.xuberRideStatusView.statusButton.isHidden = true
                self.xuberRideStatusView.statusHeightConstraint?.constant = 0
            }else if self.rideStatus == .DROPPED {
                self.floatyButton?.isHidden = true
                self.floatyButton?.removeFromSuperview()
                self.floatyButton = nil
                self.statusValueLabel.text = self.rideStatus.statusStr
            }else if self.rideStatus == .COMPLETED {
                self.floatyButton?.removeFromSuperview()
                self.floatyButton = nil
                self.statusValueLabel.text = self.rideStatus.statusStr
            }
            self.statusView.isHidden = self.rideStatus == .CANCELLED || self.rideStatus == .SEARCHING
        }
    }
    
    func showInvoice(payment: XuberRequestData) {
        if xuberInvoice == nil, let invoiceView = Bundle.main.loadNibNamed(XuberConstant.XuberInvoice, owner: self, options: [:])?.first as? XuberInvoice {
            
            invoiceView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: view.frame.width, height: view.frame.height))
            xuberInvoice = invoiceView
            
            if let beforeImage = URL(string:payment.before_image ?? "") { //hide if image not there
                xuberInvoice.beforeImage.sd_setImage(with: beforeImage, placeholderImage: #imageLiteral(resourceName: "ImagePlaceHolder"))
                
            }else{
                xuberInvoice.beforeImage.superview?.isHidden = true
            }
            if let afterImage = URL(string:payment.after_image ?? "") {
                xuberInvoice.afterImage.sd_setImage(with: afterImage, placeholderImage: #imageLiteral(resourceName: "ImagePlaceHolder"))
                
            }else{
                xuberInvoice.afterImage.superview?.isHidden = true
            }
            if String.removeNil(payment.before_image).count == 0 && String.removeNil(payment.after_image).count == 0 {
                xuberInvoice.imageStackView.isHidden = true
            }
            xuberInvoice.paymentType = PaymentType(rawValue: payment.payment_mode ?? PaymentType.CASH.rawValue) ?? .CASH
            
            view.addSubview(invoiceView)
            invoiceView.show(with: .bottom, completion: nil)
        }
        xuberInvoice.infoButton.addTarget(self, action: #selector(tapInfo), for: .touchUpInside)
        
        extraNotes = payment.payment?.extra_charges_notes ?? ""
        xuberInvoice.setValues(values: payment,isPaid: payment.paid ?? 0)
        xuberInvoice?.onClickDone = { [weak self] isCard in
            guard let self = self else {
                return
            }
            if isCard {
                let param:Parameters = [XuberInput.id : self.currentRequest?.id ?? 0,
                                        XuberInput.tips : self.xuberInvoice.tipsAmount]
                print(param)
                self.xuberPresenter?.nonCashPayment(param: param)
            }else{
                self.xuberInvoice?.dismissView(onCompletion: {
                    self.xuberInvoice = nil
                })
                self.isInvoiceShowed = true //Flag for invoice show
                self.showRatingView()
            }
        }
        xuberInvoice?.onClickChange = { [weak self] in
            guard let self = self else {
                return
            }
            self.changeInvoicePaymentTapped()
        }
    }
    
    @objc func tapInfo() {
        AppAlert.shared.simpleAlert(view: self, title: "", message: extraNotes.localized, buttonTitle: Constant.SOk.localized)
    }
    
    func showRatingView() {
        if self.ratingView == nil, let ratingView = Bundle.main.loadNibNamed(Constant.RatingView, owner: self, options: [:])?.first as? RatingView {
            ratingView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: view.frame.width, height: view.frame.height))
            ratingView.rateDriverLabel.text = XuberConstant.rateYourProvider.localized
            ratingView.setValues(color: .xuberColor)
            ratingView.idLabel.text = currentRequest?.booking_id
            
            if let provider = currentRequest?.provider {
                ratingView.userNameLabel.text = provider.first_name
               
                
                ratingView.userNameImage.sd_setImage(with: URL(string: provider.picture ?? ""), placeholderImage:#imageLiteral(resourceName: "ImagePlaceHolder"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                    // Perform operation.
                    if (error != nil) {
                        // Failed to load image
                        ratingView.userNameImage.image = #imageLiteral(resourceName: "ImagePlaceHolder")
                    } else {
                        // Successful in loading image
                        ratingView.userNameImage.image = image
                    }
                })
            }
            self.ratingView = ratingView
            self.showDimView(view: ratingView)
            ratingView.show(with: .bottom, completion: nil)
        }
        self.ratingView?.onClickSubmit = { [weak self] (rating, comments) in
            guard let self = self else {
                return
            }
            if let request = self.currentRequest {
                let comment = comments == Constant.leaveComment.localized ? "" : comments
                let param:Parameters = [XuberInput.id :  request.id ?? 0,
                                        XuberInput.rating : rating,
                                        XuberInput.comment : comment,
                                        XuberInput.admin_service_id : request.admin_service_id ??  ""]
                self.xuberPresenter?.getRating(param: param)
            }
        }
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
                        self.navigateToChatView()
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
                                    self.navigateToChatView()
                                }
                                  
                    }
                    }else{
                        
                    }
            
          }
    
    private func navigateToChatView() {
        
        let checkRequestDetail = currentRequest
        let providerDetail = checkRequestDetail?.provider
        let userDetail = checkRequestDetail?.user
        let serviceDetail = checkRequestDetail?.service
        
        let chatView = ChatViewController()
        chatView.requestId = "\((checkRequestDetail?.id ?? 0))"
        chatView.chatRequestFrom = MasterServices.Service.rawValue
        chatView.userId = "\((userDetail?.id ?? 0))"
        chatView.userName = "\( userDetail?.firstName ?? "")" + " " + "\(userDetail?.lastName ?? "")"
        chatView.providerId = "\((providerDetail?.id ?? 0))"
        chatView.providerName = "\(providerDetail?.first_name ?? "")" + " " + "\(providerDetail?.last_name ?? "")"
        chatView.adminServiceId = "\((serviceDetail?.id ?? 0))"
        navigationController?.pushViewController(chatView, animated: true)
    }
    
    func showLoaderView() {
        if loaderView == nil, let loaderView = Bundle.main.loadNibNamed(XuberConstant.LoaderView, owner: self, options: [:])?.first as? LoaderView {
            loaderView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: view.frame.width, height: view.frame.height))
            self.loaderView = loaderView
            loaderView.cancelRequestButton.backgroundColor = .xuberColor
            loaderView.findDriverLabel.text = XuberConstant.findService.localized
            loaderView.show(with: .bottom, completion: nil)
            self.view.addSubview(loaderView)
        }
        self.loaderView.onClickCancelRequest = { [weak self] in
            guard let self = self else {
                return
            }
            self.callCancelAPI(reason: nil)
        }
    }
    
    private func addMapView() {
        xmapView = XMapView(frame: mapView.bounds)
        xmapView?.tag = 100
        xmapView?.delegate = xmapView
        guard let _ = xmapView else {
            return
        }
        mapView.addSubview(xmapView!)
        mapView.bringSubviewToFront(floatyButton ?? UIButton()) // bring to front view if goes to chat and come back in between flow
        xmapView?.currentLocationMarkerImage = UIImage(named: XuberConstant.trackImage)
        xmapView?.didUpdateLocation = { [weak self] (location) in
            guard let self = self else {
                return
            }
            let currentLocation = CLLocation(latitude: location.latitude ?? 0, longitude: location.longitude ?? 0)
            self.xmapView?.currentLocation = currentLocation
        }
    }
    
    private func removeMapView() {
        for subView in mapView.subviews where subView.tag == 100 {
            subView.removeFromSuperview()
            xmapView = nil
        }
    }
    
    func showCurrentLocation() {
        xmapView?.showCurrentLocation()
    }
    
    func showRideStatus(request: XuberRequestData) {
        if xuberRideStatusView == nil, let xuberRideStatusView = Bundle.main.loadNibNamed(XuberConstant.XuberRideStatusView, owner: self, options: [:])?.first as? XuberRideStatusView {
            view.addSubview(xuberRideStatusView)
            xuberRideStatusView.translatesAutoresizingMaskIntoConstraints = false
            xuberRideStatusView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
            xuberRideStatusView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
            xuberRideStatusView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
            self.xuberRideStatusView = xuberRideStatusView
            xuberRideStatusView.show(with: .bottom, completion: nil)
            
        }
        DispatchQueue.main.async {
            self.setFloatyButton()
            self.xuberRideStatusView.setValues(value: request)
        }
        self.xuberRideStatusView.onTapStatusButton = { [weak self] in
            guard let self = self else {
                return
            }
            self.showCancelTable()
        }
        self.xuberRideStatusView.onTapInfoButton = { [weak self] in
            guard let self = self else {
                return
            }
            if URL(string: request.before_image ?? "") != nil {
                let vc = ImageViewController()
                
                vc.imageView.sd_setImage(with: URL(string: request.before_image ?? ""), placeholderImage:#imageLiteral(resourceName: "ImagePlaceHolder"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                                  // Perform operation.
                                  if (error != nil) {
                                      // Failed to load image
                                      vc.imageView.image = #imageLiteral(resourceName: "ImagePlaceHolder")
                                  } else {
                                      // Successful in loading image
                                      vc.imageView.image = image
                                  }
                              })
                
                vc.modalPresentationStyle = .overFullScreen
                self.navigationController?.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    // change payment in invoice
    func changeInvoicePaymentTapped() {
        
        let paymentVC = AccountRouter.accountStoryboard.instantiateViewController(withIdentifier: AccountConstant.PaymentSelectViewController) as! PaymentSelectViewController
        paymentVC.isChangePayment = true
        paymentVC.onClickPayment = { [weak self] (type,cardEntity) in
            guard let self = self else {
                return
            }
            self.xuberInvoice.paymentType = type
            print(type.rawValue)
            var param: Parameters = [XuberInput.id : self.currentRequest?.id ?? 0]
            param[XuberInput.payment_mode] = type.rawValue
            if type == .CARD {
                self.xuberInvoice?.doneButton.setTitle(Constant.confirmPayment.localized, for: .normal)
                self.xuberInvoice?.cardCashLabel.text = Constant.cardPrefix + (cardEntity?.last_four ?? "")
                self.selectedCard = cardEntity
                param[XuberInput.card_id] = cardEntity?.card_id
            } else if type == .CASH {
                self.xuberInvoice?.doneButton.setTitle(Constant.SDone.localized, for: .normal)
            }
            self.xuberPresenter?.updatePayment(param: param)
        }
        navigationController?.pushViewController(paymentVC, animated: true)
    }
    
    func showCancelTable() {
        if tableView == nil, let tableView = Bundle.main.loadNibNamed(Constant.CustomTableView, owner: self, options: [:])?.first as? CustomTableView {
            
            let height = (view.frame.height/100)*35
            tableView.frame = CGRect(x: 20, y: (self.view.frame.height/2)-(height/2), width: self.view.frame.width-40, height: height)
            tableView.heading = Constant.chooseReason.localized
            self.tableView = tableView
            self.tableView?.setCornerRadiuswithValue(value: 10.0)
            var reasonArr:[String] = []
            for reason in self.reasonData ?? [] {
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
        var param:Parameters = [XuberInput.id : currentRequest?.id ??  0]
        if reason !=  nil {
            param[XuberInput.reason] = reason
        }
        xuberPresenter?.cancelRequest(param: param)
    }
    
    func showDimView(view: UIView) {
        let dimView = UIView(frame: self.view.frame)
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        dimView.addSubview(view)
        self.view.addSubview(dimView)
    }
    
    // Handle Request Data
    
    func handleXuberRequest(request: XuberRequestData) {
        
        guard let status = request.status else { return }
        SendRequestInput.shared.mainSelectedService = request.category?.service_category_name //if cancel - redirect to ServiceSelectionController its used for getting service list
        SendRequestInput.shared.mainServiceId = request.category?.id
        self.sourceLocationDetail = SourceDestinationLocation(address: request.s_address ?? "",locationCoordinate: LocationCoordinate(latitude: (request.provider?.latitude ?? APPConstant.defaultMapLocation.latitude), longitude: (request.provider?.longitude ?? APPConstant.defaultMapLocation.longitude)))
        
        self.destinationLocationDetail = SourceDestinationLocation(address: request.s_address ?? "",locationCoordinate: LocationCoordinate(latitude: (request.s_latitude ?? APPConstant.defaultMapLocation.latitude), longitude: (request.s_longitude ?? APPConstant.defaultMapLocation.longitude)))
        
        switch status {
        case XuberRideStatus.SEARCHING.rawValue:
            self.showLoaderView()
            print("=== Searching")
        case XuberRideStatus.ACCEPTED.rawValue:
            print("=== Accepted")
            self.showRideStatus(request: request)
            DispatchQueue.main.async {
                self.xmapView?.setSourceLocationMarker(sourceCoordinate: self.sourceLocationDetail?.locationCoordinate ?? APPConstant.defaultMapLocation, marker: UIImage(named: Constant.sourcePin) ?? UIImage())
                self.xmapView?.setDestinationLocationMarker(destinationCoordinate: self.destinationLocationDetail?.locationCoordinate ?? APPConstant.defaultMapLocation, marker: UIImage(named: Constant.destinationPin) ?? UIImage())
                self.xmapView?.drawPolyLineFromSourceToDestination(source: self.sourceLocationDetail?.locationCoordinate ?? APPConstant.defaultMapLocation, destination: self.destinationLocationDetail?.locationCoordinate ?? APPConstant.defaultMapLocation, lineColor: .xuberColor)
            }
            self.xmapView?.enableProviderMovement(providerId: currentRequest?.provider?.id ?? 0)
            
        case XuberRideStatus.STARTED.rawValue:
            print("=== Stated")
            self.xmapView?.enableProviderMovement(providerId: 0)
            self.xmapView?.clearAll()
        case XuberRideStatus.ARRIVED.rawValue:
            print("=== Arrived")
            //            self.mapViewHelper?.mapView?.clear()
            self.xmapView?.clearAll()
            self.showRideStatus(request: request)
        case XuberRideStatus.PICKEDUP.rawValue:
            print("=== PickedUp")
            self.showRideStatus(request: request)
        case XuberRideStatus.DROPPED.rawValue:
            print("=== Dropped")
            self.showInvoice(payment: request)
        case XuberRideStatus.COMPLETED.rawValue:
            print("=== Completed")
            if isInvoiceShowed {
                self.showRatingView()
            }else{
                self.showInvoice(payment: request)
            }
            
        case XuberRideStatus.CANCELLED.rawValue:
            print("=== Cancel")
        default:
            break
        }
        self.rideStatus = XuberRideStatus(rawValue: request.status ?? "") ?? .none
        self.currentRequest = request
        self.removeUnnecessaryView(with: status)
    }
    // for remove unnecesary view
    func removeUnnecessaryView(with status: String) {
        let rideStatus = XuberRideStatus(rawValue: status) ?? .none
        switch rideStatus {
        case .none, .CANCELLED:
            if loaderView != nil {
                loaderView.dismissView {
                    self.loaderView = nil
                }
            }
            if self.xuberRideStatusView !=  nil {
                self.xuberRideStatusView.dismissView {
                    self.xuberRideStatusView = nil
                }
            }
            if self.ratingView != nil  {
                self.ratingView.dismissView {
                    self.ratingView = nil
                }
            }
            if self.xuberInvoice != nil {
                self.xuberInvoice.dismissView {
                    self.xuberInvoice = nil
                }
            }
        case .ACCEPTED, .STARTED,.PICKEDUP,.ARRIVED :
            if loaderView != nil {
                loaderView.dismissView {
                    self.loaderView = nil
                }
            }
            if self.ratingView != nil  {
                self.ratingView.dismissView {
                    self.ratingView = nil
                }
            }
            if self.xuberInvoice != nil {
                self.xuberInvoice.dismissView {
                    self.xuberInvoice = nil
                }
            }
        case .COMPLETED,.DROPPED:
            if loaderView != nil {
                loaderView.dismissView {
                    self.loaderView = nil
                }
            }
            if self.xuberRideStatusView !=  nil {
                self.xuberRideStatusView.dismissView {
                    self.xuberRideStatusView = nil
                }
            }
        default:
            return
        }
        self.xmapView?.isVisibleCurrentLocation(visible: ![.ACCEPTED,.STARTED].contains(rideStatus))
    }
    
    private func popToHomeView() {
        for vc in self.navigationController?.viewControllers ?? [UIViewController()] {
            if let myViewCont = vc as? HomeViewController
            {
                self.navigationController?.popToViewController(myViewCont, animated: true)
            }
        }
    }
}

extension XuberHomeController: XuberPresenterToXuberViewProtocol {
    
    func getReasons(reasonEntity: ReasonEntity) {
        reasonData = reasonEntity.responseData ?? []
    }
    
    func getCancelRequest(cancelEntity: SuccessEntity) {
        ToastManager.show(title: cancelEntity.message ?? "", state: .success)
        
        DispatchQueue.main.async {
            if self.isFromOrderPage {
                self.navigationController?.popViewController(animated: true)
            }else{
                self.popToHomeView()
            }
        }
    }
    
    func getCancelError(response: Any) {
        if isFromOrderPage {
            self.navigationController?.popViewController(animated: true)
        }else {
            self.popToHomeView()
        }
    }
    
    func getRating(ratingEntity: SuccessEntity) {
        BackGroundRequestManager.share.resetBackGroudTask()
        SendRequestInput.shared.clear()
        ratingView?.superview?.dismissView(onCompletion: {
            self.ratingView = nil
        })
        SendRequestInput.shared.useWallet = false
        if let requestWallet = currentRequest?.payment?.wallet, requestWallet > 0 {
            //Locally change wallet amount, without hitting profile API
            var walletBalance = AppManager.shared.getUserDetails()?.wallet_balance
            walletBalance = (walletBalance ?? 0) - requestWallet
            AppManager.shared.getUserDetails()?.wallet_balance = walletBalance
        }
        ToastManager.show(title: Constant.RatingToast, state: .success)
        if isFromOrderPage {
            self.navigationController?.popViewController(animated: true)
        }else{
            popToHomeView()
        }
    }
    
    func getUpdatePayment(paymentEntity: SuccessEntity) {
    }
    
    func nonCashPayment(paymentEntity: SuccessEntity) {
        if paymentEntity.message == "Paid" {
            xuberInvoice?.dismissView(onCompletion: {
                self.xuberInvoice = nil
            })
            isInvoiceShowed = true //Flag for invoice show
            showRatingView()
        }
    }
    
    func xuberCheckRequest(request: XuberRequestEntity) {
        Serveotp = request.request?.serve_otp ?? ""
        if let request = request.request?.data?.first {
            currentRequest = request
          
            socketAndBgTaskSetUp()
            DispatchQueue.main.async {
                self.handleXuberRequest(request: request)
            }
        }else {
            popToHomeView()
        }
    }
}
