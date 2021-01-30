//
//  CourierHomeController.swift
//  GoJekUser
//
//  Created by Sudar on 27/05/20.
//  Copyright © 2020 Appoets. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SDWebImage


var VWeight = Int()
var VHeight = Int()
var VLength = Int()
var VBreadth = Int()

class CourierHomeController: UIViewController {
    
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var headerStatusVw: UIView!
    @IBOutlet weak var statusStackVw: UIStackView!
    @IBOutlet weak var vehicleTypeBgVw: UIView!
    @IBOutlet weak var vehicleTypeImgVw: UIImageView!
    @IBOutlet weak var vehicleTypeLbl: UILabel!
    @IBOutlet weak var vehicleTypeLineVw: UIView!
    @IBOutlet weak var routeBgVw: UIView!
    @IBOutlet weak var routeImgVw: UIImageView!
    @IBOutlet weak var routeLbl: UILabel!
    @IBOutlet weak var routeRightLineVw: UIView!
    @IBOutlet weak var routeLeftLineVw: UIView!
    @IBOutlet weak var priceBgVw: UIView!
    @IBOutlet weak var priceLeftLineVw: UIView!
    @IBOutlet weak var priceImgVw: UIImageView!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var locationVw: UIView!
    @IBOutlet weak var pickupLocationTxtFld: UITextField!
    @IBOutlet weak var ongoingBGView: UIView!
    @IBOutlet weak var dotView: UIView!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var labelStatusValue: UILabel!
    @IBOutlet weak var progressStack: UIStackView!
    @IBOutlet weak var viewCurrentLocation: UIView!
    @IBOutlet weak var viewred: UIView!

    var xmapView: XMapView?
    var serviceList: [Services]?
    var courierServiceSelView: CourierServiceSelectionView?
    var courierRequestStatusView : CourierRequestStatusView?
    var riderStatus: CourierRequestStatus = .none
    var selectedID = 0
    var loaderView: LoaderView?
    var tableView: CustomTableView?
    var reasonData: [ReasonData]?
    var currentLocationImage = UIImageView()
    var isInvoiceShowed: Bool? = false
    var isAppPresentTapOnPush:Bool = false // avoiding multiple screens redirectns,if same push comes multiple times
    var isChatAlreadyPresented:Bool = false
    var fromRequest : Bool = false
    var fromChatNotification: Bool? = false
    var deliveryTypeID = Int()
    var isFromOrderPage = false
    var isPaymentCompleted = false

    var ratingView: RatingView?
    var invoiceView: CourierInvoiceView?
    var deliveryType = ""


    var sourceLocationDetail = SourceDestinationLocation() {
        didSet {
            DispatchQueue.main.async {
                self.pickupLocationTxtFld.text = self.sourceLocationDetail.address
            }
        }
    }
    
    weak var rideNowDelegate: RideNowDelegate?

    var destinationLocationDetail = SourceDestinationLocation() {
        didSet {
            DispatchQueue.main.async {
                    self.xmapView?.removePolylines()
                    self.xmapView?.drawPolyLineFromSourceToDestination(source: self.sourceLocationDetail.locationCoordinate ?? APPConstant.defaultMapLocation, destination: self.destinationLocationDetail.locationCoordinate ?? APPConstant.defaultMapLocation, lineColor: .courierColor)
            }
        }
    }
    var isAppFrom =  false
    
    var isAllRequestCompleted : Bool = false {
        didSet{
            
            if isAllRequestCompleted {
                self.labelStatusValue.text = "Provider delivered your Courier"
                self.ongoingBGView.isHidden = true
                locationVw.isHidden = false
                self.handleCompleted()
            }else{
                labelStatusValue.text = "Provider received your Courier"
                ongoingBGView.isHidden = false
                locationVw.isHidden = true
                self.setSourceDestinationAndPolyline()
                handleArrived()
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
    
    var currentDelivery : DeliveryEntity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoad()
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.removeMapView()
        fromRequest = false
    }
    override func viewDidLayoutSubviews() {
       headerStatusVw.addShadow(radius: 5, color: .lightGray)
        locationVw.addShadow(radius: 10, color: .lightGray)
        ongoingBGView.layer.cornerRadius = 8
        dotView.setCornerRadius()
        viewCurrentLocation.setCornerRadius()
        viewred.setCornerRadius()

    }
    
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar()
        navigationController?.isNavigationBarHidden = true
        self.addMapView()
        XCurrentLocation.shared.latitude = 0
        XCurrentLocation.shared.longitude = 0
        isAppPresentTapOnPush = false
         ChatPushClick.shared.isPushClick = true
        //For chat
        NotificationCenter.default.addObserver(self, selector: #selector(isChatPushRedirection), name: Notification.Name(pushNotificationType.chat_delivery.rawValue), object: nil)
        BackGroundRequestManager.share.stopBackGroundRequest()
        if CourierConstant.deliveryType == "" {
            self.socketAndBgTaskSetUp()
        }
    }
    
    func onRideCreated() {
           checkRequestApiCall()
           serviceList = nil
       }
    
}
 extension CourierHomeController {
    func storeCurrentLocation(location:LocationDetail) {
        self.sourceLocationDetail = SourceDestinationLocation(address: location.address,locationCoordinate: LocationCoordinate(latitude: (location.coordinate.latitude), longitude: (location.coordinate.longitude)))
        self.xmapView?.showCurrentLocation()
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
    
    private func getServiceListAPI(){
        self.getServiceList(location: self.sourceLocationDetail.locationCoordinate ?? CLLocationCoordinate2D())
    }
    
    func getServiceList(location: LocationCoordinate) {
        if location.latitude == 0 {
            getCurrentLocationDetails()
        }else if (serviceList?.count ?? 0 > 0) && riderStatus == .none {
            showServiceList()
        }else {
            // let tempId = "\(AppManager.shared.getSelectedServices()?.menu_type_id ?? 0)"
            self.courierPresenter?.getServiceList(coordinates: self.sourceLocationDetail.locationCoordinate ?? CLLocationCoordinate2D(), id: 1)
        }
    }
    
    func socketAndBgTaskSetUp() {
        if let requestData = currentRequest,requestData.data?.first?.id ?? 0 != 0 {
            BackGroundRequestManager.share.startBackGroundRequest(type: .ModuleWise, roomId: SocketUtitils.construtRoomKey(requestID: "\(requestData.data?.first?.id ?? 0)", serviceType: .delivery), listener: .Delivery)
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
    private func getReasons() {
           self.courierPresenter?.getReasons(param: [CourierConstant.Ptype: ServiceType.delivery.currentType])
       }
    
    func checkRequestApiCall() {
        self.courierPresenter?.checkCourierRequest()
    }
}
extension CourierHomeController {
    
    private func initialLoad(){
        pickupLocationTxtFld.placeholder = CourierConstant.enterPickup
        backBtn.addTarget(self, action: #selector(tapBack), for: .touchUpInside)
        //back Action
        viewred.backgroundColor = .red
        pickupLocationTxtFld.delegate = self
        vehicleTypeImgVw.image = UIImage.init(named:CourierConstant.redTapeImg)
        routeImgVw.image = UIImage.init(named:CourierConstant.ic_gray_icon)
        priceImgVw.image = UIImage.init(named:CourierConstant.ic_gray_icon)
        currentLocationImage.image = UIImage(named: TaxiConstant.car_marker)?.resizeImage(newWidth: 25)
        setFont()
        setColors()
        setLocalize()
        NotificationCenter.default.addObserver(self, selector: #selector(enterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        locationVw.isHidden = false
               let locationViewGesture = UITapGestureRecognizer(target: self, action: #selector(tapCurrentLocation(_:)))
               self.viewCurrentLocation.addGestureRecognizer(locationViewGesture)
        setDarkMode()
    }
    
    private func setDarkMode(){
        mapView.backgroundColor = .whiteColor
        self.headerStatusVw.backgroundColor = .boxColor
        self.backBtn.tintColor = .blackColor

    }
    @objc func tapCurrentLocation(_ sender: UITapGestureRecognizer) {
        xmapView?.showCurrentLocation()
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
        self.xmapView?.didUpdateLocation = { [weak self] (location) in
            guard let self = self else {
                return
            }
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
            if CourierConstant.deliveryType == "" {
                self.setSourceDestinationAndPolyline()
            }
        }
        if fromChatNotification == true
        {
            fromChatNotification = false
            //ChatPushClick.shared.isPushClick = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                if self.isAppPresentTapOnPush == false
                {
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
    
    @objc private func tapBack() {
        ChatPushClick.shared.isPushClick = false
        if CourierConstant.deliveryType != "" || isFromOrderPage {
            self.navigationController?.popViewController(animated: true)
        }else{
            self.navigationController?.popToViewController(ofClass: HomeViewController.self)
        }
    }
    
    private func addMapView() {
        DispatchQueue.main.async {
            
            self.xmapView = XMapView(frame: self.mapView.bounds)
            self.xmapView?.tag = 100
            guard let _ = self.xmapView else {
                return
            }
            self.xmapView?.backgroundColor = .red
            self.view.backgroundColor = .appPrimaryColor
            self.mapView.addSubview(self.xmapView!)
            self.xmapView?.didDragMap = { [weak self] (isDrag,_) in
                guard self != nil else {
                    return
                }
                self?.courierRequestStatusView?.isHidden = isDrag
                self?.courierServiceSelView?.isHidden = isDrag
            }
            self.viewWillAppearCustom()

        }
//        self.xmapView?.currentLocationMarkerImage = self.currentLocationImage.image
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
    
    private func handleRequest() {
      guard var status = currentRequest?.data?.first?.status, currentRequest?.data?.first?.id != nil else
        {
               self.riderStatus = .none
               self.removeAllView()
               return
        }
 
        for eachDeliveryRequest  in currentRequest?.data?.first?.deliveries ?? [] {
            if eachDeliveryRequest.paid == 1 && eachDeliveryRequest.status != CourierRequestStatus.completed.rawValue {
                self.currentDelivery = eachDeliveryRequest
                break
                
            }else if eachDeliveryRequest.status != CourierRequestStatus.completed.rawValue {
                  self.currentDelivery = eachDeliveryRequest
                   break
            }
        }
        
        //check Completed
        if currentRequest?.data?.first?.deliveries?.last?.status == CourierRequestStatus.completed.rawValue {
            self.currentDelivery = currentRequest?.data?.first?.deliveries?.last                 
        }
        
        let deliveryStatus = currentDelivery?.status
        
        print("-------DeliveryStatus----\(deliveryStatus ?? "")")
        if deliveryStatus == CourierRequestStatus.dropped.rawValue {
          status = deliveryStatus!
        }
        
        self.sourceLocationDetail = SourceDestinationLocation(address: currentRequest?.data?.first?.s_address ?? "", locationCoordinate: CLLocationCoordinate2D(latitude: currentRequest?.data?.first?.s_latitude ?? 0, longitude: currentRequest?.data?.first?.s_longitude ?? 0))
           
        
        if (riderStatus == CourierRequestStatus.accepted) || (riderStatus == CourierRequestStatus.started) {
            self.destinationLocationDetail = SourceDestinationLocation(address: self.currentDelivery?.dAddress ?? "", locationCoordinate: CLLocationCoordinate2D(latitude: currentRequest?.data?.first?.provider?.latitude ?? 0, longitude: currentRequest?.data?.first?.provider?.longitude ?? 0))
        }
        else{
          self.destinationLocationDetail = SourceDestinationLocation(address: self.currentDelivery?.dAddress ?? "", locationCoordinate: CLLocationCoordinate2D(latitude: currentDelivery?.dLatitude ?? 0, longitude: currentDelivery?.dLongitude ?? 0))
        }
            self.xmapView?.removeLocationMarkers()
           
           if let markerURL = URL(string: currentRequest?.data?.first?.ride?.vehicle_marker ?? "") {
            
               self.currentLocationImage.load(url: markerURL, completion: { (image) in
                   DispatchQueue.main.async {
                       self.xmapView?.currentLocationMarkerImage = image.resizeImage(newWidth: 30)
                       self.xmapView?.setProviderCurrentLocationMarkerPosition(coordinate: self.sourceLocationDetail.locationCoordinate ?? CLLocationCoordinate2D())
                    self.xmapView?.setDestinationLocationMarker(destinationCoordinate: self.destinationLocationDetail.locationCoordinate ?? APPConstant.defaultMapLocation, marker: UIImage(named: Constant.destinationPin) ?? UIImage())
                   }
               })
            
             
           }else{
//               self.xmapView?.currentLocationMarkerImage = self.currentLocationImage.image
           }
        
        let paymentBy = currentRequest?.data?.first?.payment_by
        
        self.riderStatus = CourierRequestStatus(rawValue: status) ?? CourierRequestStatus.none
        print("##### \(status)")
        
        switch riderStatus {
        case .searching:
            ongoingBGView.isHidden = true
            headerStatusVw.isHidden = true
            locationVw.isHidden = true

            handleSearch()
          
        case .accepted, .started :
            setSourceDestinationMarker()
            self.setSourceDestinationAndPolyline()

            handleArrived()
            courierRequestStatusView?.invoiceButton.isHidden = true
            ongoingBGView.isHidden = false
            locationVw.isHidden = true
            labelStatusValue.text = "Provider accepted your request"
        
           case  .arrived :
              setSourceDestinationMarker()
             // handleArrived()
              courierRequestStatusView?.invoiceButton.isHidden = false
              ongoingBGView.isHidden = false
              locationVw.isHidden = true
              labelStatusValue.text = "Provider arrived your request"
              if paymentBy == "SENDER" {
              handleDelivered()
              }else{
                 handleArrived()
              }
              self.setSourceDestinationAndPolyline()
        case .pickedup:
            setSourceDestinationMarker()
            handleArrived()
            ongoingBGView.isHidden = false
            locationVw.isHidden = true
            labelStatusValue.text = "Provider reached at your location"
           self.setSourceDestinationAndPolyline()
         
        case .dropped:
            DispatchQueue.main.async
            {
                self.labelStatusValue.text = "Provider dropped your Courier"
                self.ongoingBGView.isHidden = false
                self.locationVw.isHidden = true
            }
            self.setSourceDestinationAndPolyline()
            if paymentBy != "SENDER" {
                handleDelivered()
            }
            else{
                handleArrived()
            }
            
        case .completed:
            locationVw.isHidden = true

            DispatchQueue.main.async
            {
                self.isAllRequestCompleted = self.currentRequest?.data?.first?.deliveries?.allSatisfy({$0.paid == 1}) ?? false
            }
 
        default:
             removeAllView()
             headerStatusVw.isHidden = false
             locationVw.isHidden = false
             headerStatusVw.isHidden = false
        }
        DispatchQueue.main.async
                  {
                    self.headerStatusVw.isHidden = ![CourierRequestStatus.none].contains(self.riderStatus)
        }
        if [CourierRequestStatus.searching,CourierRequestStatus.completed,CourierRequestStatus.none].contains(riderStatus)
        {
            self.xmapView?.isVisibleCurrentLocation(visible: true)
        }
        else
        {
            self.xmapView?.isVisibleCurrentLocation(visible: false)
        }
        
    }
    
    private func handleSearch(){
       
          if self.removeView(viewObj: self.courierRequestStatusView) {
              self.courierRequestStatusView = nil
          }
          if self.removeView(viewObj: self.courierServiceSelView) {
              self.courierServiceSelView = nil
          }
         
          self.tableView?.superview?.dismissView(onCompletion: {
              self.tableView = nil
          })
          self.showLoaderView()
      }
    
    private func handleArrived() {
        
//        if self.removeView(viewObj: self.courierRequestStatusView) {
//            self.courierRequestStatusView = nil
//          }
        
        if self.removeView(viewObj: self.invoiceView) {
                   self.invoiceView = nil
               }
        if self.removeView(viewObj: self.courierServiceSelView) {
            self.courierServiceSelView = nil
        }
        
        if self.removeView(viewObj: self.loaderView) {
                   
          self.loaderView = nil
                   
        }
                
        self.tableView?.superview?.dismissView(onCompletion: {
            
         self.tableView = nil
            
        })
        
        DispatchQueue.main.async {
                self.xmapView?.drawPolyLineFromSourceToDestination(source: self.sourceLocationDetail.locationCoordinate ?? APPConstant.defaultMapLocation, destination: self.destinationLocationDetail.locationCoordinate ?? APPConstant.defaultMapLocation, lineColor: .courierColor)
                self.xmapView?.showCurrentLocation()
                
                self.xmapView?.enableProviderMovement(providerId: self.currentRequest?.data?.first?.provider?.id ?? 0)
                self.showCourierStatusView(with: self.currentRequest?.data?.first ?? RequestData())
        }
    }
    
    private func handleDelivered(){
        if self.removeView(viewObj: self.courierRequestStatusView){
            self.courierRequestStatusView = nil
        }
        if self.removeView(viewObj: self.courierServiceSelView) {
            self.courierServiceSelView = nil
        }
        
        self.tableView?.superview?.dismissView(onCompletion:
        {
                self.tableView = nil
        })
        self.xmapView?.enableProviderMovement(providerId: 0)
        let paymentBy = currentRequest?.data?.first?.payment_by
                
                   
        
        if let requestDetails = self.currentRequest?.data {
            if paymentBy != "SENDER" {

                self.showInvoice(with: requestDetails, isSenderPay: false)
            }else {
            if let invoiceShowed = self.isInvoiceShowed,invoiceShowed == true {
                if self.removeView(viewObj: self.invoiceView) {
                    self.invoiceView = nil
                }
//                self.showRatingView(with: requestDetails)
            }else {
                self.showInvoice(with: requestDetails, isSenderPay: true)
            }
        }
        }
    }
    private func handleCompleted(){
        if self.removeView(viewObj: self.courierRequestStatusView){
                 self.courierRequestStatusView = nil
             }
             if self.removeView(viewObj: self.courierServiceSelView) {
                 self.courierServiceSelView = nil
             }
             
             self.tableView?.superview?.dismissView(onCompletion:
                 {
                     
                     self.tableView = nil
                     
             })
             self.xmapView?.enableProviderMovement(providerId: 0)
             if let requestDetails = self.currentRequest?.data {
//                 if let invoiceShowed = self.isInvoiceShowed,invoiceShowed == true {
//                     if self.removeView(viewObj: self.invoiceView) {
//                         self.invoiceView = nil
//                     }
                     self.showRatingView(with: requestDetails)
               //  }
             }
    }
   
    private func removeAllView() {
        if self.removeView(viewObj: self.courierRequestStatusView) {
            self.courierRequestStatusView = nil
        }
        if self.removeView(viewObj: self.loaderView) {
            
            self.loaderView = nil
        }
        self.xmapView?.clearAll()
        self.ongoingBGView.isHidden = true
        self.headerStatusVw.isHidden = false
        self.destinationLocationDetail = SourceDestinationLocation()
        self.getServiceListAPI()
    }
    

    private func removeMapView() {
        for subView in mapView.subviews where subView.tag == 100 {
            xmapView?.clearAll()
            subView.removeFromSuperview()
            xmapView?.currentLocation = nil
            xmapView = nil
        }
    }
    
    private func removeView(viewObj: UIView?) -> Bool {
           if let views = viewObj {
               views.removeFromSuperview()
               return true
           }
           return false
       }
    
    
    
    private func setSourceDestinationMarker() {
        self.xmapView?.setSourceLocationMarker(sourceCoordinate: self.sourceLocationDetail.locationCoordinate ?? APPConstant.defaultMapLocation, marker: UIImage(named: Constant.sourcePin) ?? UIImage())
        self.xmapView?.setDestinationLocationMarker(destinationCoordinate: self.destinationLocationDetail.locationCoordinate ?? APPConstant.defaultMapLocation, marker: UIImage(named: Constant.destinationPin) ?? UIImage())
       }

    private func setSourceDestinationAndPolyline() {
               DispatchQueue.main.async {
                   self.setSourceDestinationMarker()
                self.xmapView?.drawPolyLineFromSourceToDestination(source: self.sourceLocationDetail.locationCoordinate ?? APPConstant.defaultMapLocation, destination: self.destinationLocationDetail.locationCoordinate ?? APPConstant.defaultMapLocation, lineColor: .courierColor)
               }
       }
    
    func showServiceList() {
        
        if let _ = getServiceListView() {
           // DispatchQueue.main.async {
                self.courierServiceSelView?.serviceDetails = self.serviceList ?? []
           // }
            courierServiceSelView?.tapService = { selectedService in
                 
                guard let id = selectedService.id else {return}
                self.selectedID = id
                VHeight = selectedService.height ?? 0
                VWeight = selectedService.weight ?? 0
                VBreadth = selectedService.breadth ?? 0
                VLength = selectedService.length ?? 0

            }
            
        }
    }
    
    private func showLoaderView() {
           if let _ = self.getLoaderView() {
               loaderView?.cancelRequestButton.backgroundColor = .courierColor
            loaderView?.cancelRequestButton.titleLabel?.textColor = .white
               self.loaderView?.onClickCancelRequest = { [weak self] in
                   guard let self = self else {
                       return
                   }
                self.showCancelTable()
               }
           }
       }
    
    
    private func getServiceListView() -> CourierServiceSelectionView?{
        guard let _ = self.courierServiceSelView else {
            if let serviceSelectionView =  Bundle.main.loadNibNamed(CourierConstant.CourierServiceSelectionView, owner: self, options: [:])?.first as? CourierServiceSelectionView  {
                self.view.addSubview(serviceSelectionView)
                serviceSelectionView.translatesAutoresizingMaskIntoConstraints = false
                serviceSelectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
                serviceSelectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
                serviceSelectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
                serviceSelectionView.show(with: .bottom, completion: nil)
                serviceSelectionView.nextBtn.addTarget(self, action: #selector(nextButtonAction), for: .touchUpInside)
                self.courierServiceSelView = serviceSelectionView
                
            }
            return courierServiceSelView
        }
        return self.courierServiceSelView
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
    
    
    
    
    func showCourierStatusView(with request : RequestData) {
        if let _ = self.getRideStatusView() {
            self.courierRequestStatusView?.set(values: request)
            self.courierRequestStatusView?.tapOnCall = {
                if let phoneNumber = self.currentRequest?.data?.first?.provider?.mobile
                {
                    AppUtils.shared.call(to: phoneNumber)
                }
            }
            self.courierRequestStatusView?.tapOnChat =
            {
                    self.navigationToChatView()
            }
            
            self.courierRequestStatusView?.tapOnInvoice =
            {
                if let requestDetails = self.currentRequest?.data {
                    self.displayInvoice(with: requestDetails, isSenderPay: true)
                }
            }
        }
    }
    
    private func getRideStatusView() -> CourierRequestStatusView? {
           guard let _ = self.courierRequestStatusView else {
               if let rideStatusView =  Bundle.main.loadNibNamed(CourierConstant.CourierRequestStatusView, owner: self, options: [:])?.first as? CourierRequestStatusView {
                   self.view.addSubview(rideStatusView)
                   rideStatusView.translatesAutoresizingMaskIntoConstraints = false
                   rideStatusView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
                   rideStatusView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
                   rideStatusView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
                   rideStatusView.show(with: .right, completion: nil)
                   rideStatusView.layoutIfNeeded()
                   self.courierRequestStatusView = rideStatusView
               }
               return courierRequestStatusView
           }
           return self.courierRequestStatusView
       }
    
    
    
    @objc func nextButtonAction(){
        if selectedID == 0  {
            ToastManager.show(title: "Please Select Service", state: .error)
        }else{
            let routeVC = CourierRouter.courierStoryboard.instantiateViewController(withIdentifier: CourierConstant.CourierRouteViewController) as! CourierRouteViewController
            routeVC.serviceTypeID = selectedID
            routeVC.deliveryTypeID = self.deliveryTypeID
            routeVC.sourceLocationDetail = self.sourceLocationDetail
            navigationController?.pushViewController(routeVC, animated: true)
        }
    }
    
    func navigationToChatView() {
        
        let checkRequestDetail = currentRequest?.data?.first
        let providerDetail = checkRequestDetail?.provider
        let userDetail = checkRequestDetail?.user
        let serviceDetail = checkRequestDetail?.service_type
        let chatView = ChatViewController()
        chatView.requestId = "\((checkRequestDetail?.id ?? 0))"
        chatView.chatRequestFrom = MasterServices.Delivery.rawValue
        chatView.userId = "\((userDetail?.id ?? 0))"
        chatView.userName = "\( userDetail?.firstName ?? "")" + " " + "\(userDetail?.lastName ?? "")"
        chatView.providerId = "\((providerDetail?.id ?? 0))"
        chatView.providerName = "\(providerDetail?.first_name ?? "")" + " " + "\(providerDetail?.last_name ?? "")"
        chatView.adminServiceId = serviceDetail?.admin_service_id
        chatView.isChatPresented = isChatAlreadyPresented
        self.navigationController?.pushViewController(chatView, animated: true)
    }
    
    private func setFont() {
        pickupLocationTxtFld.font = .setCustomFont(name: .medium, size: .x14)
        vehicleTypeLbl.font = .setCustomFont(name: .medium, size: .x12)
        routeLbl.font = .setCustomFont(name: .medium, size: .x12)
        priceLbl.font = .setCustomFont(name: .medium, size: .x12)
        labelStatus.font = .setCustomFont(name: .medium, size: .x14)
        labelStatusValue.font = .setCustomFont(name: .bold, size: .x14)
    }
    private func setColors() {
        vehicleTypeLbl.textColor = .red
        routeLbl.textColor = .lightGray
        priceLbl.textColor = .lightGray
    }
    private func setLocalize(){
        vehicleTypeLbl.text = CourierConstant.vehicleType.localized
        routeLbl.text = CourierConstant.route.localized
        priceLbl.text = CourierConstant.price.localized
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
            self.courierPresenter?.cancelRequest(param: param)
        }
    }
    
    
    private func showDimView(view: UIView) {
           let dimView = UIView(frame: self.view.frame)
           dimView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
           dimView.addSubview(view)
           self.view.addSubview(dimView)
       }
}


extension CourierHomeController : CourierPresenterToCourierViewProtocol{
    
    // get cancel reasons
      func getReasonsResponse(reasonEntity: ReasonEntity) {
          self.reasonData = reasonEntity.responseData ?? []
      }
    
    func cancelRequestSuccess(requestEntity: Request) {
        self.tableView?.superview?.dismissView(onCompletion: {
            self.tableView = nil
        })
        ToastManager.show(title: requestEntity.message ?? "", state: .success)
        
        BackGroundRequestManager.share.stopBackGroundRequest()
        if isFromOrderPage {
            self.navigationController?.popViewController(animated: true)
        }else{
            self.navigationController?.popToViewController(ofClass: HomeViewController.self)
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
    
    
    func checkCourierRequest(requestEntity: Request) {
        
        print("requestCalled \(requestEntity.responseData?.data?.last?.status)")
          if let requestData = requestEntity.responseData?.data, requestData.count > 0 {
                    self.currentRequest = requestEntity.responseData
                    self.socketAndBgTaskSetUp()
                    DispatchQueue.main.async {
                        self.handleRequest()
                    }
          }else{
            if isFromOrderPage {
                self.navigationController?.popViewController(animated: true)
            }else{
                self.navigationController?.popToViewController(ofClass: HomeViewController.self)
            }
            
        }
        
    }
}
extension CourierHomeController : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let vc = TaxiRouter.taxiStoryboard.instantiateViewController(withIdentifier: TaxiConstant.LocationSelectionController) as! LocationSelectionController
        vc.locationDelegate = self
        vc.isFromCourier = true
        vc.isSource = textField == self.pickupLocationTxtFld
        self.navigationController?.pushViewController(vc, animated: true)
        return false
    }
}
extension  CourierHomeController: LocationDelegate {
    func selectedLocation(isSource: Bool, addressDetails: SourceDestinationLocation) {
        if isSource {
            self.sourceLocationDetail = addressDetails
            let tempId = AppManager.shared.getSelectedServices()?.menu_type_id ?? 0
            self.courierPresenter?.getServiceList(coordinates: sourceLocationDetail.locationCoordinate ?? CLLocationCoordinate2D(), id: tempId)
        }else{
            self.destinationLocationDetail = addressDetails
        }
    }
}
extension CourierHomeController {
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
    
    func showRatingView(with request : [RequestData]) {
        
        locationVw.isHidden = true
        if let requestWallet = request.first?.payment?.wallet, requestWallet > 0 {  //Locally change wallet amount, without hitting profile API
            var walletBalance = AppManager.shared.getUserDetails()?.wallet_balance
            walletBalance = (walletBalance ?? 0) - requestWallet
            AppManager.shared.getUserDetails()?.wallet_balance = walletBalance
        }
        
        if let _ = self.getRatingView() {
            if self.removeView(viewObj: self.invoiceView) {
                self.invoiceView = nil
            }
            self.ratingView?.setValues(color: .courierColor)
            self.ratingView?.idLabel.text = TaxiConstant.bookingId.localized + ":" + "\(String(describing: request.first?.booking_id ?? ""))"
            if let provider = request.first?.provider {
                self.ratingView?.userNameLabel.text = (provider.first_name ?? "") + " " + (provider.last_name ?? "")
                
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
                                                                   TaxiConstant.admin_service_id: self.currentRequest?.data?.first?.service_type?.admin_service_id ?? ""]
                                          self.courierPresenter?.ratingToProvider(param: param)
                }
                
            }
        }
    }
    
    
    func invoicePaymentSuccess(requestEntity: Request){
        ToastManager.show(title: requestEntity.message ?? "", state: .success)
        self.isInvoiceShowed = true
        checkRequestApiCall()
     }
     
    func ratingToProviderSuccess(requestEntity: Request){
        ToastManager.show(title: requestEntity.message ?? "", state: .success)
        self.isInvoiceShowed = false
        BackGroundRequestManager.share.resetBackGroudTask()
        socketAndBgTaskSetUp()
        self.ratingView?.dismissView(onCompletion:
            {
                self.ratingView?.removeFromSuperview()
                self.ratingView = nil
                self.xmapView?.clearAll()
                self.getServiceListAPI()
                self.headerStatusVw.isHidden = false
                self.removeAllView()
                self.navigationController?.popToViewController(ofClass: HomeViewController.self)

        })
    }
    
}
extension CourierHomeController {
    
    private func getInvoiceView() -> CourierInvoiceView?{
           guard let _ = self.invoiceView else {
               if let invoiceView = Bundle.main.loadNibNamed(CourierConstant.CourierInvoiceView, owner: self, options: [:])?.first as? CourierInvoiceView {
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
    
    func showInvoice(with request: [RequestData],isSenderPay: Bool) {
        if let _ = self.getInvoiceView() {
            self.invoiceView?.onClickConfirm = { [weak self] (isCash) in
                guard let self = self else {
                    return
                }
                self.invoiceView?.dismissView(onCompletion: {
                    self.invoiceView = nil
//                    self.handleRequest()
                })
                if isCash  {
                    self.isInvoiceShowed = true
                    self.handleArrived()
//                    self.showRatingView(with: request)
                }else{
                    if request.first?.paid == 1 {
//                        self.showRatingView(with: request)
                    }else {
                        guard let id = self.currentRequest?.data?.first?.id else {return}
                        let param : Parameters = ["id":id]
                        self.courierPresenter?.invoicePayment(param: param)
                    }
                }
                       
            }
            self.invoiceView?.requestData = self.currentRequest
            if let current = currentDelivery {
                self.invoiceView?.setValues(values: request.first ?? RequestData(),data : current, isSenderPay: isSenderPay)
            }
        }
    }
    
    
    func displayInvoice(with request: [RequestData],isSenderPay: Bool) {
        if let _ = self.getInvoiceView() {
            self.invoiceView?.onClickConfirm = { [weak self] (isCash) in
                guard let self = self else {
                    return
                }
                self.invoiceView?.dismissView(onCompletion: {
                    self.invoiceView = nil
//                    self.handleRequest()
                })
            }
            self.invoiceView?.requestData = self.currentRequest
            if let current = currentDelivery {
                self.invoiceView?.setValues(values: request.first ?? RequestData(),data : current, isSenderPay: isSenderPay)
            }
        }
    }
}

