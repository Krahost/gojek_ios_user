//
//  TaxiHomeViewController.swift
//  GoJekUser
//
//  Created by Ansar on 10/06/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SDWebImage
class TaxiHomeViewController: UIViewController {
    
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var sourceView:UIView!
    @IBOutlet weak var destinationView:UIView!
    @IBOutlet weak var addressBGView:UIView!
    @IBOutlet weak var viewCurrentLocation: UIView!
    @IBOutlet weak var backButton:UIButton!
    @IBOutlet weak var sourceTextField: UITextField!
    @IBOutlet weak var destinationTextField: UITextField!
    
    var rideTypeId:Int? //getting from menu list
    var fromChatNotification: Bool? = false
    var riderStatus: TaxiRideStatus = .none
    var serviceList: [Services]?
    var paymentMode: PaymentType?
    var reasonData: [ReasonData]?
    var isInvoiceShowed: Bool? = false
    var xmapView: XMapView?
    var selectedCard = CardResponseData()
    var serviceSelectionView: ServiceSelectionView?
    var loaderView: LoaderView?
    var tableView: CustomTableView?
    var invoiceView: InvoiceView?
    var rateCardView: RateCardView?
    var ratingView: RatingView?
    var rideDetailView: RideDetailView?
    var rideStatusView: RideStatusView?
    var floatyButton: FloatyButton?
    var sosButton: UIButton?
    var isFromOrderPage = false
    var isAppPresentTapOnPush:Bool = false // avoiding multiple screens redirectns,if same push comes multiple times
    var isChatAlreadyPresented:Bool = false
    var isAppFrom =  false
    var currentLocationImage = UIImageView()
    var newRequest = false
    var sourceLocationDetail = SourceDestinationLocation() {
        didSet {
            DispatchQueue.main.async {
                self.sourceTextField.text = self.sourceLocationDetail.address
            }
        }
    }
    
    var destinationLocationDetail = SourceDestinationLocation() {
        didSet {
            self.destinationTextField.text = self.destinationLocationDetail.address
            DispatchQueue.main.async {
                    self.xmapView?.removePolylines()
                    self.xmapView?.drawPolyLineFromSourceToDestination(source: self.sourceLocationDetail.locationCoordinate ?? APPConstant.defaultMapLocation, destination: self.destinationLocationDetail.locationCoordinate ?? APPConstant.defaultMapLocation, lineColor: .courierColor)
            }
        }
    }
    
    var currentRequest : RequestResponseData? {
        didSet {
            DispatchQueue.main.async {
                if (self.currentRequest?.data?.count ?? 0) > 0 {
                    self.handleRequest()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoads()
        isAppFrom = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.hideTabBar()
        }
        self.viewWillAppearCustom()
        XCurrentLocation.shared.latitude = 0
        XCurrentLocation.shared.longitude = 0
        isAppPresentTapOnPush = false
        ChatPushClick.shared.isPushClick = true
        //For chat
        NotificationCenter.default.addObserver(self, selector: #selector(isChatPushRedirection), name: Notification.Name(pushNotificationType.chat_transport.rawValue), object: nil)
        BackGroundRequestManager.share.stopBackGroundRequest()
      //  socketSettingUpdate()
        self.socketAndBgTaskSetUp()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.removeMapView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.viewWillLayoutSubviewCustom()
    }
    
}

//MARK: - Methods
extension TaxiHomeViewController {
    private func initialLoads() {
        self.localization()
        setFont()
        mapView.backgroundColor = .whiteColor
        self.backButton.addTarget(self, action: #selector(tapBack), for: .touchUpInside)
        // for to get cancel reasons list
        //BackGroundRequestManager.share.stopBackGroundRequest()
        //self.socketAndBgTaskSetUp()
        currentLocationImage.image = UIImage(named: TaxiConstant.car_marker)?.resizeImage(newWidth: 25)
        let locationViewGesture = UITapGestureRecognizer(target: self, action: #selector(tapCurrentLocation(_:)))
        self.viewCurrentLocation.addGestureRecognizer(locationViewGesture)
        NotificationCenter.default.addObserver(self, selector: #selector(enterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        sourceTextField.backgroundColor = .boxColor
        destinationTextField.backgroundColor = .boxColor
        sourceTextField.textColor = .blackColor
        destinationTextField.textColor = .blackColor
        sourceView.backgroundColor = .boxColor
        destinationView.backgroundColor = .boxColor
        mapView.backgroundColor = .whiteColor
    }
    
    @objc private func enterForeground() {
        
        if let _ = currentRequest {
            currentRequest = nil
        }
        isAppFrom = false
        BackGroundRequestManager.share.resetBackGroudTask()
        socketAndBgTaskSetUp()
    }
    
    private func viewWillAppearCustom() {
        
        self.navigationController?.isNavigationBarHidden = true
        self.addMapView()
        if CommonFunction.checkisRTL() {
            //self.backButton.imageView?.image = UIImage.init(named: Constant.ic_back)?.ro
            self.backButton.imageView!.transform = self.backButton.imageView!.transform.rotated(by: .pi)
        }else {
            self.backButton.imageView?.image = UIImage.init(named: Constant.ic_back)
        }
        self.backButton.tintColor = .blackColor
        self.xmapView?.didUpdateLocation = { [weak self] (location) in
            guard let self = self else {
                return
            }
            self.xmapView?.locationUpdate = self
            print("current location : \(location)")
            let currentLocation = CLLocation(latitude: location.latitude ?? 0, longitude: location.longitude ?? 0)
            if self.sourceLocationDetail.locationCoordinate == nil {
                self.xmapView?.currentLocation = currentLocation
                self.getCurrentLocationDetails()
            }else{
                self.xmapView?.moveCameraPosition(lat: self.sourceLocationDetail.locationCoordinate?.latitude ?? APPConstant.defaultMapLocation.latitude, lng: self.sourceLocationDetail.locationCoordinate?.longitude ?? APPConstant.defaultMapLocation.longitude)
            }
        }
        getReasons()
        DispatchQueue.main.async {
            self.setSourceDestinationAndPolyline()
        }
        
        if fromChatNotification == true {
            fromChatNotification = false
            ChatPushClick.shared.isPushClick = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                if self.isAppPresentTapOnPush == false {
                    self.isAppPresentTapOnPush = true
                    self.isChatAlreadyPresented = false
                }
                else {
                    self.isChatAlreadyPresented = true
                }
                self.navigationToChatView()
            }
        }
    }
    
    private func viewWillLayoutSubviewCustom() {
        addressBGView.addShadow(radius: 8, color: .lightGray)
        destinationView.addShadow(radius: 0, color: .lightGray)
        viewCurrentLocation.setRadiusWithShadow()
        self.xmapView?.frame = self.mapView.bounds
        DispatchQueue.main.async {
            self.sosButton?.setCornerRadius()
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
                self.navigationToChatView()
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
                    self.navigationToChatView()
                }
                
            }
        }else{
            
        }
    }
    
    private func localization() {
        sourceTextField.placeholder = TaxiConstant.enterSource.localized
        destinationTextField.placeholder = TaxiConstant.enterDestination.localized
    }
    
    private func setFont() {
        sourceTextField.font = UIFont.setCustomFont(name: .medium, size: .x14)
        destinationTextField.font = UIFont.setCustomFont(name: .medium, size: .x14)
    }
    
    //Getting current location detail
    private func getCurrentLocationDetails() {
        xmapView?.getCurrentLocationDetail { [weak self] (location) in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                if let cLocation = self.sourceLocationDetail.locationCoordinate,cLocation.latitude == 0 {
                    self.storeCurrentLocation(location: location)
                } else {
                    self.storeCurrentLocation(location: location)
                    if (self.currentRequest?.data?.count ?? 0) == 0 {
                        self.getServiceListAPI()
                    }
                }
            }
        }
    }
    
    private func setSourceDestinationAndPolyline() {
        if (currentRequest?.data?.count ?? 0) > 0 {
            handleRequest()
            return
        }
        if !(sourceTextField.text?.isEmpty ?? false) && !(destinationTextField.text?.isEmpty ?? false) {
            getServiceListAPI()
            DispatchQueue.main.async {
                self.setSourceDestinationMarker()
                self.xmapView?.drawPolyLineFromSourceToDestination(source: self.sourceLocationDetail.locationCoordinate ?? APPConstant.defaultMapLocation, destination: self.destinationLocationDetail.locationCoordinate ?? APPConstant.defaultMapLocation, lineColor: .taxiColor)
                //   self.xmapView?.showCurrentLocation()
                
            }
        }
    }
    
    private func addMapView() {
        xmapView = XMapView(frame: self.mapView.bounds)
        xmapView?.tag = 100
        guard let _ = xmapView else {
            return
        }
        self.mapView.addSubview(self.xmapView!)
        self.mapView.bringSubviewToFront(self.floatyButton ?? UIButton()) // bring to front view if goes to chat and come back in between flow
        self.mapView.bringSubviewToFront(self.sosButton ?? UIButton())
        self.xmapView?.didDragMap = { [weak self] (isDrag,_) in
            guard let self = self else {
                return
            }
            self.serviceSelectionView?.isHidden = isDrag
            self.rateCardView?.isHidden = isDrag
            self.rideDetailView?.isHidden = isDrag
            self.rideStatusView?.isHidden = isDrag
            self.floatyButton?.isHidden = isDrag
            self.sosButton?.isHidden = isDrag
        }
    }
    
    private func removeMapView() {
        for subView in mapView.subviews where subView.tag == 100 {
            xmapView?.clearAll()
            subView.removeFromSuperview()
            xmapView?.currentLocation = nil
            xmapView = nil
        }
    }
    
    private func setMenuButton() {
        if let _ = self.getSosButton() {
            self.sosButton?.setTitle(TaxiConstant.sos, for: .normal)
            self.sosButton?.addTarget(self, action: #selector(sosButtonAction(_:)), for: .touchUpInside)
            self.sosButton?.titleLabel?.font = UIFont.setCustomFont(name: .bold, size: .x14)
            self.sosButton?.setTitleColor(.white, for: .normal)
            self.sosButton?.backgroundColor = .black
        }
        if let _ = getFloatyView() {
            floatyButton?.buttonOneImage = UIImage(named: Constant.phoneImage)?.imageTintColor(color1: .white) ?? UIImage()
            floatyButton?.buttonTwoImage = UIImage(named: Constant.chatImage)?.imageTintColor(color1: .white) ?? UIImage()
            floatyButton?.bgColor = .taxiColor
            floatyButton?.backgroundColor = .black
            floatyButton?.onTapButtonOne = { [weak self] in
                guard let self = self else {
                    return
                }
                if let phoneNumber = self.currentRequest?.data?.first?.provider?.mobile {
                    AppUtils.shared.call(to: phoneNumber)
                }
            }
            floatyButton?.onTapButtonTwo = { [weak self] in
                guard let self = self else {
                    return
                }
                self.navigationToChatView()
            }
        }
    }
    
    @objc func sosButtonAction(_ sender: UIButton) {
        if let phoneNumber = currentRequest?.sos {
            AppUtils.shared.call(to: phoneNumber)
        }
    }
    
    func navigationToChatView() {
        
        let checkRequestDetail = currentRequest?.data?.first
        let providerDetail = checkRequestDetail?.provider
        let userDetail = checkRequestDetail?.user
        let serviceDetail = checkRequestDetail?.service_type
        let chatView = ChatViewController()
        chatView.requestId = "\((checkRequestDetail?.id ?? 0))"
        chatView.chatRequestFrom = MasterServices.Transport.rawValue
        chatView.userId = "\((userDetail?.id ?? 0))"
        chatView.userName = "\( userDetail?.firstName ?? "")" + " " + "\(userDetail?.lastName ?? "")"
        chatView.providerId = "\((providerDetail?.id ?? 0))"
        chatView.providerName = "\(providerDetail?.first_name ?? "")" + " " + "\(providerDetail?.last_name ?? "")"
        chatView.adminServiceId = serviceDetail?.admin_service_id
        chatView.isChatPresented = isChatAlreadyPresented
        self.navigationController?.pushViewController(chatView, animated: true)
    }
    
    private func getFloatyView() -> FloatyButton? {
        guard let _ = floatyButton else {
            floatyButton = FloatyButton()
            mapView.addSubview(self.floatyButton ?? UIView())
            if let taxiView = self.rideStatusView {
                floatyButton?.translatesAutoresizingMaskIntoConstraints = false
                floatyButton?.bottomAnchor.constraint(equalTo: taxiView.topAnchor, constant: -10).isActive = true
                floatyButton?.rightAnchor.constraint(equalTo: taxiView.rightAnchor, constant: -10).isActive = true
                floatyButton?.heightAnchor.constraint(equalTo: taxiView.widthAnchor, multiplier: 0.12).isActive = true
                floatyButton?.widthAnchor.constraint(equalTo: taxiView.widthAnchor, multiplier: 0.12).isActive = true
            }
            return floatyButton
        }
        return floatyButton
    }
    
    private func getSosButton() -> UIButton? {
        guard let _ = sosButton else {
            sosButton = UIButton()
            mapView.addSubview(self.sosButton ?? UIButton())
            if let taxiView = self.rideStatusView {
                sosButton?.translatesAutoresizingMaskIntoConstraints = false
                sosButton?.bottomAnchor.constraint(equalTo: taxiView.topAnchor, constant: -10).isActive = true
                sosButton?.leftAnchor.constraint(equalTo: taxiView.leftAnchor, constant: 10).isActive = true
                sosButton?.heightAnchor.constraint(equalTo: taxiView.widthAnchor, multiplier: 0.12).isActive = true
                sosButton?.widthAnchor.constraint(equalTo: taxiView.widthAnchor, multiplier: 0.12).isActive = true
            }
            return sosButton
        }
        return self.sosButton
    }
    
    func storeCurrentLocation(location:LocationDetail) {
        self.sourceLocationDetail = SourceDestinationLocation(address: location.address,locationCoordinate: LocationCoordinate(latitude: (location.coordinate.latitude), longitude: (location.coordinate.longitude)))
        self.xmapView?.showCurrentLocation()
    }
    
    func socketAndBgTaskSetUp() {
        if let requestData = currentRequest,requestData.data?.first?.id ?? 0 != 0 {
            BackGroundRequestManager.share.startBackGroundRequest(type: .ModuleWise, roomId: SocketUtitils.construtRoomKey(requestID: "\(requestData.data?.first?.id ?? 0)", serviceType: .transport), listener: .Transport)
            BackGroundRequestManager.share.requestCallback =  { [weak self] in
                guard let self = self else {
                    return
                }
                self.checkRequestApiCall()
            }
        } else {
            checkRequestApiCall()
        }
    }
    
    func socketBaseApi(){
        
    }
    
    func checkRequestApiCall() {
        self.taxiPresenter?.checkTaxiRequest()
    }
    
    private func getServiceListAPI() {
        self.getServiceList(location: self.sourceLocationDetail.locationCoordinate ?? CLLocationCoordinate2D())
    }
    
    @objc func tapCurrentLocation(_ sender: UITapGestureRecognizer) {
        xmapView?.showCurrentLocation()
    }
    
    private func getReasons() {
        self.taxiPresenter?.getReasons(param: [TaxiConstant.type: ServiceType.trips.currentType])
    }
    
    func getServiceList(location: LocationCoordinate) {
        if location.latitude == 0 {
            getCurrentLocationDetails()
        }else if (serviceList?.count ?? 0 > 0) && riderStatus == .none {
            showServiceList()
        }else {
            let tempId = "\(AppManager.shared.getSelectedServices()?.menu_type_id ?? 0)"
            let param: Parameters = [TaxiConstant.type: tempId,
                                     AccountConstant.latitude: location.latitude,
                                     AccountConstant.longitude: location.longitude,
                                     LoginConstant.city_id: guestAccountCity]
            self.taxiPresenter?.getServiceList(param: param)
        }
    }
    
    private func handleRequest() {
        guard let status = currentRequest?.data?.first?.status, currentRequest?.data?.first?.id != nil else {
            self.riderStatus = .none
            self.removeAllView()
            return
        }
        self.sourceLocationDetail = SourceDestinationLocation(address: currentRequest?.data?.first?.s_address ?? "", locationCoordinate: CLLocationCoordinate2D(latitude: currentRequest?.data?.first?.s_latitude ?? 0, longitude: currentRequest?.data?.first?.s_longitude ?? 0))
        if (TaxiRideStatus(rawValue: status) ?? TaxiRideStatus.none) == .started {
            self.destinationLocationDetail = SourceDestinationLocation(address: currentRequest?.data?.first?.d_address ?? "", locationCoordinate: CLLocationCoordinate2D(latitude: currentRequest?.data?.first?.provider?.latitude ?? 0, longitude: currentRequest?.data?.first?.provider?.longitude ?? 0))
        }
        else{
            self.destinationLocationDetail = SourceDestinationLocation(address: currentRequest?.data?.first?.d_address ?? "", locationCoordinate: CLLocationCoordinate2D(latitude: currentRequest?.data?.first?.d_latitude ?? 0, longitude: currentRequest?.data?.first?.d_longitude ?? 0))
        }
        
        //        self.xmapView?.removeLocationMarkers()
        
        if let markerURL = URL(string: currentRequest?.data?.first?.ride?.vehicle_marker ?? "") {
            self.currentLocationImage.load(url: markerURL, completion: { (image) in
                DispatchQueue.main.async {
                    self.xmapView?.currentLocationMarkerImage = image.resizeImage(newWidth: 30)
                    self.xmapView?.setProviderCurrentLocationMarkerPosition(coordinate: self.sourceLocationDetail.locationCoordinate ?? CLLocationCoordinate2D())
                    self.xmapView?.setDestinationLocationMarker(destinationCoordinate: self.destinationLocationDetail.locationCoordinate ?? APPConstant.defaultMapLocation, marker: UIImage(named: Constant.destinationPin) ?? UIImage())
                }
            })
            
        }else{
            self.xmapView?.currentLocationMarkerImage = self.currentLocationImage.image
        }
        self.riderStatus = TaxiRideStatus(rawValue: status) ?? TaxiRideStatus.none
        print("##### \(status)")
        switch riderStatus {
        case .searching:
            handleSearch()
        case .accepted, .pickedup, .started, .arrived :
            setSourceDestinationMarker()
            
            handleOnRide(with: status)
        case .dropped:
            handleDropped()
        case .completed:
            handleComplete()
        default:
            removeAllView()
        }
        addressBGView.isHidden = ![TaxiRideStatus.none].contains(riderStatus)
        if [TaxiRideStatus.searching,TaxiRideStatus.completed,TaxiRideStatus.none].contains(riderStatus) {
            self.xmapView?.isVisibleCurrentLocation(visible: true)
        }else{
            self.xmapView?.isVisibleCurrentLocation(visible: false)
        }
    }
    
    @objc func extendTripSelect() {
        AppAlert.shared.simpleAlert(view: self, title: "", message: Constant.extendTripAlert.localized, buttonOneTitle: Constant.SYes.localized, buttonTwoTitle: Constant.SNo.localized)
        AppAlert.shared.onTapAction = { [weak self] tag in
            guard let self = self else {
                return
            }
            if tag == 0 {
                let locationView = TaxiRouter.taxiStoryboard.instantiateViewController(withIdentifier: TaxiConstant.LocationSelectionController) as! LocationSelectionController
                locationView.isSource = false
                locationView.isExtendTrip = true
                locationView.isExtendTripSelectedLocation = { [weak self] addressData in
                    guard let self = self else {
                        return
                    }
                    // print(addressData)
                    let extendParams:Parameters = [TaxiConstant.id: self.currentRequest?.data?.first?.id ?? 0,
                                                   TaxiConstant.latitude: addressData.locationCoordinate?.latitude ?? 0.0,
                                                   TaxiConstant.longitude: addressData.locationCoordinate?.longitude ?? 0.0,
                                                   TaxiConstant.address: addressData.address ?? ""]
                    self.taxiPresenter?.extendTrip(param: extendParams)
                }
                self.navigationController?.pushViewController(locationView, animated: true)
            }
        }
    }
    
    // change payment in invoice
    @objc func changeInvoicePaymentTapped() {
        
        let paymentVC = AccountRouter.accountStoryboard.instantiateViewController(withIdentifier: AccountConstant.PaymentSelectViewController) as! PaymentSelectViewController
        paymentVC.isChangePayment = true
        paymentVC.onClickPayment = { [weak self] (type,cardEntity) in
            guard let self = self else {
                return
            }
            self.paymentMode = type
            self.invoiceView?.paymentType = type
            if type == .CASH {
                self.invoiceView?.cardCashLabel.text = type.rawValue
                self.invoiceView?.paymentImage.image = PaymentType(rawValue: type.rawValue)?.image
            } else {
                self.selectedCard = cardEntity!
                self.invoiceView?.cardCashLabel.text = Constant.cardPrefix + cardEntity!.last_four!
                self.invoiceView?.paymentImage.image = PaymentType(rawValue: type.rawValue)?.image
            }
            
            self.taxiPresenter?.updatePayment(param: [TaxiConstant.id: self.currentRequest?.data?.first?.id ?? 0,
                                                      TaxiConstant.payment_mode: self.paymentMode?.rawValue ?? PaymentType.CASH.rawValue,
                                                      TaxiConstant.card_id: self.selectedCard.card_id ?? ""])
        }
        self.navigationController?.pushViewController(paymentVC, animated: true)
    }
    
    private func showDimView(view: UIView) {
        let dimView = UIView(frame: self.view.frame)
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        dimView.addSubview(view)
        self.view.addSubview(dimView)
    }
    
    @objc func tapBack() {
         ChatPushClick.shared.isPushClick = false
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func tapCurrentLocation() {
        DispatchQueue.main.async {
            self.xmapView?.showCurrentLocation()
        }
    }
}

//MARK: UI Methods

extension TaxiHomeViewController {
    
    func showServiceList() {
        if let _ = getServiceListView() {
            DispatchQueue.main.async {
                self.serviceSelectionView?.serviceDetails = self.serviceList ?? []
            }
            serviceSelectionView?.paymentChangeClick = { [weak self] (paymentModes,cardEntity) in
                guard let self = self else {
                    return
                }
                self.paymentMode = paymentModes
                self.selectedCard = cardEntity
                if (self.currentRequest?.data?.count ?? 0) > 0 {
                    self.taxiPresenter?.updatePayment(param: [TaxiConstant.id: self.currentRequest?.data?.first?.id ?? 0,
                                                              TaxiConstant.payment_mode: self.paymentMode?.rawValue ?? PaymentType.CASH.rawValue,
                                                              TaxiConstant.card_id: self.selectedCard.card_id ?? ""])
                }
            }
            serviceSelectionView?.tapService = { [weak self] (servicesData) in
                guard let self = self else {
                    return
                }
                if let serviceView = self.serviceSelectionView {
                    if (self.removeView(viewObj: serviceView)) {
                        self.serviceSelectionView = nil
                    }
                    self.showRateCard(serviceData: servicesData)
                }
                
            }
            serviceSelectionView?.tapGetPricing = { [weak self] selectedService in
                guard let self = self else {
                    return
                }
                if self.destinationTextField.text?.trimString().count == 0 {
                    ToastManager.show(title: TaxiConstant.chooseProviderLoc.localized, state: .error)
                    return
                }
                let requestEntity = TaxiReuqestEntity()
                requestEntity.s_latitude = self.sourceLocationDetail.locationCoordinate?.latitude ?? 0.0
                requestEntity.s_longitude = self.sourceLocationDetail.locationCoordinate?.longitude ?? 0.0
                requestEntity.s_address = self.sourceLocationDetail.address
                requestEntity.service_type = selectedService.id
                requestEntity.d_latitude = self.destinationLocationDetail.locationCoordinate?.latitude ?? 0.0
                requestEntity.d_longitude = self.destinationLocationDetail.locationCoordinate?.longitude ?? 0.0
                requestEntity.d_address = self.destinationLocationDetail.address
                requestEntity.payment_mode = self.paymentMode?.rawValue ?? PaymentType.CASH.rawValue
                requestEntity.rideTypeId = self.rideTypeId ?? 0
                
                let estimationVC = TaxiRouter.taxiStoryboard.instantiateViewController(withIdentifier: TaxiConstant.PriceEstimationController) as! PriceEstimationController
                estimationVC.requestEntity = requestEntity
                estimationVC.rideNowDelegate = self
                self.navigationController?.pushViewController(estimationVC, animated: true)
            }
        }
    }
    
    func showRateCard(serviceData: Services) {
        if let _ = self.getRateCardView() {
            rateCardView?.setValues(serviceData: serviceData)
            self.rateCardView?.tapDone = { [weak self] in
                guard let self = self else {
                    return
                }
                if (self.removeView(viewObj: self.rateCardView)) {
                    self.rateCardView = nil
                }
                self.showServiceList()
            }
        }
    }
    
    private func showLoaderView() {
        if let _ = self.getLoaderView() {
            loaderView?.cancelRequestButton.backgroundColor = .taxiColor
            self.loaderView?.onClickCancelRequest = { [weak self] in
                guard let self = self else {
                    return
                }
                self.showCancelTable()
            }
        }
    }
    
    // cancel reasons func
    private func showCancelTable() {
        if self.tableView == nil, let tableView = Bundle.main.loadNibNamed(Constant.CustomTableView, owner: self, options: [:])?.first as? CustomTableView {
            let height = (self.view.frame.height/100)*35
            tableView.frame = CGRect(x: 20, y: (self.view.frame.height/2)-(height/2), width: self.view.frame.width-40, height: height)
            tableView.heading = Constant.chooseReason.localized
            self.tableView = tableView
            var reasonArr:[String] = []
            for reason in self.reasonData ?? [] {
                reasonArr.append(reason.reason ?? "")
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
            let param: Parameters = [TaxiConstant.id: self.currentRequest?.data?.first?.id  ?? 0,
                                     TaxiConstant.reason: selectedReason]
            self.taxiPresenter?.cancelRequest(param: param)
        }
    }
    
    func showInvoice(with request: RequestData) {
        if let _ = self.getInvoiceView() {
            self.invoiceView?.changeButton.addTarget(self, action: #selector(self.changeInvoicePaymentTapped), for: .touchUpInside)
            self.invoiceView?.onClickConfirm = { [weak self] (tipsAmount,isCash) in
                guard let self = self else {
                    return
                }
                self.invoiceView?.dismissView(onCompletion: {
                    self.invoiceView = nil
                })
                if isCash  {
                    self.isInvoiceShowed = true
                    self.showRatingView(with: request)
                }else{
                    if request.paid == 1 {
                        self.showRatingView(with: request)
                    }else {
                        let param: Parameters = [TaxiConstant.id: request.id ?? 0,
                                                 TaxiConstant.tips: tipsAmount,
                                                 TaxiConstant.card_id: self.selectedCard.card_id ?? ""]
                        self.taxiPresenter?.invoicePayment(param: param)
                    }
                }
            }
            self.invoiceView?.setValues(values: request)
        }
    }
    
    func showRatingView(with request : RequestData) {
        
        if let requestWallet = request.payment?.wallet, requestWallet > 0 {  //Locally change wallet amount, without hitting profile API
            var walletBalance = AppManager.shared.getUserDetails()?.wallet_balance
            walletBalance = (walletBalance ?? 0) - requestWallet
            AppManager.shared.getUserDetails()?.wallet_balance = walletBalance
        }
        
        if let _ = self.getRatingView() {
            if self.removeView(viewObj: self.invoiceView) {
                self.invoiceView = nil
            }
            self.ratingView?.setValues(color: .taxiColor)
            self.ratingView?.idLabel.text = TaxiConstant.bookingId.localized + ":" + "\(String(describing: request.booking_id ?? ""))"
            if let provider = request.provider {
                self.ratingView?.userNameLabel.text = provider.first_name
                
                self.ratingView?.userNameImage.sd_setImage(with: URL(string: provider.picture ?? ""), placeholderImage:#imageLiteral(resourceName: "ImagePlaceHolder"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                    // Perform operation.
                    if (error != nil) {
                        // Failed to load image
                        self.ratingView?.userNameImage.image = #imageLiteral(resourceName: "ImagePlaceHolder")
                    } else {
                        // Successful in loading image
                        self.ratingView?.userNameImage.image = image
                    }
                })
            }
            self.ratingView?.onClickSubmit = { [weak self] (rating, comments) in
                guard let self = self else {
                    return
                }
                if (self.currentRequest?.data?.first?.id ?? 0) > 0 {
                    let comment = comments == Constant.leaveComment.localized ? "" : comments
                    let param: Parameters = [TaxiConstant.id: self.currentRequest?.data?.first?.id ?? 0,
                                             TaxiConstant.rating: rating,
                                             TaxiConstant.comment: comment,
                                             TaxiConstant.admin_service_id: request.service_type?.admin_service_id ?? ""]
                    self.taxiPresenter?.ratingToProvider(param: param)
                }
            }
        }
    }
    
    func showRideStatusView(with request : RequestData) {
        if let _ = self.getRideStatusView() {
            if self.rideStatusView != nil {
                self.rideStatusView?.set(values: request)
                let status = TaxiRideStatus(rawValue: request.status ?? "") ?? .none
                setMenuButton()
                if status == .pickedup {
                    floatyButton?.removeFromSuperview()
                    floatyButton = nil
                }
            }
            self.rideStatusView?.onClickCancelOrShareRide =  { [weak self] (isCancel) in
                if isCancel {
                    self?.showCancelTable()
                }else{
                    self?.shareRide()
                }
            }
            // show riding status view
            self.showDetailView(with: request)
        }
    }
    
    private func getRateCardView() -> RateCardView?{
        guard let _ = self.rateCardView else {
            if let rateCardView = Bundle.main.loadNibNamed(TaxiConstant.RateCardView, owner: self, options: [:])?.first as? RateCardView {
                self.view.addSubview(rateCardView)
                rateCardView.translatesAutoresizingMaskIntoConstraints = false
                rateCardView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
                rateCardView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
                rateCardView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
                rateCardView.show(with: .bottom, completion: nil)
                rateCardView.layoutIfNeeded()
                self.rateCardView = rateCardView
            }
            return rateCardView
        }
        return self.rateCardView
    }
    
    private func getRideStatusView() -> RideStatusView? {
        guard let _ = self.rideStatusView else {
            if let rideStatusView =  Bundle.main.loadNibNamed(TaxiConstant.RideStatusView, owner: self, options: [:])?.first as? RideStatusView {
                self.view.addSubview(rideStatusView)
                rideStatusView.translatesAutoresizingMaskIntoConstraints = false
                rideStatusView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
                rideStatusView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
                rideStatusView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
                rideStatusView.show(with: .right, completion: nil)
                rideStatusView.layoutIfNeeded()
                self.rideStatusView = rideStatusView
            }
            return rideStatusView
        }
        return self.rideStatusView
    }
    
    private func getRatingView() -> RatingView? {
        guard let _ = self.ratingView else {
            if let ratingView = Bundle.main.loadNibNamed(Constant.RatingView, owner: self, options: [:])?.first as? RatingView {
                self.view.addSubview(ratingView)
                ratingView.translatesAutoresizingMaskIntoConstraints = false
                ratingView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
                ratingView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
                ratingView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
                ratingView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
                ratingView.show(with: .bottom, completion: nil)
                ratingView.layoutIfNeeded()
                self.ratingView = ratingView
            }
            return ratingView
        }
        return self.ratingView
    }
    
    private func getLoaderView() -> LoaderView?{
        guard let _ = self.loaderView else {
            if let loaderView = Bundle.main.loadNibNamed(TaxiConstant.LoaderView, owner: self, options: [:])?.first as? LoaderView {
                self.view.addSubview(loaderView)
                loaderView.translatesAutoresizingMaskIntoConstraints = false
                loaderView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
                loaderView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
                loaderView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
                loaderView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
                loaderView.show(with: .bottom, completion: nil)
                loaderView.layoutIfNeeded()
                self.loaderView = loaderView
            }
            return loaderView
        }
        return self.loaderView
    }
    
    private func getInvoiceView() -> InvoiceView?{
        guard let _ = self.invoiceView else {
            if let invoiceView = Bundle.main.loadNibNamed(TaxiConstant.InvoiceView, owner: self, options: [:])?.first as? InvoiceView {
                self.view.addSubview(invoiceView)
                invoiceView.translatesAutoresizingMaskIntoConstraints = false
                invoiceView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
                invoiceView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
                invoiceView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
                invoiceView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
                invoiceView.show(with: .bottom, completion: nil)
                invoiceView.layoutIfNeeded()
                self.invoiceView = invoiceView
            }
            return invoiceView
        }
        return self.invoiceView
    }
    
    private func getRideDetailView() -> RideDetailView? {
        guard let _ = self.rideDetailView else {
            if let rideDetailView =  Bundle.main.loadNibNamed(TaxiConstant.RideDetailView, owner: self, options: [:])?.first as? RideDetailView {
                self.view.addSubview(rideDetailView)
                rideDetailView.translatesAutoresizingMaskIntoConstraints = false
                rideDetailView.topAnchor.constraint(equalTo: self.backButton.bottomAnchor, constant: 15).isActive = true
                rideDetailView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
                rideDetailView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
                rideDetailView.show(with: .right, completion: nil)
                rideDetailView.layoutIfNeeded()
                self.rideDetailView = rideDetailView
            }
            return rideDetailView
        }
        return self.rideDetailView
    }
    
    private func getServiceListView() -> ServiceSelectionView?{
        
        guard let _ = self.serviceSelectionView else {
            if let serviceSelectionView =  Bundle.main.loadNibNamed(TaxiConstant.ServiceSelectionView, owner: self, options: [:])?.first as? ServiceSelectionView  {
                self.view.addSubview(serviceSelectionView)
                serviceSelectionView.translatesAutoresizingMaskIntoConstraints = false
                serviceSelectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
                serviceSelectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
                serviceSelectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
                serviceSelectionView.show(with: .bottom, completion: nil)
                self.serviceSelectionView = serviceSelectionView
            }
            return serviceSelectionView
        }
        return self.serviceSelectionView
    }
    
    func showDetailView(with request : RequestData) {
        if let _ = self.getRideDetailView() {
            self.rideDetailView?.extendTripButton.addTarget(self, action: #selector(self.extendTripSelect), for: .touchUpInside)
            self.rideDetailView?.set(values: request)
        }
    }
    
    private func handleSearch() {
        if self.removeView(viewObj: self.rideStatusView) {
            self.rideStatusView = nil
        }
        if self.removeView(viewObj: self.serviceSelectionView) {
            self.serviceSelectionView = nil
        }
        if self.removeView(viewObj: self.invoiceView) {
            self.invoiceView = nil
        }
        if self.removeView(viewObj: self.ratingView) {
            self.ratingView = nil
        }
        if self.removeView(viewObj: self.rideDetailView) {
            self.rideDetailView = nil
        }
        self.tableView?.superview?.dismissView(onCompletion: {
            self.tableView = nil
        })
        self.showLoaderView()
    }
    
    private func handleOnRide(with status: String) {
        if self.removeView(viewObj: self.serviceSelectionView) {
            self.serviceSelectionView = nil
        }
        if self.removeView(viewObj: self.loaderView) {
            self.loaderView = nil
        }
        if self.removeView(viewObj: self.invoiceView) {
            self.invoiceView = nil
        }
        if self.removeView(viewObj: self.ratingView) {
            self.ratingView = nil
        }
        self.tableView?.superview?.dismissView(onCompletion: {
            self.tableView = nil
        })
        DispatchQueue.main.async {
            
            self.xmapView?.drawPolyLineFromSourceToDestination(source: self.sourceLocationDetail.locationCoordinate ?? APPConstant.defaultMapLocation, destination: self.destinationLocationDetail.locationCoordinate ?? APPConstant.defaultMapLocation, lineColor: .taxiColor)
            self.xmapView?.showCurrentLocation()
            
            self.xmapView?.enableProviderMovement(providerId: self.currentRequest?.data?.first?.provider?.id ?? 0)
            self.showRideStatusView(with: self.currentRequest?.data?.first ?? RequestData())
        }
    }
    
    private func handleComplete() {
        if self.removeView(viewObj: self.serviceSelectionView) {
            self.serviceSelectionView = nil
        }
        if self.removeView(viewObj: self.loaderView) {
            self.loaderView = nil
        }
        if self.removeView(viewObj: self.rideStatusView) {
            self.rideStatusView = nil
        }
        if self.removeView(viewObj: self.rideDetailView) {
            self.rideDetailView = nil
        }
        self.tableView?.superview?.dismissView(onCompletion: {
            self.tableView = nil
        })
        self.sosButton?.removeFromSuperview()
        self.sosButton = nil
        self.floatyButton?.removeFromSuperview()
        self.floatyButton = nil
        self.xmapView?.enableProviderMovement(providerId: 0)
        if let requestDetails = self.currentRequest?.data?.first {
            if let invoiceShowed = self.isInvoiceShowed,invoiceShowed == true {
                if self.removeView(viewObj: self.invoiceView) {
                    self.invoiceView = nil
                }
                self.showRatingView(with: requestDetails)
            }else {
                self.showInvoice(with: requestDetails)
            }
        }
    }
    
    private  func handleDropped() {
        if self.removeView(viewObj: self.serviceSelectionView) {
            self.serviceSelectionView = nil
        }
        if self.removeView(viewObj: self.rideStatusView) {
            self.rideStatusView = nil
        }
        if self.removeView(viewObj: self.loaderView) {
            self.loaderView = nil
        }
        
        if self.removeView(viewObj: self.rideDetailView) {
            self.rideDetailView = nil
        }
        if self.removeView(viewObj: self.ratingView) {
            self.ratingView = nil
        }
        if self.removeView(viewObj: self.tableView?.superview) {
            self.tableView = nil
        }
        self.sosButton?.removeFromSuperview()
        self.sosButton = nil
        self.floatyButton?.removeFromSuperview()
        self.floatyButton = nil
        self.xmapView?.enableProviderMovement(providerId: 0)
        self.showInvoice(with: self.currentRequest?.data?.first ?? RequestData())
    }
    
    private func removeAllView() {
         newRequest =  false
        UserDefaults.standard.set(newRequest, forKey: Constant.newRequestHideSearch)
        
        if self.removeView(viewObj: self.rideStatusView) {
            self.rideStatusView = nil
        }
        if self.removeView(viewObj: self.loaderView) {
            self.loaderView = nil
        }
        if self.removeView(viewObj: self.invoiceView) {
            self.invoiceView = nil
        }
        if self.removeView(viewObj: self.ratingView) {
            self.ratingView = nil
        }
        if self.removeView(viewObj: self.rideDetailView) {
            self.rideDetailView = nil
        }
        if self.removeView(viewObj: self.tableView?.superview) {
            self.tableView = nil
        }
        self.sosButton?.removeFromSuperview()
        self.sosButton = nil
        self.floatyButton?.removeFromSuperview()
        self.floatyButton = nil
        self.xmapView?.clearAll()
        self.addressBGView.isHidden = false
        self.destinationLocationDetail = SourceDestinationLocation()
        self.getServiceListAPI()
    }
    
    private func setSourceDestinationMarker() {
        self.xmapView?.setSourceLocationMarker(sourceCoordinate: self.sourceLocationDetail.locationCoordinate ?? APPConstant.defaultMapLocation, marker: UIImage(named: Constant.sourcePin) ?? UIImage())
        self.xmapView?.setDestinationLocationMarker(destinationCoordinate: self.destinationLocationDetail.locationCoordinate ?? APPConstant.defaultMapLocation, marker: UIImage(named: Constant.destinationPin) ?? UIImage())
//        self.xmapView?.setPickupDestinationLocationMarker(sourceCoordinate: self.sourceLocationDetail.locationCoordinate ?? APPConstant.defaultMapLocation,destinationCoordinate: self.destinationLocationDetail.locationCoordinate ?? APPConstant.defaultMapLocation, marker: UIImage(named: Constant.destinationPin) ?? UIImage(), title: currentRequest?.data?.first?.assigned_time ?? "")
    }
    
    private func removeView(viewObj: UIView?) -> Bool {
        if let views = viewObj {
            views.removeFromSuperview()
            return true
        }
        return false
    }
    
    private func shareRide() {
        let rideDetail = currentRequest?.data?.first
        let driverName = (rideDetail?.provider?.first_name ?? .empty).giveSpace + (rideDetail?.provider?.last_name ?? .empty)
        let vehicleNameNo = "\(rideDetail?.service_type?.vehicle?.vehicle_model ?? .empty) " + "(" + "\(rideDetail?.service_type?.vehicle?.vehicle_no ?? .empty)" + ")"
        
        let mapFormat = "http://maps.google.com/maps?q=loc:\(XCurrentLocation.shared.latitude ?? 0),\(XCurrentLocation.shared.longitude ?? 0)"
        let addressDetails = TaxiConstant.tookFrom + " \(rideDetail?.s_address ?? .empty) " + TaxiConstant.to + " \(rideDetail?.d_address ?? .empty)"
        
        var message = TaxiConstant.shareRideInitialContent + " \(driverName) " + TaxiConstant.shareContentIn.giveSpace + vehicleNameNo.giveSpace
        message += TaxiConstant.geolocation + " \(mapFormat)" + "\n"
        message += addressDetails
        
        let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [message], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
}

//MARK:- Textfield Delegate



extension TaxiHomeViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let vc = TaxiRouter.taxiStoryboard.instantiateViewController(withIdentifier: TaxiConstant.LocationSelectionController) as! LocationSelectionController
        vc.locationDelegate = self
        vc.isSource = textField == self.sourceTextField
        self.navigationController?.pushViewController(vc, animated: true)
        return false
    }
}

//MARK:- Location delegate

extension  TaxiHomeViewController: LocationDelegate {
    func selectedLocation(isSource: Bool, addressDetails: SourceDestinationLocation) {
        if isSource {
            self.sourceLocationDetail = addressDetails
            let tempId = "\(AppManager.shared.getSelectedServices()?.menu_type_id ?? 0)"
            let location = sourceLocationDetail.locationCoordinate
            let param: Parameters = [TaxiConstant.type: tempId,
                                     AccountConstant.latitude: location?.latitude ?? String.empty,
                                     AccountConstant.longitude: location?.longitude ?? String.empty,
                                     LoginConstant.city_id: guestAccountCity]
            self.taxiPresenter?.getServiceList(param: param)
        }else{
            self.destinationLocationDetail = addressDetails
        }
    }
}

//MARK:- API calls

extension TaxiHomeViewController: TaxiPresenterToTaxiViewProtocol {
    
    func checkTaxiRequest(requestEntity: Request) {
        if let requestData = requestEntity.responseData?.data, requestData.count > 0 {
            self.currentRequest = requestEntity.responseData
            self.socketAndBgTaskSetUp()
            DispatchQueue.main.async {
                self.handleRequest()
            }
        }else{
            self.currentRequest = requestEntity.responseData
            
            newRequest = UserDefaults.standard.value(forKey: Constant.newRequestHideSearch) as? Bool ?? false

            if newRequest {
                self.riderStatus = .none
                self.removeAllView()
            }
            if isFromOrderPage {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func getServiceList(serviceEntity: ServiceListEntity) {
        
        self.serviceList = serviceEntity.responseData?.services ?? []
        
        if let providers = serviceEntity.responseData?.providers,providers.count > 0 && self.currentRequest?.data?.count == 0 {
            let markerImage = UIImageView()
            
            for providerMarker in providers {
                if let imageUrl = URL(string: serviceEntity.responseData?.services?.first?.vehicle_marker ?? "")  {
                    markerImage.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "ImagePlaceHolder"))
                    
                    markerImage.contentMode = .scaleAspectFit
                }
                let mapMarker = MarkerDetails(image: markerImage.image ?? #imageLiteral(resourceName: "car_placeHolder_Icon"), position:LocationCoordinate(latitude: providerMarker.latitude ?? 0.0, longitude: providerMarker.longitude ?? 0.0))
                self.xmapView?.addMarker(markers: mapMarker)
            }
        }
        DispatchQueue.main.async {
            if (self.currentRequest?.data?.count ?? 0) == 0 || self.riderStatus == .none {
                self.showServiceList()
            }
        }
    }
    
    // get cancel reasons
    func getReasonsResponse(reasonEntity: ReasonEntity) {
        self.reasonData = reasonEntity.responseData ?? []
    }
    
    func ratingToProviderSuccess(requestEntity: Request) {
        BackGroundRequestManager.share.resetBackGroudTask()
        self.currentRequest = requestEntity.responseData
        self.isInvoiceShowed = false
        handleRequest()
        ToastManager.show(title: Constant.RatingToast, state: .success)
        socketAndBgTaskSetUp()
        paymentMode = PaymentType(rawValue: PaymentType.CASH.rawValue)
        if isFromOrderPage {
            self.navigationController?.popViewController(animated: true)
        }else{
            if (self.currentRequest?.data?.count ?? 0) == 0 {
                self.getServiceListAPI()
            }
        }
        
    }
    
    func invoicePaymentSuccess(requestEntity: Request) {
        ToastManager.show(title: requestEntity.message ?? "", state: .success)
        self.isInvoiceShowed = true
        checkRequestApiCall()
    }
    
    func cancelRequestSuccess(requestEntity: Request) {
        self.tableView?.superview?.dismissView(onCompletion: {
            self.tableView = nil
        })
        ToastManager.show(title: requestEntity.message ?? "", state: .success)
        
        paymentMode = PaymentType(rawValue: PaymentType.CASH.rawValue)
        self.currentRequest = requestEntity.responseData
        if isFromOrderPage {
            self.navigationController?.popViewController(animated: true)
        }else{
            self.removeAllView()
        }
        checkRequestApiCall()
    }
    
    func failureResponse(failureData: Data) {
        if
            let utf8Text = String(data: failureData, encoding: .utf8),
            let messageDic = AppUtils.shared.stringToDictionary(text: utf8Text),
            let message =  messageDic[Constant.message] as? String {
            if message == TaxiConstant.rideAlreadyCancel {
                self.tableView?.superview?.dismissView(onCompletion: {
                    self.tableView = nil
                })
                paymentMode = PaymentType(rawValue: PaymentType.CASH.rawValue)
                
                socketAndBgTaskSetUp()
                if isFromOrderPage {
                    self.navigationController?.popViewController(animated: true)
                }else{
                    self.removeAllView()
                }
            }
        }
    }
    
    // update payment
    func updatePaymentSuccess(requestEntity: Request) {
        ToastManager.show(title: requestEntity.message ?? "", state: .success)
        checkRequestApiCall()
    }
    
    func extendTripSuccess(requestEntity: Request) {
        ToastManager.show(title: requestEntity.message ?? "", state: .success)
        self.currentRequest = requestEntity.responseData
        checkRequestApiCall()
    }
    
    func sendRequestSuccess(requestEntity: Request) {
        ToastManager.show(title: requestEntity.message ?? "", state: .success)
        checkRequestApiCall()
        serviceList = nil
        navigationController?.popViewController(animated: true)
    }
}

extension TaxiHomeViewController:  RideNowDelegate {
    
    func onRideCreated() {
        checkRequestApiCall()
        newRequest =  true
        UserDefaults.standard.set(newRequest, forKey: Constant.newRequestHideSearch)

        serviceList = nil
    }
}


extension TaxiHomeViewController : XmapLocationUpdateProtocol{
    func locationUpdated(location: XCurrentLocation) {
        print("current location : \(location)")
    }
    
}
