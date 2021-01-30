//
//  PriceEstimationController.swift
//  GoJekUser
//
//  Created by Ansar on 01/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

protocol RideNowDelegate: class {
    func onRideCreated()
}

class PriceEstimationController: UIViewController {
    
    @IBOutlet weak var stackViewHeight: NSLayoutConstraint!
    //Static Label
    @IBOutlet weak var staticPeakHourLabel: UILabel!
    @IBOutlet weak var staticCouponAmountLabel: UILabel!
    @IBOutlet weak var topOutterView: UIView!
    @IBOutlet weak var midOutterView: UIView!
    @IBOutlet weak var staticTaxFareLabel: UILabel!
    @IBOutlet weak var staticBaseFareLabel: UILabel!
    @IBOutlet weak var staticDistanceLabel: UILabel!
    @IBOutlet weak var staticEstimateFareLabel: UILabel!
    @IBOutlet weak var staticEtaLabel: UILabel!
    @IBOutlet weak var staticModelLabel: UILabel!
    @IBOutlet weak var staticWheelChairLabel: UILabel!
    @IBOutlet weak var staticChildSeatLabel: UILabel!
    @IBOutlet weak var staticCouponLabel: UILabel!
    @IBOutlet weak var staticSurgeLabel: UILabel!
    
    //dynamic
    @IBOutlet weak var peakHourLabel: UILabel!
    @IBOutlet weak var couponAmountLabel: UILabel!
    @IBOutlet weak var taxFareLabel: UILabel!
    @IBOutlet weak var baseFareLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var estimateFareLabel: UILabel!
    @IBOutlet weak var etaLabel: UILabel!
    @IBOutlet weak var serviceModelLabel: UILabel!
    @IBOutlet weak var surgeValueLabel: UILabel!
    
    @IBOutlet weak var scheduleTimeLabel: UILabel!
    @IBOutlet weak var useWalletAmount: UILabel!
    @IBOutlet weak var peakPercentageLabel: UILabel!
    
    //Button
    @IBOutlet weak var scheduleButton: UIButton!
    @IBOutlet weak var rideNowButton: UIButton!
    @IBOutlet weak var viewCouponButton: UIButton!
    @IBOutlet weak var wheelChairYesButton: UIButton!
    @IBOutlet weak var wheelChairNoButton: UIButton!
    @IBOutlet weak var childSeatYesButton: UIButton!
    @IBOutlet weak var childSeatNoButton: UIButton!
    @IBOutlet weak var bookForSomeoneButton: UIButton!
    @IBOutlet weak var useWalletButton: UIButton!
    @IBOutlet weak var editBookSomeoneButton: UIButton!
    
    @IBOutlet weak var walletOutterView: UIView!
    @IBOutlet weak var surgeOuterView: UIView!
    @IBOutlet weak var surgeInnerView: UIView!
    @IBOutlet weak var scheduleShowView: UIView!
    @IBOutlet weak var scheduleDeleteView: UIView!
    @IBOutlet weak var scheduleEditView: UIView!
    
    @IBOutlet weak var peakHourStackView: UIStackView!
    @IBOutlet weak var couponStackView: UIStackView!
    @IBOutlet weak var couponViews: UIView!
    @IBOutlet weak var walletBalanceView: UIView!
    @IBOutlet weak var chairCapacityView: UIView!
    @IBOutlet weak var chairCapacityStackView: UIStackView!
    
    var bookSomeOnePhoneNumber:String = ""
    var bookSomeOneName:String = ""
    var bookSomeOneEmail: String = ""
    
    var isSchedule:Bool = false
    
    var estimateFareData: EstimateFareEntity?
    var requestEntity: TaxiReuqestEntity?
    var counponEntity: PromocodeData?
    var chairCapacity : Int = 0
    var stackHeight = 400
    
    weak var rideNowDelegate: RideNowDelegate?
    
    //Clouser For OnclickRide
    var onClickRideNow:((TaxiReuqestEntity)->Void)?
    
    var isWheelChairEnable = false {
        didSet {
            wheelChairYesButton.setImage(UIImage(named: isWheelChairEnable ? Constant.circleFullImage : Constant.circleImage), for: .normal)
            wheelChairYesButton.setTitleColor(isWheelChairEnable ? .blackColor : .lightGray, for: .normal)
            wheelChairYesButton.tintColor = isWheelChairEnable ? .blackColor : .lightGray
            
            wheelChairNoButton.setTitleColor(isWheelChairEnable ? .lightGray : .blackColor, for: .normal)
            wheelChairNoButton.tintColor = isWheelChairEnable ? .lightGray : .blackColor
            wheelChairNoButton.setImage(UIImage(named: isWheelChairEnable ? Constant.circleImage : Constant.circleFullImage), for: .normal)
        }
    }
    
    var isChildSeatEnable = false {
        didSet {
            childSeatYesButton.setImage(UIImage(named: isChildSeatEnable ? Constant.circleFullImage : Constant.circleImage), for: .normal)
            childSeatYesButton.setTitleColor(isChildSeatEnable ? .blackColor : .lightGray, for: .normal)
            childSeatYesButton.tintColor = isChildSeatEnable ? .blackColor : .lightGray
            
            childSeatNoButton.setImage(UIImage(named: isChildSeatEnable ? Constant.circleImage : Constant.circleFullImage), for: .normal)
            childSeatNoButton.setTitleColor(isChildSeatEnable ? .lightGray : .blackColor, for: .normal)
            childSeatNoButton.tintColor = isChildSeatEnable ? .lightGray : .blackColor
        }
    }
    
    var isBookSomeEnable = false {
        didSet {
            bookForSomeoneButton.setImage(UIImage(named: isBookSomeEnable ? Constant.squareFill : Constant.sqaureEmpty), for: .normal)
            if isBookSomeEnable {
                showBookSomeOneView(isFromEdit: false)
            }else{
                editBookSomeoneButton.isHidden = true
            }
        }
    }
    
    var isWalletEnable = false {
        didSet {
            useWalletButton.setImage(UIImage(named: isWalletEnable ? Constant.squareFill : Constant.sqaureEmpty), for: .normal)
        }
    }
    
    var bookSomeOneView: BookSomeOneView?
    var couponView: CouponView?
    var scheduleNowView: ScheduleView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialLoads()
    }
    override func viewDidAppear(_ animated: Bool) {
        hideTabBar()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar()
        
        navigationController?.isNavigationBarHidden = false
        if let imageView = scheduleEditView.subviews.first as? UIImageView{
            imageView.image =  UIImage(named: Constant.editImage)
            imageView.imageTintColor(color1: .lightGray)
        }
        if let imageView = scheduleDeleteView.subviews.first as? UIImageView{
            imageView.image =  UIImage(named: Constant.deleteImage)
            imageView.imageTintColor(color1: .lightGray)
        }
        getEstimateFareAPI()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        scheduleNowView = nil
        couponView = nil
        bookSomeOneView = nil
    }
    
}

//MARK: - Methods

extension PriceEstimationController {
    
    private func initialLoads() {
        setFont()
        setNavigationBar()
        peakPercentageLabel.adjustsFontSizeToFitWidth = true
        wheelChairYesButton.addTarget(self, action: #selector(tapWheelChair(_:)), for: .touchUpInside)
        wheelChairNoButton.addTarget(self, action: #selector(tapWheelChair(_:)), for: .touchUpInside)
        childSeatYesButton.addTarget(self, action: #selector(tapChildSeat(_:)), for: .touchUpInside)
        childSeatNoButton.addTarget(self, action: #selector(tapChildSeat(_:)), for: .touchUpInside)
        bookForSomeoneButton.addTarget(self, action: #selector(tapBookSomeOne(_:)), for: .touchUpInside)
        editBookSomeoneButton.addTarget(self, action: #selector(tapBookSomeOne(_:)), for: .touchUpInside)
        rideNowButton.addTarget(self, action: #selector(tapRideNow(_:)), for: .touchUpInside)
        useWalletButton.addTarget(self, action: #selector(tapWallet(_:)), for: .touchUpInside)
        viewCouponButton.addTarget(self, action: #selector(tapViewCoupon(_:)), for: .touchUpInside)
        scheduleButton.addTarget(self, action: #selector(tapScheduleNow(_:)), for: .touchUpInside)
        scheduleShowView.isHidden = true
        let editGesture = UITapGestureRecognizer(target: self, action: #selector(tapScheduleEditDelete(_:)))
        let deleteGesture = UITapGestureRecognizer(target: self, action: #selector(tapScheduleEditDelete(_:)))
        scheduleEditView.addGestureRecognizer(editGesture)
        scheduleDeleteView.addGestureRecognizer(deleteGesture)
        scheduleEditView.backgroundColor = .veryLightGray
        scheduleDeleteView.backgroundColor = .veryLightGray
        surgeOuterView.isHidden = true
        chairCapacityView.isHidden = true
        setButtons()
        setString()
        let walletBalance = AppManager.shared.getUserDetails()?.wallet_balance
        
        if walletBalance == nil || walletBalance == 0.0 {
            walletBalanceView.isHidden = true
        }
        else {
            walletBalanceView.isHidden = false
            useWalletAmount.text = walletBalance?.setCurrency()
        }
       setDarkMode()
    }
    
    private func setDarkMode(){
        self.view.backgroundColor = .backgroundColor
        surgeOuterView.backgroundColor = .boxColor
        surgeInnerView.backgroundColor = .boxColor
        scheduleShowView.backgroundColor = .boxColor
       scheduleDeleteView.backgroundColor = .boxColor
        scheduleEditView.backgroundColor = .boxColor
        peakHourStackView.backgroundColor = .boxColor
        couponStackView.backgroundColor = .boxColor
         couponViews.backgroundColor = .boxColor
         walletBalanceView.backgroundColor = .boxColor
         chairCapacityView.backgroundColor = .boxColor
        chairCapacityStackView.backgroundColor = .boxColor
        midOutterView.backgroundColor = .boxColor
        topOutterView.backgroundColor = .boxColor
        walletOutterView.backgroundColor = .boxColor
        useWalletAmount.textColor =  .blackColor
        bookForSomeoneButton.setTitleColor(.blackColor, for: .normal)
        useWalletButton.textColor(color: .blackColor)
        
    }
    
    private func getEstimateFareAPI() {
        let param = Parameters.setEstimateFareParameter(requestEntity: requestEntity!)
        taxiPresenter?.getEstimateFare(param: param)
    }
    
    private func setNavigationBar() {
        self.setNavigationTitle()
        self.setLeftBarButtonWith(color: .blackColor)
        title = TaxiConstant.priceEstimation.localized
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    private func setString() {
        self.staticEstimateFareLabel.text = TaxiConstant.total.localized
        self.staticEtaLabel.text = TaxiConstant.eta.uppercased()
        self.staticDistanceLabel.text = TaxiConstant.estimateDistance.localized
        self.staticBaseFareLabel.text = TaxiConstant.baseFare.localized
        self.staticTaxFareLabel.text = TaxiConstant.taxFare.localized
        self.staticCouponAmountLabel.text = TaxiConstant.couponAmount.localized
        self.staticPeakHourLabel.text = TaxiConstant.peakHour.localized

        
        
        
        self.staticModelLabel.text = TaxiConstant.model.localized
        self.staticWheelChairLabel.text = TaxiConstant.wheelChair.localized
        self.staticChildSeatLabel.text = TaxiConstant.childSeat.localized
        
        self.staticCouponLabel.text = TaxiConstant.applyCoupon.localized
        self.viewCouponButton.setTitle(Constant.viewCoupon.localized.uppercased(), for: .normal)
        self.surgeValueLabel.text = TaxiConstant.surgeMessage.localized
        self.scheduleButton.setTitle(TaxiConstant.scheduleNow.localized.uppercased(), for: .normal)
        self.rideNowButton.setTitle(TaxiConstant.rideNow.localized.uppercased(), for: .normal)
        self.bookForSomeoneButton.setTitle(TaxiConstant.bookSomeone.localized, for: .normal)
        self.useWalletButton.setTitle(TaxiConstant.useWallet.localized, for: .normal)
        
        self.setButtonImageSet(button: self.childSeatNoButton)
        self.setButtonImageSet(button: self.childSeatYesButton)
        if CommonFunction.checkisRTL() {
            self.useWalletButton.contentHorizontalAlignment = .right
            self.useWalletButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: -5, bottom: 0, right: 0)
            self.bookForSomeoneButton.contentHorizontalAlignment = .right
            estimateFareLabel.textAlignment = .left
            distanceLabel.textAlignment = .left
            etaLabel.textAlignment = .left
            serviceModelLabel.textAlignment = .left
            surgeValueLabel.textAlignment = .left
            
        }else {
            self.useWalletButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 0)
            self.useWalletButton.contentHorizontalAlignment = .left
            self.bookForSomeoneButton.contentHorizontalAlignment = .left
            estimateFareLabel.textAlignment = .right
            distanceLabel.textAlignment = .right
            etaLabel.textAlignment = .right
            serviceModelLabel.textAlignment = .right
            surgeValueLabel.textAlignment = .right
        }
        self.setButtonImageSet(button: self.wheelChairNoButton)
        self.setButtonImageSet(button: self.wheelChairYesButton)
        
        self.useWalletButton.imageEdgeInsets = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        self.useWalletButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.useWalletButton.imageView?.contentMode = .scaleAspectFit
        
        self.bookForSomeoneButton.imageEdgeInsets = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        self.bookForSomeoneButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.bookForSomeoneButton.imageView?.contentMode = .scaleAspectFit
        
        wheelChairYesButton.setTitle(Constant.SYes.localized, for: .normal)
        wheelChairNoButton.setTitle(Constant.SNo.localized, for: .normal)
        childSeatYesButton.setTitle(Constant.SYes.localized, for: .normal)
        childSeatNoButton.setTitle(Constant.SNo.localized, for: .normal)
        editBookSomeoneButton.setTitle(TaxiConstant.edit.localized, for: .normal)
    }
    
    private func setButtons() {
        viewCouponButton.setTitleColor(.taxiColor, for: .normal)
        editBookSomeoneButton.backgroundColor = UIColor.taxiColor.withAlphaComponent(0.5)
        editBookSomeoneButton.textColor(color: .taxiColor)
        editBookSomeoneButton.borderColor = .taxiColor
        editBookSomeoneButton.borderLineWidth = 1.0
        editBookSomeoneButton.isHidden = true
        
        isWheelChairEnable = false //initially its false
        isChildSeatEnable = false
        isBookSomeEnable = false
        isWalletEnable = false
        
        scheduleButton.backgroundColor = .taxiColor
        rideNowButton.backgroundColor = .taxiColor
        
        DispatchQueue.main.async {
            self.surgeInnerView.setCornerRadius()
            self.surgeInnerView.borderColor = .white
            self.surgeInnerView.borderLineWidth = 6.0
            self.surgeInnerView.backgroundColor = .taxiColor
            self.surgeOuterView.addDashLine(strokeColor: .taxiColor, lineWidth: 2.0)
        }
    }
    
    private func setButtonImageSet(button: UIButton) { //Set Button image size
        button.imageEdgeInsets = UIEdgeInsets(top: 6, left: 0, bottom: 6, right: 0)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        button.imageView?.contentMode = .scaleAspectFit
    }
    
    private func setResizeRadioButton(button: UIButton) {
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 6, bottom: 4, right: 6)
        button.imageView?.contentMode = .scaleAspectFit
    }
    
    func setFont() {
        staticEstimateFareLabel.font = .setCustomFont(name: .bold, size: .x20)
        staticDistanceLabel.font = .setCustomFont(name: .medium, size: .x14)
        staticBaseFareLabel.font = .setCustomFont(name: .medium, size: .x14)
        staticTaxFareLabel.font = .setCustomFont(name: .medium, size: .x14)
        staticCouponAmountLabel.font = .setCustomFont(name: .medium, size: .x14)
        staticPeakHourLabel.font = .setCustomFont(name: .medium, size: .x14)

        peakHourLabel.font = .setCustomFont(name: .medium, size: .x14)
        couponAmountLabel.font = .setCustomFont(name: .medium, size: .x14)
        taxFareLabel.font = .setCustomFont(name: .medium, size: .x14)
        baseFareLabel.font = .setCustomFont(name: .medium, size: .x14)

        
        distanceLabel.font = .setCustomFont(name: .medium, size: .x14)
        staticEtaLabel.font = .setCustomFont(name: .medium, size: .x14)
        staticModelLabel.font = .setCustomFont(name: .medium, size: .x14)
        useWalletAmount.font = .setCustomFont(name: .medium, size: .x14)
        staticWheelChairLabel.font = .setCustomFont(name: .medium, size: .x14)
        staticChildSeatLabel.font = .setCustomFont(name: .medium, size: .x14)
        staticCouponLabel.font = .setCustomFont(name: .medium, size: .x14)
        useWalletButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x14)
        viewCouponButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x14)
        scheduleButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x18)
        rideNowButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x18)
        bookForSomeoneButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x14)
        scheduleTimeLabel.font = .setCustomFont(name: .medium, size: .x14)
        surgeValueLabel.font = .setCustomFont(name: .medium, size: .x14)
        staticSurgeLabel.font = .setCustomFont(name: .medium, size: .x14)
        estimateFareLabel.font = .setCustomFont(name: .bold, size: .x20)
        etaLabel.font = .setCustomFont(name: .medium, size: .x14)
        serviceModelLabel.font = .setCustomFont(name: .medium, size: .x14)
        childSeatYesButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x14)
        childSeatNoButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x14)
        wheelChairNoButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x14)
        wheelChairYesButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x14)
    }
    
    func showBookSomeOneView(isFromEdit:Bool){
        if self.bookSomeOneView == nil, let bookSomeOneView = Bundle.main.loadNibNamed(TaxiConstant.BookSomeOneView, owner: self, options: [:])?.first as? BookSomeOneView {
            view.addSubview(bookSomeOneView)
            bookSomeOneView.nameTextField.text = bookSomeOneName
            bookSomeOneView.phoneNumberTextField.text = bookSomeOnePhoneNumber
            bookSomeOneView.emailTextField.text = bookSomeOneEmail
            bookSomeOneView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: view.frame.width, height: view.frame.height))
            self.bookSomeOneView = bookSomeOneView
            
            bookSomeOneView.show(with: .bottom, completion: nil)
        }
        bookSomeOneView?.onClickSubmit = { [weak self] (nameStr,phoneNumber,email) in
            guard let self = self else {
                return
            }
            self.bookSomeOneName = nameStr
            self.bookSomeOnePhoneNumber = phoneNumber
            self.bookSomeOneEmail = email
            
            if self.bookSomeOneName == "" && self.bookSomeOnePhoneNumber == "" {
                self.editBookSomeoneButton.isHidden = true
                self.isBookSomeEnable = false
            }else {
                self.editBookSomeoneButton.isHidden = false
                self.isBookSomeEnable = true
            }
            self.bookSomeOneView?.removeFromSuperview()
            self.bookSomeOneView = nil
        }
        bookSomeOneView?.onClickClose = { [weak self] in
            guard let self = self else {
                return
            }
            self.bookSomeOneView?.dismissView(onCompletion: {
                self.bookSomeOneView?.removeFromSuperview()
                self.bookSomeOneView = nil
                if self.bookSomeOneName == "" && self.bookSomeOnePhoneNumber == "" {
                    self.isBookSomeEnable = false
                }else {
                    // isBookSomeEnable = true
                }
            })
        }
        view.layoutIfNeeded()
    }
    
    @objc func tapWheelChair(_ sender: UIButton) {
        isWheelChairEnable = sender.tag == 1 ? true : false
    }
    
    @objc func tapChildSeat(_ sender: UIButton) {
        isChildSeatEnable = sender.tag == 1 ? true : false
    }
    
    @objc func tapBookSomeOne(_ sender: UIButton) {
        if sender.tag == 1 {
            showBookSomeOneView(isFromEdit: true)
        }else{
            isBookSomeEnable = !isBookSomeEnable
        }
    }
    
    @objc func tapScheduleEditDelete(_ sender: UITapGestureRecognizer) {
        if sender.view?.tag == 1 { //edit Schedule
            tapScheduleNow(scheduleButton)
        }
        else { //delete schedule
            AppAlert.shared.simpleAlert(view: self, title: "", message: Constant.deleteScheduleReq.localized, buttonOneTitle: Constant.SYes.localized, buttonTwoTitle: Constant.SNo.localized)
            AppAlert.shared.onTapAction = { [weak self] tag in
                guard let self = self else {
                    return
                }
                if tag == 0 {
                    self.scheduleShowView.isHidden = true
                    self.scheduleButton.isHidden = false
                    self.rideNowButton.setTitle(TaxiConstant.rideNow.localized.uppercased(), for: .normal)
                }
            }
        }
    }
    
    @objc func tapWallet(_ sender: UIButton) {
        isWalletEnable = !isWalletEnable
    }
    
    //Ride Now
    @objc func tapRideNow(_ sender: UIButton) {
        if guestLogin() {
            
            requestEntity?.wheel_chair = isWheelChairEnable ? 1 : 0
            requestEntity?.child_seat = isChildSeatEnable ? 1 : 0
            requestEntity?.use_wallet = isWalletEnable ? 1 : 0
            requestEntity?.distance = estimateFareData?.responseData?.fare?.distance ?? 0.0
            requestEntity?.someone = bookSomeOneName.count > 0 ? 1 : 0
            
            requestEntity?.someone_email = bookSomeOneEmail
            requestEntity?.someone_mobile = bookSomeOnePhoneNumber
            requestEntity?.someone_name = bookSomeOneName
            requestEntity?.isSchedule = isSchedule
            
            let param = Parameters.setTaxiRequestParameter(requestEntity: requestEntity!)
            taxiPresenter?.sendRequest(param: param)
        }
        
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
                self.requestEntity?.promocode_id = 0
                self.requestEntity?.percentage = 0
                self.requestEntity?.max_amount = 0
                self.getEstimateFareAPI()
//                self.estimateFareLabel.text = self.estimateFareData?.responseData?.fare?.estimated_fare?.setCurrency()
            }else{
                self.viewCouponButton.setTitle(selectedCoupon?.promo_code, for: .normal)
//                var discount = Int(self.estimateFareData?.responseData?.fare?.estimated_fare ?? 0.00) / (selectedCoupon?.percentage ?? 0)
//                if(discount > (selectedCoupon?.max_amount ?? 0)){
//                    self.estimateFareLabel.text = Double(Int(self.estimateFareData?.responseData?.fare?.estimated_fare ?? 0.00) - (selectedCoupon?.max_amount ?? 0)).setCurrency()
//                }
//                else{
//                    self.estimateFareLabel.text = Double(Int(self.estimateFareData?.responseData?.fare?.estimated_fare ?? 0.00) - discount).setCurrency()
//                }
                self.requestEntity?.promocode_id = selectedCoupon?.id
                self.requestEntity?.percentage = selectedCoupon?.percentage
                self.requestEntity?.max_amount = selectedCoupon?.max_amount
                self.getEstimateFareAPI()
            }
        }
    }
    
    
    @objc func tapScheduleNow(_ sender: UIButton) {
        
        if scheduleNowView == nil, let scheduleView = Bundle.main.loadNibNamed(TaxiConstant.ScheduleView, owner: self, options: [:])?.first as? ScheduleView {
            let viewHeight = (view.frame.height/100)*25
            scheduleView.frame = CGRect(origin: CGPoint(x: 0, y: view.frame.height-viewHeight), size: CGSize(width: view.frame.width, height: viewHeight))
            self.scheduleNowView = scheduleView
            scheduleView.show(with: .bottom, completion: nil)
            showDimView(view: scheduleView)
            
            if requestEntity?.schedule_date != nil && requestEntity?.schedule_time != nil {
                scheduleNowView?.dateLabel.text = requestEntity?.schedule_date
                scheduleNowView?.timeLabel.text = requestEntity?.schedule_time
            }
        }
        scheduleNowView?.onClickScheduleNow = { [weak self] (selectedDate,selectedTime) in
            guard let self = self else {
                return
            }
            if selectedDate == "" && selectedTime == "" {
                AppAlert.shared.simpleAlert(view: self, title: "", message: Constant.dateTimeSelect.localized, buttonTitle: "OK")
                return
            }
            self.isSchedule = true
            self.requestEntity?.schedule_date = selectedDate
            self.requestEntity?.schedule_time = selectedTime
            
            self.scheduleTimeLabel.text =  "\(TaxiConstant.scheduleOn) \(selectedDate) , \(selectedTime)"
            
            self.scheduleNowView?.superview?.removeFromSuperview() // remove dimview
            self.scheduleNowView?.dismissView(onCompletion: {
                self.scheduleNowView = nil
            })
            self.scheduleShowView.isHidden = false
            self.scheduleButton.isHidden = true
            
            self.rideNowButton.setTitle(TaxiConstant.scheduleNow.localized.uppercased(), for: .normal)
            
        }
    }
    
    private func showDimView(view: UIView) {
        let dimView = UIView(frame: self.view.frame)
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        dimView.addSubview(view)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapCloseView))
        
        dimView.addGestureRecognizer(gesture)
        self.view.addSubview(dimView)
    }
    
    @objc func tapCloseView() {
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
}

// set api response
extension PriceEstimationController {
    
    private func setValuesUpdate() {
        chairCapacity = estimateFareData?.responseData?.service?.capacity ?? 0
        setHiddenWheelChairView()
        estimateFareLabel.text = estimateFareData?.responseData?.fare?.estimated_fare?.setCurrency()
        baseFareLabel.text = Double(estimateFareData?.responseData?.fare?.base_price ?? 0).setCurrency()
        taxFareLabel.text = Double(estimateFareData?.responseData?.fare?.tax_price ?? 0).setCurrency()
        var height = 350
        if((estimateFareData?.responseData?.fare?.peak ?? 0) == 0){
            height = height - 50
            peakHourStackView.isHidden = true
        }
        else{
        peakHourStackView.isHidden = false
        peakHourLabel.text = estimateFareData?.responseData?.fare?.peak_percentage ?? ""
        }
        if((estimateFareData?.responseData?.fare?.coupon_amount ?? 0) == 0){
            height = height - 50
            couponStackView.isHidden = true
        }
        else{
            couponStackView.isHidden = false
            couponAmountLabel.text = Double(estimateFareData?.responseData?.fare?.coupon_amount ?? 0).setCurrency()
        }
        stackViewHeight.constant = CGFloat(height)
        self.view.layoutIfNeeded()
        etaLabel.text = estimateFareData?.responseData?.fare?.time ?? ""
        serviceModelLabel.text = estimateFareData?.responseData?.service?.vehicle_name ?? ""
        distanceLabel.text = "\(estimateFareData?.responseData?.fare?.distance ?? 0.00) KM"
        couponViews.isHidden = estimateFareData?.responseData?.promocodes?.count == 0
        
        if estimateFareData?.responseData?.fare?.peak == 1 {
            surgeOuterView.isHidden = false
            peakPercentageLabel.text = estimateFareData?.responseData?.fare?.peak_percentage ?? "0"
        }else {
            surgeOuterView.isHidden = true
        }
    }
    
    private func setHiddenWheelChairView() {
        chairCapacityView.isHidden =  chairCapacity < 4
    }
}
//MARK: - API

extension PriceEstimationController: TaxiPresenterToTaxiViewProtocol {
    
    func getEstimateFareResponse(estimateEntity: EstimateFareEntity) {
        self.estimateFareData = estimateEntity
        self.setValuesUpdate()
    }
    
    func sendRequestSuccess(requestEntity: Request) {
        ToastManager.show(title: requestEntity.message ?? "", state: .success)
        rideNowDelegate?.onRideCreated()
        navigationController?.popViewController(animated: true)
    }
}

