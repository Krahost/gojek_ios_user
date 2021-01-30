//
//  FoodieCartViewController.swift
//  GoJekUser
//
//  Created by Thiru on 07/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class FoodieCartViewController: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var cartListTableView: UITableView!
    @IBOutlet weak var scheduleButton: UIButton!
    @IBOutlet weak var placeOrderButtton: UIButton!
    @IBOutlet weak var bottomView: UIStackView!
    @IBOutlet weak var labelItemNotAvailable: UILabel!

    var ScheduleView: FoodieScheduleTimeView!
    var addNoteView: FoodieAddNoteView!
    var orderPlacePoupView: OrderPlacePopup!
    var foodieCheckOut: FoodieCheckoutResponseData?
    var foodieAddOnsView: FoodieAddOns?
    
    var foodieCartList: CartListResponse?
    var foodieProductList: [Cart] = Array()
    var priceSymbol = AppManager.shared.getUserDetails()
    var couponView: CouponView?
    var promoCodeListArr:[PromocodeData] = []
    var addressDetail:AddressResponseData!
    
    var addonsArr:[String] = []
    var addressId: Int?
    var paymentMode: String = "CASH"
    var isWallet = 0
    var selectedCardId = "0"
    var doorStep = 0

    var orderType = ""
    var promoCodeId = 0
    let userDetail = AppManager.shared.getUserDetails()
    var addressDatasource: [AddressResponseData] = Array()
    var selectedPromo:PromocodeData?

    
    // View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = FoodieConstant.cart.localized
        initialLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.hideTabBar()
    }
}

//MARK: - LocalMethod

extension FoodieCartViewController {
    
    private func initialLoad() {
        self.setNavigationTitle()
        self.setLeftBarButtonWith(color: .blackColor)
        self.view.backgroundColor = .veryLightGray
        DispatchQueue.main.async {
            self.scheduleButton.setCornerRadiuswithValue(value: 10)
            self.placeOrderButtton.setCornerRadiuswithValue(value: 10)
        }
        placeOrderButtton.backgroundColor = .foodieColor
        placeOrderButtton.setTitle(FoodieConstant.placeOrder.localized.uppercased(), for: .normal)
        placeOrderButtton.addTarget(self, action: #selector(placeOrderAction), for: .touchUpInside)
        placeOrderButtton.setTitleColor(.white, for: .normal)
        placeOrderButtton.titleLabel?.font = UIFont.setCustomFont(name: .medium, size: .x18)
        self.cartListTableView.register(UINib(nibName: FoodieConstant.FoodieItemsTableViewCell, bundle: nil), forCellReuseIdentifier: FoodieConstant.FoodieItemsTableViewCell)
        self.cartListTableView.register(UINib(nibName: FoodieConstant.CartPageTableViewCell, bundle: nil), forCellReuseIdentifier: FoodieConstant.CartPageTableViewCell)
        self.cartListTableView.register(UINib(nibName: FoodieConstant.FoodieDeliveryTableViewCell, bundle: nil), forCellReuseIdentifier: FoodieConstant.FoodieDeliveryTableViewCell)
        
        self.cartListTableView.backgroundColor = .veryLightGray
        self.view.backgroundColor = .veryLightGray
        labelItemNotAvailable.font = UIFont.setCustomFont(name: .medium, size: .x12)
        labelItemNotAvailable.textColor = .lightGray
        labelItemNotAvailable.isHidden = true
        labelItemNotAvailable.text = FoodieConstant.checkoutItem.localized
        self.scheduleButton.isHidden = true
        //Get Address List
        self.foodiePresenter?.getSavedAddress()
        //API Call
        var param = ["order_type":orderType]
      //  if(orderType == orderByType.delivery.rawValue)
                    //{
                       param[FoodieConstant.userAddressId] = "\(addressId ?? 0)"
                  // }
        
        self.foodiePresenter?.getCartList(param: param)
        
        self.foodiePresenter?.getSavedAddress()


        
        self.orderType = orderByType.delivery.rawValue

        setDarkMode()
    }
    
    func setDarkMode(){
        self.view.backgroundColor = .backgroundColor
        self.cartListTableView.backgroundColor = .backgroundColor
    }
    
    
    private func showDimView(view: UIView) {
        let dimView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        let dimViewTap = UITapGestureRecognizer(target: self, action: #selector(tapDimView))
        dimView.addGestureRecognizer(dimViewTap)
        dimView.addSubview(view)
        self.view.addSubview(dimView)
    }
    
    @objc func tapDimView() {
        if couponView != nil {
            couponView?.superview?.removeFromSuperview() // dimview
            couponView?.dismissView(onCompletion: {
                self.couponView = nil
            })
        }
    }
    
    private func navigateToManageAddressView() {
        let manageAddressController = AccountRouter.accountStoryboard.instantiateViewController(withIdentifier: AccountConstant.ManageAddressController) as! ManageAddressController
        manageAddressController.delegate = self
        manageAddressController.isFromCartView = true
        self.navigationController?.pushViewController(manageAddressController, animated: true)
    }
    
    private func navigateToPaymetView() {
        let paymentVC = AccountRouter.accountStoryboard.instantiateViewController(withIdentifier: AccountConstant.PaymentSelectViewController) as! PaymentSelectViewController
        paymentVC.isChangePayment = true
        paymentVC.onClickPayment = { [weak self] (type,cardEntity) in
            guard let self = self else {
                return
            }
            let cell = self.cartListTableView.cellForRow(at: [2,0]) as? FoodieDeliveryTableViewCell
            cell?.paymentTypeLabel.text = type.rawValue
            if type == .CARD {
                cell?.cardLabel.text = Constant.cardPrefix + (cardEntity?.last_four ?? "")
                self.selectedCardId = cardEntity?.card_id ?? "0"
                self.paymentMode = "CARD"
                
            }else{
                self.paymentMode = "CASH"
                cell?.cardLabel.text = ""
            }
            

            if self.orderType == orderByType.delivery.rawValue &&  self.paymentMode == "CARD" {
                cell?.doorStepButton.isHidden = false
                      }else{
                cell?.doorStepButton.isHidden = true

                      }
        }
        self.navigationController?.pushViewController(paymentVC, animated: true)
    }
    
    private func updateCartDetailView() {
        //Display tableview data
        self.foodieProductList = foodieCartList?.carts ?? []
        labelItemNotAvailable.isHidden = true
        placeOrderButtton.setTitle(FoodieConstant.placeOrder.localized.uppercased(), for: .normal)
        for item in foodieProductList {
            if item.product?.status == 0 {
                labelItemNotAvailable.isHidden = false
                placeOrderButtton.setTitle(FoodieConstant.itemNotAvail.localized.uppercased(), for: .normal)
            }
        }
     UIView.transition(with: cartListTableView,
     duration: 0.35,
     options: .curveEaseIn,
     animations: { self.cartListTableView.reloadData() })
        
        if let count = foodieCartList?.carts?.count, count>0 {
            self.bottomView.isHidden = false
            cartListTableView.backgroundView = nil
            
        }
        else {
            self.bottomView.isHidden = true
            cartListTableView.setBackgroundImageAndTitle(imageName: FoodieConstant.cauldron, title: FoodieConstant.cartEmpty.localized,tintColor: .black)
        }
    }
    
    private func placeOrderSuccess() {
        if self.orderPlacePoupView == nil {
            self.orderPlacePoupView = Bundle.main.loadNibNamed(FoodieConstant.OrderPlacePopup, owner: self, options: [:])?.first as? OrderPlacePopup
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            self.orderPlacePoupView.frame = CGRect(x: 0, y: 0, width: (window?.frame.width)!, height: (window?.frame.height)!)
            self.orderPlacePoupView.showMessage(orderID: self.foodieCheckOut?.store_order_invoice_id ?? "")
            window?.addSubview(self.orderPlacePoupView)
            
            self.orderPlacePoupView?.show(with: .bottom, completion: nil)
        }
        
        self.orderPlacePoupView.onClickClose = { [weak self] in
            guard let self = self else {
                return
            }
            self.orderPlacePoupView.removeFromSuperview()
            self.orderPlacePoupView = nil
            let foodiecartVC = FoodieRouter.foodieStoryboard.instantiateViewController(withIdentifier: FoodieConstant.FoodieOrderStatusViewController) as! FoodieOrderStatusViewController
            orderRequestId = self.foodieCheckOut?.id ?? 0
            self.navigationController?.pushViewController(foodiecartVC, animated: true)
        }
    }
}

extension FoodieCartViewController {
    
    @objc func placeOrderAction() {
         if addressId == nil && self.orderType == orderByType.delivery.rawValue {
            AppAlert.shared.simpleAlert(view: self, title: FoodieConstant.Address.localized, message: nil)
            
        }
        else {
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            let dateresult = formatter.string(from: date)
      

            var param: Parameters = [FoodieConstant.Pwallet: isWallet,
                                     FoodieConstant.paymentMode: paymentMode,
                                     FoodieConstant.orderType: orderType,
                                     FoodieConstant.Pleave_at_door:doorStep ]
            
            if foodieCartList?.storeType != FoodieConstant.food {
                param[FoodieConstant.deliveryDate] = dateresult
            }
            
            if(orderType == orderByType.delivery.rawValue)
            {
                param[FoodieConstant.userAddressId] = addressId!
            }

            
            if promoCodeId != 0 {
                param[FoodieConstant.promocodeId] = promoCodeId
                
            }
            if selectedCardId != "0" {
                param[FoodieConstant.cardId] = selectedCardId
            }
            
            self.foodiePresenter?.postOrderCheckout(param: param)
        }
       
    }
    
    
    @objc func addNoteViewAction() {
        
        if self.addNoteView == nil {
            self.addNoteView = Bundle.main.loadNibNamed(FoodieConstant.FoodieAddNoteView, owner: self, options: [:])?.first as? FoodieAddNoteView
            
            self.addNoteView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            
            self.view.addSubview(self.addNoteView!)
            self.addNoteView?.show(with: .bottom, completion: nil)
        }
        self.addNoteView.onClickClose = { [weak self] in
            guard let self = self else {
                return
            }
            self.addNoteView.removeFromSuperview()
            self.addNoteView = nil
        }
        self.addNoteView.onClickSubmit = { [weak self] in
            guard let self = self else {
                return
            }
            self.addNoteView.removeFromSuperview()
            self.addNoteView = nil
            // self.headerView.isRemoveNote = true
        }
    }
}

//MARK: - UITableViewDataSource
extension FoodieCartViewController: ManageAddressDelegate {
    func addressValue(addressArr: [AddressResponseData]) {
        print("Hello")
        let cell = self.cartListTableView.cellForRow(at: [2,0]) as? FoodieDeliveryTableViewCell
     
        if addressArr.count == 0 {
            cell?.addressTypeLabel.text = Constant.noSavedAddress.localized
            cell?.addressStringLabel.text = .empty
            cell?.addressChangeButton.setTitle(FoodieConstant.add.localized.uppercased(), for: .normal)
            var param = ["order_type":self.orderType]
                                                      if(self.orderType == orderByType.delivery.rawValue)
                                                                             {
                                                                              param[FoodieConstant.userAddressId] = "0"
                                                                             }
                                                                   self.foodiePresenter?.getCartList(param: param)
        }else{
            for i in 0..<addressArr.count {
                let address = addressArr[i]
                if address.id == self.addressId {
                    cell?.addressTypeLabel.text = address.address_type ?? FoodieConstant.homeAddress.localized
                    cell?.addressStringLabel.text = address.locationAddress()
                    cell?.addressChangeButton.setTitle(FoodieConstant.change.localized.uppercased(), for: .normal)
                    var param = ["order_type":self.orderType]
                               if(self.orderType == orderByType.delivery.rawValue)
                                                      {
                                                       param[FoodieConstant.userAddressId] = "\(self.addressId ?? 0)"
                                                      }
                                            self.foodiePresenter?.getCartList(param: param)
                    
                }else{
                    var param = ["order_type":self.orderType]
                                            if(self.orderType == orderByType.delivery.rawValue)
                                                                   {
                                                                    param[FoodieConstant.userAddressId] = "0"
                                                                   }
                                                         self.foodiePresenter?.getCartList(param: param)
                    cell?.addressTypeLabel.text = Constant.noSavedAddress.localized
                    cell?.addressStringLabel.text = .empty
                    cell?.addressChangeButton.setTitle(FoodieConstant.add.localized.uppercased(), for: .normal)
                }
            }
        }
    }
    
    func selectedAddress(address: AddressResponseData) {
        self.addressId = address.id
        self.addressDetail = address
        let cell = self.cartListTableView.cellForRow(at: [2,0]) as? FoodieDeliveryTableViewCell
        var param = ["order_type":self.orderType]
                    if(self.orderType == orderByType.delivery.rawValue)
                                           {
                                            param[FoodieConstant.userAddressId] = "\(self.addressId ?? 0)"
                                           }
                                 self.foodiePresenter?.getCartList(param: param)
        DispatchQueue.main.async {
            cell?.addressTypeLabel.text = address.address_type ?? FoodieConstant.homeAddress.localized
            cell?.addressStringLabel.text = address.locationAddress()
        }
        if  cell?.addressStringLabel.text == "" {
            cell?.addressChangeButton.setTitle(FoodieConstant.add.localized.uppercased(), for: .normal)
        }else{
            cell?.addressChangeButton.setTitle(FoodieConstant.change.localized.uppercased(), for: .normal)
            
        }
    }
}

//MARK: - UITableViewDataSource
extension FoodieCartViewController: UITableViewDataSource {
    @objc func tapDeleteAction(sender:UIButton) {
        let productList = foodieProductList[sender.tag]
     //   let productDetail = productList.product
        let param: Parameters = [FoodieConstant.cartId: productList.id ?? 0]
                  self.foodiePresenter?.postRemoveCart(param: param)
           }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = foodieCartList?.carts?.count, count>0 {
            if section == 0  {
                return 1
            }else if section == 1  {
                return foodieProductList.count
            }else{
                return 1
                
            }
        }
        return 0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: FoodieConstant.CartPageTableViewCell, for: indexPath) as! CartPageTableViewCell
            
            let shopDetail = foodieCartList?.carts?.first?.store
            DispatchQueue.main.async {
                cell.nameLabel.text = shopDetail?.store_name ?? ""
                cell.descrLabel.text = shopDetail?.storetype?.name ?? ""
                let rateValue = Double(shopDetail?.rating ?? 0).rounded(.awayFromZero)
                cell.ratingLabel.text = rateValue.toString()
                
                
                cell.reastaurantLogoImageView.sd_setImage(with: URL(string: shopDetail?.picture ?? "") , placeholderImage:#imageLiteral(resourceName: "ImagePlaceHolder"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                                                        // Perform operation.
                                                        if (error != nil) {
                                                            // Failed to load image
                                                          cell.reastaurantLogoImageView.image = #imageLiteral(resourceName: "ImagePlaceHolder")
                                                        } else {
                                                            // Successful in loading image
                                                          cell.reastaurantLogoImageView.image = image
                                                        }
                                                    })
                
            }
            return cell
        }else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: FoodieConstant.FoodieItemsTableViewCell, for: indexPath) as! FoodieItemsTableViewCell
            cell.itemsaddView.tag = indexPath.row
            if #available(iOS 13.0, *) {
                cell.backgroundColor = .systemBackground
            } else {
                // Fallback on earlier versions
                cell.backgroundColor = .veryLightGray

            }
            cell.backgroundColor = .backgroundColor
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.itemsaddView.delegate = self
            cell.itemsaddView.tag = indexPath.row
            cell.customizeButton.tag = indexPath.row
            cell.foodieAddonsgaDelegate = self
            let productList = foodieProductList[indexPath.row]
            
            let productDetail = productList.product
            cell.itemNameLabel.text = productDetail?.item_name
            cell.delBtn.tag = indexPath.row
            cell.delBtn.addTarget(self, action: #selector(tapDeleteAction), for: .touchUpInside)
            if productDetail?.is_veg == "Non Veg"
                  {
                     cell.isVeg  = false
                  }else{
                      cell.isVeg  = true

                  }
            
            if productDetail?.quantity != nil && productDetail?.quantity != 0 {
                       cell.qtyLabel.isHidden = false
                cell.qtyLabel.text = "Qty \(String(productDetail?.quantity ?? 0))"
                if productDetail?.unit != nil  {
                    cell.qtyLabel.text = (cell.qtyLabel.text ?? "") + " " + "\(String(productDetail?.unit?.name ?? ""))"
                   }
                   }else{
                       cell.qtyLabel.isHidden = true
                   }
            
            if productDetail?.status == 0 {
                cell.itemDisableVw.isHidden = false
                cell.overView.isHidden = true
               
            }else{
                cell.itemDisableVw.isHidden = true
                cell.overView.isHidden = false
            }
            
            cell.itemsaddView.count = productList.quantity ?? 0
            cell.priceLabel.text = "\(self.priceSymbol?.currency ?? "") \(productList.totalItemPrice ?? 0.0)"
            
            
            cell.itemImageView.sd_setImage(with: URL(string: productDetail?.picture ?? ""), placeholderImage:#imageLiteral(resourceName: "ImagePlaceHolder"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                                                                   // Perform operation.
                                                                   if (error != nil) {
                                                                       // Failed to load image
                                                                     cell.itemImageView.image = #imageLiteral(resourceName: "ImagePlaceHolder")
                                                                   } else {
                                                                       // Successful in loading image
                                                                     cell.itemImageView.image = image
                                                                   }
                                                               })
            
            
            if productList.cartaddon?.count == 0 {
                cell.customizableLabel.isHidden = true
                cell.addonsLabel.isHidden = true
                cell.customizeButton.isHidden = true
            }else{
                cell.addonsLabel.isHidden = false
                cell.customizableLabel.isHidden = false
                cell.customizeButton.isHidden = false
                
            }
            let font = UIFont.setCustomFont(name: .medium, size: .x14)

            let cartDetails = self.getCartAddOnValue(values: productList.cartaddon ?? [])
            let height = cell.heightForView(text: cartDetails, font: font, width: 100.0)
            cell.heightConstraint.constant = height + 10
            cell.addonsLabel.text = cartDetails
            
            
            
            cell.layoutIfNeeded()
            
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: FoodieConstant.FoodieDeliveryTableViewCell, for: indexPath) as! FoodieDeliveryTableViewCell
            
            let wallet = AppManager.shared.getUserDetails()?.wallet_balance
            if (wallet  ?? 0) > 0 {
                cell.useWalletAmount.setTitle(FoodieConstant.useWallet.localized + "(" + (wallet?.setCurrency().localized ?? "") + ")", for: .normal)
            }else{
                cell.useWalletAmount.isHidden = true
            }
            
            DispatchQueue.main.async {
                cell.addressTypeLabel.text = self.addressDetail?.address_type ?? Constant.noSavedAddress.localized
                cell.addressStringLabel.text = self.addressDetail?.locationAddress()
            }
            if self.addressDetail != nil {
                cell.addressChangeButton.setTitle(FoodieConstant.change.localized.uppercased(), for: .normal)
                
            }else{
                cell.addressChangeButton.setTitle(FoodieConstant.add.localized.uppercased(), for: .normal)
                
            }
            
            
            if orderType == orderByType.delivery.rawValue &&  self.paymentMode == "CARD" {
                cell.doorStepButton.isHidden = false
            }else{
                cell.doorStepButton.isHidden = true

            }
            
            if self.orderType == orderByType.delivery.rawValue {
                cell.deliveryAddress.isHidden = false
                cell.deliveryChargeView.isHidden = false
                cell.deliveryImageView.image = UIImage(named: Constant.circleFullImage)?.imageTintColor(color1: .foodieColor)
                cell.takeawayImageView.image = UIImage(named: Constant.circleImage)?.imageTintColor(color1: .foodieColor)
            }else{
                cell.deliveryAddress.isHidden = true
                cell.deliveryChargeView.isHidden = true
                cell.deliveryImageView.image = UIImage(named: Constant.circleImage)?.imageTintColor(color1: .foodieColor)
                cell.takeawayImageView.image = UIImage(named: Constant.circleFullImage)?.imageTintColor(color1: .foodieColor)
            }
            
            let currency = self.userDetail?.currency ?? ""
            cell.discountValueLabel.text = "-\(currency)\(self.foodieCartList?.shopDiscount ?? 0)"
  
            cell.totalValueLabel.text = "\(currency)\(self.foodieCartList?.payable ?? 0)"
            cell.itemtotalValueLbl.text = "\(currency)\(self.foodieCartList?.totalItemPrice ?? 0.0)"
            cell.deliveryValueLabel.text = "\(currency)\(self.foodieCartList?.deliveryCharges ?? 0.0)"
            cell.paymentTypeLabel.text  = FoodieConstant.cash.localized
            cell.cardLabel.text = ""
            cell.taxLabelValue.text = "\(currency)\(self.foodieCartList?.shopGstAmount ?? 0)"
            cell.storePackageAmountValue.text = "\(currency)\(self.foodieCartList?.shopPackageCharge ?? 0.0)"
            cell.promoCodeView.isHidden = true
            cell.deliveryViewButtonAction = { [weak self] action in
                guard let self = self else {
                    return
                }
                switch action {
                case DeliveryViewAction.addressChange:
                    self.navigateToManageAddressView()
                    break
                case DeliveryViewAction.paymentChange:
                    self.navigateToPaymetView()
                    break
                case DeliveryViewAction.couponChange:
                    self.scheduleButton.isHidden = false
                    break
                    
                case DeliveryViewAction.deliveryType:
                    self.orderType = orderByType.delivery.rawValue
                    cell.deliveryAddress.isHidden = false
                    cell.deliveryChargeView.isHidden = false
                
                    cell.deliveryImageView.image = UIImage(named: Constant.circleFullImage)?.imageTintColor(color1: .foodieColor)
                    cell.takeawayImageView.image = UIImage(named: Constant.circleImage)?.imageTintColor(color1: .foodieColor)
                    if self.orderType == orderByType.delivery.rawValue &&  self.paymentMode == "CARD" {
                                  cell.doorStepButton.isHidden = false
                              }else{
                                  cell.doorStepButton.isHidden = true

                              }
                    cell.updateConstraints()
                     self.view.layoutIfNeeded()
                    self.cartListTableView.reloadData()

                  //  self.paymentMode = "CASH"
                    var param = ["order_type":self.orderType]
                    if(self.orderType == orderByType.delivery.rawValue)
                                           {
                                            param[FoodieConstant.userAddressId] = "\(self.addressId ?? 0)"
                                           }
                                 self.foodiePresenter?.getCartList(param: param)
                    break
                case DeliveryViewAction.takeAwayType:
                    self.orderType = orderByType.takeAway.rawValue
                    cell.deliveryAddress.isHidden = true
                    cell.deliveryChargeView.isHidden = true
                    cell.deliveryImageView.image = UIImage(named: Constant.circleImage)?.imageTintColor(color1: .foodieColor)
                    cell.takeawayImageView.image = UIImage(named: Constant.circleFullImage)?.imageTintColor(color1: .foodieColor)
                    if self.orderType == orderByType.delivery.rawValue &&  self.paymentMode == "CARD" {
                                  cell.doorStepButton.isHidden = false
                              }else{
                                  cell.doorStepButton.isHidden = true

                              }
                    cell.updateConstraints()
                     self.view.layoutIfNeeded()
                    self.cartListTableView.reloadData()

                    var param = ["order_type":self.orderType]
                    if(self.orderType == orderByType.delivery.rawValue)
                                           {
                                            param[FoodieConstant.userAddressId] = "\(self.addressId ?? 0)"
                                           }
                                 self.foodiePresenter?.getCartList(param: param)

                    break
                case DeliveryViewAction.useWallet:
                    if cell.useWalletAmount.imageView?.image?.isEqual(to: UIImage(named: Constant.squareFill) ?? UIImage()) ?? false {
                        self.isWallet = 0
                        cell.useWalletAmount.setImage(UIImage(named: Constant.sqaureEmpty), for: .normal)
                    }else{
                        self.isWallet = 1
                        cell.useWalletAmount.setImage(UIImage(named: Constant.squareFill), for: .normal)
                    }
                    break
                case DeliveryViewAction.doorStep:
                    if cell.doorStepButton.imageView?.image?.isEqual(to: UIImage(named: Constant.squareFill) ?? UIImage()) ?? false {
                        self.doorStep = 0
                        cell.doorStepButton.setImage(UIImage(named: Constant.sqaureEmpty), for: .normal)
                    }else{
                        self.doorStep = 1
                        cell.doorStepButton.setImage(UIImage(named: Constant.squareFill), for: .normal)
                    }
                    break
                case DeliveryViewAction.showCoupon:
                    if self.couponView == nil, let couponView = Bundle.main.loadNibNamed(Constant.CouponView, owner: self, options: [:])?.first as? CouponView {
                        let viewHeight = ((self.view.frame.height )/100)*30 //30% of view
                        couponView.frame = CGRect(origin: CGPoint(x: 0, y: (self.view.frame.height)-viewHeight), size: CGSize(width: (self.view.frame.width), height: viewHeight))
                        self.couponView = couponView
                        couponView.setValues(color: .foodieColor)
                        couponView.set(values: self.promoCodeListArr )
                        couponView.show(with: .bottom, completion: nil)
                        if let selectedCoupon = self.selectedPromo {
                            self.couponView?.isSelectedPromo(values: selectedCoupon)
                        }
                        self.showDimView(view: couponView)
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
                    
                        self.promoCodeId = selectedPromocode?.id ?? 0
                        self.foodiePresenter?.getPromoCodeCartList(promoCodeStr: selectedPromocode?.id?.toString() ?? "")
                       
                    }
                    break
                }
            }
            return cell
        }
    }
    
    func reload(tableView: UITableView) {

        let contentOffset = tableView.contentOffset
        tableView.reloadData()
        tableView.layoutIfNeeded()
        tableView.setContentOffset(contentOffset, animated: false)

    }
    
    func getCartAddOnValue(values: [Cartaddon]) -> (String) {
        var cartName:String = ""
        for cart in values {
            cartName = cartName + (cart.addon_name ?? "") + ","
        }
        cartName = String(cartName.dropLast())
        return (cartName)
    }
}

//MARK: - UITableviewDelegate
extension FoodieCartViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 130
        }
        return UITableView.automaticDimension
    }
}


//MARK: - PlusMinusDelegates
extension FoodieCartViewController: PlusMinusDelegates {
    
    func countChange(count: Int, tag: Int,isplus: Bool) {
        print("Count \(count) Tag \(tag)")
        let productDetail = foodieProductList[tag]
        let cell:FoodieItemsTableViewCell = self.cartListTableView.cellForRow(at: IndexPath(row: tag, section: 1)) as? FoodieItemsTableViewCell ?? FoodieItemsTableViewCell()
        
        if isplus {
            cell.itemsaddView.count = cell.itemsaddView.count + 1
            
        }else{
            cell.itemsaddView.count = cell.itemsaddView.count - 1
        }
        
        if cell.itemsaddView.count == 0 {
            let param: Parameters = [FoodieConstant.cartId: productDetail.id!]
            self.foodiePresenter?.postRemoveCart(param: param)
        }else {
            let param: Parameters = [FoodieConstant.itemId: (productDetail.product?.id ?? 0),
                                     FoodieConstant.cartId: productDetail.id ?? 0,
                                     FoodieConstant.qty: cell.itemsaddView.count,
                                     FoodieConstant.repeatVal: 1,
                                     FoodieConstant.Pcustomize: 0]
            self.foodiePresenter?.postAddToCart(param: param)
        }
    }
}


//MARK: - FilterViewDelegate
extension FoodieCartViewController: CartHeaderViewDelegate {
    
    func addRemoveNote() {
    }
    
    func editNote() {
        addNoteViewAction()
    }
}

//MARK: - FoodiePresenterToFoodieViewProtocol
extension FoodieCartViewController: FoodiePresenterToFoodieViewProtocol {
    
    func getCartListResponse(cartListEntity: FoodieCartListEntity) {
        self.foodieCartList = cartListEntity.responseData
        self.updateCartDetailView()
        let params:Parameters = [XuberInput.totalAmount : cartListEntity.responseData?.payable ?? 0,XuberInput.storeID : foodieCartList?.carts?.first?.storeId ?? 0]
        self.foodiePresenter?.getPromoCodeList(param: params)
    }
    
    func postAddToCartResponse(addCartEntity: FoodieCartListEntity) {
        self.foodieCartList = addCartEntity.responseData
        //API Call
        var param = ["order_type":orderType]
        if(orderType == orderByType.delivery.rawValue)
                        {
                            param[FoodieConstant.userAddressId] = "\(addressId ?? 0)"
                        }
        self.foodiePresenter?.getCartList(param: param)
        self.updateCartDetailView()
    }
    
    func postRemoveCartResponse(cartListEntity: FoodieCartListEntity) {
        self.foodieCartList = cartListEntity.responseData
        //API Call
        var param = ["order_type":orderType]
        if(orderType == orderByType.delivery.rawValue)
                        {
                            param[FoodieConstant.userAddressId] = "\(addressId ?? 0)"
                        }
              self.foodiePresenter?.getCartList(param: param)
        self.updateCartDetailView()
    }
    
    func postOrderCheckoutResponse(checkoutEntity: FoodieCheckoutEntity) {
        foodieCheckOut = checkoutEntity.responseData
        if foodieCheckOut == nil{
            if checkoutEntity.statusCode == "205" {
                //API Call
                var param = ["order_type":orderType]
                if(orderType == orderByType.delivery.rawValue)
                                {
                                    param[FoodieConstant.userAddressId] = "\(addressId ?? 0)"
                                }
                self.foodiePresenter?.getCartList(param: param)
                self.updateCartDetailView()
                
                AppAlert.shared.simpleAlert(view: self, title: "", message: FoodieConstant.checkoutItem.localized,buttonTitle: Constant.SOk.localized)

            }else{
                // ToastManager.show(title: checkoutEntity.message ?? "", state: .error)
                AppAlert.shared.simpleAlert(view: self, title: "", message: (checkoutEntity.message ?? "").localized,buttonTitle: Constant.SOk.localized)
                
            }
        }else{
            self.placeOrderSuccess()
        }
    }
    
    func getSavedAddressResponse(addressList: SavedAddressEntity) {
        let addressList = addressList.responseData ?? []
        if let count = foodieCartList?.carts?.count, count>0 {
            
            
            addressDetail = addressList.first
            self.addressId = addressDetail?.id
            let cell = self.cartListTableView.cellForRow(at: [2,0]) as? FoodieDeliveryTableViewCell
            DispatchQueue.main.async {
                cell?.addressTypeLabel.text = self.addressDetail?.address_type ?? Constant.noSavedAddress.localized
                cell?.addressStringLabel.text = self.addressDetail?.locationAddress()
            }
            if self.addressDetail != nil {
                cell?.addressChangeButton.setTitle(FoodieConstant.change.localized.uppercased(), for: .normal)
                
            }else{
                cell?.addressChangeButton.setTitle(FoodieConstant.add.localized.uppercased(), for: .normal)
                
            }
           UIView.transition(with: cartListTableView,
            duration: 0.35,
            options: .curveEaseIn,
            animations: { self.cartListTableView.reloadData() })
        }
         var param = ["order_type":orderType]
          if(orderType == orderByType.delivery.rawValue)
                      {
                         param[FoodieConstant.userAddressId] = "\(addressId ?? 0)"
                     }
          self.foodiePresenter?.getCartList(param: param)
        
    }
    
    func getPromoCodeResponse(getPromoCodeResponse: PromocodeEntity) {
        self.promoCodeListArr = getPromoCodeResponse.responseData ?? []
        
        if let count = foodieCartList?.carts?.count, count>0 {
            
            let cell = cartListTableView.cellForRow(at: [2,0]) as? FoodieDeliveryTableViewCell
            
            if self.promoCodeListArr.count == 0 {
                cell?.couponOuterView.isHidden = true
            }else{
                cell?.couponOuterView.isHidden = false
            }
        }
        //Get Address List
    }
    
    func postPromoCodeCartResponse(cartListEntity: FoodieCartListEntity) {
        
        let cell = self.cartListTableView.cellForRow(at: [2,0]) as? FoodieDeliveryTableViewCell
        
        let currency = self.userDetail?.currency ?? ""
        
        if self.promoCodeListArr.count == 0 || cartListEntity.responseData?.promocodeAmount == 0.0 {
            cell?.viewCouponButton.setTitle(Constant.viewCoupon.localized.uppercased(), for: .normal)
            cell?.offerCouponAmt.isHidden = true
        }else{
            cell?.viewCouponButton.setTitle("-\(currency)\(cartListEntity.responseData?.promocodeAmount ?? 0)", for: .normal)
            cell?.offerCouponAmt.isHidden = false
        }
        
        
        
        cell?.totalValueLabel.text = "\(currency)\(cartListEntity.responseData?.payable ?? 0)"
        
    }
}
extension FoodieCartViewController : ShowAddonsDelegates {
    func addonsCustomize(tag: Int) {
        
        self.addOnsButton(tag: tag)
    }
}

extension FoodieCartViewController : FoodieAddOnsProtocol{
    func ondoneAction(addonsItem: NSMutableArray,indexPath:Int,tag:Int,isplus: Bool) {
        let cell:FoodieItemsTableViewCell = self.cartListTableView.cellForRow(at: IndexPath(row: tag, section: 1)) as? FoodieItemsTableViewCell ?? FoodieItemsTableViewCell()
        let productDetail = foodieProductList[tag]
        let cardId = productDetail.id ?? 0
        self.foodieAddOnsView?.dismissView(onCompletion: {
            self.foodieAddOnsView = nil
            var addOnsArr: [String] = []
            for i in 0..<addonsItem.count {
                if let addonsStr = addonsItem[i] as? String {
                    if !addonsStr.isEmpty {
                        addOnsArr.append(addonsStr)
                    }
                }
            }
            
            let addOnsStr = addOnsArr.joined(separator: ",")
            print(addOnsStr)
            
             if cardId != 0 {
                if cell.itemsaddView.count == 0 {
                    let param: Parameters = [FoodieConstant.cartId: cardId]
                    self.foodiePresenter?.postRemoveCart(param: param)
                }
                else {
                    let param: Parameters = [FoodieConstant.itemId: (productDetail.product?.id ?? 0),
                                             FoodieConstant.cartId: cardId,
                                             FoodieConstant.qty: cell.itemsaddView.count,
                                             FoodieConstant.addons: addOnsStr,
                                             FoodieConstant.repeatVal: 0,
                                             FoodieConstant.Pcustomize: 1]
                    self.foodiePresenter?.postAddToCart(param: param)
                }
            }
        })
    }
    
    func addOnsButton(tag: Int) { //count tag-cell tag
        if self.foodieAddOnsView == nil, let foodieAddOnsView = Bundle.main.loadNibNamed(FoodieConstant.FoodieAddOns, owner: self, options: [:])?.first as? FoodieAddOns {
            self.foodieAddOnsView?.addonsItem.removeAllObjects()
            foodieAddOnsView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.frame.width, height: self.view.frame.height))
            foodieAddOnsView.delegate = self
            self.foodieAddOnsView = foodieAddOnsView
            self.view.addSubview(foodieAddOnsView)
        }
        let productDetail = foodieProductList[tag]

        self.foodieAddOnsView?.tagCount = tag
        self.foodieAddOnsView?.isCartPage = true
        self.foodieAddOnsView?.CartAddonsArr = productDetail.cartaddon ?? []
        self.foodieAddOnsView?.AddonsArr = productDetail.product?.itemsaddon ?? []
        self.foodieAddOnsView?.itemNameLabel.text = productDetail.product?.item_name
        
        let addOnsCount = productDetail.product?.itemsaddon?.count ?? 0
               for _ in 0..<addOnsCount{
                   self.foodieAddOnsView?.addonsItem.add("")
                   
               }
        

        
        for i in 0..<(addOnsCount) {
            if let firstSuchElement = productDetail.cartaddon?.first(where: { $0.store_item_addons_id == productDetail.product?.itemsaddon?[i].id }) {
                print(firstSuchElement) // 4
                self.foodieAddOnsView?.addonsItem.replaceObject(at: i, with: productDetail.product?.itemsaddon?[i].id?.toString() ?? "")

            }else{
                self.foodieAddOnsView?.addonsItem.replaceObject(at: i, with: "")
            }
        }
        
        self.foodieAddOnsView?.onClickClose = { [weak self] in
            guard let self = self else {
                return
            }
            self.foodieAddOnsView?.dismissView(onCompletion: {
                self.foodieAddOnsView = nil
            })
        }
        

        
        
        self.foodieAddOnsView?.itemImageView.sd_setImage(with: URL(string: productDetail.product?.picture ?? ""), placeholderImage:UIImage.init(named: FoodieConstant.imagePlaceHolder),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
            // Perform operation.
            if (error != nil) {
                // Failed to load image
                self.foodieAddOnsView?.itemImageView.image = UIImage.init(named: FoodieConstant.imagePlaceHolder)
            } else {
                // Successful in loading image
                self.foodieAddOnsView?.itemImageView.image = image
            }
        })
        
        self.foodieAddOnsView?.itemPriceLabel.text = Double(productDetail.itemPrice ?? 0).setCurrency()
       
        self.foodieAddOnsView?.addOnsTableView.reloadData()
    }
}




