//
//  ReceiptView.swift
//  GoJekUser
//
//  Created by Ansar on 12/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class ReceiptView: UIView {
    
    @IBOutlet weak var staticReceiptLabel: UILabel!
    @IBOutlet weak var sourcelocationview: UIView!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var sourcelocationLabel: UILabel!
    @IBOutlet weak var commissionView: UIView!
    @IBOutlet weak var weightView: UIView!
    @IBOutlet weak var heightView: UIView!
    @IBOutlet weak var breadthView: UIView!
    @IBOutlet weak var lengthView: UIView!
    @IBOutlet weak var deliveryTypeView: UIView!
    @IBOutlet weak var receiverMobileView: UIView!
    @IBOutlet weak var recieverView: UIView!
    @IBOutlet weak var itemDiscountView: UIView!
    @IBOutlet weak var itemDiscountValueLabel: UILabel!
    @IBOutlet weak var staticItemDiscountLabel: UILabel!
    @IBOutlet weak var staticDeliveryLabel: UILabel!
    @IBOutlet weak var tollChargeView: UIView!
    @IBOutlet weak var tollChargeValueLabel: UILabel!
    @IBOutlet weak var staticBreadthLabel: UILabel!
    @IBOutlet weak var staticReceiverMobileLabel: UILabel!
    @IBOutlet weak var staticRecieverNameLabel: UILabel!
    @IBOutlet weak var staticTollChargeLabel: UILabel!
    @IBOutlet weak var staticTotalLabel: UILabel!
    @IBOutlet weak var staticBaseFareLabel: UILabel!
    @IBOutlet weak var staticTaxFareLabel: UILabel!
    @IBOutlet weak var staticHourlyLabel: UILabel!
    @IBOutlet weak var staticDistanceLabel: UILabel!
    @IBOutlet weak var staticWalletLabel: UILabel!
    @IBOutlet weak var staticDiscountLabel: UILabel!
    @IBOutlet weak var staticTipsLabel: UILabel!
    @IBOutlet weak var staticWaitingLabel: UILabel!
    @IBOutlet weak var staticRoundOffLabel: UILabel!
    @IBOutlet weak var staticExtraChargeLabel: UILabel!
    @IBOutlet weak var staticHeightLabel: UILabel!
    @IBOutlet weak var staticPayableLabel: UILabel!
    @IBOutlet weak var staticLengthLabel: UILabel!
    @IBOutlet weak var staticWeightLabel: UILabel!
    @IBOutlet weak var staticCommissionLabel: UILabel!
    @IBOutlet weak var CommissionLabel: UILabel!
    
    @IBOutlet weak var packageView: UIView!
    @IBOutlet weak var deliveryView: UIView!
    @IBOutlet weak var deliveryTypeLabel: UILabel!
    @IBOutlet weak var deliveryChargeLabel: UILabel!
    @IBOutlet weak var staticDeliveryChargeLabel: UILabel!
    @IBOutlet weak var receiverMobileLabel: UILabel!
    @IBOutlet weak var packageValueLabel: UILabel!
    @IBOutlet weak var staticPackageLabel: UILabel!
    @IBOutlet weak var baseFareValueLabel: UILabel!
    @IBOutlet weak var taxFareValueLabel: UILabel!
    @IBOutlet weak var hourlyFareValueLabel: UILabel!
    @IBOutlet weak var distanceValueLabel: UILabel!
    @IBOutlet weak var walletFareValueLabel: UILabel!
    @IBOutlet weak var discountFareValueLabel: UILabel!
    @IBOutlet weak var tipsFareValueLabel: UILabel!
    @IBOutlet weak var totalFareValueLabel: UILabel!
    @IBOutlet weak var waitingValueLabel: UILabel!
    @IBOutlet weak var roundOffValueLabel: UILabel!
    @IBOutlet weak var extraChargeLabel: UILabel!
    @IBOutlet weak var payableLabel: UILabel!
    @IBOutlet weak var recieverNameLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var breadthLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    @IBOutlet weak var receiptOuterView: UIView!
    @IBOutlet weak var totalView: UIView!
    @IBOutlet weak var closeView: UIView!
    @IBOutlet weak var baseFareView: UIView!
    @IBOutlet weak var taxFareView: UIView!
    @IBOutlet weak var hourlyFareView: UIView!
    @IBOutlet weak var distanceView: UIView!
    @IBOutlet weak var walletView: UIView!
    @IBOutlet weak var discountView: UIView!
    @IBOutlet weak var tipsView: UIView!
    @IBOutlet weak var waitingView: UIView!
    @IBOutlet weak var roundOffView: UIView!
    @IBOutlet weak var extraChargeView: UIView!
    @IBOutlet weak var payableView: UIView!
    
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var peakChargeView: UIView!
    @IBOutlet weak var peakChargeLbl: UILabel!
    @IBOutlet weak var peakChargeValueLbl: UILabel!
    
    var onTapClose:(()->Void)?
    var isFlow = false
    override func awakeFromNib() {
        superview?.awakeFromNib()
        initialLoads()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        if isFlow{
        receiptOuterView.addDashLine(strokeColor: .courierColor, lineWidth: 1)
        }
        else{
        receiptOuterView.addDashLine(strokeColor: .appPrimaryColor, lineWidth: 1)
        }
    }
}

//MARK: - Methods

extension ReceiptView  {
    
    private func initialLoads() {
        self.sourcelocationview.isHidden = true
        self.locationView.isHidden = true
        totalView.backgroundColor = .appPrimaryColor
        totalView.setCornerRadiuswithValue(value: 5)
        self.closeButton.addTarget(self, action: #selector(tapClose), for: .touchUpInside)
        setFont()
        localize()
        payableView.backgroundColor = .veryLightGray
        setDarkMode()
    }
    
    private func setDarkMode(){
        self.receiptOuterView.backgroundColor = .boxColor
        self.baseFareView.backgroundColor = .boxColor
        self.taxFareView.backgroundColor = .boxColor
        self.hourlyFareView.backgroundColor = .boxColor
        self.distanceView.backgroundColor = .boxColor
        self.walletView.backgroundColor = .boxColor
        self.discountView.backgroundColor = .boxColor
        self.tipsView.backgroundColor = .boxColor
        self.waitingView.backgroundColor = .boxColor
        self.roundOffView.backgroundColor = .boxColor
        self.extraChargeView.backgroundColor = .boxColor
        self.peakChargeView.backgroundColor = .boxColor
        self.closeView.backgroundColor = .boxColor
        self.payableView.backgroundColor = .boxColor
    }
    
    @objc func tapClose() {
        self.onTapClose!()
    }
    
    private func localize()  {
        staticReceiptLabel.text  = OrderConstant.receipt.localized
        //        staticBaseFareLabel.text  = OrderConstant.baseFare.localized
        staticTaxFareLabel.text  = OrderConstant.taxFare.localized
        staticRecieverNameLabel.text = OrderConstant.receiverName.localized
        staticReceiverMobileLabel.text = OrderConstant.receiverMobile.localized
        staticHourlyLabel.text  = OrderConstant.hourFare.localized
        staticWalletLabel.text  = OrderConstant.wallet.localized
        staticDiscountLabel.text  = OrderConstant.discountApplied.localized
        staticTipsLabel.text  = OrderConstant.tips.localized
        staticDistanceLabel.text = OrderConstant.distanceFare.localized
        staticWaitingLabel.text = OrderConstant.waiting.localized
        staticRoundOffLabel.text = OrderConstant.roundOff.localized
        staticExtraChargeLabel.text = OrderConstant.extraCharge.localized
        peakChargeLbl.text =  OrderConstant.peakCharge.localized
        staticPackageLabel.text = OrderConstant.packageCharge.localized
        staticDeliveryChargeLabel.text = OrderConstant.deliveryCharge.localized
        staticTollChargeLabel.text = OrderConstant.tollCharge.localized
        staticItemDiscountLabel.text = OrderConstant.itemDiscount.localized
        staticPayableLabel.text = OrderConstant.total.localized
        
        staticHeightLabel.text = OrderConstant.height.localized
        staticWeightLabel.text = OrderConstant.weight.localized
        staticLengthLabel.text = OrderConstant.length.localized
        staticBreadthLabel.text = OrderConstant.breadth.localized
        staticCommissionLabel.text = OrderConstant.commission.localized
        staticDeliveryLabel.text = OrderConstant.deliveryType.localized
        
        if CommonFunction.checkisRTL() {
            baseFareValueLabel.textAlignment = .left
            taxFareValueLabel.textAlignment = .left
            hourlyFareValueLabel.textAlignment = .left
            distanceValueLabel.textAlignment = .left
            discountFareValueLabel.textAlignment = .left
            walletFareValueLabel.textAlignment = .left
            tipsFareValueLabel.textAlignment = .left
            totalFareValueLabel.textAlignment = .left
            waitingValueLabel.textAlignment = .left
            roundOffValueLabel.textAlignment = .left
            extraChargeLabel.textAlignment = .left
            payableLabel.textAlignment = .left
            
            heightLabel.textAlignment = .left
            breadthLabel.textAlignment = .left
            weightLabel.textAlignment = .left
            lengthLabel.textAlignment = .left
            recieverNameLabel.textAlignment = .left
            receiverMobileLabel.textAlignment = .left
            CommissionLabel.textAlignment = .left

        }else {
            baseFareValueLabel.textAlignment = .right
            taxFareValueLabel.textAlignment = .right
            hourlyFareValueLabel.textAlignment = .right
            distanceValueLabel.textAlignment = .right
            walletFareValueLabel.textAlignment = .right
            discountFareValueLabel.textAlignment = .right
            tipsFareValueLabel.textAlignment = .right
            totalFareValueLabel.textAlignment = .right
            waitingValueLabel.textAlignment = .right
            roundOffValueLabel.textAlignment = .right
            extraChargeLabel.textAlignment = .right
            payableLabel.textAlignment = .right
            
            heightLabel.textAlignment = .right
            breadthLabel.textAlignment = .right
            weightLabel.textAlignment = .right
            lengthLabel.textAlignment = .right
            recieverNameLabel.textAlignment = .right
            receiverMobileLabel.textAlignment = .right
            CommissionLabel.textAlignment = .right
        }
    }
    
    private func setFont()  {
        itemDiscountValueLabel.font  = UIFont.setCustomFont(name: .medium, size: .x14)
        staticItemDiscountLabel.font  = UIFont.setCustomFont(name: .medium, size: .x14)
        staticTollChargeLabel.font  = UIFont.setCustomFont(name: .medium, size: .x14)
        tollChargeValueLabel.font  = UIFont.setCustomFont(name: .medium, size: .x14)
        staticReceiptLabel.font  = UIFont.setCustomFont(name: .bold, size: .x14)
        peakChargeLbl.font = .setCustomFont(name: .light, size: .x14)
        staticBaseFareLabel.font  = UIFont.setCustomFont(name: .medium, size: .x14)
        staticRecieverNameLabel.font  = UIFont.setCustomFont(name: .medium, size: .x14)
        staticReceiverMobileLabel.font  = UIFont.setCustomFont(name: .medium, size: .x14)
        staticTaxFareLabel.font  = UIFont.setCustomFont(name: .medium, size: .x14)
        staticHourlyLabel.font  = UIFont.setCustomFont(name: .medium, size: .x14)
        staticWalletLabel.font  = UIFont.setCustomFont(name: .medium, size: .x14)
        staticDiscountLabel.font  = UIFont.setCustomFont(name: .medium, size: .x14)
        staticTotalLabel.font  = UIFont.setCustomFont(name: .medium, size: .x14)
        staticTipsLabel.font  = UIFont.setCustomFont(name: .medium, size: .x14)
        staticDistanceLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        staticWaitingLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        staticRoundOffLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        staticExtraChargeLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        
        staticBreadthLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        staticLengthLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        staticWeightLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        staticHeightLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        staticDeliveryLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        staticCommissionLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)

        staticPackageLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        staticDeliveryChargeLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        staticPayableLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        peakChargeLbl.font = UIFont.setCustomFont(name: .medium, size: .x14)
        tollChargeValueLabel.font = UIFont.setCustomFont(name: .bold, size: .x14)
        baseFareValueLabel.font  = UIFont.setCustomFont(name: .bold, size: .x14)
        taxFareValueLabel.font  = UIFont.setCustomFont(name: .bold, size: .x14)
        hourlyFareValueLabel.font  = UIFont.setCustomFont(name: .bold, size: .x14)
        walletFareValueLabel.font  = UIFont.setCustomFont(name: .bold, size: .x14)
        peakChargeValueLbl.font  = UIFont.setCustomFont(name: .bold, size: .x14)
        discountFareValueLabel.font  = UIFont.setCustomFont(name: .bold, size: .x14)
        walletFareValueLabel.font  = UIFont.setCustomFont(name: .bold, size: .x14)
        tipsFareValueLabel.font  = UIFont.setCustomFont(name: .bold, size: .x14)
        distanceValueLabel.font = UIFont.setCustomFont(name: .bold, size: .x14)
        waitingValueLabel.font = UIFont.setCustomFont(name: .bold, size: .x14)
        roundOffValueLabel.font = UIFont.setCustomFont(name: .bold, size: .x14)
        totalFareValueLabel.font = UIFont.setCustomFont(name: .bold, size: .x14)
        extraChargeLabel.font = UIFont.setCustomFont(name: .bold, size: .x14)
        packageValueLabel.font = UIFont.setCustomFont(name: .bold, size: .x14)
        deliveryChargeLabel.font = UIFont.setCustomFont(name: .bold, size: .x14)
        payableLabel.font = UIFont.setCustomFont(name: .bold, size: .x14)
        recieverNameLabel.font = UIFont.setCustomFont(name: .bold, size: .x14)
        receiverMobileLabel.font = UIFont.setCustomFont(name: .bold, size: .x14)
        lengthLabel.font = UIFont.setCustomFont(name: .bold, size: .x14)
        breadthLabel.font = UIFont.setCustomFont(name: .bold, size: .x14)
        heightLabel.font = UIFont.setCustomFont(name: .bold, size: .x14)
        weightLabel.font = UIFont.setCustomFont(name: .bold, size: .x14)
        deliveryTypeLabel.font = UIFont.setCustomFont(name: .bold, size: .x14)
        CommissionLabel.font = UIFont.setCustomFont(name: .bold, size: .x14)
        locationLabel.font  = .setCustomFont(name: .medium, size: .x14)
        sourcelocationLabel.font  = .setCustomFont(name: .medium, size: .x14)

    }
    
    func setCourierValues(values: CourierHistoryEntity, index: Int) {
        if (values.deliveries?.count ?? 0) > 1{
            self.sourcelocationview.isHidden = false
            self.locationView.isHidden = false
        }
        else{
            self.sourcelocationview.isHidden = true
            self.locationView.isHidden = true
        }
        deliveryView.isHidden = true
        packageView.isHidden = true
        itemDiscountView.isHidden = true
        tipsView.isHidden = true
        peakChargeView.isHidden = true
        recieverView.isHidden = false
        receiverMobileView.isHidden = false
        commissionView.isHidden = true
        deliveryTypeView.isHidden = false
        self.locationLabel.text = values.deliveries?[index].d_address ?? ""
        self.sourcelocationLabel.text = values.s_address ?? ""
        let paymentMode = PaymentType(rawValue: values.payment_mode ?? "CASH") ?? .CASH
        self.baseFareValueLabel.text = Double(values.deliveries?[index].payment?.fixed ?? 0).setCurrency()
        staticBaseFareLabel.text  = OrderConstant.baseFare.localized
        self.taxFareValueLabel.text = Double(values.deliveries?[index].payment?.tax ?? 0).setCurrency()
        staticWaitingLabel.text = OrderConstant.weight.localized
       // self.hourlyFareValueLabel.text = (values.hour ?? 0)?.setCurrency()
        hourlyFareView.isHidden = true
        self.distanceValueLabel.text = Double(values.deliveries?[index].payment?.distance ?? 0).setCurrency()
        
        //        self.walletFareValueLabel.text = values.wallet?.setCurrency()
        //        self.walletView.isHidden = (values.wallet ?? 0) == 0
        self.walletView.isHidden = true
        self.discountFareValueLabel.text = "-" + (Double(values.deliveries?[index].payment?.discount ?? 0).setCurrency() ?? "")
        self.discountView.isHidden = (values.deliveries?[index].payment?.discount ?? 0) == 0
        
        self.recieverNameLabel.text = values.deliveries?[index].name ?? ""
        self.receiverMobileLabel.text = values.deliveries?[index].mobile ?? ""
        self.deliveryTypeLabel.text = values.deliveries?[index].package_type?.package_name ?? ""
        //        self.tipsFareValueLabel.text = values.tips?.setCurrency()
        //        self.tipsView.isHidden = (values.tips ?? 0) == 0
        
        self.waitingValueLabel.text = Double(values.deliveries?[index].payment?.weight ?? 0).setCurrency()
        self.waitingView.isHidden = (values.deliveries?[index].payment?.weight ?? 0) == 0
        //        self.roundOffValueLabel.text = values.round_of?.setCurrency()
        //        self.roundOffView.isHidden = (values.round_of ?? 0) == 0
        self.roundOffView.isHidden = true
        
        //        self.extraChargeLabel.text = values.extra_charges?.setCurrency()
        //        self.extraChargeView.isHidden = (values.extra_charges ?? 0) == 0
        self.extraChargeView.isHidden = true
        
        //        self.tollChargeValueLabel.text = values.toll_charge?.setCurrency()
        //        self.tollChargeView.isHidden = (values.toll_charge ?? 0) == 0
        
        self.CommissionLabel.text = (values.deliveries?[index].payment?.commision ?? 0).setCurrency()
//        self.commissionView.isHidden = (values.deliveries?[index].payment?.commision ?? 0) == 0
//        self.commissionView.isHidden = (values.deliveries?[index].payment?.commision ?? 0) == 0

        self.lengthLabel.text = "\(values.deliveries?[index].length ?? 0)" + "" + OrderConstant.cm.localized
        self.lengthView.isHidden = (values.deliveries?[index].length ?? 0) == 0
        
        self.heightLabel.text = "\(values.deliveries?[index].height ?? 0)" + "" + OrderConstant.cm.localized
        self.heightView.isHidden = (values.deliveries?[index].height ?? 0) == 0
        
        self.breadthLabel.text = "\(values.deliveries?[index].breadth ?? 0)" + "" + OrderConstant.cm.localized
        self.breadthView.isHidden = (values.deliveries?[index].breadth ?? 0) == 0
        
        self.weightLabel.text = "\(values.deliveries?[index].weight ?? 0)" + "" + OrderConstant.kg.localized
        self.weightView.isHidden = (values.deliveries?[index].weight ?? 0) == 0
        
        self.tollChargeView.isHidden = true
        
        let payableAmt = Double((values.deliveries?[index].payment?.total ?? 0.0))
        payableLabel.text = payableAmt.setCurrency()
        
        if paymentMode == .CASH {
            
            let totalAmt = Double((values.deliveries?[index].payment?.total ?? 0.0)).rounded()
            self.totalFareValueLabel.text = totalAmt.setCurrency()
        }else {
                let totalAmt = Double((values.deliveries?[index].payment?.total ?? 0.0))
                self.totalFareValueLabel.text = totalAmt.setCurrency()
        }
        staticTotalLabel.text  = OrderConstant.payableAmount.localized
    }
    
    
    func setCourierFlowValues(values: RequestResponseData, index: Int) {
        staticReceiptLabel.text = CourierConstant.fareDetails.localized
        deliveryView.isHidden = true
        packageView.isHidden = true
        itemDiscountView.isHidden = true
        tipsView.isHidden = true
        peakChargeView.isHidden = true
        recieverView.isHidden = true
        receiverMobileView.isHidden = true
        commissionView.isHidden = true
        deliveryTypeView.isHidden = true

        totalView.backgroundColor = .courierColor
        isFlow = true
        receiptOuterView.addDashLine(strokeColor: .courierColor, lineWidth: 1)

        let paymentMode = PaymentType(rawValue: values.data?.first?.payment_mode ?? "CASH") ?? .CASH
        self.baseFareValueLabel.text = Double(values.data?.first?.deliveries?[index].payment?.fixed ?? 0).setCurrency()
        staticBaseFareLabel.text  = OrderConstant.baseFare.localized
        self.taxFareValueLabel.text = Double(values.data?.first?.deliveries?[index].payment?.tax ?? 0).setCurrency()
        staticWaitingLabel.text = OrderConstant.weightFare.localized
       // self.hourlyFareValueLabel.text = (values.hour ?? 0)?.setCurrency()
        hourlyFareView.isHidden = true
        self.distanceValueLabel.text = Double(values.data?.first?.deliveries?[index].payment?.distance ?? 0).setCurrency()
        
        //        self.walletFareValueLabel.text = values.wallet?.setCurrency()
        //        self.walletView.isHidden = (values.wallet ?? 0) == 0
        self.walletView.isHidden = true
        self.discountFareValueLabel.text = "-" + (Double(values.data?.first?.deliveries?[index].payment?.discount ?? 0).setCurrency() ?? "")
        self.discountView.isHidden = (values.data?.first?.deliveries?[index].payment?.discount ?? 0) == 0
        
        self.recieverNameLabel.text = values.data?.first?.deliveries?[index].name ?? ""
        self.receiverMobileLabel.text = values.data?.first?.deliveries?[index].mobile ?? ""
        self.deliveryTypeLabel.text = values.data?.first?.deliveries?[index].package_type?.package_name ?? ""
        //        self.tipsFareValueLabel.text = values.tips?.setCurrency()
        //        self.tipsView.isHidden = (values.tips ?? 0) == 0
        
        self.waitingValueLabel.text = Double(values.data?.first?.deliveries?[index].payment?.weight ?? 0).setCurrency()
        self.waitingView.isHidden = (values.data?.first?.deliveries?[index].payment?.weight ?? 0) == 0
        //        self.roundOffValueLabel.text = values.round_of?.setCurrency()
        //        self.roundOffView.isHidden = (values.round_of ?? 0) == 0
        self.roundOffView.isHidden = true
        
        //        self.extraChargeLabel.text = values.extra_charges?.setCurrency()
        //        self.extraChargeView.isHidden = (values.extra_charges ?? 0) == 0
        self.extraChargeView.isHidden = true
        
        //        self.tollChargeValueLabel.text = values.toll_charge?.setCurrency()
        //        self.tollChargeView.isHidden = (values.toll_charge ?? 0) == 0
        
        self.CommissionLabel.text = (values.data?.first?.deliveries?[index].payment?.commision ?? 0).setCurrency()
//        self.commissionView.isHidden = (values.deliveries?[index].payment?.commision ?? 0) == 0
//        self.commissionView.isHidden = (values.deliveries?[index].payment?.commision ?? 0) == 0

        self.lengthLabel.text = "\(values.data?.first?.deliveries?[index].length ?? 0)" + "" + OrderConstant.cm.localized
        self.lengthView.isHidden = (values.data?.first?.deliveries?[index].length ?? 0) == 0
        
        self.heightLabel.text = "\(values.data?.first?.deliveries?[index].height ?? 0)" + "" + OrderConstant.cm.localized
        self.heightView.isHidden = (values.data?.first?.deliveries?[index].height ?? 0) == 0
        
        self.breadthLabel.text = "\(values.data?.first?.deliveries?[index].breadth ?? 0)" + "" + OrderConstant.cm.localized
        self.breadthView.isHidden = (values.data?.first?.deliveries?[index].breadth ?? 0) == 0
        
        self.weightLabel.text = "\(values.data?.first?.deliveries?[index].weight ?? 0)" + "" + OrderConstant.kg.localized
        self.weightView.isHidden = (values.data?.first?.deliveries?[index].weight ?? 0) == 0
        
        self.tollChargeView.isHidden = true
        
        let payableAmt = Double((values.data?.first?.deliveries?[index].payment?.total ?? 0.0))
        payableLabel.text = payableAmt.setCurrency()
        
        if paymentMode == .CASH {
            
            let totalAmt = Double((values.data?.first?.deliveries?[index].payment?.total ?? 0.0)).rounded()
            self.totalFareValueLabel.text = totalAmt.setCurrency()
        }else {
                let totalAmt = Double((values.data?.first?.deliveries?[index].payment?.total ?? 0.0))
                self.totalFareValueLabel.text = totalAmt.setCurrency()
        }
        lengthView.isHidden = true
        heightView.isHidden = true
        breadthView.isHidden = true
        weightView.isHidden = true
        staticTotalLabel.text  = OrderConstant.payableAmount.localized
    }
    
    
    func setValues(values: Payment,calculator: String) {
        deliveryView.isHidden = true
        packageView.isHidden = true
        itemDiscountView.isHidden = true
        peakChargeView.isHidden = true
        self.hourlyFareView.isHidden = true
        self.distanceView.isHidden = true
        self.staticBaseFareLabel.text = values.base_fare_text ?? OrderConstant.baseFare.localized
        // baseFareLabel.text = values.payment?.base_fare_text
        staticHourlyLabel.text = values.time_fare_text ?? OrderConstant.hourFare.localized
        staticDistanceLabel.text = values.distance_fare_text ?? OrderConstant.distanceFare.localized
        staticWaitingLabel.text = values.waiting_fare_text ?? OrderConstant.waitingFare.localized
        staticDiscountLabel.text = values.discount_fare_text ?? OrderConstant.discountApplied.localized
        
        
        let paymentMode = PaymentType(rawValue: values.payment_mode ?? "CASH") ?? .CASH
        self.baseFareValueLabel.text = values.fixed?.setCurrency()
        //  staticBaseFareLabel.text  = OrderConstant.baseFare.localized
        self.taxFareValueLabel.text = (values.tax ?? 0)?.setCurrency()
//      if let hourFare = values.hour, hourFare>0 {
//           self.hourlyFareValueLabel.text = (values.hour ?? 0)?.setCurrency()
//        self.hourlyFareView.isHidden = false
//      }else{
//        self.hourlyFareView.isHidden = true
//
//        }
//        if let distanceFare = values.distance, distanceFare>0 {
//             self.distanceValueLabel.text = (values.distance ?? 0)?.setCurrency()
//          self.distanceView.isHidden = false
//        }else{
//          self.distanceView.isHidden = true
//
//          }
        
        if calculator == invoiceCalculator.min.rawValue {
              if  let timeFare = values.minute, timeFare>0{
                                    self.hourlyFareValueLabel.text = (values.minute ?? 0)?.setCurrency()
                                                    self.hourlyFareView.isHidden = false
                            }
              }
        else if calculator == invoiceCalculator.hour.rawValue {
                   if  let timeFare = values.hour, timeFare>0{
                  self.hourlyFareValueLabel.text = (values.hour ?? 0)?.setCurrency()
                                          self.hourlyFareView.isHidden = false
                  }
              }
        else if calculator == invoiceCalculator.distancemin.rawValue {
                  
                  if  let timeFare = values.minute, timeFare>0{
                          self.hourlyFareValueLabel.text = (values.minute ?? 0)?.setCurrency()
                                          self.hourlyFareView.isHidden = false
                  }
                          if  let distanceFare = values.distance, distanceFare>0{
                        self.distanceValueLabel.text = (values.distance ?? 0)?.setCurrency()
                           self.distanceView.isHidden = false
                  }
                       
              }        // distance with hour base
              else if calculator == invoiceCalculator.distancehour.rawValue {
                    if  let timeFare = values.hour, timeFare>0{
                                            self.hourlyFareValueLabel.text = (values.hour ?? 0)?.setCurrency()
                                                            self.hourlyFareView.isHidden = false
                                    }
                                  if  let distanceFare = values.distance, distanceFare>0{
                                                   self.distanceValueLabel.text = (values.distance ?? 0)?.setCurrency()
                                                      self.distanceView.isHidden = false
                                             }

              }
        
        
        self.walletFareValueLabel.text = values.wallet?.setCurrency()
        self.walletView.isHidden = (values.wallet ?? 0) == 0
        
        self.discountFareValueLabel.text = "-" + (values.discount?.setCurrency() ?? "")
        self.discountView.isHidden = (values.discount ?? 0) == 0
        
        self.tipsFareValueLabel.text = values.tips?.setCurrency()
        self.tipsView.isHidden = (values.tips ?? 0) == 0
        
        self.waitingValueLabel.text = values.waiting_amount?.setCurrency()
        self.waitingView.isHidden = (values.waiting_amount ?? 0) == 0
        
        self.roundOffValueLabel.text = values.round_of?.setCurrency()
        self.roundOffView.isHidden = (values.round_of ?? 0) == 0
        
        self.extraChargeLabel.text = values.extra_charges?.setCurrency()
        self.extraChargeView.isHidden = (values.extra_charges ?? 0) == 0
        
        self.tollChargeValueLabel.text = values.toll_charge?.setCurrency()
        self.tollChargeView.isHidden = (values.toll_charge ?? 0) == 0
        
        let payableAmt = Double((values.tips ?? 0.0)+(values.total ?? 0.0))
        payableLabel.text = payableAmt.setCurrency()
        
        if paymentMode == .CASH || paymentMode == .WALLET {
            
            let totalAmt = Double((values.tips ?? 0.0)+(values.cash ?? 0.0))
            self.totalFareValueLabel.text = totalAmt.setCurrency()
        }else {
            let totalAmt = Double((values.tips ?? 0.0)+(values.card ?? 0.0))
            self.totalFareValueLabel.text = totalAmt.setCurrency()
        }
        staticTotalLabel.text  = OrderConstant.payableAmount.localized
        if let peakFare = values.peak_amount, peakFare>0 {
            peakChargeValueLbl.text = peakFare.setCurrency()
            peakChargeView.isHidden = false
        }else{
            peakChargeView.isHidden = true
        }
    }
    
    func setFoodieValues(values: Order_invoice) {
        
        peakChargeView.isHidden = true
        self.baseFareValueLabel.text = values.item_price?.setCurrency()
        self.baseFareView.isHidden  = (values.item_price ?? 0) == 0
        staticBaseFareLabel.text  = OrderConstant.itemTotal.localized
        self.taxFareValueLabel.text = values.tax_amount?.setCurrency()
        self.taxFareView.isHidden = (values.tax_amount ?? 0) == 0
        payableView.isHidden = true
        
        self.hourlyFareView.isHidden = true
        self.distanceView.isHidden = true
        self.tipsView.isHidden = true
        self.waitingView.isHidden = true
        self.extraChargeView.isHidden = true
        self.tollChargeView.isHidden = true
        
        self.roundOffValueLabel.text = values.round_of?.setCurrency()
        self.roundOffView.isHidden = (values.round_of ?? 0) == 0
        staticTotalLabel.text  = OrderConstant.total.localized
        staticTaxFareLabel.text = OrderConstant.taxAmount.localized
        
        self.itemDiscountValueLabel.text = "-" + (values.discount?.setCurrency() ?? "")
        self.itemDiscountView.isHidden = (values.discount ?? 0) == 0
        
        
        self.walletFareValueLabel.text = values.wallet_amount?.setCurrency()
        self.walletView.isHidden = (values.wallet_amount ?? 0) == 0
        
        self.discountFareValueLabel.text = "-" + (values.promocode_amount?.setCurrency() ?? "")
        self.discountView.isHidden =  (values.promocode_amount ?? 0) == 0
        
        self.deliveryChargeLabel.text = (values.delivery_amount?.setCurrency() ?? "")
        self.deliveryView.isHidden =  (values.delivery_amount ?? 0) == 0
        
        self.packageValueLabel.text = (values.store_package_amount?.setCurrency() ?? "")
        self.packageView.isHidden =  (values.store_package_amount ?? 0) == 0
        
        self.payableLabel.text = values.total_amount?.setCurrency()
        
        self.totalFareValueLabel.text = values.cash?.setCurrency() //Web team told there is no condition for cash and card so added only cash flow
    }
}
