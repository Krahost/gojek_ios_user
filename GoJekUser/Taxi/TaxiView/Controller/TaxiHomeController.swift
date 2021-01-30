//
//  TaxiHomeController.swift
//  GoJekUser
//
//  Created by Ansar on 26/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
//import Floaty

class TaxiHomeController: UIViewController {
    
    @IBOutlet weak var mapView: XMapView!
    @IBOutlet weak var sourceView:UIView!
    @IBOutlet weak var destinationView:UIView!
    @IBOutlet weak var backButton:UIButton!
    @IBOutlet weak var sourceTextField: UITextField!
    @IBOutlet weak var destinationTextField: UITextField!
    @IBOutlet weak var locationStackView:UIStackView!
    @IBOutlet weak var viewCurrentLocation: UIView!
    @IBOutlet weak var dividerLineView: UIView!
    @IBOutlet weak var addressView: UIView!
    
    //MARK:- local variable
    
    var carMoveMent = ARCarMovement()
//    var floatyButton = Floaty()
    var buttonSOS = UIButton()
    var isReroute:Bool = false
    var menuButton = UIButton()
    let chatImage = UIButton()
    let phoneImage = UIButton()
    let floatyView = UIView()
    
    var count = 0
    var rideTypeId: Int = 0
    var mapViewHelper: GoogleMapsHelper?
    var isUserInteractingWithMap = false
    var riderStatus: TaxiRideStatus = .none // Provider current status
    var currentRequestId = 0
    
    var providerLastLocation = LocationCoordinate()
    var serviceSelectionView: ServiceSelectionView?
    var rateCardView: RateCardView?
    var loaderView: LoaderView?
    var rideStatusView: RideStatusView?
    var invoiceView: InvoiceView?
    var ratingView: RatingView?
    var riderStatusView: RideDetailView?
    
    var etaView: EtaView?
    
    var currentLocation = Bind<LocationCoordinate>(APPConstant.AppData.defaultMapLocation)
    
    var tableView: CustomTableView?
    var reasonData:[ReasonData] = []
    var serviceDetails:[Services] = []
    var paymentType:String = PaymentType.CASH.rawValue // by default will be cash
    var selectedCardEntity = CardResponseData()
    var currentRequest: Request!
    var seatcapacity:Int = 0
    
    private var isWallet = 0
    private var isWheelChair = 0
    private var isChildSeat = 0
    private var isSomeOne = 0

    
    var isInvoiceShowed:Bool = false
    var isdrawPollyline: Bool = false
    var isTapCancelOnRide: Bool = false
    
    var sourceLocationDetail = SourceDestinationLocation()  {
        didSet {
            self.sourceTextField.text = sourceLocationDetail.address
            if riderStatus == .none && serviceDetails.count == 0 {
                self.getServiceDetails(location: sourceLocationDetail.locationCoordinate ?? CLLocationCoordinate2D())
            }
        }
    }
    
    var destinationDetail = SourceDestinationLocation() {
        didSet {
            self.destinationTextField.text = destinationDetail.address
        }
    }
    
    var sourceMarker : UIImageView = {
        let marker = UIImageView()
        marker.image =  UIImage(named: Constant.string.sourcePin)?.resizeImage(newWidth: 25)
        return marker
    }()
    
    var destinationMarker : UIImageView = {
        let marker = UIImageView()
        marker.image =  UIImage(named: Constant.string.destinationPin)?.resizeImage(newWidth: 25)
        return marker
    }()
    
    // provider location marker
    var markerProviderLocation : GMSMarker = {
        let marker = GMSMarker()
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: 30, height: 30)))
        imageView.contentMode =  .scaleAspectFit
        imageView.image = UIImage(named: TaxiConstant.key.car_marker)
        marker.iconView = imageView
        marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        return marker
    }()
    
    var taxiPresenter: TaxiViewToTaxiPresenterProtocol?
    
    //For reuse same parameters
    private var estimateInputParameter: Parameters = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //checkForProviderStatus()
        initialLoads()
        NotificationCenter.default.addObserver(self, selector: #selector(enterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        self.mapView.didUpdateLocation = { (location) in
            let currentLocation = CLLocation(latitude: location.latitude ?? 0, longitude: location.longitude ?? 0)
            self.mapView.currentLocation = currentLocation
            self.getCurrentLocationDetails()
        }
      //  self.setMenuButton()
        self.buttonSOS.isHidden = true
        self.menuButton.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        self.hideTabBar()
        checkRequestApiCall()
       // socketAndBgTaskSetUp()
    }
    
    private func setMenuButton() {
        
        self.menuButton.frame.size = CGSize.init(width: 40, height: 40)
        self.menuButton.frame.origin.x = self.mapView.frame.width - (self.menuButton.frame.height) - 25
        self.menuButton.frame.origin.y = (self.mapView.frame.height - (self.rideStatusView?.frame.height ?? 0) - 15)
        let menuImage = UIImageView()
        menuImage.image = UIImage.init(named: Constant.string.moreCrossImage)
        menuImage.image?.withRenderingMode(.alwaysTemplate)
        menuImage.imageTintColor(color1: .white)
        menuImage.contentMode = .scaleAspectFit
        self.menuButton.accessibilityIdentifier = "more"
        self.menuButton.addTarget(self, action: #selector(menuButtonAction(_:)), for: .touchUpInside)
        self.menuButton.backgroundColor = .xuberColor
        self.menuButton.setCornerRadius()
        self.menuButton.setImage(menuImage.image, for: .normal)
        
        chatImage.setImage(UIImage(named: XuberConstant.chat)?.withRenderingMode(.alwaysTemplate), for: .normal)
        
        phoneImage.setImage(UIImage(named: XuberConstant.phone)?.withRenderingMode(.alwaysTemplate), for: .normal)
        chatImage.addTarget(self, action: #selector(chatButtonAction(_:)), for: .touchUpInside)
        phoneImage.addTarget(self, action: #selector(phoneButtonAction(_:)), for: .touchUpInside)
        
        self.mapView.addSubview(menuButton)
    }
    
    @objc func menuButtonAction(_ sender: UIButton) {
        
        if self.menuButton.accessibilityIdentifier == "more" {
            floatyView.frame = CGRect(x: 0, y: 0, width: self.mapView.frame.width, height: self.mapView.frame.height)
            floatyView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            self.mapView.addSubview(floatyView)
            self.mapView.bringSubviewToFront(menuButton)
            self.menuButton.accessibilityIdentifier = ""
            
            chatImage.frame = CGRect(x: menuButton.frame.minX, y: menuButton.frame.minY - menuButton.frame.height - 20, width: 40, height: 40)
            chatImage.backgroundColor = .white
            chatImage.setCornerRadius()
            
            floatyView.addSubview(chatImage)
            
            phoneImage.frame = CGRect(x: menuButton.frame.minX, y: chatImage.frame.minY - chatImage.frame.height - 20, width: 40, height: 40)
            phoneImage.backgroundColor = .white
            phoneImage.setCornerRadius()
            floatyView.addSubview(phoneImage)
            chatImage.transform = CGAffineTransform(scaleX: 0.70, y: 0.70)
            
            phoneImage.transform = CGAffineTransform(scaleX: 0.70, y: 0.70)
            UIView.animate(withDuration: 2.0,
                           delay: 0,
                           usingSpringWithDamping: 0.2,
                           initialSpringVelocity: 6.0,
                           options: .allowUserInteraction,
                           animations: { [weak self] in
                            self?.phoneImage.transform = .identity
                            self?.chatImage.transform = .identity
                            
                },
                           completion: nil)
            
        }else{
            self.menuButton.accessibilityIdentifier = "more"
            self.floatyView.removeFromSuperview()
            
        }
        
    }
    
    
    @objc func chatButtonAction(_ sender: UIButton) {
        self.navigationToChatView()
    }
    
    func navigationToChatView() {
        
        let checkRequestDetail = self.currentRequest.responseData?.data?.first
        let providerDetail = checkRequestDetail?.provider
        let userDetail = checkRequestDetail?.user
        let serviceDetail = checkRequestDetail?.service_type
        let chatView = ChatViewController()
        chatView.requestId = "\((checkRequestDetail?.id)!)"
        chatView.chatRequestFrom = MasterServices.Transport.rawValue
        chatView.userId = "\((userDetail?.id)!)"
        chatView.userName = "\( userDetail?.firstName ?? "")" + " " + "\(userDetail?.lastName ?? "")"
        chatView.providerId = "\((providerDetail?.id)!)"
        chatView.providerName = "\(providerDetail?.first_name ?? "")" + " " + "\(providerDetail?.last_name ?? "")"
        chatView.adminServiceId = "\((serviceDetail?.admin_service_id)!)"
        self.navigationController?.pushViewController(chatView, animated: true)
    }
    
    @objc func phoneButtonAction(_ sender: UIButton) {
        if let phoneNumber = self.currentRequest?.responseData?.data?.first?.provider?.mobile {
            AppUtils.shared.call(to: phoneNumber)
        }
    }


    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //        mapViewHelper?.updateMapFrame(frame: self.mapView.frame, centerPoint: self.mapView.center)
        viewCurrentLocation.setRoundCircle()
        addressView.addShadow(radius: 8, color: .lightGray)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        TaxiHelperPage.shared.stopListening()
    }
}

//MARK: - Methods

extension TaxiHomeController {
    
    private func initialLoads() {
        

        self.viewCurrentLocation.addShadowWithRadius(shadowColor: UIColor.lightGray, shadowOpacity: 3.0, shadowRadius:8.0, shadowOffset: CGSize(width: CGFloat(0.0), height: CGFloat(0.2)))
        self.viewCurrentLocation.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(getCurrentLocation)))
        
        self.sourceTextField.placeholder = TaxiConstant.key.enterSource.localized
        self.destinationTextField.placeholder = TaxiConstant.key.enterDestination.localized
        self.backButton.addTarget(self, action: #selector(tapBack), for: .touchUpInside)
        self.backButton.setBothCorner()
        self.taxiPresenter = TaxiRouter.createModule(controller: self)
        dividerLineView.backgroundColor = .dividerColor
        addressView.addShadow(radius: 5, color: .black)
        
        self.carMoveMent.delegate = self
        // for to get cancel reasons list
        self.taxiPresenter?.getReasons(param: [TaxiInputs.type: ServiceType.trips.currentType])
        self.mapView.currentLocationMarkerImage = UIImage(named: TaxiConstant.key.car_marker)?.resizeImage(newWidth: 25)
        
        setFont()
    }
    
    private func setFont() {
        self.sourceTextField.font = UIFont.setCustomFont(name: .medium, size: .x14)
        self.destinationTextField.font = UIFont.setCustomFont(name: .medium, size: .x14)
    }
    
    //Add Mapview
    
    private func addMapView(){
        
        self.mapViewHelper = GoogleMapsHelper()
        self.mapViewHelper?.getMapView(withDelegate: self, in: self.mapView)
        self.mapViewHelper?.removerPinMarker()
    }
    
    func showServiceSelectionView() {
        
        if self.serviceSelectionView == nil, let selectionView = Bundle.main.loadNibNamed(TaxiConstant.key.ServiceSelectionView, owner: self, options: [:])?.first as? ServiceSelectionView {
            let viewHeight = (self.view.frame.height/100)*40 //40% of  view
            selectionView.frame = CGRect(origin: CGPoint(x: 0, y: self.view.frame.height-viewHeight), size: CGSize(width: self.view.frame.width, height: viewHeight))
            self.serviceSelectionView = selectionView
            self.serviceSelectionView?.serviceDetails = self.serviceDetails
            self.view.addSubview(selectionView)
            selectionView.show(with: .bottom, completion: nil)
            serviceSelectionView?.changeButton.addTarget(self, action: #selector(changePaymentButtonTapped), for: .touchUpInside)
        }
        else {
            self.serviceSelectionView?.serviceDetails = self.serviceDetails
            self.serviceSelectionView?.serviceCollectionView.reloadData()
        }
        
        if paymentType == PaymentType.CASH.rawValue {
            serviceSelectionView?.cardOrCashLabel.text = self.paymentType
            serviceSelectionView?.paymentImage.image = PaymentType.CASH.image //"money_icon"
        }
        else {
            serviceSelectionView?.cardOrCashLabel.text = TaxiConstant.key.cardPrefix + selectedCardEntity.last_four!
            serviceSelectionView?.paymentImage.image = PaymentType.CARD.image
        }
        
        self.serviceSelectionView?.tapService = { servicesData in
            self.showRateCard(serviceData: [servicesData])
            self.serviceSelectionView?.isHidden = true
        }
        self.serviceSelectionView?.tapGetPricing = { selectedService in
            if self.destinationTextField.text?.trimString().count == 0 {
                ToastManager.show(title: TaxiConstant.key.chooseProviderLoc.localized, state: .error)
                return
            }
            let estimationVC = TaxiRouter.taxiStoryboard.instantiateViewController(withIdentifier: TaxiConstant.key.PriceEstimationController) as! PriceEstimationController
            
            //  let wheelChair = estimationVC.
            let parameter: Parameters = [TaxiInputs.s_latitude: self.sourceLocationDetail.locationCoordinate?.latitude ?? 0.0,
                                         TaxiInputs.s_longitude: self.sourceLocationDetail.locationCoordinate?.longitude ?? 0.0,
                                         TaxiInputs.service_type: selectedService.id ?? 0,
                                         TaxiInputs.d_latitude: self.destinationDetail.locationCoordinate?.latitude ?? 0.0,
                                         TaxiInputs.d_longitude: self.destinationDetail.locationCoordinate?.longitude ?? 0.0,
                                         TaxiInputs.payment_mode: self.paymentType]
            
            
            self.estimateInputParameter = parameter
            
            if estimationVC.isWalletEnable {
                self.isWallet = 1
            }
            else {
                self.isWallet = 0
            }
            
           // estimationVC.estimateInputParameter = parameter
            
            //on Click Ride Now Button
            estimationVC.onClickRideNow =  { rideRequestData in
                
                if estimationVC.isWalletEnable {
                    self.isWallet = 1
                }
                else {
                    self.isWallet = 0
                }
                self.createRequest(rideRequestInputData: rideRequestData)
            }
            self.navigationController?.pushViewController(estimationVC, animated: true)
        }
    }
    
    //Getting current location detail
    private func getCurrentLocationDetails() {
        self.mapView.getCurrentLocationDetail { (location) in
            print(location.coordinate.latitude)
            print(location.coordinate.longitude)
            print(location.address)
            DispatchQueue.main.async {
                self.sourceLocationDetail = SourceDestinationLocation(address: location.address,locationCoordinate: LocationCoordinate(latitude: (location.coordinate.latitude), longitude: (location.coordinate.longitude)))
                self.mapView.showCurrentLocation()
            }
        }
    }
    
    
    // MARK:- Temporarily Hide Service View
    
    func isMapInteracted(_ isHide : Bool){
        
        UIView.animate(withDuration: 0.2) {
            self.serviceSelectionView?.frame.origin.y = (self.view.frame.height-(isHide ? 0 : self.serviceSelectionView?.frame.height ?? 0))
            self.locationStackView?.alpha = isHide ? 0 : 1
            self.rideStatusView?.alpha = isHide ? 0 : 1
            self.riderStatusView?.alpha = isHide ? 0 : 1
        }
        
    }
    
    func showRateCard(serviceData: [Services]) {
        
        if self.rateCardView == nil, let rateCardView = Bundle.main.loadNibNamed(TaxiConstant.key.RateCardView, owner: self, options: [:])?.first as? RateCardView {
            
            rateCardView.frame = CGRect(origin: CGPoint(x: 0, y: self.view.frame.height-rateCardView.frame.height), size: CGSize(width: self.view.frame.width, height: rateCardView.frame.height))
            self.rateCardView = rateCardView
            self.view.addSubview(rateCardView)
           // rateCardView.setValues(serviceData: serviceData)
            rateCardView.show(with: .bottom, completion: nil)
        }
        
        self.rateCardView?.tapDone = {
            self.rateCardView?.removeFromSuperview()
            self.rateCardView = nil
            self.serviceSelectionView?.isHidden = false
        }
    }
    
    func showRideStatusView(with request : Request) {
        
        self.locationStackView.isHidden = true
        
        if self.rideStatusView == nil, let rideStatusView = Bundle.main.loadNibNamed(TaxiConstant.key.RideStatusView, owner: self, options: [:])?.first as? RideStatusView {
            self.resetServiceView()
            let subViewHeight = rideStatusView.frame.height - 20
            
            rideStatusView.frame = CGRect(origin: CGPoint(x: 0, y: self.view.frame.maxY - subViewHeight - 20), size: CGSize(width: self.view.frame.width, height: subViewHeight + 20))
            
            self.rideStatusView = rideStatusView
            self.view.addSubview(rideStatusView)
            rideStatusView.show(with: .right, completion: nil)
           // setMenuButton()
            //rideStatusView.set(values: request)
        }
        
        if self.rideStatusView != nil {
            //self.rideStatusView?.set(values: request)
        }
        
        self.rideStatusView?.onClickCancel =  {
            self.showCancelTable()
            self.isTapCancelOnRide = true
        }
        
        // show riding status view
        showRiderStausView(with: request)
    }
    
    func showRiderStausView(with request : Request) {
        
        if self.riderStatusView == nil, let riderStatusView = Bundle.main.loadNibNamed(TaxiConstant.key.RideDetailView, owner: self, options: [:])?.first as? RideDetailView {
            riderStatusView.frame = CGRect(origin: CGPoint(x: 10, y: self.backButton.frame.height + 100), size: CGSize(width: self.view.frame.width - 20, height: 110))
            self.riderStatusView = riderStatusView
            self.view.addSubview(riderStatusView)
            riderStatusView.show(with: .top, completion: nil)
            setMenuButton()
        }
        let extendTripGesture = UITapGestureRecognizer(target: self, action: #selector(extendTripSelect))
        self.riderStatusView?.extendTripButton.addGestureRecognizer(extendTripGesture)
        
        if self.riderStatusView != nil {
            //self.riderStatusView?.set(values: request)
            DispatchQueue.main.async {
                let requestData = request.responseData?.data
                if requestData?.first?.status == TaxiRideStatus.pickedup.rawValue {
                    self.menuButton.isHidden = true
                    self.buttonSOS.isHidden = true
                }
                else {
                    guard let tempHeight = self.rideStatusView?.frame.height else {
                        return
                    }
                    self.setMenuButton()
                  //  self.menuButton.paddingY = tempHeight+10
                    self.buttonSOS.frame.origin.y = (self.mapView.frame.height)-(tempHeight+50)
                    self.menuButton.isHidden = false
                    self.buttonSOS.isHidden = false
                }
            }
        }
    }
    
    func showLoaderView() {
        
        if self.serviceSelectionView != nil {
            self.serviceSelectionView?.removeFromSuperview()
            self.serviceSelectionView?.isHidden = true
            self.serviceSelectionView = nil
            self.locationStackView.isHidden = true
        }
        
        if self.loaderView == nil, let loaderView = Bundle.main.loadNibNamed(TaxiConstant.key.LoaderView, owner: self, options: [:])?.first as? LoaderView {
            
            loaderView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.frame.width, height: self.view.frame.height))
            loaderView.cancelRequestButton.backgroundColor = .taxiColor
            self.loaderView = loaderView
            self.view.addSubview(loaderView)
            loaderView.show(with: .bottom, completion: nil)
        }
        self.loaderView?.onClickCancelRequest = {
            self.showCancelTable()
        }
    }
    
    // cancel reasons func
    private func showCancelTable() {
        
        if self.tableView == nil, let tableView = Bundle.main.loadNibNamed(Constant.string.CustomTableView, owner: self, options: [:])?.first as? CustomTableView {
            
            let height = (self.view.frame.height/100)*35
            tableView.frame = CGRect(x: 20, y: (self.view.frame.height/2)-(height/2), width: self.view.frame.width-40, height: height)
            tableView.heading = Constant.string.chooseReason.localized
            self.tableView = tableView
            var reasonArr:[String] = []
            for reason in self.reasonData {
                reasonArr.append(reason.reason ?? "")
            }
            tableView.values = reasonArr
            tableView.show(with: .bottom, completion: nil)
            showDimView(view: tableView)
        }
        self.tableView?.onClickClose = {
            self.tableView?.superview?.dismissView(onCompletion: {
                self.tableView = nil
            })
        }
        self.tableView?.selectedItem = { selectedReason in
            
            let param: Parameters = [TaxiInputs.id: self.currentRequestId, TaxiInputs.reason: selectedReason]
            self.taxiPresenter?.cancelRequest(param: param)
        }
    }
    
    private func showDimView(view: UIView) {
        let dimView = UIView(frame: self.view.frame)
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        dimView.addSubview(view)
        self.view.addSubview(dimView)
    }
    
    func showInvoice(with request: Request) {
        if self.invoiceView == nil, let invoiceView = Bundle.main.loadNibNamed(TaxiConstant.key.InvoiceView, owner: self, options: [:])?.first as? InvoiceView {
            
            invoiceView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.frame.width, height: self.view.frame.height))
            self.invoiceView = invoiceView
            invoiceView.show(with: .bottom, completion: nil)
            self.invoiceView?.changeButton.addTarget(self, action: #selector(self.changeInvoicePaymentTapped), for: .touchUpInside)
            
            self.view.addSubview(invoiceView)
        }
        
        self.invoiceView?.onClickConfirm = { (tipsAmount,isCash) in
            self.invoiceView?.dismissView(onCompletion: {
                self.invoiceView = nil
                
            })
            if isCash  {
                self.showRatingView(with: request)
            }
            else {
                self.taxiPresenter?.invoicePayment(param: [TaxiInputs.id: request.responseData?.data?.first?.id ?? 0, TaxiInputs.tips: tipsAmount,TaxiInputs.card_id: self.selectedCardEntity.card_id ?? ""])
            }
            self.isInvoiceShowed = true
            return
        }
        //self.invoiceView?.set(with: request)
    }
    
    func showRatingView(with request: Request) {
        
        self.invoiceView?.isHidden  = true
        self.invoiceView = nil
        if self.ratingView == nil, let ratingView = Bundle.main.loadNibNamed(Constant.string.RatingView, owner: self, options: [:])?.first as? RatingView {
            
            ratingView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.frame.width, height: self.view.frame.height))
            ratingView.setValues(color: .taxiColor)
            self.ratingView = ratingView
            self.view.addSubview(ratingView)
            ratingView.show(with: .bottom, completion: nil)
        }
        //ratingView?.set(request: request)
        self.ratingView?.onClickSubmit = { (rating, comments) in
            
            if self.currentRequestId > 0 {
                var comment = ""
                if comments == Constant.string.leaveComment.localized {
                    comment = ""
                }
                else {
                    comment = comments
                }
                let param: Parameters = [TaxiInputs.id: request.responseData?.data?.first?.id ?? 0,
                                         TaxiInputs.rating: rating, TaxiInputs.comment: comment,
                                         TaxiInputs.admin_service_id: request.responseData?.data?.first?.service_type?.admin_service_id ?? 0]
                self.taxiPresenter?.ratingToProvider(param: param)
            }
            self.removeRatingView()
            self.locationStackView.isHidden = false
            self.showServiceSelectionView()
        }
    }
    
    //  Remove RideStatus View
    private func removeRatingView() {
        self.ratingView?.dismissView(onCompletion: {
            self.ratingView = nil
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        })
    }
    
    //Draw Polyline
    
    func drawPolyline(from: LocationCoordinate, to: LocationCoordinate) {
        self.mapView.createRoute(source: from, destination: to, with: "", color: .taxiColor)
    }
}

extension TaxiHomeController {
    
    // change payment before sending request
    @objc func changePaymentButtonTapped() {
        
        let paymentVC = AccountRouter.accountStoryboard.instantiateViewController(withIdentifier: AccountConstant.key.PaymentSelectViewController) as! PaymentSelectViewController
        paymentVC.isChangePayment = true
        paymentVC.onClickPayment = { (type,cardEntity) in
            
            self.paymentType = type.rawValue
            if type == .CARD {
                self.selectedCardEntity = cardEntity!
            }
            self.showServiceSelectionView()
        }
        
        self.navigationController?.pushViewController(paymentVC, animated: true)
    }
    
    // change payment in invoice
    @objc func changeInvoicePaymentTapped() {
        
        let paymentVC = AccountRouter.accountStoryboard.instantiateViewController(withIdentifier: AccountConstant.key.PaymentSelectViewController) as! PaymentSelectViewController
        paymentVC.isChangePayment = true
        paymentVC.onClickPayment = { (type,cardEntity) in
            self.paymentType = type.rawValue
            self.invoiceView?.paymentType = type
            if type == .CASH {
                self.invoiceView?.cardCashLabel.text = type.rawValue
                self.invoiceView?.paymentImage.image = PaymentType(rawValue: type.rawValue)?.image
            } else {
                self.selectedCardEntity = cardEntity!
                self.invoiceView?.cardCashLabel.text = TaxiConstant.key.cardPrefix + cardEntity!.last_four!
                self.invoiceView?.paymentImage.image = PaymentType(rawValue: type.rawValue)?.image
            }
            self.taxiPresenter?.updatePayment(param: [TaxiInputs.id: self.currentRequest.responseData?.data?.first?.id ?? 0, TaxiInputs.payment_mode: self.paymentType,TaxiInputs.card_id: self.selectedCardEntity.card_id ?? ""])
        }
        self.navigationController?.pushViewController(paymentVC, animated: true)
    }
    
    @objc func tapBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // get current location
    @objc func getCurrentLocation() {
        //        if currentLocation.value != nil {
        //            self.mapViewHelper?.getCurrentLocation(onReceivingLocation: { (location) in
        //                self.mapViewHelper?.moveTo(location: location.coordinate, with: self.mapView.center)
        //            })
        //        }
        DispatchQueue.main.async {
            self.mapView.showCurrentLocation()
        }
    }
    
    @objc private func enterForeground() {
        //checkRequestApiCall()
        socketAndBgTaskSetUp()
    }
    
    @objc func extendTripSelect() {
        print("selected")
        AppAlert.shared.simpleAlert(view: self, title: "", message: Constant.string.extendTripAlert.localized, buttonOneTitle: Constant.string.SYes.localized, buttonTwoTitle: Constant.string.SNo.localized)
        AppAlert.shared.onTapAction = { tag in
            if tag == 0 {
                let locationView = TaxiRouter.taxiStoryboard.instantiateViewController(withIdentifier: TaxiConstant.key.LocationSelectionController) as! LocationSelectionController
                locationView.isSource = false
                locationView.isExtendTrip = true
                locationView.isExtendTripSelectedLocation = { addressData in
                    // print(addressData)
                    let extendParams:Parameters = [TaxiInputs.id: self.currentRequestId, TaxiInputs.latitude: addressData.locationCoordinate?.latitude ?? 0.0, TaxiInputs.longitude: addressData.locationCoordinate?.longitude ?? 0.0, TaxiInputs.address: addressData.address ?? ""]
                    self.taxiPresenter?.extendTrip(param: extendParams)
                }
                self.navigationController?.pushViewController(locationView, animated: true)
            }
        }
    }
    
    @objc func validateRequest() {
        
        //        if riderStatus == .searching {
        //            ToastManager.show(title: TaxiConstant.key.noDriversFound.localized, state: .error)
        //            self.cancelRequest()
        //        }
        // after 60sec it will check request based on that cancel automatically
        checkRequestApiCall()
    }
}


// MARK:- MapView

extension TaxiHomeController: GMSMapViewDelegate  {
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        self.isMapInteracted(false)
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        
        print("Gesture ",gesture)
        self.isUserInteractingWithMap = gesture
        
        if self.isUserInteractingWithMap {
            self.isMapInteracted(true)
        }
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
        if isUserInteractingWithMap {
            
        }
    }
    
    func getLocationFromMovement(mapView:GMSMapView){
        let geocoder = GMSGeocoder()
        let latitute = mapView.camera.target.latitude
        let longitude = mapView.camera.target.longitude
        let position = CLLocationCoordinate2DMake(latitute, longitude)
        geocoder.reverseGeocodeCoordinate(position) { response , error in
            if error != nil {
                // print("GMSReverseGeocode Error: \(String(describing: error?.localizedDescription))")
            }else {
                let result = response?.results()?.first
                let address = result?.lines?.reduce("") { $0 == "" ? $1 : $0 + ", " + $1 }
                self.sourceLocationDetail = SourceDestinationLocation(address: address,locationCoordinate: LocationCoordinate(latitude: (result?.coordinate.latitude ?? APPConstant.AppData.defaultMapLocation.latitude), longitude: (result?.coordinate.longitude ?? APPConstant.AppData.defaultMapLocation.longitude)))
            }
        }
    }
}

//MARK: - Location Delegate

extension TaxiHomeController: LocationDelegate {
    
    func selectedLocation(isSource: Bool, addressDetails: SourceDestinationLocation) {
        if isSource {
            self.sourceLocationDetail = addressDetails
        }else{
            
            self.destinationDetail = addressDetails
        }
        
        if !(self.sourceTextField.text?.isEmpty ?? false) && !(self.destinationTextField.text?.isEmpty ?? false) {
            self.mapView.setSourceLocationMarker(sourceCoordinate: self.sourceLocationDetail.locationCoordinate ?? APPConstant.AppData.defaultMapLocation, marker: UIImage(named: Constant.string.sourcePin) ?? UIImage())
            self.mapView.setDestinationLocationMarker(destinationCoordinate: self.destinationDetail.locationCoordinate ?? APPConstant.AppData.defaultMapLocation, marker: UIImage(named: Constant.string.destinationPin) ?? UIImage())
            
            self.mapView.createRoute(source: self.sourceLocationDetail.locationCoordinate ?? APPConstant.AppData.defaultMapLocation, destination: self.destinationDetail.locationCoordinate ?? APPConstant.AppData.defaultMapLocation, with: "", color: .taxiColor)
        }
    }
}

//MARK: - Textfield Delegate

extension TaxiHomeController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let vc = TaxiRouter.taxiStoryboard.instantiateViewController(withIdentifier: TaxiConstant.key.LocationSelectionController) as! LocationSelectionController
        vc.locationDelegate = self
        if textField == self.sourceTextField { //Source View
            vc.isSource = true
        }else{ //Destination view
            vc.isSource = false
        }
        self.navigationController?.pushViewController(vc, animated: true)
        return false
    }
}

// service calls

extension TaxiHomeController {
    
    func socketAndBgTaskSetUp() {
        
        
        if let requestData = currentRequest,(requestData.responseData?.data?.first?.id ?? 0) != 0 {
            XSocketIOManager.sharedInstance.sendSocketRequest(requestId: requestData.responseData?.data?.first?.id ?? 0, serviceType: .transport, listenerType: .Transport) {
                self.checkRequestApiCall()
            }

        } else {
            guard let _ = currentRequest else  {
                self.riderStatus = .none
                self.mapView.clearAll()
                self.getServiceDetails(location: self.sourceLocationDetail.locationCoordinate ?? CLLocationCoordinate2D())
                return
            }
            checkRequestApiCall()
        }
        
    }
    
    func checkRequestApiCall() {
        
        taxiPresenter?.checkTaxiRequest()
        
    }
    
    // Create Request
    func createRequest(rideRequestInputData: TaxiReuqestEntity) {
        
        self.navigationController?.popViewController(animated: true)
        
        var param: Parameters = [TaxiInputs.s_latitude: estimateInputParameter["s_latitude"] ?? 0,
                                 TaxiInputs.s_longitude: estimateInputParameter["s_longitude"] ?? 0,
                                 TaxiInputs.service_type: estimateInputParameter["service_type"] ?? 0,
                                 TaxiInputs.d_latitude: estimateInputParameter["d_latitude"] ?? 0,
                                 TaxiInputs.d_longitude: estimateInputParameter["d_longitude"] ?? 0,
                                 TaxiInputs.distance: rideRequestInputData.distance ?? 0.0,
                                 TaxiInputs.payment_mode: self.paymentType,
                                 TaxiInputs.use_wallet: self.isWallet,
                                 TaxiInputs.wheelchair: rideRequestInputData.wheelchair ?? 0,
                                 TaxiInputs.child_seat: rideRequestInputData.child_seat ?? 0,
                                 TaxiInputs.someone: rideRequestInputData.someone ?? 0,
                                 TaxiInputs.someone_name: rideRequestInputData.someone_name ?? "",
                                 TaxiInputs.someone_mobile: rideRequestInputData.someone_mobile ?? "",
                                 TaxiInputs.someone_email: rideRequestInputData.someone_email ?? "",
                                 TaxiInputs.promocode_id: rideRequestInputData.promocode_id ?? 0,
                                 TaxiInputs.card_id: selectedCardEntity.card_id ?? "",
                                 TaxiInputs.s_address:sourceLocationDetail.address ?? "",
                                 TaxiInputs.d_address :destinationDetail.address ?? "",
                                 TaxiInputs.ride_type_id : self.rideTypeId]
        
        if rideRequestInputData.isSchedule == true {
            param[TaxiInputs.schedule_date] = rideRequestInputData.schedule_date ?? ""
            param[TaxiInputs.schedule_time] = rideRequestInputData.schedule_time ?? ""
        }
        
        taxiPresenter?.sendRequest(param: param)
    }
    
    func resetServiceView() { //Temp solution need to refactor
        if let _ = serviceSelectionView {
            self.serviceSelectionView?.removeFromSuperview()
            self.serviceSelectionView = nil
        }
    }
    
    func setProviderStatusBasedOnRequest(requestData: Request) {
        
        self.currentRequest = requestData
        if let requetsId = currentRequest.responseData?.data?.first?.id {
            self.currentRequestId = requetsId
        }
        if currentRequest.responseData?.data?.first?.status == nil {
            self.riderStatus = .none
            self.cancelledRideUIArrangement()
            if self.loaderView != nil {
                self.loaderView?.dismissView(onCompletion: {
                    self.loaderView = nil
                })
            }
            
            self.locationStackView.isHidden = false
            
            BackGroundRequestManager.share.resetBackGroudTask()
            self.getServiceDetails(location: self.sourceLocationDetail.locationCoordinate ?? CLLocationCoordinate2D())
        }
        else {
            self.riderStatus = TaxiRideStatus(rawValue: (currentRequest.responseData?.data?.first?.status)!) ?? .none
        }
        
        self.handleRequest(request: requestData)
    }
    
    //MARK:- checkForProviderStatus
    
    func checkForProviderStatus() {
        
        // LoadingIndicator.show()
        TaxiHelperPage.shared.startListening { (request) in
            if request != nil {
                self.currentRequest = request!
                if let requetsId = request?.responseData?.data?.first?.id {
                    self.currentRequestId = requetsId
                }
                
                if request?.responseData?.data?.first?.status == nil {
                    self.riderStatus = .none
                    
                    self.getServiceDetails(location: self.sourceLocationDetail.locationCoordinate ?? CLLocationCoordinate2D())
                }
                else {
                    self.riderStatus = TaxiRideStatus(rawValue: (request?.responseData?.data?.first?.status)!) ?? .none
                }
            }
            //Handle request
            self.handleRequest(request: request!)
        }
    }
    
    //cancel request
    
    func cancelRequest(reason: String? = nil) {
        
        if self.currentRequestId > 0 {
            
            let param: Parameters = [TaxiInputs.id: currentRequestId]
            taxiPresenter?.cancelRequest(param: param)
        }
    }
    
    func getServiceDetails(location:LocationCoordinate) {
        
        if location.latitude == 0 || serviceDetails.count > 0 {
            return
        }
        else {
            self.taxiPresenter?.getServiceList(id: "\(AppManager.shared.getSelectedServices()?.menu_type_id ?? 0)", location: location)
        }
    }
}

//MARK: - API

extension TaxiHomeController: TaxiPresenterToTaxiViewProtocol {
    
    func getServiceList(serviceEntity: ServiceListEntity) {
        
        self.serviceDetails = serviceEntity.responseData?.services ?? []
        
        if let providers = serviceEntity.responseData?.providers,providers.count > 0 {
            for providerMarker in providers {
                let markerImage = UIImageView()
                if let imageUrl = URL(string: serviceEntity.responseData?.services?.first?.vehicle_marker ?? "")  {
                    markerImage.load(url: imageUrl)
                }
                let mapMarker = MarkerDetails(image: markerImage.image ?? #imageLiteral(resourceName: "scooter"), position:LocationCoordinate(latitude: providerMarker.latitude ?? 0.0, longitude: providerMarker.longitude ?? 0.0))
                mapViewHelper?.addMarker(markers: mapMarker)
            }
        }
        self.serviceSelectionView?.serviceDetails = self.serviceDetails
        DispatchQueue.main.async {
            if self.currentRequestId == 0 || self.riderStatus == .cancelled {
                self.showServiceSelectionView()
            }
        }
    }
    
    func sendRequestSuccess(requestEntity: Request) {
        print(requestEntity)
        ToastManager.show(title: requestEntity.responseData?.message ?? "", state: .success)
        socketAndBgTaskSetUp()
    }
    
    func cancelRequestSuccess(requestEntity: Request) {
        print(requestEntity)
        
        self.tableView?.superview?.dismissView(onCompletion: {
            self.tableView = nil
        })
        
        if self.isTapCancelOnRide == true {
            self.isTapCancelOnRide = false
            ToastManager.show(title: requestEntity.message ?? "", state: .success)
        }
        self.rideStatusView?.removeFromSuperview()
        self.riderStatusView?.removeFromSuperview()
        self.rideStatusView = nil
        
        if let _ = loaderView {
            self.loaderView?.removeFromSuperview()
            self.loaderView = nil
        }
        self.destinationTextField.text = ""
        self.mapView.clearAll()
        initialLoads()
        locationStackView.isHidden = false
        self.showServiceSelectionView()
    }
    
    
    func invoicePaymentSuccess(requestEntity: Request) {
        ToastManager.show(title: requestEntity.message ?? "", state: .success)
        //print(requestEntity)
        self.isInvoiceShowed = true
        rideStatusView?.isHidden = true
        riderStatusView?.isHidden = true
        LoadingIndicator.show()
    }
    
    func ratingToProviderSuccess(requestEntity: Request) {
        print(requestEntity)
        BackGroundRequestManager.share.resetBackGroudTask()
    }
    
    // update payment
    func updatePaymentSuccess(requestEntity: Request) {
        ToastManager.show(title: requestEntity.message ?? "", state: .success)
        print(requestEntity)
    }
    
    // get cancel reasons
    func getReasonsResponse(reasonEntity: ReasonEntity) {
        self.reasonData = reasonEntity.responseData ?? []
    }
    
    // extend trip sucess
    
    func extendTripSuccess(requestEntity: Request) {
        ToastManager.show(title: requestEntity.message ?? "", state: .success)
        checkForProviderStatus()
        print(requestEntity)
    }
    
    func checkTaxiRequest(requestEntity: Request) {
        
        self.currentRequest = requestEntity
        DispatchQueue.main.async {
            self.setProviderStatusBasedOnRequest(requestData: requestEntity)
        }
        
        print(requestEntity.responseData?.data as Any)
        
        if let requestData = requestEntity.responseData?.data, requestData.count > 0 {
            self.socketAndBgTaskSetUp()
        } else {
            if let _ = loaderView {
                self.loaderView?.removeFromSuperview()
                self.loaderView = nil
                self.destinationTextField.text = ""
                self.mapView.clearAll()
            }
            self.showServiceSelectionView()
        }
    }
    
    //MARK:- Set ETA
    
    func showETA(with providerLocation : LocationCoordinate) {
//        guard let sourceLocation = self.sourceLocationDetail?.value else {return}
//        var source = LocationCoordinate()
//        var destination = LocationCoordinate()
//        
//        if riderStatus == .pickedup {
//            destination = destinationLocationDetail?.coordinate ?? defaultMapLocation //after pickup ETA to destination
//            source = currentLocation.value ?? defaultMapLocation
//        }else{
//            destination = providerLocation
//            source = sourceLocation.coordinate
//        }
        self.mapViewHelper = GoogleMapsHelper()
        self.mapViewHelper?.mapView = GMSMapView()
        self.mapViewHelper?.mapView?.getEstimation(between: self.sourceLocationDetail.locationCoordinate ?? APPConstant.AppData.defaultMapLocation, to: providerLocation, completion: { (estimation) in
            DispatchQueue.main.async {
                self.mapView.setETAView(destCoordinate: providerLocation,etaTime: estimation)
//                self.etaView?.setETA(value: estimation)
            }
        })
    }
    
}
