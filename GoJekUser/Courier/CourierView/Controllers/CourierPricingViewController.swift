
//
//  CourierPricingViewController.swift
//  GoJekUser
//
//  Created by Thiru on 29/05/20.
//  Copyright © 2020 Appoets. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class CourierPricingViewController: UIViewController {
    
    
    @IBOutlet weak var mainScrlVw: UIScrollView!
    @IBOutlet weak var viewBgVw: UIView!
    @IBOutlet weak var priceVw: UIView!
    @IBOutlet weak var titlebgVw: UIView!
    @IBOutlet weak var vehilcleNameLbl: UILabel!
    @IBOutlet weak var basefareVw: UIView!
    @IBOutlet weak var basefaretitleLbl: UILabel!
    @IBOutlet weak var basefaretitleValueLbl: UILabel!
    @IBOutlet weak var distancefareVw: UIView!
    @IBOutlet weak var distancefaretitleLbl: UILabel!
    @IBOutlet weak var distancefaretitleValueLbl: UILabel!
    @IBOutlet weak var timingVw: UIView!
    @IBOutlet weak var timingtitleLbl: UILabel!
    @IBOutlet weak var timingValueLbl: UILabel!
    @IBOutlet weak var taxVw: UIView!
    @IBOutlet weak var taxtitleLbl: UILabel!
    @IBOutlet weak var taxValueLbl: UILabel!
    @IBOutlet weak var priceLineVw: UIView!
    @IBOutlet weak var subTotalVw: UIView!
    @IBOutlet weak var subTotaltitleLbl: UILabel!
    @IBOutlet weak var subTotalValueLbl: UILabel!
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
    @IBOutlet weak var paymentVw: UIView!
    @IBOutlet weak var paymentbgVw: UIView!
    @IBOutlet weak var paymentTitleLbl: UILabel!
    @IBOutlet weak var paymentStackvw: UIStackView!
    @IBOutlet weak var cashBtn: UIButton!
    @IBOutlet weak var cardBtn: UIButton!
    @IBOutlet weak var couponVw: UIView!
    @IBOutlet weak var couponBgVw: UILabel!
    @IBOutlet weak var deliveryBtn: UIButton!
    @IBOutlet weak var scheduleBtn: UIButton!
    @IBOutlet weak var labelResponsibleForPayment: UILabel!
    @IBOutlet weak var btnReceiver: UIButton!
    @IBOutlet weak var btnSender: UIButton!
    @IBOutlet weak var viewCouponButton: UIButton!

    
    @IBOutlet weak var cardOrCashLabel:UILabel!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var paymentImage:UIImageView!
    

    
    
    var estimateFareData: CourierEstimateEntity?
    var isSchedule = false
    var scheduleTime = String()
    var scheduleDate = String()
    var counponEntity: PromocodeData?
    var scheduleNowView: CourierScheduleView?
    var courierRequestArray = [CourierData]()
    var sourceLocation = SourceDestinationLocation()
    var couponView: CouponView?
    var isPushToPayment = false
    
//    var paymentMode: PaymentType?
    var serviceID = Int()
    var deliveryTypeID = Int()
    var weight = Int()

    var iscash:Bool = false { //true - cash , false - card
        didSet {
            cashBtn.setImage(UIImage(named: iscash ? Constant.circleFullImage : Constant.circleImage), for: .normal)
            cardBtn.setImage(UIImage(named: iscash ? Constant.circleImage : Constant.circleFullImage), for: .normal)
            isSender = true
            btnReceiver.isHidden = !iscash
        }
    }
    var isSender:Bool = false { //true - sender , false - receiver
        didSet {
            btnSender.setImage(UIImage(named: isSender ? Constant.circleFullImage : Constant.circleImage), for: .normal)
            btnReceiver.setImage(UIImage(named: isSender ? Constant.circleImage : Constant.circleFullImage), for: .normal)
        }
    }
    
    var paymentMode:PaymentType = .CASH {
        didSet {
            paymentImage.image = paymentMode.image
            cardOrCashLabel.text = paymentMode.rawValue
            if(paymentMode == .CASH){
               iscash = true
            }
            else{
               iscash = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoad()
    }
    
    override func viewDidLayoutSubviews() {
        headerStatusVw.addShadow(radius: 5, color: .lightGray)
        priceVw.setCornerRadiuswithValue(value: 5)
        paymentVw.setCornerRadiuswithValue(value: 5)
        couponVw.setCornerRadiuswithValue(value: 5)
        paymentVw.addShadow(radius: 5, color: .darkGray)
        couponVw.addShadow(radius: 5, color: .darkGray)
        priceVw.addShadow(radius: 5, color: .darkGray)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.getDistanceAndEstimatedFare()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if !isPushToPayment {
            self.navigationController?.isNavigationBarHidden = true
        }
    }
    
    
    // change payment before sending request
    @objc func changePaymentButtonTapped() {
        
        let paymentVC = AccountRouter.accountStoryboard.instantiateViewController(withIdentifier: AccountConstant.PaymentSelectViewController) as! PaymentSelectViewController
        paymentVC.isChangePayment = true
        paymentVC.onClickPayment = { [weak self] (type,cardEntity) in
            guard let self = self else {
                return
            }
            self.paymentMode = type
            if type == .CARD {
                self.cardOrCashLabel.text = Constant.cardPrefix + (cardEntity?.last_four ?? "")
            }else{
                self.cardOrCashLabel.text = type.rawValue
            }
        }
        isPushToPayment = true
        UIApplication.topViewController()?.navigationController?.pushViewController(paymentVC, animated: true)
    }
    
    
    private func getEstimatedFare(requestArray:[CourierData]){
        
        var dlatitudeArr = [String:Double]()
        var dlongitudeArr = [String:Double]()
        var weightArr = [String:Int]()
        var lengthArr = [String:Int]()
        var breadthArr = [String:Int]()
        var heightArr = [String:Int]()
        var distance = Double()
        
        for i in 0..<courierRequestArray.count
        {
            dlatitudeArr["\(i)"] = courierRequestArray[i].d_latitude
            dlongitudeArr["\(i)"] = courierRequestArray[i].d_longitude
            distance = distance + (courierRequestArray[i].distance ?? 0)
            weight = weight + (courierRequestArray[i].weight ?? 0)
            weightArr["\(i)"] = courierRequestArray[i].weight
            lengthArr["\(i)"] = courierRequestArray[i].length
            breadthArr["\(i)"] = courierRequestArray[i].breadth
            heightArr["\(i)"] = courierRequestArray[i].height
            
        }
        
        let params : Parameters = [CourierConstant.Ps_latitude:self.sourceLocation.locationCoordinate?.latitude ?? 0,
                                   CourierConstant.Ps_longitude:self.sourceLocation.locationCoordinate?.longitude ?? 0,
                                   CourierConstant.Pd_latitude:dlatitudeArr,
                                   CourierConstant.Pd_longitude:dlongitudeArr,
                                   CourierConstant.Pservice_type:serviceID.toString(),
                                   CourierConstant.Pweight:weightArr,
                                   CourierConstant.Plength:lengthArr,
                                   CourierConstant.Pbreadth:breadthArr,
                                   CourierConstant.Pheight:heightArr,
                                   CourierConstant.deliveryMode:courierRequestArray.count > 1 ? CourierConstant.multiple :CourierConstant.single,
                                   CourierConstant.deliveryTypeId:self.deliveryTypeID,
                                   CourierConstant.Ppayment_mode:self.paymentMode.rawValue ?? PaymentType.CASH.rawValue,
                                   CourierConstant.distance1:distance]
        
        self.courierPresenter?.getEstimateFare(param: params)
    }
    
    @objc func tapViewCoupon(_ sender: UIButton) {
        if couponView == nil, let couponView = Bundle.main.loadNibNamed(Constant.CouponView, owner: self, options: [:])?.first as? CouponView {
            let viewHeight = (view.frame.height/100)*30
            couponView.frame = CGRect(origin: CGPoint(x: 0, y: view.frame.height-viewHeight), size: CGSize(width: view.frame.width, height: viewHeight))
            self.couponView = couponView
            couponView.setValues(color: .taxiColor)
            couponView.show(with: .bottom, completion: nil)
            self.couponView?.set(values: estimateFareData?.responseData?.promocodes ?? [])
            if let selectedCoupon = counponEntity {
                self.couponView?.isSelectedPromo(values: selectedCoupon)
            }
            showDimView(view: couponView)
        }
        
        // selected coupon stored in globally
        couponView?.applyCouponAction = { [weak self] (selectedCoupon) in
            guard let self = self else {
                return
            }
            self.couponView?.superview?.removeFromSuperview()
            self.couponView?.dismissView(onCompletion: {
                self.couponView = nil
            })
            self.counponEntity = selectedCoupon
            if self.estimateFareData?.responseData?.promocodes?.count == 0 || selectedCoupon == nil {
                self.viewCouponButton.setTitle(Constant.viewCoupon.localized.uppercased(), for: .normal)
            }else{
                self.viewCouponButton.setTitle(selectedCoupon?.promo_code, for: .normal)
              //  self.requestEntity?.promocode_id = selectedCoupon?.id
            }
        }
    }
    
    private func getDistanceAndEstimatedFare(){
        
        for i in 0..<courierRequestArray.count {
            
            let lat = courierRequestArray[i].d_latitude
            let long = courierRequestArray[i].d_longitude
            
            let sourceCoordinates = CLLocation(latitude:self.sourceLocation.locationCoordinate?.latitude ?? 0, longitude:self.sourceLocation.locationCoordinate?.longitude ?? 0)
            let destinationCoordinates = CLLocation(latitude:lat ?? 0, longitude:long ?? 0)
            let distanceInMeters = sourceCoordinates.distance(from: destinationCoordinates)
            courierRequestArray[i].distance = distanceInMeters / 1000
        }
        self.getEstimatedFare(requestArray: self.courierRequestArray)
    }
    
    
    @IBAction func paymentSelection(sender:UIButton){
        iscash = sender.tag == 1 ? true : false
        if iscash {
            paymentMode = PaymentType(rawValue: PaymentType.CASH.rawValue) ?? PaymentType.CASH
        }else{
            paymentMode = PaymentType(rawValue: PaymentType.CARD.rawValue) ?? PaymentType.CASH
        }
    }
    
    @IBAction func payerSelection(sender:UIButton){
        isSender = sender.tag == 1 ? true : false
    }
    
}
extension CourierPricingViewController {
    
    private func initialLoad() {
        
        setNavigationBar()
        iscash = true
        isSender = true
        priceLineVw.backgroundColor = .lightText
        priceVw.setBorder(width: 1, color: .lightText)
        cashBtn.setImageTitle(spacing: 10)
        cardBtn.setImageTitle(spacing: 10)
        cardBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        cardBtn.imageView?.contentMode = .scaleAspectFit
        cashBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        cashBtn.imageView?.contentMode = .scaleAspectFit
        btnSender.setImageTitle(spacing: 10)
        btnReceiver.setImageTitle(spacing: 10)
        btnSender.imageEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        btnSender.imageView?.contentMode = .scaleAspectFit
        btnReceiver.imageEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        btnReceiver.imageView?.contentMode = .scaleAspectFit
        viewCouponButton.addTarget(self, action: #selector(tapViewCoupon(_:)), for: .touchUpInside)
        routeImgVw.imageTintColor(color1: .lightGray)
        priceImgVw.imageTintColor(color1: .lightGray)
        vehicleTypeImgVw.image = UIImage.init(named: CourierConstant.redTapeImg)
        routeImgVw.image = UIImage.init(named: CourierConstant.redTapeImg)
        priceImgVw.image = UIImage.init(named: CourierConstant.redTapeImg)
        setFont()
        setColors()
        setLocalize()
        self.cardBtn.tag = 2
        self.cashBtn.tag = 1
        self.btnReceiver.tag = 2
        self.btnSender.tag = 1
        self.cashBtn.addTarget(self, action:#selector(paymentSelection(sender:)), for: .touchUpInside)
        cardBtn.addTarget(self, action:#selector(paymentSelection(sender:)), for: .touchUpInside)
        self.btnReceiver.addTarget(self, action:#selector(payerSelection(sender:)), for: .touchUpInside)
        self.btnSender.addTarget(self, action:#selector(payerSelection(sender:)), for: .touchUpInside)
        scheduleBtn.addTarget(self, action: #selector(tapScheduleNow), for: .touchUpInside)
        deliveryBtn.addTarget(self, action: #selector(tapdeliverynow), for: .touchUpInside)
        changeButton.addTarget(self, action: #selector(changePaymentButtonTapped), for: .touchUpInside)

        setDarkMode()
        paymentMode = .CASH
    }
    
    private func setDarkMode(){
        self.view.backgroundColor = .backgroundColor
        self.priceVw.backgroundColor = .boxColor
        self.paymentVw.backgroundColor = .boxColor
        self.headerStatusVw.backgroundColor = .boxColor
        self.couponVw.backgroundColor = .boxColor

    }
    
    private func setFont() {
        vehicleTypeLbl.font = .setCustomFont(name: .medium, size: .x12)
        routeLbl.font = .setCustomFont(name: .medium, size: .x12)
        priceLbl.font = .setCustomFont(name: .medium, size: .x12)
        cashBtn.titleLabel?.font = .setCustomFont(name: .medium, size: .x14)
        cardBtn.titleLabel?.font = .setCustomFont(name: .medium, size: .x14)
        paymentTitleLbl.font = .setCustomFont(name: .bold, size: .x16)
        labelResponsibleForPayment.font = .setCustomFont(name: .bold, size: .x16)
        deliveryBtn.titleLabel?.font = .setCustomFont(name: .medium, size: .x18)
        scheduleBtn.titleLabel?.font = .setCustomFont(name: .medium, size: .x18)
        self.basefaretitleLbl.font = .setCustomFont(name: .medium, size: .x16)
        self.taxtitleLbl.font  = .setCustomFont(name: .medium, size: .x16)
        self.distancefaretitleLbl.font = .setCustomFont(name: .medium, size: .x16)
        self.timingtitleLbl.font = .setCustomFont(name: .medium, size: .x16)
        self.subTotaltitleLbl.font = .setCustomFont(name: .bold, size: .x18)
        self.vehilcleNameLbl.font = .setCustomFont(name: .medium, size: .x16)
        self.taxValueLbl.font = .setCustomFont(name: .medium, size: .x16)
        self.distancefaretitleValueLbl.font = .setCustomFont(name: .medium, size: .x16)
        self.timingValueLbl.font = .setCustomFont(name: .medium, size: .x16)
        self.distancefaretitleValueLbl.font = .setCustomFont(name: .medium, size: .x16)
        self.couponBgVw.font = .setCustomFont(name: .bold, size: .x16)
        self.vehilcleNameLbl.font = .setCustomFont(name: .bold, size: .x16)
        changeButton.titleLabel?.font = .setCustomFont(name: .bold, size: .x12)
        cardOrCashLabel.font = .setCustomFont(name: .medium, size: .x12)
    }
    
    private func setColors(){
        self.view.backgroundColor = .veryLightGray
        mainScrlVw.backgroundColor = .clear
        viewBgVw.backgroundColor = .clear
        vehicleTypeLbl.textColor = .lightGray
        routeLbl.textColor = .lightGray
        priceLbl.textColor = .lightGray
        vehicleTypeLineVw.backgroundColor = .lightGray
        routeLeftLineVw.backgroundColor = .lightGray
        routeRightLineVw.backgroundColor = .lightGray
        priceLeftLineVw.backgroundColor = .lightGray
        deliveryBtn.backgroundColor = .courierColor
        scheduleBtn.backgroundColor = .courierColor
        deliveryBtn.setTitleColor(.white, for: .normal)
        scheduleBtn.setTitleColor(.white, for: .normal)
        viewCouponButton.setTitleColor(.courierColor, for: .normal)
        self.taxValueLbl.textColor = .darkGray
        self.distancefaretitleValueLbl.textColor = .darkGray
        self.timingValueLbl.textColor = .darkGray
        self.distancefaretitleValueLbl.textColor = .darkGray
        self.subTotalValueLbl.textColor = .darkGray
        cardOrCashLabel.textColor = .darkGray
        changeButton.backgroundColor = UIColor.courierColor.withAlphaComponent(0.2)
        changeButton.layer.borderColor = UIColor.courierColor.cgColor
        changeButton.textColor(color: .courierColor)
        changeButton.borderColor = .courierColor
        changeButton.borderLineWidth = 1.0
        changeButton.cornerRadius = 5.0
    }
    
    private func setLocalize(){
        vehicleTypeLbl.text = CourierConstant.vehicleType.localized
        paymentTitleLbl.text = CourierConstant.paymentmethod.localized
        couponBgVw.text =  CourierConstant.applyCoupon.localized
        routeLbl.text = CourierConstant.route.localized
        priceLbl.text = CourierConstant.price.localized
        cashBtn.setTitle(CourierConstant.cash.localized, for: .normal)
        cardBtn.setTitle(CourierConstant.card.localized, for: .normal)
        btnReceiver.setTitle(CourierConstant.receiver.localized, for: .normal)
        btnSender.setTitle(CourierConstant.sender.localized, for: .normal)
        changeButton.setTitle(Constant.change.localized.uppercased(), for: .normal)
        self.basefaretitleLbl.text = CourierConstant.estimateDistance.localized
//        self.taxtitleLbl.text  = CourierConstant.tax.localized
        self.distancefaretitleLbl.text = CourierConstant.estimateFare.localized
        self.timingtitleLbl.text = CourierConstant.weight.localized
        self.subTotaltitleLbl.text = CourierConstant.subTotal.localized
        self.viewCouponButton.setTitle(Constant.viewCoupon.localized.uppercased(), for: .normal)
    }
    
    private func setNavigationBar() {
        self.setNavigationTitle()
        self.setLeftBarButtonWith(color: .blackColor)
        self.title = CourierConstant.price
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    private func setValuesUpdate(){
        self.vehilcleNameLbl.text = self.estimateFareData?.responseData?.service?.vehicle_name
//        self.taxValueLbl.text = "\(self.estimateFareData?.responseData?.currency ?? "")\(self.estimateFareData?.responseData?.fare?.tax_price ?? 0)"
        self.distancefaretitleValueLbl.text = "\(self.estimateFareData?.responseData?.currency ?? "")\(self.estimateFareData?.responseData?.fare?.estimated_fare ?? 0)"
        self.timingValueLbl.text = "\(weight)"
        self.basefaretitleValueLbl.text = "\(self.estimateFareData?.responseData?.fare?.distance ?? 0) Kms"
        self.subTotalValueLbl.text = "\(self.estimateFareData?.responseData?.currency ?? "")\(self.estimateFareData?.responseData?.fare?.estimated_fare ?? 0)"
        if estimateFareData?.responseData?.promocodes?.count == 0 {
            couponVw.isHidden = true
        }else{
            couponVw.isHidden = false
        }
    }
    
    private func createRequest(){
        
        var picsArr = [String:Data]()
        
        var param : Parameters  = [:]
        
        for i in 0..<courierRequestArray.count {
            param["receiver_name[\(i)]"] = courierRequestArray[i].receiver_name
            param["receiver_mobile[\(i)]"] = courierRequestArray[i].receiver_mobile
            param["d_latitude[\(i)]"] = courierRequestArray[i].d_latitude
            param["d_longitude[\(i)]"] = courierRequestArray[i].d_longitude
            param["d_address[\(i)]"] = courierRequestArray[i].d_address
            param["distance[\(i)]"] = courierRequestArray[i].distance
            param["package_type_id[\(i)]"] = courierRequestArray[i].package_type_id
            param["receiver_instruction[\(i)]"] = courierRequestArray[i].receiver_instruction
            param["weight[\(i)]"] = courierRequestArray[i].weight
            param["is_fragile\(i)"] = courierRequestArray[i].is_fragile
            picsArr["picture[\(i)]"] = courierRequestArray[i].picture
            param["length[\(i)]"] = courierRequestArray[i].length
                     param["breadth[\(i)]"] = courierRequestArray[i].breadth
                     param["height[\(i)]"] = courierRequestArray[i].height
        }
        
        param.updateValue(self.sourceLocation.locationCoordinate?.latitude ?? 0, forKey: CourierConstant.Ps_latitude)
        param.updateValue(self.sourceLocation.locationCoordinate?.longitude ?? 0, forKey: CourierConstant.Ps_longitude)
        param.updateValue(serviceID, forKey: CourierConstant.Pservice_type)
        param.updateValue(self.sourceLocation.address ?? "", forKey: CourierConstant.Ps_address)
        param.updateValue(iscash ? "CASH" : "CARD", forKey: CourierConstant.Ppayment_mode)
        param.updateValue(isSender ? "SENDER" : "RECEIVER", forKey: CourierConstant.Ppayment_by)
        param.updateValue(0, forKey: CourierConstant.Puse_wallet)
        param.updateValue(deliveryTypeID, forKey: CourierConstant.Pdelivery_type_id)
   
        if isSchedule {
            
            param.updateValue(self.scheduleDate, forKey: "schedule_date")
                   param.updateValue(self.scheduleTime, forKey: "schedule_time")
            
        }
        self.courierPresenter?.sendRequestWithImage(param: param, imageData: picsArr)

    }
}
extension CourierPricingViewController {
    @objc func tapScheduleNow(_ sender: UIButton) {
        
        if scheduleNowView == nil, let scheduleView = Bundle.main.loadNibNamed(CourierConstant.CourierScheduleView, owner: self, options: [:])?.first as? CourierScheduleView {
            let viewHeight = (view.frame.height/100)*25
            scheduleView.frame = CGRect(origin: CGPoint(x: 0, y: view.frame.height-viewHeight), size: CGSize(width: view.frame.width, height: viewHeight))
            self.scheduleNowView = scheduleView
            scheduleView.show(with: .bottom, completion: nil)
            showDimView(view: scheduleView)
        }
        scheduleNowView?.onClickScheduleNow = { [weak self] (selectedDate,selectedTime) in
            guard let self = self else {
                return
            }
            if selectedDate == "" && selectedTime == "" {
                AppAlert.shared.simpleAlert(view: self, title: "", message: Constant.dateTimeSelect.localized, buttonTitle: "OK")
                return
            }
            self.scheduleDate = selectedDate
            self.scheduleTime = selectedTime
            self.isSchedule = true
            
            self.createRequest()
            self.scheduleNowView?.superview?.removeFromSuperview() // remove dimview
            self.scheduleNowView?.dismissView(onCompletion: {
                self.scheduleNowView = nil
            })
            
        }
    
    }
    private func showDimView(view: UIView) {
           let dimView = UIView(frame: self.view.frame)
           dimView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
           dimView.addSubview(view)
           
           let gesture = UITapGestureRecognizer(target: self, action: #selector(tapClose))
           
           dimView.addGestureRecognizer(gesture)
           self.view.addSubview(dimView)
       }
    @objc func tapClose() {
        if scheduleNowView != nil {
            scheduleNowView?.superview?.removeFromSuperview()
            scheduleNowView?.dismissView(onCompletion: {
                self.scheduleNowView = nil
            })
        }
        if couponView != nil  {
            couponView?.superview?.removeFromSuperview()
            couponView?.dismissView(onCompletion: {
                self.couponView = nil
            })
        }
    }
     @objc func tapdeliverynow() {
        createRequest()
    }
}


extension CourierPricingViewController : CourierPresenterToCourierViewProtocol {
    
    
    func getEstimateFareResponse(estimateEntity: CourierEstimateEntity) {
        
        self.estimateFareData = estimateEntity
        self.setValuesUpdate()
    }
    
    func sendRequestSuccess(requestEntity: Request) {
        CourierConstant.deliveryType = ""
        ToastManager.show(title: requestEntity.message ?? "", state: .success)
        if isSchedule {
            self.navigationController?.popToViewController(ofClass: HomeViewController.self)

        }else{
            let routeVC = CourierRouter.courierStoryboard.instantiateViewController(withIdentifier: CourierConstant.CourierHomeController) as! CourierHomeController
                   routeVC.fromRequest = true
                routeVC.onRideCreated()
                   navigationController?.pushViewController(routeVC, animated: true)
        }
       
        
    }
}


