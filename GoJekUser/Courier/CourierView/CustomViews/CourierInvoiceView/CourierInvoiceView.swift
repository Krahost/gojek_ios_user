//
//  CourierInvoiceView.swift
//  GoJekUser
//
//  Created by Sudar on 03/07/20.
//  Copyright © 2020 Appoets. All rights reserved.
//

import UIKit

class CourierInvoiceView: UIView {
    
//New
    @IBOutlet weak var sourcelocationPinImageView: UIImageView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var totalAmountView: UIView!
    @IBOutlet weak var staticTotalPriceLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var invoiceTableView: UITableView!
    @IBOutlet weak var staticPaymentTypeLable: UILabel!
    @IBOutlet weak var staticPaymentByLable: UILabel!
    @IBOutlet weak var paymentTypeLabel: UILabel!
    @IBOutlet weak var paymentByLabel: UILabel!
    @IBOutlet weak var pickupLoaction: UILabel!
    private var receiptView: ReceiptView?
    private var disputeStatusView : DisputeStatusView?
    @IBOutlet weak var staticBookingIDlabel: UILabel!
    @IBOutlet weak var bookingIDLabel: UILabel!
    
    
    
    
    
    
//    @IBOutlet weak var commissionView: UIView!
    @IBOutlet weak var weightView: UIView!
    @IBOutlet weak var heightView: UIView!
    @IBOutlet weak var breadthView: UIView!
    @IBOutlet weak var lengthView: UIView!
    @IBOutlet weak var deliveryTypeView: UIView!
    @IBOutlet weak var receiverMobileView: UIView!
    @IBOutlet weak var recieverView: UIView!
    
    @IBOutlet weak var staticDeliveryLabel: UILabel!
    @IBOutlet weak var staticBreadthLabel: UILabel!
    @IBOutlet weak var staticReceiverMobileLabel: UILabel!
    @IBOutlet weak var staticRecieverNameLabel: UILabel!
    @IBOutlet weak var staticHeightLabel: UILabel!
    @IBOutlet weak var staticLengthLabel: UILabel!
    @IBOutlet weak var staticWeightLabel: UILabel!
//    @IBOutlet weak var staticCommissionLabel: UILabel!
//    @IBOutlet weak var CommissionLabel: UILabel!
    @IBOutlet weak var deliveryTypeLabel: UILabel!
    @IBOutlet weak var receiverMobileLabel: UILabel!
    @IBOutlet weak var recieverNameLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var breadthLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!

    @IBOutlet weak var deliverySelectionButton: UIButton!
    @IBOutlet weak var mainScrlVw: UIScrollView!
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var totalPriceTitleLbl: UILabel!
    @IBOutlet weak var totalPriceValueLbl: UILabel!
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var headerVw: UIView!
    @IBOutlet weak var headerImgVw: UIImageView!
    
    @IBOutlet weak var couponVw: UIView!
    @IBOutlet weak var deliveryDateTitleLbl: UILabel!
    @IBOutlet weak var deliveryDateLbl: UILabel!
    @IBOutlet weak var discountApliedLbl: UILabel!
    @IBOutlet weak var discountApliedValueLbl: UILabel!
    
    @IBOutlet weak var statusTblVw: UITableView!
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
    @IBOutlet weak var detailsVw: UIView!
    
    @IBOutlet weak var totalVw: UIView!
       @IBOutlet weak var totaltitleLbl: UILabel!
       @IBOutlet weak var totalValueLbl: UILabel!
    
    @IBOutlet weak var roundoffVw: UIView!
          @IBOutlet weak var roundofftitleLbl: UILabel!
          @IBOutlet weak var roundoffValueLbl: UILabel!
    
    @IBOutlet weak var subTotalVw: UIView!
    @IBOutlet weak var subTotaltitleLbl: UILabel!
    @IBOutlet weak var subTotalValueLbl: UILabel!
    @IBOutlet weak var discountView: UIView!
    
    @IBOutlet weak var heightTableView: NSLayoutConstraint!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var imagePayment: UIImageView!

    @IBOutlet weak var labelPaymentType: UILabel!

    
    var requestData : RequestResponseData?
    var ratingView: RatingView?
    var onClickConfirm:((Bool)->Void)?
    var isPaid:Int = 0
    var selectedIndex = 0
    var openedArr = [Int]()
    var paymentType : PaymentType = .NONE {
         didSet {
             submitBtn.setTitle(paymentType == .CASH ? Constant.SDone.localized.uppercased() : Constant.confirm.localized.uppercased(), for: .normal)
         }
     }

    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    override func awakeFromNib(){
        initialLoad()
    }
    
    private func initialLoad(){
        mainScrlVw.contentSize  = CGSize(width: bgView.frame.width, height: bgView.frame.height)
        setDesignUpdate()
        setFont()
        setTargets()
        setColors()
        setLocalization()
        registerXiB()
//        if let deliveryValue = requestData?.data?.first{
//            self.setValues(values: deliveryValue)
//        }
        submitBtn.addTarget(self, action: #selector(confirmPayment(sender:)), for:.touchUpInside)
        totalVw.layer.borderColor = UIColor.black.cgColor
        totalVw.layer.borderWidth = 1
        
        deliverySelectionButton.layer.borderColor = UIColor.courierColor.cgColor
        deliverySelectionButton.layer.borderWidth = 0.5
        
        setDarkMode()
        deliverySelectionButton.addTarget(self, action: #selector(invoiceClicked), for: .touchUpInside)
    }
    
    private func setDarkMode(){
        headerVw.backgroundColor = .boxColor
        self.backgroundColor = .backgroundColor
        self.couponVw.backgroundColor = .boxColor
        self.detailsVw.backgroundColor = .boxColor
        self.backBtn.tintColor = .blackColor
    }
    
    private func registerXiB(){
        statusTblVw.delegate =  self
        statusTblVw.dataSource = self
        statusTblVw.register(nibName: CourierConstant.CourierStatusTableViewCell)
        
        //New
        invoiceTableView.delegate = self
        invoiceTableView.dataSource = self
        invoiceTableView.separatorStyle = .none
        invoiceTableView.backgroundColor = .backgroundColor
        invoiceTableView.register(nibName: CourierConstant.CourierInvoiceCell)
    }
    private func setDesignUpdate(){
        headerVw.setCornerRadiuswithValue(value: 5)
        submitBtn.setCornerRadiuswithValue(value: 5)
        deliverySelectionButton.setCornerRadiuswithValue(value: 4)
        
    }
    private func setColors() {
        //New
        doneButton.backgroundColor = .courierColor
        totalAmountView.backgroundColor = .courierColor
        staticPaymentByLable.textColor = .courierColor
        totalAmountView.backgroundColor = .courierColor
        staticPaymentTypeLable.textColor = .courierColor
        staticBookingIDlabel.textColor = .courierColor
        sourcelocationPinImageView.setImageColor(color: .red)
        
        mainScrlVw.backgroundColor = .clear
        bgView.backgroundColor = .clear
        submitBtn.backgroundColor = .courierColor
        totalPriceTitleLbl.textColor = .white
        totalPriceValueLbl.textColor = .white
        basefaretitleLbl.textColor = .darkGray
        basefaretitleValueLbl.textColor = .darkGray
        distancefaretitleLbl.textColor = .darkGray
        distancefaretitleValueLbl.textColor = .darkGray
        timingtitleLbl.textColor = .darkGray
        timingValueLbl.textColor = .darkGray
        taxtitleLbl.textColor = .darkGray
        taxValueLbl.textColor = .darkGray
        deliveryDateLbl.textColor = .darkGray
        vehilcleNameLbl.textColor =  .courierColor
        pickupLoaction.textColor = .darkGray
        deliverySelectionButton.textColor(color: .courierColor)
    }
    private func setFont(){
        //New
        doneButton.titleLabel?.font = .setCustomFont(name: .bold, size: .x14)
        staticTotalPriceLabel.font = .setCustomFont(name: .bold, size: .x16)
        staticPaymentTypeLable.font = .setCustomFont(name: .bold, size: .x14)
        staticPaymentByLable.font = .setCustomFont(name: .bold, size: .x14)
        staticBookingIDlabel.font = .setCustomFont(name: .bold, size: .x14)
        bookingIDLabel.font = .setCustomFont(name: .bold, size: .x14)

        paymentTypeLabel.font = .setCustomFont(name: .bold, size: .x14)
        paymentByLabel.font = .setCustomFont(name: .bold, size: .x14)
        totalPriceLabel.font = .setCustomFont(name: .bold, size: .x50)
        pickupLoaction.font = .setCustomFont(name: .medium, size: .x14)
        
        
        
        
        titleLbl.font = .setCustomFont(name: .bold, size: .x18)
        deliveryDateTitleLbl.font = .setCustomFont(name: .medium, size: .x14)
        deliveryDateLbl.font = .setCustomFont(name: .medium, size: .x12)
        discountApliedLbl.font = .setCustomFont(name: .medium, size: .x14)
        discountApliedValueLbl.font = .setCustomFont(name: .medium, size: .x12)
        vehilcleNameLbl.font = .setCustomFont(name: .bold, size: .x16)
        basefaretitleLbl.font = .setCustomFont(name: .medium, size: .x14)
        basefaretitleValueLbl.font = .setCustomFont(name: .medium, size: .x14)
        distancefaretitleLbl.font = .setCustomFont(name: .medium, size: .x14)
        distancefaretitleValueLbl.font = .setCustomFont(name: .medium, size: .x14)
        timingtitleLbl.font = .setCustomFont(name: .medium, size: .x14)
        timingValueLbl.font = .setCustomFont(name: .medium, size: .x14)
        taxtitleLbl.font = .setCustomFont(name: .medium, size: .x14)
        taxValueLbl.font = .setCustomFont(name: .medium, size: .x14)
        totaltitleLbl.font = .setCustomFont(name: .medium, size: .x14)
        totalValueLbl.font = .setCustomFont(name: .medium, size: .x14)
        subTotaltitleLbl.font = .setCustomFont(name: .bold, size: .x16)
        subTotalValueLbl.font = .setCustomFont(name: .bold, size: .x16)
        submitBtn.titleLabel?.font = .setCustomFont(name: .medium, size: .x18)
        totalPriceValueLbl.font = .setCustomFont(name: .bold, size: .x30)
        totalPriceTitleLbl.font = .setCustomFont(name: .medium, size: .x14)
        roundofftitleLbl.font = .setCustomFont(name: .medium, size: .x14)
        roundoffValueLbl.font = .setCustomFont(name: .medium, size: .x14)
        labelPaymentType.font = .setCustomFont(name: .medium, size: .x14)
        deliverySelectionButton.titleLabel?.font = .setCustomFont(name: .bold, size: .x16)
        staticBreadthLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        staticLengthLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        staticWeightLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        staticHeightLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        staticDeliveryLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        staticRecieverNameLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        staticReceiverMobileLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        recieverNameLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        receiverMobileLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        lengthLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        breadthLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        heightLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        weightLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        deliveryTypeLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        recieverNameLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        receiverMobileLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)

    }
    private func setLocalization(){
        //New
        doneButton.setTitle(CourierConstant.done.localized, for: .normal)
        staticTotalPriceLabel.text = CourierConstant.totalprice.localized
        staticPaymentTypeLable.text = CourierConstant.paymentType.localized.uppercased()
        staticBookingIDlabel.text = CourierConstant.bookingId.localized.uppercased()
        staticPaymentByLable.text = CourierConstant.paymentBy.localized.uppercased()
        staticHeightLabel.text = OrderConstant.height.localized
        staticLengthLabel.text = OrderConstant.length.localized
        staticWeightLabel.text = OrderConstant.weight.localized
        staticBreadthLabel.text = OrderConstant.breadth.localized
        staticDeliveryLabel.text = OrderConstant.packageType.localized

        
        titleLbl.text = CourierConstant.invoice.localized
        submitBtn.setTitle(CourierConstant.proceed.localized, for: .normal)
        basefaretitleLbl.text = CourierConstant.basefare.localized
        distancefaretitleLbl.text = CourierConstant.totalDistance.localized
        timingtitleLbl.text = CourierConstant.weightFare.localized
        taxtitleLbl.text = CourierConstant.tax.localized
        deliveryDateTitleLbl.text = CourierConstant.deliverydate.localized
        totalPriceTitleLbl.text = CourierConstant.totalprice.localized
        subTotaltitleLbl.text = CourierConstant.subTotal.localized
        totaltitleLbl.text = CourierConstant.total.localized
        roundofftitleLbl.text = CourierConstant.roundoff.localized
        deliverySelectionButton.setTitle(CourierConstant.overAll.localized, for: .normal)
        
        
        staticHeightLabel.text = OrderConstant.height.localized
        staticWeightLabel.text = OrderConstant.weight.localized
        staticLengthLabel.text = OrderConstant.length.localized
        staticBreadthLabel.text = OrderConstant.breadth.localized
//        staticCommissionLabel.text = OrderConstant.commission.localized
        staticDeliveryLabel.text = OrderConstant.deliveryType.localized
        staticRecieverNameLabel.text = OrderConstant.receiverName.localized
        staticReceiverMobileLabel.text = OrderConstant.receiverMobile.localized
    }
    private func setTargets(){
        backBtn.addTarget(self, action: #selector(tapBack), for: .touchUpInside)
    }
    
    @objc private func tapBack(){
        for vc in UIApplication.topViewController()?.navigationController?.viewControllers ?? [UIViewController()] {
            if let myViewCont = vc as? HomeViewController
            {
                UIApplication.topViewController()?.navigationController?.popToViewController(myViewCont, animated: true)
            }
        }
    }
    
    @objc func invoiceClicked(){
        
        if (requestData?.data?.first?.deliveries?.count ?? 0) <= 1 {
        self.deliverySelectionButton.isUserInteractionEnabled = false
        self.deliverySelectionButton.setTitle(CourierConstant.delivery.localized + " " + "1", for: .normal)
        self.selectedIndex = 0
        if let data = self.requestData?.data?.first?.deliveries?[self.selectedIndex] {
                self.setValues(values: self.requestData?.data?.first ?? RequestData(), data: data, isSenderPay: false)
        }
        }
        else{
        self.deliverySelectionButton.isUserInteractionEnabled = true
        var arr = [String]()
        arr.append(CourierConstant.overAll.localized)
        for i in 0..<(requestData?.data?.first?.deliveries?.count ?? 0){
            arr.append(CourierConstant.delivery.localized + " " + "\(i + 1)")
        }
        self.selectedIndex = 0
        if let data = self.requestData?.data?.first?.deliveries?[self.selectedIndex] {
            self.setValues(values: self.requestData?.data?.first ?? RequestData(), data: data, isSenderPay: true)
        }


        PickerManager.shared.showPicker(pickerData: arr, selectedData: nil) { [weak self] (selectedType) in
            guard let self = self else {
                return
            }
            // selected index
            for i in 0..<arr.count {
                if selectedType == arr[i]{
                    self.selectedIndex = i
                }
            }
            self.deliverySelectionButton.setTitle(selectedType, for: .normal)
            if self.selectedIndex == 0 {
                if let data = self.requestData?.data?.first?.deliveries?[self.selectedIndex] {
                    self.setValues(values: self.requestData?.data?.first ?? RequestData(), data: data, isSenderPay: true)
                }
            }
            else{
                if let data = self.requestData?.data?.first?.deliveries?[self.selectedIndex - 1] {
                    self.setValues(values: self.requestData?.data?.first ?? RequestData(), data: data, isSenderPay: false)
                }
            }

            self.setNeedsUpdateConstraints()
            self.layoutIfNeeded()
        }
        }
    }
    
    @objc func makeCallAction(sender : UIButton){
        AppUtils.shared.call(to: self.requestData?.data?.first?.deliveries?[sender.tag].mobile ?? "")
    }
    
    @objc func showfareDetails(sender : UIButton){
        if self.receiptView == nil, let receiptView = Bundle.main.loadNibNamed(OrderConstant.ReceiptView, owner: self, options: [:])?.first as? ReceiptView {
        receiptView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self.receiptView = receiptView
        if let data =  self.requestData{
        self.receiptView?.setCourierFlowValues(values: data, index: sender.tag)
        }
        self.receiptView?.show(with: .bottom, completion: nil)
            self.showDimView(view: self.receiptView ?? DisputeStatusView())
        }
        self.receiptView?.onTapClose = { [weak self] in
            guard let self = self else {
                return
            }
            self.receiptView?.superview?.dismissView(onCompletion: {
                self.receiptView = nil
            })
        }
    }
    
    private func showDimView(view: UIView) {
        let dimView = UIView(frame: self.frame)
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        dimView.addSubview(view)
        self.addSubview(dimView)
        let dimViewTap = UITapGestureRecognizer(target: self, action: #selector(tapDimView))
        dimView.addGestureRecognizer(dimViewTap)
    }
    
    @objc func tapDimView() {
           if self.disputeStatusView != nil {
               self.disputeStatusView?.superview?.removeFromSuperview() // dimview
               self.disputeStatusView?.dismissView(onCompletion: {
                   self.disputeStatusView = nil
               })
           }
    }
    
    func setValues(values:RequestData, data : DeliveryEntity, isSenderPay : Bool) {
        //New
        pickupLoaction.text = values.s_address ?? ""
        bookingIDLabel.text = values.booking_id ?? ""
        self.totalPriceLabel.text = "\(values.currency ?? "") \(String(describing: (values.payment?.payable ?? 0).roundOff(2)))"
//        totalPriceLabel.text = data.payment?.total?.rounded().setCurrency()
        if values.payment_mode == PaymentType.CASH.rawValue {
            paymentTypeLabel.text = PaymentType.CASH.rawValue
            
        }else{
            paymentTypeLabel.text = PaymentType.CARD.rawValue
        }
        if values.payment_by?.uppercased() == "SENDER" {
            paymentByLabel.text = CourierConstant.sender.localized.uppercased()
            
        }else{
            paymentByLabel.text = CourierConstant.receiver.localized.uppercased()
        }
        invoiceTableView.reloadData()
        
        
//        if (values.deliveries?.count ?? 0) <= 1 {
//            self.deliverySelectionButton.isUserInteractionEnabled = false            //set button
//            self.deliverySelectionButton.setTitle(CourierConstant.delivery.localized + " " + "1", for: .normal)
//            self.weightView.isHidden = false
//            self.lengthView.isHidden = false
//            self.breadthView.isHidden = false
//            self.recieverView.isHidden = false
//            self.heightView.isHidden = false
//            self.receiverMobileView.isHidden = false
//            self.deliveryTypeView.isHidden = false
//            self.totalPriceValueLbl.text = "\(values.currency ?? "") \(data.payment?.payable ?? 0)"
//         self.deliveryDateLbl.text = values.assigned_time
//        self.vehilcleNameLbl.text = values.booking_id
//        isPaid = values.deliveries?.first?.paid ?? 0
//        paymentType = PaymentType(rawValue: values.payment_mode ?? "") ?? .CASH
//        if isPaid == 1 {
//            submitBtn.setTitle(Constant.SDone.localized.uppercased(), for: .normal)
//        }
////        distancefareVw.isHidden = true
//        roundoffValueLbl.text = "\(values.currency ?? "") \(data.payment?.round_of?.rounded(toPlaces: 2) ?? 0)"
//        self.discountApliedValueLbl.text = "\(values.currency ?? "") \(data.payment?.discount ?? 0)"
//        discountView.isHidden = data.payment?.discount == 0
//        totalValueLbl.text = "\(values.currency ?? "") \(data.payment?.total ?? 0)"
//        self.basefaretitleValueLbl.text = "\(values.currency ?? "") \(data.payment?.fixed ?? 0)"
//        self.distancefaretitleValueLbl.text = "\(values.currency ?? "") \(data.payment?.distance ?? 0)"
//        self.timingValueLbl.text = "\(values.currency ?? "") \(data.payment?.weight ?? 0)"
//        self.taxValueLbl.text = "\(values.currency ?? "") \(data.payment?.tax ?? 0)"
//        self.subTotalValueLbl.text = "\(values.currency ?? "") \(data.payment?.payable ?? 0)"
//        //        self.commissionView.isHidden = (values.deliveries?[index].payment?.commision ?? 0) == 0
////        self.commissionView.isHidden = (values.deliveries?[index].payment?.commision ?? 0) == 0
//
//        self.lengthLabel.text = "\(data.length ?? 0)" + "" + OrderConstant.cm.localized
//        self.lengthView.isHidden = (data.length ?? 0) == 0
//
//        self.heightLabel.text = "\(data.height ?? 0)" + "" + OrderConstant.cm.localized
//        self.heightView.isHidden = (data.height ?? 0) == 0
//
//        self.breadthLabel.text = "\(data.breadth ?? 0)" + "" + OrderConstant.cm.localized
//        self.breadthView.isHidden = (data.breadth ?? 0) == 0
//
//        self.weightLabel.text = "\(data.weight ?? 0)" + "" + OrderConstant.kg.localized
//        self.weightView.isHidden = (data.weight ?? 0) == 0
//        self.recieverNameLabel.text = data.name ?? ""
//        self.receiverMobileLabel.text = data.mobile ?? ""
//        self.deliveryTypeLabel.text = data.package_type?.package_name ?? ""
//        heightTableView.constant = CGFloat(((values.deliveries?.count ?? 0) + 1) * 55)
//        statusTblVw.reloadData()
//
//        if values.payment_mode == PaymentType.CASH.rawValue {
//            imagePayment.image = #imageLiteral(resourceName: "money_icon")
//            labelPaymentType.text = PaymentType.CASH.rawValue
//
//        }else{
//            imagePayment.image = #imageLiteral(resourceName: "ic_credit_card")
//            labelPaymentType.text = PaymentType.CARD.rawValue
//        }
//        }
//        else{
//        self.deliverySelectionButton.isUserInteractionEnabled = true
//        if isSenderPay{
//            self.totalPriceValueLbl.text = "\(values.currency ?? "") \(String(describing: (values.payment?.payable ?? 0).roundOff(2)))"
//            self.deliveryDateLbl.text = values.assigned_time
//            self.vehilcleNameLbl.text = values.booking_id
//            isPaid = values.deliveries?.first?.paid ?? 0
//            paymentType = PaymentType(rawValue: values.payment_mode ?? "") ?? .CASH
//            if isPaid == 1 {
//                submitBtn.setTitle(Constant.SDone.localized.uppercased(), for: .normal)
//            }
////            distancefareVw.isHidden = true
//            roundoffValueLbl.text = "\(values.currency ?? "") \(data.payment?.round_of?.rounded(toPlaces: 2) ?? 0)"
//            self.discountApliedValueLbl.text = "\(values.currency ?? "") \(data.payment?.discount ?? 0)"
//            discountView.isHidden = values.payment?.discount == 0
//            totalValueLbl.text = "\(values.currency ?? "") \((values.payment?.total ?? 0).roundOff(2))"
//            self.basefaretitleValueLbl.text = "\(values.currency ?? "") \((values.payment?.fixed ?? 0).roundOff(2))"
//            self.distancefaretitleValueLbl.text = "\(values.currency ?? "") \(data.payment?.distance ?? 0)"
//            self.timingValueLbl.text = "\(values.currency ?? "") \(values.payment?.weight ?? 0)"
//            self.taxValueLbl.text = "\(values.currency ?? "") \(values.payment?.tax ?? 0)"
//            self.subTotalValueLbl.text = "\(values.currency ?? "") \(values.payment?.payable ?? 0)"
//            self.recieverNameLabel.text = data.name ?? ""
//            self.receiverMobileLabel.text = data.mobile ?? ""
//            self.deliveryTypeLabel.text = data.package_type?.package_name ?? ""
//            heightTableView.constant = CGFloat(((values.deliveries?.count ?? 0) + 1) * 55)
//
//            self.weightView.isHidden = true
//            self.lengthView.isHidden = true
//            self.breadthView.isHidden = true
//            self.recieverView.isHidden = true
//            self.heightView.isHidden = true
//            self.receiverMobileView.isHidden = true
//            self.deliveryTypeView.isHidden = true
//            statusTblVw.reloadData()
//
//            if values.payment_mode == PaymentType.CASH.rawValue {
//                imagePayment.image = #imageLiteral(resourceName: "money_icon")
//                labelPaymentType.text = PaymentType.CASH.rawValue
//
//            }else{
//                imagePayment.image = #imageLiteral(resourceName: "ic_credit_card")
//                labelPaymentType.text = PaymentType.CARD.rawValue
//            }
//        }
//        else{
//            //set button
//            for i in 0..<(requestData?.data?.first?.deliveries?.count ?? 0){
//                if let loopData = requestData?.data?.first?.deliveries?[i]{
//                    if (loopData.id ?? 0) == (data.id ?? 0) {
//                        self.selectedIndex = i
//                        self.deliverySelectionButton.setTitle(CourierConstant.delivery.localized + " " + "\(i + 1)", for: .normal)
//                    }
//                }
//            }
//            self.weightView.isHidden = false
//            self.lengthView.isHidden = false
//            self.breadthView.isHidden = false
//            self.recieverView.isHidden = false
//            self.heightView.isHidden = false
//            self.receiverMobileView.isHidden = false
//            self.deliveryTypeView.isHidden = false
//        self.totalPriceValueLbl.text = "\(values.currency ?? "") \(data.payment?.payable ?? 0)"
//        self.deliveryDateLbl.text = values.assigned_time
//        self.vehilcleNameLbl.text = values.booking_id
//        isPaid = values.deliveries?.first?.paid ?? 0
//        paymentType = PaymentType(rawValue: values.payment_mode ?? "") ?? .CASH
//        if isPaid == 1 {
//            submitBtn.setTitle(Constant.SDone.localized.uppercased(), for: .normal)
//        }
////        distancefareVw.isHidden = true
//        roundoffValueLbl.text = "\(values.currency ?? "") \(data.payment?.round_of?.rounded(toPlaces: 2) ?? 0)"
//        self.discountApliedValueLbl.text = "\(values.currency ?? "") \(data.payment?.discount ?? 0)"
//        discountView.isHidden = data.payment?.discount == 0
//        totalValueLbl.text = "\(values.currency ?? "") \(data.payment?.total ?? 0)"
//        self.basefaretitleValueLbl.text = "\(values.currency ?? "") \(data.payment?.fixed ?? 0)"
//        self.distancefaretitleValueLbl.text = "\(values.currency ?? "") \(data.payment?.distance ?? 0)"
//        self.timingValueLbl.text = "\(values.currency ?? "") \(data.payment?.weight ?? 0)"
//        self.taxValueLbl.text = "\(values.currency ?? "") \(data.payment?.tax ?? 0)"
//        self.subTotalValueLbl.text = "\(values.currency ?? "") \(data.payment?.payable ?? 0)"
//        //        self.commissionView.isHidden = (values.deliveries?[index].payment?.commision ?? 0) == 0
////        self.commissionView.isHidden = (values.deliveries?[index].payment?.commision ?? 0) == 0
//
//        self.lengthLabel.text = "\(data.length ?? 0)" + "" + OrderConstant.cm.localized
//        self.lengthView.isHidden = (data.length ?? 0) == 0
//
//        self.heightLabel.text = "\(data.height ?? 0)" + "" + OrderConstant.cm.localized
//        self.heightView.isHidden = (data.height ?? 0) == 0
//
//        self.breadthLabel.text = "\(data.breadth ?? 0)" + "" + OrderConstant.cm.localized
//        self.breadthView.isHidden = (data.breadth ?? 0) == 0
//
//        self.weightLabel.text = "\(data.weight ?? 0)" + "" + OrderConstant.kg.localized
//        self.weightView.isHidden = (data.weight ?? 0) == 0
//        self.recieverNameLabel.text = data.name ?? ""
//        self.receiverMobileLabel.text = data.mobile ?? ""
//        self.deliveryTypeLabel.text = data.package_type?.package_name ?? ""
//        heightTableView.constant = CGFloat(((values.deliveries?.count ?? 0) + 1) * 55)
//        statusTblVw.reloadData()
//
//        if values.payment_mode == PaymentType.CASH.rawValue {
//            imagePayment.image = #imageLiteral(resourceName: "money_icon")
//            labelPaymentType.text = PaymentType.CASH.rawValue
//
//        }else{
//            imagePayment.image = #imageLiteral(resourceName: "ic_credit_card")
//            labelPaymentType.text = PaymentType.CARD.rawValue
//        }
//      }
//        }
    }
    
    @IBAction func confirmPayment(sender:UIButton){
        if paymentType == .CASH {
            if isPaid == 0 {
                onClickConfirm?(paymentType == .CASH)
            }else{
                ToastManager.show(title: Constant.pleaseConfirmPayment.localized, state: .error)
            }
        }else{
            onClickConfirm?(paymentType == .CASH)
        }
    }
}
extension CourierInvoiceView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
        return (self.requestData?.data?.first?.deliveries?.count ?? 0)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == invoiceTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: CourierConstant.CourierInvoiceCell, for: indexPath)  as! CourierInvoiceCell
            let data = self.requestData?.data?.first?.deliveries?[indexPath.row]
            if openedArr.contains(indexPath.row){
                cell.isOpened = true
            }
            else{
                cell.isOpened = false
            }
            cell.selectionStyle = .none
            cell.destinationAddressLabel.text = data?.dAddress ?? ""
            cell.recieverNameLabel.text = data?.name ?? ""
            cell.recieverMobileLabel.text = data?.mobile ?? ""
            cell.lengthLabel.text = "\(data?.length ?? 0) \(OrderConstant.cm.localized)"
            cell.lengthView.isHidden = ((data?.length ?? 0) == 0)
            cell.breadthLabel.text = "\(data?.breadth ?? 0) \(OrderConstant.cm.localized)"
            cell.breadthView.isHidden = ((data?.breadth ?? 0) == 0)
            cell.weightLabel.text = "\(data?.weight ?? 0) \(OrderConstant.kg.localized)"
            cell.weightView.isHidden = ((data?.weight ?? 0) == 0)
            cell.heightLabel.text = "\(data?.height ?? 0) \(OrderConstant.cm.localized)"
            cell.heightView.isHidden = ((data?.height ?? 0) == 0)

            cell.packageLabel.text = data?.package_type?.package_name ?? ""
            cell.packageTypeView.isHidden = ((data?.package_type?.package_name ?? "") == "")
            cell.descriptionLabel.text = data?.instruction ?? ""
            cell.instructionView.isHidden = ((data?.instruction ?? "") == "")
            cell.callButton.tag = indexPath.row
            cell.fareDetailsButton.tag = indexPath.row
            cell.callButton.addTarget(self, action: #selector(makeCallAction(sender:)), for: .touchUpInside)
            cell.fareDetailsButton.addTarget(self, action: #selector(showfareDetails(sender:)), for: .touchUpInside)

            var current = 0
            for i in 0..<(self.requestData?.data?.first?.deliveries?.count ?? 0) {
                if (self.requestData?.data?.first?.deliveries?[i].status?.uppercased() ?? "") == CourierRequestStatus.completed.rawValue{
                    current = i + 1
                    break
                }
            }
            
            // current delivery
            if indexPath.row == current {
                cell.outterView.borderColor = .courierColor
                cell.callButton.tintColor = .courierColor
                cell.fareDetailsButton.tintColor = .courierColor
                cell.deliveryHeadingLabel.textColor = .courierColor
                cell.dropdownImageView.setImageColor(color: .courierColor)
                cell.deliveryHeadingLabel.text = CourierConstant.delivery.localized.uppercased() + " " + "\(indexPath.row + 1) - ( \(CourierConstant.current.localized) )".uppercased()
                if (self.requestData?.data?.first?.deliveries?.count ?? 0) == 1 {
                    cell.deliveryHeadingLabel.text = CourierConstant.delivery.localized.uppercased()
                }
                cell.contentView.alpha = 1
            }
            else{
                cell.outterView.borderColor = .lightGray
                cell.callButton.tintColor = .lightGray
                cell.fareDetailsButton.tintColor = .lightGray
                cell.deliveryHeadingLabel.textColor = .lightGray
                cell.dropdownImageView.setImageColor(color: .lightGray)
                cell.deliveryHeadingLabel.text = CourierConstant.delivery.localized.uppercased() + " " + "\(indexPath.row  + 1)".uppercased()
                if (self.requestData?.data?.first?.deliveries?.count ?? 0) == 1 {
                    cell.deliveryHeadingLabel.text = CourierConstant.delivery.localized.uppercased()
                }
                cell.contentView.alpha = 0.7
            }
            
            
            
            
            cell.contentView.backgroundColor = .clear
            return cell
        }
        else{
        let cell = tableView.dequeueReusableCell(withIdentifier: CourierConstant.CourierStatusTableViewCell, for: indexPath)  as! CourierStatusTableViewCell
        
        if indexPath.row == 0 {
            
            cell.locationTitleLbl.text = CourierConstant.pickuplocation
            cell.locationLbl.text = self.requestData?.data?.first?.s_address
            cell.topLineVw.isHidden = true
            cell.statusImgVw.image =  UIImage.init(named: CourierConstant.redTapeImg)
        }else{
            
            cell.locationTitleLbl.text = CourierConstant.dropofflocation
            cell.locationLbl.text =  self.requestData?.data?.first?.deliveries?[indexPath.row - 1].dAddress
            cell.topLineVw.isHidden = true
            cell.statusImgVw.image =  UIImage.init(named: CourierConstant.ic_greenTap)
            
        }
        return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if openedArr.contains(indexPath.row){
            openedArr =  openedArr.filter(){$0 != indexPath.row}
        }
        else{
            openedArr.append(indexPath.row)
//            animals = animals.filter(){$0 != "chimps"}
        }
        tableView.reloadData()
    }
}
// MARK: - UITableViewDelegate

extension CourierInvoiceView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//        if openedArr.contains(indexPath.row){
//            return 100
//        }
//        else{
//          return 50
//        }
        return UITableView.automaticDimension
    
    }
}
