//
//  InvoiceView.swift
//  GoJekUser
//
//  Created by Ansar on 04/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class InvoiceView: UIView {
    
    //Static label
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var midView: UIView!
    @IBOutlet weak var invoiceTitle: UILabel!
    @IBOutlet weak var staticSourceDestinationLabel: UILabel!
    @IBOutlet weak var bookingIDLabel: UILabel!
    @IBOutlet weak var distanceTravelLabel: UILabel!
    @IBOutlet weak var timeTakenLabel: UILabel!
    @IBOutlet weak var baseFareLabel: UILabel!
    @IBOutlet weak var staticTollLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var tipsLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var paymentViaLabel: UILabel!
    @IBOutlet weak var cardCashLabel: UILabel!
    @IBOutlet weak var walletLabel: UILabel!
    @IBOutlet weak var paidAmountLabel: UILabel!
    
    //Distance label
    @IBOutlet weak var sourceAddressLabel: UILabel!
    @IBOutlet weak var destinationAddressLabel: UILabel!
    @IBOutlet weak var bookingIDValueLabel: UILabel!
    @IBOutlet weak var distanceTravelValueLabel: UILabel!
    @IBOutlet weak var timeTakenValueLabel: UILabel!
    @IBOutlet weak var baseFareValueLabel: UILabel!
    @IBOutlet weak var tollValueLabel: UILabel!
    @IBOutlet weak var taxValueLabel: UILabel!
    @IBOutlet weak var totalValueLabel: UILabel!
    @IBOutlet weak var walletValueLabel: UILabel!
    @IBOutlet weak var paidAmountValueLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var discountValueLabel: UILabel!
    
    @IBOutlet weak var staticDollarLabel: UILabel!
    @IBOutlet weak var paymentOuterView: UIView!
    @IBOutlet weak var paymentInnerView: UIView!
    @IBOutlet weak var invoiceImageView: UIView!
    @IBOutlet weak var totalView:UIView!
    @IBOutlet weak var walletView: UIView!
    @IBOutlet weak var payableAmountView: UIView!
    @IBOutlet weak var timeTakenView: UIView!
    @IBOutlet weak var tollChargeView: UIView!
    @IBOutlet weak var distanceTarvelledView: UIView!
    
    @IBOutlet weak var discountView: UIView!
    @IBOutlet weak var tipsView: UIView!
    //Button
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var tipAddButton: UIButton!
    @IBOutlet weak var paymentImage: UIImageView!
    
    @IBOutlet weak var distanceFareView: UIView!
    @IBOutlet weak var distanceFareLbl: UILabel!
    @IBOutlet weak var distanceFareValueLbl: UILabel!
    
    @IBOutlet weak var waitingChargeView: UIView!
    @IBOutlet weak var waitingChargeLbl: UILabel!
    @IBOutlet weak var waitingChargeValueLbl: UILabel!
    
    @IBOutlet weak var peakChargeView: UIView!
    @IBOutlet weak var peakChargeLbl: UILabel!
    @IBOutlet weak var peakChargeValueLbl: UILabel!
    
    @IBOutlet weak var totalFareView: UIView!
    @IBOutlet weak var totalFareLabel: UILabel!
    @IBOutlet weak var totalFareValueLabel: UILabel!
    
    var onClickConfirm:((Float,Bool)->Void)? //Bool - isCash or not
    
    var isPaid:Int = 0
    
    var tipView:TipsView?
    
    private var tipsAmount: Float = 0
    
    private var payableAmount: Float = 0
    
    private var currency = ""
    
    
    var paymentType : PaymentType = .NONE {
        didSet {
            confirmButton.setTitle(paymentType == .CASH ? Constant.SDone.localized.uppercased() : Constant.confirm.localized.uppercased(), for: .normal)
            tipsView?.isHidden = (paymentType.rawValue == PaymentType.CASH.rawValue)
            changeButton?.isHidden = !(paymentType.rawValue == PaymentType.CASH.rawValue)
        }
    }
    
    private var total: Float = 0 {
        didSet {
          //  let totalAmt = Double(total+tipsAmount)
           // totalValueLabel.text = currency+totalAmt.roundOff(2)
            paidAmountValueLabel.text = setCurrency(amount: Double(payableAmount+tipsAmount), currency: currency)
            staticDollarLabel.text =  paidAmountValueLabel.text
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialLoads()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async {
            self.staticDollarLabel.setCornerRadius()
            self.invoiceImageView.setCornerRadius()
            self.paymentInnerView.setRoundCircle()
            if CommonFunction.checkisRTL() {
                self.paymentOuterView.setOneSideCorner(corners: .topRight, radius: self.paymentInnerView.frame.width/2)
            }else {
                self.paymentOuterView.setOneSideCorner(corners: .topLeft, radius: self.paymentInnerView.frame.width/2)
            }
        }
    }
}

//MARK: - Methods

extension InvoiceView {
    
    private func initialLoads() {
        confirmButton.addTarget(self, action: #selector(tapConfirm), for: .touchUpInside)
        tipAddButton.addTarget(self, action: #selector(tapAddTip), for: .touchUpInside)
        tipsAmount = 0.0
        setColor()
        setString()
        setCustomFont()
        staticDollarLabel.adjustsFontSizeToFitWidth = true
        setDarkMode()
    }
    
    private func setDarkMode(){
        self.backgroundColor = .backgroundColor
        self.topView.backgroundColor = .boxColor
        self.midView.backgroundColor = .boxColor
        self.paymentOuterView.backgroundColor = .boxColor
    }
    
    func setColor() {
      //  totalView.backgroundColor = UIColor.taxiColor.withAlphaComponent(0.1)
        payableAmountView.backgroundColor = UIColor.taxiColor.withAlphaComponent(0.1)
        tipAddButton.setTitleColor(.taxiColor, for: .normal)
        totalLabel.textColor = .blackColor
        totalFareLabel.textColor = .blackColor
        totalFareValueLabel.textColor = .blackColor
        totalValueLabel.textColor = .blackColor
        confirmButton.backgroundColor = .taxiColor
        changeButton.setTitleColor(.taxiColor, for: .normal)
        tipAddButton.setTitleColor(.taxiColor, for: .normal)
        staticDollarLabel.backgroundColor = .taxiColor
        backgroundColor = .veryLightGray
    }
    
    func setString() {
        invoiceTitle.text = TaxiConstant.invoice.localized
        staticSourceDestinationLabel.text = TaxiConstant.sourceDestination.localized
        bookingIDLabel.text = TaxiConstant.bookingId.localized
        distanceTravelLabel.text = TaxiConstant.distanceTravel.localized
        distanceFareLbl.text = TaxiConstant.distan.localized
        waitingChargeLbl.text = TaxiConstant.waitCharge.localized
        peakChargeLbl.text =  TaxiConstant.peakCharge.localized
        discountLabel.text = TaxiConstant.discount.localized
        timeTakenLabel.text = TaxiConstant.timeTaken.localized
        baseFareLabel.text = TaxiConstant.baseFare.localized
        staticTollLabel.text = TaxiConstant.tollCharge.localized
        taxLabel.text = TaxiConstant.tax.localized
        tipsLabel.text = Constant.tips.localized
        totalFareLabel.text =  TaxiConstant.totalfare.localized
        totalLabel.text = TaxiConstant.subtotal.localized
        paymentViaLabel.text = TaxiConstant.paymentVia.localized
        walletLabel.text = TaxiConstant.walletDeduction.localized
        paidAmountLabel.text = TaxiConstant.payable.localized
        tipAddButton.setTitle(Constant.add.localized.uppercased(), for: .normal)
        changeButton.setTitle(Constant.change.localized.uppercased(), for: .normal)
        
        if CommonFunction.checkisRTL() {
            baseFareValueLabel.textAlignment = .left
            bookingIDValueLabel.textAlignment = .left
            distanceTravelValueLabel.textAlignment = .left
            timeTakenValueLabel.textAlignment = .left
            tollValueLabel.textAlignment = .left
            taxValueLabel.textAlignment = .left
            walletValueLabel.textAlignment = .left
            discountValueLabel.textAlignment = .left
            totalValueLabel.textAlignment = .left
            paidAmountValueLabel.textAlignment = .left
//            distanceFareLbl.textAlignment = .left
//            waitingChargeLbl.textAlignment = .left
//            peakChargeLbl.textAlignment = .left
            
        }else
        {
            baseFareValueLabel.textAlignment = .right
            bookingIDValueLabel.textAlignment = .right
            distanceTravelValueLabel.textAlignment = .right
            timeTakenValueLabel.textAlignment = .right
            tollValueLabel.textAlignment = .right
            taxValueLabel.textAlignment = .right
            walletValueLabel.textAlignment = .right
            discountValueLabel.textAlignment = .right
            totalValueLabel.textAlignment = .right
            paidAmountValueLabel.textAlignment = .right
//            distanceFareLbl.textAlignment = .right
//            waitingChargeLbl.textAlignment = .right
//            peakChargeLbl.textAlignment = .right
        }
    }
    
    private func setCustomFont() {
        invoiceTitle.font = .setCustomFont(name: .medium, size: .x16)
        sourceAddressLabel.font = .setCustomFont(name: .light, size: .x14)
        destinationAddressLabel.font = .setCustomFont(name: .light, size: .x14)
        staticSourceDestinationLabel.font = .setCustomFont(name: .bold, size: .x16)
        
        bookingIDLabel.font = .setCustomFont(name: .light, size: .x14)
        bookingIDValueLabel.font = .setCustomFont(name: .light, size: .x14)
        staticTollLabel.font = .setCustomFont(name: .light, size: .x14)
        tollValueLabel.font = .setCustomFont(name: .light, size: .x14)
        timeTakenLabel.font = .setCustomFont(name: .light, size: .x14)
        timeTakenValueLabel.font = .setCustomFont(name: .light, size: .x14)
        baseFareLabel.font = .setCustomFont(name: .light, size: .x14)
        baseFareValueLabel.font = .setCustomFont(name: .light, size: .x14)
        distanceTravelLabel.font = .setCustomFont(name: .light, size: .x14)
        distanceTravelValueLabel.font = .setCustomFont(name: .light, size: .x14)
        taxLabel.font = .setCustomFont(name: .light, size: .x14)
        taxValueLabel.font = .setCustomFont(name: .light, size: .x14)
        tipsLabel.font = .setCustomFont(name: .light, size: .x14)
        tipAddButton.titleLabel?.font = .setCustomFont(name: .light, size: .x14)
        paymentViaLabel.font = .setCustomFont(name: .medium, size: .x14)
        cardCashLabel.font = .setCustomFont(name: .medium, size: .x14)
        walletLabel.font = .setCustomFont(name: .light, size: .x14)
        walletValueLabel.font = .setCustomFont(name: .light, size: .x14)
        discountLabel.font = .setCustomFont(name: .light, size: .x14)
        discountValueLabel.font = .setCustomFont(name: .light, size: .x14)
        distanceFareLbl.font = .setCustomFont(name: .light, size: .x14)
        waitingChargeLbl.font = .setCustomFont(name: .light, size: .x14)
        peakChargeLbl.font = .setCustomFont(name: .light, size: .x14)
        distanceFareValueLbl.font = .setCustomFont(name: .light, size: .x14)
        waitingChargeValueLbl.font = .setCustomFont(name: .light, size: .x14)
        peakChargeValueLbl.font = .setCustomFont(name: .light, size: .x14)
        staticDollarLabel.font = .setCustomFont(name: .medium, size: .x10)
        totalFareLabel.font = .setCustomFont(name: .bold, size: .x14)
        totalFareValueLabel.font = .setCustomFont(name: .bold, size: .x14)
        paidAmountLabel.font = .setCustomFont(name: .bold, size: .x16)
        paidAmountValueLabel.font = .setCustomFont(name: .bold, size: .x16)
        totalLabel.font = .setCustomFont(name: .bold, size: .x14)
        totalValueLabel.font = .setCustomFont(name: .bold, size: .x14)
        confirmButton.titleLabel?.font = .setCustomFont(name: .bold, size: .x18)
        changeButton.titleLabel?.font = .setCustomFont(name: .bold, size: .x12)
    }
    
    @objc func tapConfirm() {
        if paymentType == .CASH {
            if isPaid == 1 {
                onClickConfirm?(tipsAmount,paymentType == .CASH)
            }else{
                ToastManager.show(title: Constant.pleaseConfirmPayment.localized, state: .error)
            }
        }
        else{
            onClickConfirm?(tipsAmount,paymentType == .CASH)
        }
    }
    
    @objc func tapAddTip() {
        showTipsView()
    }
    
    func showTipsView() {
        if self.tipView == nil, let tipView = Bundle.main.loadNibNamed(Constant.TipsView, owner: self, options: [:])?.first as? TipsView {
            
            tipView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.frame.width, height: self.frame.height))
            self.tipView = tipView
            self.tipView?.buttonColor = .taxiColor
            self.addSubview(tipView)
            tipView.show(with: .bottom, completion: nil)
        }
        self.tipView?.onClickAdd = { [weak self] (tipValue) in
            guard let self = self else {
                return
            }
            self.tipView?.dismissView(onCompletion: {
                self.tipView = nil
            })
            if tipValue.count == 0 {
                self.tipAddButton.setTitle(Constant.add.localized.uppercased(), for: .normal)
                self.tipsAmount = 0
                self.total = self.payableAmount
            }else{
                self.tipAddButton.setTitle(Double(tipValue)?.setCurrency(), for: .normal)
                self.tipsAmount = Float(tipValue) ?? 0.0
                self.total = self.payableAmount
            }
        }
    }
    
    
    func setValues(values: RequestData) {
        
       
        peakChargeView.isHidden = true
        distanceFareView.isHidden = true
        timeTakenView.isHidden = true
        
        
        distanceFareLbl.text = values.payment?.distance_fare_text
        timeTakenLabel.text = values.payment?.time_fare_text
        
        if values.calculator == invoiceCalculator.min.rawValue {
            if  let timeFare = values.payment?.minute, timeFare>0{
            timeTakenValueLabel.text = setCurrency(amount: values.payment?.minute ?? 0, currency: currency)
            timeTakenView.isHidden = false
            }
        }else if values.calculator == invoiceCalculator.hour.rawValue {
             if  let timeFare = values.payment?.hour, timeFare>0{
            timeTakenValueLabel.text = setCurrency(amount: values.payment?.hour ?? 0, currency: currency)
            timeTakenView.isHidden = false
            }
        }  else if values.calculator == invoiceCalculator.distancemin.rawValue {
            
            if  let timeFare = values.payment?.minute, timeFare>0{
                timeTakenView.isHidden = false
                timeTakenValueLabel.text = setCurrency(amount: values.payment?.minute ?? 0, currency: currency)
            }
                    if  let distanceFare = values.payment?.distance, distanceFare>0{
                  distanceFareView.isHidden = false
                  distanceFareValueLbl.text = setCurrency(amount: values.distance ?? 0, currency: currency)
            }
                 
        }        // distance with hour base
        else if values.calculator == invoiceCalculator.distancehour.rawValue {
             if  let timeFare = values.payment?.hour, timeFare>0{
                      timeTakenView.isHidden = false
                      timeTakenValueLabel.text = setCurrency(amount: values.payment?.hour ?? 0, currency: currency)
                  }
                          if  let distanceFare = values.payment?.distance, distanceFare>0{
                        distanceFareView.isHidden = false
                        distanceFareValueLbl.text = setCurrency(amount: values.distance ?? 0, currency: currency)
                  }

        }
        if let waitingFare = values.payment?.waiting_amount, waitingFare>0 {
             waitingChargeValueLbl.text = setCurrency(amount: values.payment?.waiting_amount ?? 0, currency: currency)
            waitingChargeView.isHidden = false
        }else{
           
                   waitingChargeView.isHidden = true
        }
        if let peakFare = values.payment?.peak_amount, peakFare>0 {
               peakChargeValueLbl.text = setCurrency(amount: values.payment?.peak_amount ?? 0, currency: currency)
               peakChargeView.isHidden = false
        }else{
             peakChargeView.isHidden = true
        }
        
        if let totalFare = values.payment?.total_fare, totalFare>0 {
                                totalFareValueLabel.text = setCurrency(amount: values.payment?.total_fare ?? 0, currency: currency)
                               totalFareView.isHidden = false
               }else{
                   totalFareView.isHidden = true
               }
               if let subFare = values.payment?.sub_total, subFare>0 {
                      totalValueLabel.text = setCurrency(amount: values.payment?.sub_total ?? 0, currency: currency)
                      totalView.isHidden = false
               }else{
                    totalView.isHidden = true
                   
               }
        
        
        
        isPaid = values.paid ?? 0
        currency = values.currency ?? ""
        paymentType = PaymentType(rawValue: values.payment_mode ?? "") ?? .CASH
     //   changeButton.isHidden = isPaid == 1
        bookingIDValueLabel.text = values.booking_id ?? ""
        distanceTravelValueLabel.text = "\(values.total_distance ?? 0.0) \(values.unit ?? "")"
        sourceAddressLabel.text = values.s_address
        destinationAddressLabel.text = values.d_address
        baseFareLabel.text = values.payment?.base_fare_text
        timeTakenLabel.text = values.payment?.time_fare_text
        baseFareValueLabel.text = setCurrency(amount: values.payment?.fixed ?? 0, currency: currency)
        tollValueLabel.text = setCurrency(amount:  values.payment?.toll_charge ?? 0, currency: currency)
        tollChargeView.isHidden = values.payment?.toll_charge ?? 0 == 0
        totalValueLabel.text = setCurrency(amount: values.payment?.total ?? 0, currency: currency)
        staticDollarLabel.text = setCurrency(amount: values.payment?.payable ?? 0, currency: currency)
        taxValueLabel.text = setCurrency(amount:  values.payment?.tax ?? 0, currency: currency)

        payableAmount = Float(values.payment?.payable ?? 0)
        total = Float(values.payment?.total ?? 0.0)
        cardCashLabel.text = values.payment_mode ?? ""
        walletValueLabel.text = "- " + setCurrency(amount:  values.payment?.wallet ?? 0, currency: currency)
        walletView.isHidden = values.payment?.wallet == 0
        if let paymentImage = PaymentType(rawValue: values.payment_mode ?? "")?.image {
            self.paymentImage.image = paymentImage
        }
        discountValueLabel.text = "-" + setCurrency(amount: values.payment?.discount ?? 0, currency: currency)
        discountView.isHidden = values.payment?.discount == 0

        distanceTarvelledView.isHidden = false
        
        if values.payment?.payable == 0.0 {
            changeButton.isHidden = true
        }

        if isPaid == 1 {
            confirmButton.setTitle(Constant.SDone.localized.uppercased(), for: .normal)
        }
    }
    
    func set(with values: RequestData) {
        
        let requestData = values
        currency = requestData.currency ?? ""
        paymentType = PaymentType(rawValue: requestData.payment_mode ?? "") ?? .CASH
        isPaid = requestData.paid ?? 0
        paymentOuterView.isHidden = isPaid == 1
        
        bookingIDValueLabel.text = requestData.booking_id ?? ""
        distanceTravelValueLabel.text = "\(requestData.distance ?? 0) \(requestData.unit ?? "")"
        timeTakenValueLabel.text = setCurrency(amount: Double(requestData.payment?.waiting_amount ?? 0.0), currency: currency)
        baseFareLabel.text = requestData.payment?.base_fare_text
        baseFareValueLabel.text = setCurrency(amount: requestData.payment?.fixed ?? 0, currency: currency)
        tollValueLabel.text = setCurrency(amount:  requestData.payment?.toll_charge ?? 0, currency: currency)
        taxValueLabel.text = setCurrency(amount:  requestData.payment?.tax ?? 0, currency: currency)
        totalValueLabel.text = setCurrency(amount:  requestData.payment?.total ?? 0, currency: currency)
        
        staticDollarLabel.text = setCurrency(amount:  requestData.payment?.payable ?? 0, currency: currency)
        payableAmount = Float(requestData.payment?.payable ?? 0.00)
        total = Float(requestData.payment?.total ?? 0.0)
        cardCashLabel.text = requestData.payment_mode ?? ""
        
        walletValueLabel.text = "- " + setCurrency(amount:  requestData.payment?.wallet ?? 0, currency: currency)
        walletView.isHidden = requestData.payment?.wallet == 0
        // paidAmountValueLabel.text = requestData?.first?.payment?.payable?.setCurrency()
        if let paymentImage = PaymentType(rawValue: requestData.payment_mode ?? "")?.image {
            self.paymentImage.image = paymentImage
        }
        
        // coupon
        if requestData.payment?.discount == 0 || requestData.payment?.discount == nil {
            discountView.isHidden = true
        }else {
            discountView.isHidden = false
            discountValueLabel.text = "-" + setCurrency(amount:  requestData.payment?.discount ?? 0, currency: currency)
        }
        
        if requestData.payment?.payable == 0 {
            paymentOuterView.isHidden = true
        }
        else {
            paymentOuterView.isHidden = false
        }
        
        if paymentType == .CASH {
            tipsView?.isHidden = true
        }
        else {
            tipsView?.isHidden = false
        }
        
        sourceAddressLabel.text = requestData.s_address
        destinationAddressLabel.text = requestData.d_address
        
        distanceTarvelledView.isHidden = false
    }
    
    func setCurrency(amount:Double,currency:String) -> String  {
        return currency+amount.roundOff(2)
    }
}
