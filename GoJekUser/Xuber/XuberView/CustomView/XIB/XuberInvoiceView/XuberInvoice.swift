//
//  XuberInvoice.swift
//  GoJekUser
//
//  Created by Ansar on 13/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class XuberInvoice: UIView {
    
    @IBOutlet weak var beforeImage: UIImageView!
    @IBOutlet weak var afterImage: UIImageView!
    @IBOutlet weak var cardCashImage: UIImageView!
    
    @IBOutlet weak var imageStackView: UIStackView!
    @IBOutlet weak var totalInvoiceView: UIView!
    @IBOutlet weak var paidView: UIView!
    @IBOutlet weak var hourView: UIView!
    @IBOutlet weak var extraChargeView: UIView!
    
    @IBOutlet weak var walletView: UIView!
    @IBOutlet weak var tipsView: UIView!
    @IBOutlet weak var couponView: UIView!
    
    //Static Label
    @IBOutlet weak var beforeLabel: UILabel!
    @IBOutlet weak var afterLabel: UILabel!
    @IBOutlet weak var staticBaseFareLabel: UILabel!
    @IBOutlet weak var staticBookingIdLabel: UILabel!
    @IBOutlet weak var staticTaxFareLabel: UILabel!
    @IBOutlet weak var staticHourlyFareLabel: UILabel!
    @IBOutlet weak var staticWalletFareLabel: UILabel!
    @IBOutlet weak var staticCouponFareLabel: UILabel!
    @IBOutlet weak var staticTotalFareLabel: UILabel!
    @IBOutlet weak var staticAmountPaidFareLabel: UILabel!
    @IBOutlet weak var staticTipsLabel: UILabel!
    @IBOutlet weak var staticExtraChargeLabel: UILabel!
    @IBOutlet weak var headingLabel: UILabel!
    
    //Dynamic label
    @IBOutlet weak var baseFareLabel: UILabel!
    @IBOutlet weak var bookingIdValueLabel: UILabel!
    @IBOutlet weak var taxFareLabel: UILabel!
    @IBOutlet weak var hourlyFareLabel: UILabel!
    @IBOutlet weak var walletFareLabel: UILabel!
    @IBOutlet weak var totalFareLabel: UILabel!
    @IBOutlet weak var totalPaidFareLabel: UILabel!
    @IBOutlet weak var cardCashLabel: UILabel!
    @IBOutlet weak var couponValueLabel: UILabel!
    @IBOutlet weak var extraChageValueLabel: UILabel!
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var tipButton: UIButton!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    
    
    
    var onClickDone:((Bool)->Void)?
    var onClickInfo:(()->Void)?
    var onClickChange:(()->Void)?
    var tipView:TipsView?
    var extraView:ExtraChargeView?
    
    var extraNotes:String = ""
    
    var isPaid:Int?
    
    var tipsAmount: Double = 0
    
    private var payableAmount: Double = 0
    
    var paymentType : PaymentType = .NONE {
        didSet {
            cardCashImage.image = paymentType.image
            cardCashLabel.text = paymentType.rawValue
            tipsView?.isHidden = (paymentType.rawValue == PaymentType.CASH.rawValue)
            changeButton?.isHidden = !(paymentType.rawValue == PaymentType.CASH.rawValue)
            totalInvoiceView.layoutIfNeeded()
        }
    }
    
    private var total: Double = 0 {
        didSet {
            DispatchQueue.main.async {
                let totalAmt = Double(self.total+self.tipsAmount)
                self.totalFareLabel.text = totalAmt.setCurrency()
                let payableAmt = Double(self.payableAmount+self.tipsAmount)
                self.totalPaidFareLabel.text = payableAmt.setCurrency()
            }
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialLoads()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        beforeImage.setRoundCorner()
        afterImage.setRoundCorner()
        doneButton.setBothCorner()
        paidView.addDashLine(strokeColor: .xuberColor, lineWidth: 1.5)
       
    }
    
}

extension XuberInvoice {
    private func initialLoads() {
        setFont()
        localize()
        infoButton.setImage(UIImage(named: Constant.infoImage), for: .normal)
        staticTipsLabel.textColor = .xuberColor
        doneButton.backgroundColor = .xuberColor
        changeButton.setTitleColor(.xuberColor, for: .normal)
        tipButton.setTitleColor(.xuberColor, for: .normal)
        changeButton.setTitle(Constant.change.localized, for: .normal)
        doneButton.addTarget(self, action: #selector(tapDone), for: .touchUpInside)
        tipButton.addTarget(self, action: #selector(tapTipView), for: .touchUpInside)
        infoButton.addTarget(self, action: #selector(tapInfo), for: .touchUpInside)
        changeButton.addTarget(self, action: #selector(tapChange), for: .touchUpInside)
        beforeImage.isUserInteractionEnabled = true
        let beforeGesture = UITapGestureRecognizer(target: self, action: #selector(tapBeforeImage))
        beforeImage.addGestureRecognizer(beforeGesture)
        let afterGesture = UITapGestureRecognizer(target: self, action: #selector(tapAfterImage))
        afterImage.addGestureRecognizer(afterGesture)
        afterImage.isUserInteractionEnabled = true
        DispatchQueue.main.async {
            self.afterImage.setShadow(color: .lightGray)
            self.beforeImage.setShadow(color: .lightGray)
//            self.totalInvoiceView.addShadow(radius: 5.0, color: .lightGray)
        }
        setDarkMode()
    }
    
    private func setDarkMode(){
        self.backgroundColor = .backgroundColor
        self.stackView.backgroundColor = .boxColor
    }
    
    private func setFont() {
        beforeLabel.font = .setCustomFont(name: .light, size: .x14)
        afterLabel.font = .setCustomFont(name: .light, size: .x14)
        staticBaseFareLabel.font = .setCustomFont(name: .light, size: .x14)
        staticBookingIdLabel.font = .setCustomFont(name: .light, size: .x14)
        staticTaxFareLabel.font = .setCustomFont(name: .light, size: .x14)
        staticHourlyFareLabel.font = .setCustomFont(name: .light, size: .x14)
        staticWalletFareLabel.font = .setCustomFont(name: .light, size: .x14)
        staticCouponFareLabel.font = .setCustomFont(name: .light, size: .x14)
        staticTotalFareLabel.font = .setCustomFont(name: .light, size: .x14)
        staticAmountPaidFareLabel.font = .setCustomFont(name: .light, size: .x16)
        staticTipsLabel.font = .setCustomFont(name: .light, size: .x16)
        headingLabel.font = .setCustomFont(name: .bold, size: .x18)
        
        baseFareLabel.font = .setCustomFont(name: .medium, size: .x14)
        bookingIdValueLabel.font = .setCustomFont(name: .medium, size: .x14)
        taxFareLabel.font = .setCustomFont(name: .medium, size: .x14)
        hourlyFareLabel.font = .setCustomFont(name: .medium, size: .x14)
        walletFareLabel.font = .setCustomFont(name: .medium, size: .x14)
        totalFareLabel.font = .setCustomFont(name: .medium, size: .x14)
        totalPaidFareLabel.font = .setCustomFont(name: .medium, size: .x14)
        cardCashLabel.font = .setCustomFont(name: .medium, size: .x14)
        couponValueLabel.font = .setCustomFont(name: .medium, size: .x14)
        tipButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x14)
        staticExtraChargeLabel.font = .setCustomFont(name: .medium, size: .x14)
        doneButton.titleLabel?.font = .setCustomFont(name: .bold, size: .x18)
        changeButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x14)
    }
    
    private func localize() {
        beforeLabel.text = XuberConstant.before.localized
        afterLabel.text = XuberConstant.after.localized
        staticBaseFareLabel.text = XuberConstant.baseFare.localized
        staticTaxFareLabel.text = XuberConstant.taxFare.localized
        staticHourlyFareLabel.text = XuberConstant.hourlyFare.localized
        staticWalletFareLabel.text = XuberConstant.walletDetection.localized
        staticCouponFareLabel.text = XuberConstant.coupon.localized
        staticTotalFareLabel.text = XuberConstant.total.localized
        staticAmountPaidFareLabel.text = XuberConstant.amounToPaid.localized
        staticTipsLabel.text = XuberConstant.tips.localized
        staticExtraChargeLabel.text = XuberConstant.extraCharges.localized
        staticBookingIdLabel.text = XuberConstant.bookingId.localized
        headingLabel.text = XuberConstant.invoice.localized
        tipButton.setTitle(XuberConstant.add.localized, for: .normal)
        cardCashImage.image = UIImage(named: Constant.cardImage)
        
        if CommonFunction.checkisRTL() {
            
            baseFareLabel.textAlignment = .left
            bookingIdValueLabel.textAlignment = .left
            taxFareLabel.textAlignment = .left
            hourlyFareLabel.textAlignment = .left
            walletFareLabel.textAlignment = .left
            totalFareLabel.textAlignment = .left
            totalPaidFareLabel.textAlignment = .left
            cardCashLabel.textAlignment = .left
            couponValueLabel.textAlignment = .left
            extraChageValueLabel.textAlignment = .left
            
        }else {
            baseFareLabel.textAlignment = .right
            bookingIdValueLabel.textAlignment = .right
            taxFareLabel.textAlignment = .right
            hourlyFareLabel.textAlignment = .right
            walletFareLabel.textAlignment = .right
            totalFareLabel.textAlignment = .right
            totalPaidFareLabel.textAlignment = .right
            cardCashLabel.textAlignment = .left
            couponValueLabel.textAlignment = .right
            extraChageValueLabel.textAlignment = .right
        }
    }
    
    @objc func tapTipView() {
        if tipView == nil, let tipView = Bundle.main.loadNibNamed(Constant.TipsView, owner: self, options: [:])?.first as? TipsView {
            
            tipView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: frame.width, height: frame.height))
            self.tipView = tipView
            self.tipView?.buttonColor = .xuberColor
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
                self.tipButton.setTitle(Constant.add.localized.uppercased(), for: .normal)
                self.tipsAmount = 0
                self.total = self.payableAmount 
            }else{
                self.tipButton.setTitle(Double(tipValue)?.setCurrency(), for: .normal)
                self.tipsAmount = Double(tipValue) ?? 0.0
                self.total = self.payableAmount 
            }
        }
    }
    
    private func showDimView(view: UIView) {
        let dimView = UIView(frame: self.frame)
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        dimView.addSubview(view)
        self.addSubview(dimView)
    }
    
    
    func setValues(values: XuberRequestData,isPaid:Int) {
        self.isPaid = isPaid
        bookingIdValueLabel.text = values.booking_id
        if let payment = values.payment {
            baseFareLabel.text = payment.fixed?.setCurrency()
            taxFareLabel.text = payment.tax?.setCurrency()
            
            hourlyFareLabel.text =  payment.hour?.setCurrency()
            hourView.isHidden = payment.hour == 0
            
            extraChageValueLabel.text = payment.extra_charges?.setCurrency()
            extraChargeView.isHidden = payment.extra_charges == 0
            
            walletFareLabel.text = "-" + (payment.wallet?.setCurrency() ?? "")
            walletView.isHidden = payment.wallet == 0
            
            totalFareLabel.text = payment.total?.setCurrency()
            total = Double(payment.total ?? 0.0)
            payableAmount = payment.payable ?? 0
            
            totalPaidFareLabel.text = payment.payable?.setCurrency()
            extraNotes = payment.extra_charges_notes ?? ""
            infoButton.isHidden = extraNotes.count == 0
//            paidView.isHidden = isPaid == 1
            changeButton.isHidden = isPaid == 1
            if payment.payable == 0.0 {
                changeButton.isHidden = true
            }
            
            if let promo = payment.promocode_id, promo == 0 {
                couponView.isHidden = true
            }else{
                couponValueLabel.text = XuberConstant.promoApplied + " (-" + (payment.discount?.setCurrency() ?? "") + ")"
            }
            if payment.payment_mode == Constant.card.uppercased() {
                doneButton.setTitle(isPaid == 1 ? Constant.SDone.localized : Constant.confirmPayment.localized, for: .normal)
                tipsView.isHidden = isPaid == 1
            }else{
                doneButton.setTitle(Constant.SDone.localized, for: .normal)
                tipsView.isHidden = true
            }
        }
    }
    
    @objc func tapDone() {
        if paymentType == .CARD {
            if isPaid == 1 {
                onClickDone?(false)
            }else{
                onClickDone?(true)
            }
        }else{
            if isPaid == 1 {
                onClickDone?(false)
            }else{
                ToastManager.show(title: Constant.pleaseConfirmPayment.localized, state: .error)
            }
        }
    }
    
    @objc func tapChange() {
        onClickChange?()
    }
    
    @objc func tapInfo() { //Extra Charge info Tap
     
//        EmptyView(frame: bounds)
//        if extraView == nil, let extraView = Bundle.main.loadNibNamed(XuberConstant.ExtraChargeView, owner: self, options: [:])?.first as? ExtraChargeView {
//            let width = (frame.width/100)*60
//            extraView.frame = CGRect(origin: CGPoint(x: (frame.width/2)-(width/2), y: (frame.height/2)-((extraView?.frame.height ?? 0)/2)), size: CGSize(width: width, height: extraView?.frame.height ?? 50))
//            extraView.titleLabel.text = extraNotes
//            extraView.closeButton.isUserInteractionEnabled = true
//            extraView = extraView
////            showDimView(view: extraView)
//            extraView?.show(with: .bottom, completion: nil)
//
//            //addSubview(extraView ?? UIView())
//        }
//        extraView?.onTapClose = {
//            extraView?.superview?.dismissView(onCompletion: {
//                extraView = nil
//            })
//        }
        
     //   AppAlert.shared.simpleAlert(view: self, title: "", message: extraNotes, buttonTitle: Constant.SOk)
        
    }
    
    @objc func tapBeforeImage() {
        showImage(image: beforeImage.image ?? UIImage())
    }
    
    @objc func tapAfterImage() {
        showImage(image: afterImage.image ?? UIImage())
    }
    
    func showImage(image: UIImage)  {
        let vc = ImageViewController()
        vc.imageView.image = image
        vc.modalPresentationStyle = .overFullScreen
        UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
    }
    
    
}
