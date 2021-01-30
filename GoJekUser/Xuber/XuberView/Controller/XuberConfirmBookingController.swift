//
//  XuberConfirmBookingController.swift
//  GoJekUser
//
//  Created by Ansar on 19/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

class XuberConfirmBookingController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var outterView: UIView!
    

    var promoCodeData:[PromocodeData] = [] {
        didSet{
            self.tableView.reloadInMainThread()
        }
    }
    
    var selectedPromo:PromocodeData?
    var couponView:CouponView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoads()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
}

extension XuberConfirmBookingController {
    private func initialLoads() {
        self.tableView.register(nibName: XuberConstant.XuberServiceDetailCell)
        self.tableView.register(nibName: XuberConstant.XuberInstructionCell)
        self.tableView.register(nibName: XuberConstant.XuberApplyCouponCell)
        self.tableView.register(nibName: XuberConstant.XuberPaymentSelectionCell)
        self.nextButton.setBothCorner()
        self.nextButton.titleLabel?.font = UIFont.setCustomFont(name: .bold, size: .x18)
        self.nextButton.backgroundColor = .xuberColor
        self.nextButton.setTitle(XuberConstant.next.localized, for: .normal)
        self.nextButton.addTarget(self, action: #selector(tapNext), for: .touchUpInside)
        self.view.backgroundColor = .veryLightGray
        
        self.setNavigationBar()
        let param:Parameters = [XuberInput.totalAmount : SendRequestInput.shared.price ?? 0]
        xuberPresenter?.getPromocode(param: param)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        setDarkMode()
    }
    
    
    private func setDarkMode(){
        self.view.backgroundColor = .backgroundColor
        self.outterView.backgroundColor = .boxColor
        self.tableView.backgroundColor = .boxColor

    }
    
    private func setNavigationBar() {
        self.setNavigationTitle()
        self.setLeftBarButtonWith(color: .blackColor)
        self.title = XuberConstant.confirmBooking.localized
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    @objc func tapNext() {
     
        guard validation() else {
            return
        }
        var param:Parameters = [XuberInput.s_latitude : SendRequestInput.shared.s_latitude ?? 0,
                                XuberInput.s_longitude : SendRequestInput.shared.s_longitude ?? 0,
                                XuberInput.s_address : SendRequestInput.shared.s_address ?? "",
                                XuberInput.service_id : SendRequestInput.shared.serviceId ?? "",
                                XuberInput.payment_mode : SendRequestInput.shared.paymentMode ?? PaymentType.CASH.rawValue,
                                XuberInput.use_wallet : SendRequestInput.shared.useWallet ? 1 : 0,
                                XuberInput.id : SendRequestInput.shared.providerId ?? 0,
                                XuberInput.promocode_id : self.selectedPromo?.id ?? 0,
                                XuberInput.price : SendRequestInput.shared.price ?? 0,
                                XuberInput.quantity : SendRequestInput.shared.quantity ?? 1]
        
        var instructionImage:[String:Data]? = [XuberInput.allow_image:SendRequestInput.shared.instructionImage?.jpegData(compressionQuality: 0.2) ?? Data()]
        if SendRequestInput.shared.allowImage ?? false {
            instructionImage = [XuberInput.allow_image:SendRequestInput.shared.instructionImage?.jpegData(compressionQuality: 0.2) ?? Data()]
            param[XuberInput.allow_description] = SendRequestInput.shared.instruction ?? ""
        }else{
            instructionImage = nil
        }
        
        if SendRequestInput.shared.isSchedule ?? false {
            param[XuberInput.schedule_date] = SendRequestInput.shared.scheduleDate ?? ""
            param[XuberInput.schedule_time] = SendRequestInput.shared.scheduleTime ?? ""
        }
        xuberPresenter?.sendRequest(param: param, imageData: instructionImage)
        
    }
    
    func validation() -> Bool {
        if SendRequestInput.shared.allowImage ?? false {
            if SendRequestInput.shared.instructionImage == nil {
                ToastManager.show(title: XuberConstant.chooseInstructionImage.localized, state: .error)
                return false
            }
            if SendRequestInput.shared.instruction == nil {
                ToastManager.show(title: XuberConstant.instructionEmpty.localized, state: .error)
                return false
            }
        }
        return true
    }
    
    // change payment before sending request
    func changePaymentButtonTapped() {
        
        let paymentVC = AccountRouter.accountStoryboard.instantiateViewController(withIdentifier: AccountConstant.PaymentSelectViewController) as! PaymentSelectViewController
        paymentVC.isChangePayment = true
        paymentVC.onClickPayment = { [weak self] (type,cardEntity) in
            guard let self = self else {
                return
            }
            SendRequestInput.shared.paymentMode = type.rawValue
            let cell:XuberPaymentSelectionCell = self.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! XuberPaymentSelectionCell
            if type == .CARD {
                cell.cardOrCashLabel.text = Constant.cardPrefix+(cardEntity?.last_four ?? "")
            }else{
                cell.cardOrCashLabel.text = type.rawValue
            }
            cell.paymentImage.image = type.image
        }
        
        self.navigationController?.pushViewController(paymentVC, animated: true)
    }
    
    func showViewCoupon() {
        if self.couponView == nil, let couponView = Bundle.main.loadNibNamed(Constant.CouponView, owner: self, options: [:])?.first as? CouponView {
            let viewHeight = (self.view.frame.height/100)*30 //30% of view
            couponView.frame = CGRect(origin: CGPoint(x: 0, y: self.view.frame.height-viewHeight), size: CGSize(width: self.view.frame.width, height: viewHeight))
            self.couponView = couponView
            //            self.view.addSubview(couponView)
            couponView.setValues(color: .xuberColor)
            couponView.show(with: .bottom, completion: nil)
            self.couponView?.set(values: self.promoCodeData)
            if let selectedCoupon = selectedPromo {
                self.couponView?.isSelectedPromo(values: selectedCoupon)
            }
            showDimView(view: couponView)
        }
        
        // selected coupon stored in globally
        self.couponView?.applyCouponAction = { [weak self] selectedPromocode in
            guard let self = self else {
                return
            }
            self.couponView?.superview?.dismissView(onCompletion: {
                self.couponView = nil
            })
            self.selectedPromo = selectedPromocode
             let cell:XuberApplyCouponCell = self.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! XuberApplyCouponCell
            if self.promoCodeData.count == 0 || self.selectedPromo == nil {
               SendRequestInput.shared.promocode_id = 0
                cell.applyButton.setTitle(Constant.apply.localized, for: .normal)
                cell.couponTextField.text = ""
            }else{
                cell.couponTextField.text = selectedPromocode?.promo_code ?? ""
                cell.applyButton.setTitle(Constant.remove.localized, for: .normal)
                SendRequestInput.shared.promocode_id = selectedPromocode?.id
            }
        }
    }
    
    func showDimView(view: UIView) {
        let dimView = UIView(frame: self.view.frame)
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        dimView.addSubview(view)
        self.view.addSubview(dimView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.couponView != nil {
            self.couponView?.superview?.dismissView(onCompletion: {
                self.couponView = nil
            })
        }
    }
}

extension XuberConfirmBookingController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 40
        }else if (indexPath.row == 3) && !(SendRequestInput.shared.allowImage ?? false) {
            return 0
        }else if (indexPath.row == 2) && (self.promoCodeData.count == 0){
            return 0
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed(XuberConstant.XuberServiceDetailHeader, owner: self, options: [:])?.first as? XuberServiceDetailHeader
        headerView?.priceLabel.text = XuberConstant.price.localized+(SendRequestInput.shared.fareType?.fareString ?? "")
        headerView?.qtyLabel.isHidden = !(SendRequestInput.shared.isAllowQuantity ?? false)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("##\(indexPath.section) == \(indexPath.row)")
        
        if indexPath.row == 0 {
            let cell: XuberServiceDetailCell = self.tableView.dequeueReusableCell(withIdentifier: XuberConstant.XuberServiceDetailCell, for: indexPath) as! XuberServiceDetailCell
            cell.priceLabelLabel.text = SendRequestInput.shared.price?.setCurrency()
            cell.serviceListLabel.text = SendRequestInput.shared.selectedSubService
            cell.qtyLabel.text = SendRequestInput.shared.quantity?.toString()
            cell.qtyLabel.isHidden = !(SendRequestInput.shared.isAllowQuantity ?? false)
            //            cell.layoutIfNeeded()
            return cell
        } else if indexPath.row == 1 {
            let cell: XuberPaymentSelectionCell = self.tableView.dequeueReusableCell(withIdentifier: XuberConstant.XuberPaymentSelectionCell, for: indexPath) as! XuberPaymentSelectionCell
            cell.cardOrCashLabel.text = PaymentType.CASH.rawValue
            cell.paymentImage.image = PaymentType.CASH.image
            cell.onTapChange = { [weak self] in
                guard let self = self else {
                    return
                }
                self.changePaymentButtonTapped()
            }
            if let walletBalance = AppManager.shared.getUserDetails()?.wallet_balance, walletBalance > 0 {
                cell.walletButton.setTitle(Constant.wallet.localized+" (\(String(describing: walletBalance.setCurrency())))", for: .normal)
            }else{
                cell.walletButton.superview?.isHidden = true
            }
            return cell
        }else if indexPath.row == 2 {
            let cell: XuberApplyCouponCell = self.tableView.dequeueReusableCell(withIdentifier: XuberConstant.XuberApplyCouponCell, for: indexPath) as! XuberApplyCouponCell
            cell.onTapCouponCode = { [weak self] in
                guard let self = self else {
                    return
                }
                self.showViewCoupon()
            }
            cell.onTapApply = { [weak self] tag in
                guard let self = self else {
                    return
                }
                if tag == 1 {
                    SendRequestInput.shared.promocode_id = 0
                    cell.applyButton.setTitle(Constant.apply.localized, for: .normal)
                    cell.couponTextField.text = ""
                    self.selectedPromo = nil
                }else{
                    self.showViewCoupon()
                }
            }
            return cell
        }else{
            let cell: XuberInstructionCell = self.tableView.dequeueReusableCell(withIdentifier: XuberConstant.XuberInstructionCell, for: indexPath) as! XuberInstructionCell
            cell.onTapImage = { [weak self] in
                guard let self = self else {
                    return
                }
                self.showImage(with: { (image) in
                    cell.instructionImage.image = image
                    SendRequestInput.shared.instructionImage = image
                })
            }
            
            return cell
        }
    }
}

extension XuberConfirmBookingController: XuberPresenterToXuberViewProtocol {
    
    func sendRequest(requestEntity: XuberRequestEntity) {
        
        if requestEntity.request?.message == "Schedule request created!" {
            ToastManager.show(title: requestEntity.message ?? "", state: .success)
            let vc = HomeRouter.homeStoryboard.instantiateViewController(withIdentifier: HomeConstant.VHomeViewController) as! HomeViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = XuberRouter.xuberStoryboard.instantiateViewController(withIdentifier: XuberConstant.XuberHomeController) as! XuberHomeController
            XCurrentLocation.shared.latitude = 0
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    func getPromocode(promocodeEntity: PromocodeEntity) {
        self.promoCodeData = promocodeEntity.responseData ?? []
    }
}
