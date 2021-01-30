//
//  OrderDetailController.swift
//  GoJekUser
//
//  Created by Thiru on 26/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

class OrderDetailController: UIViewController {
    
    // Navigation view
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var backButtonView: UIView!
    @IBOutlet weak var orderIDLabel: UILabel!
    @IBOutlet weak var orderTypeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationTableView: UITableView!
    //Buttons view
    @IBOutlet weak var disputeButton: UIButton!
    @IBOutlet weak var viewReceiptButton: UIButton!
    @IBOutlet weak var bottomView: UIView!

    private var disputeStatusView : DisputeStatusView?
    private var receiptView: ReceiptView?
    
    var orderDetailData: OrderDetailReponseData?
    var selectedServiceType: ServiceType = .trips
    var tripId: Int = 0
    
    //MARK: View LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.hideTabBar()
        self.navigationController?.isNavigationBarHidden = true
        initialLoads()
    }
    
    private func setDarkMode(){
        self.view.backgroundColor = .backgroundColor
        self.navigationView.backgroundColor = .boxColor
        self.backButtonView.backgroundColor = .boxColor
        self.topView.backgroundColor = .boxColor
       self.backImageView.setImageColor(color: .blackColor)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Shadow and Radius
        navigationView.addShadow(radius: 0, color: .lightGray)
        
    }
}

//MARK:- Methods

extension OrderDetailController  {
    
    private func initialLoads() {
        let backAction = UITapGestureRecognizer(target: self, action: #selector(tapBackButton))  //** back tap **//
        self.backButtonView.addGestureRecognizer(backAction)
      
        self.disputeButton.addTarget(self, action: #selector(tapDispute), for: .touchUpInside)
        self.viewReceiptButton.addTarget(self, action: #selector(tapViewReceipt), for: .touchUpInside)
        DispatchQueue.main.async {
            self.disputeButton.setBothCorner()
            self.viewReceiptButton.setBothCorner()
        }
        setColors()
        localize()
        setFont()
        reloadSubView()
        locationTableView.register(nibName: OrderConstant.SourceTableViewCell)
        locationTableView.register(nibName: OrderConstant.SourceDestinationCell)

        locationTableView.register(nibName: OrderConstant.ProfileCell)
        locationTableView.register(nibName: OrderConstant.DetailOrderCell)
        locationTableView.delegate = self
        locationTableView.dataSource = self
        
       setDarkMode()
    }
    
    private func setFont() {
        disputeButton.titleLabel?.font = UIFont.setCustomFont(name: .medium, size: .x18)
        viewReceiptButton.titleLabel?.font = UIFont.setCustomFont(name: .medium, size: .x18)
        orderIDLabel.font = UIFont.setCustomFont(name: .bold, size: .x16)
        orderTypeLabel.font = UIFont.setCustomFont(name: .medium, size: .x12)
        dateLabel.font = UIFont.setCustomFont(name: .medium, size: .x12)
        timeLabel.font = UIFont.setCustomFont(name: .medium, size: .x12)
    }
    
    private func setColors() {
        
        dateLabel.textColor = .appPrimaryColor
        timeLabel.textColor = .appPrimaryColor
        disputeButton.backgroundColor = .appPrimaryColor
        viewReceiptButton.backgroundColor = .appPrimaryColor
        self.view.backgroundColor = .veryLightGray
    }
    
    private func localize() {
        viewReceiptButton.setTitle(OrderConstant.viewReceipt.localized, for: .normal)
    }
    
    
    
    private func disputeNavigation(isDispuite: Bool) {
        let disputeViewController = OrderRouter.orderStoryboard.instantiateViewController(withIdentifier: OrderConstant.DisputeViewController) as! DisputeViewController
        disputeViewController.delegate = self
        disputeViewController.tripId = tripId
        disputeViewController.isDispute = isDispuite
        disputeViewController.selectedServiceType = self.selectedServiceType
        disputeViewController.orderDetailData = self.orderDetailData
        disputeViewController.modalPresentationStyle = .overCurrentContext
        self.present(disputeViewController, animated: true, completion: nil)
    }
    
    private func dateFormatConvertion(dateString: String) -> String {
        let baseConfig = AppConfigurationManager.shared.baseConfigModel
        let dateFormat = baseConfig?.responseData?.appsetting?.date_format
        let dateFormatTo = dateFormat == "1" ? DateFormat.dd_mm_yyyy_hh_mm_ss : DateFormat.dd_mm_yyyy_hh_mm_ss_a
        let dateFormatReturn = dateFormat == "1" ? DateFormat.ddMMMyy24 : DateFormat.ddMMMyy12
        return AppUtils.shared.dateToString(dateStr: dateString, dateFormatTo: dateFormatTo, dateFormatReturn: dateFormatReturn)
    }
    
    private func setDateAndTime(dateString: String) {
        let seperatedStrArr = dateString.components(separatedBy: ",")
        if seperatedStrArr.count > 1 {
            timeLabel.text = String.removeNil(seperatedStrArr[1])
            dateLabel.text =  String.removeNil(seperatedStrArr[0])
        } else  {
            timeLabel.text = .empty
            dateLabel.text =  String.removeNil(seperatedStrArr[0])
        }
    }
}

extension OrderDetailController {
    
    @objc func tapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
   
    
    @objc func tapDispute() {
        if disputeButton.currentTitle == OrderConstant.dispute.localized {
            disputeNavigation(isDispuite: true)
        }else{
            showDisputeStatus(isDispute: true)
        }
    }
    
    @objc func tapViewReceipt() {
        //Check Multiple Delivery
        if (self.orderDetailData?.delivery?.deliveries?.count != 1) && (selectedServiceType == .delivery) {
            let alert = UIAlertController(title: APPConstant.appName.localized, message: "", preferredStyle: .actionSheet)
            
            for i in 0..<(self.orderDetailData?.delivery?.deliveries?.count ?? 0) {
                alert.addAction(UIAlertAction(title: OrderConstant.receipt.localized + " " + "\(i + 1)", style: .default , handler:{ (UIAlertAction)in
                    if self.receiptView == nil, let receiptView = Bundle.main.loadNibNamed(OrderConstant.ReceiptView, owner: self, options: [:])?.first as? ReceiptView {
                    receiptView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                    self.receiptView = receiptView
                    if let payment = self.orderDetailData?.delivery {
                        self.receiptView?.setCourierValues(values: payment, index: i)
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
                }))
            }
            
            alert.addAction(UIAlertAction(title: Constant.dismiss.localized, style: .cancel, handler:{ (UIAlertAction)in
            }))
            self.present(alert, animated: true, completion: {
            })
        }
        else{
        if self.receiptView == nil, let receiptView = Bundle.main.loadNibNamed(OrderConstant.ReceiptView, owner: self, options: [:])?.first as? ReceiptView {
            
            receiptView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            self.receiptView = receiptView
            if selectedServiceType == .trips {
                if let payment = self.orderDetailData?.transport?.payment {
                    self.receiptView?.setValues(values: payment,calculator: self.orderDetailData?.transport?.calculator ?? "")
                }
            }else if selectedServiceType == .service {
                if let payment = self.orderDetailData?.service?.payment {
                    self.receiptView?.setValues(values: payment,calculator:"")
                }
            }else if selectedServiceType == .delivery {
                if let payment = self.orderDetailData?.delivery {
                    self.receiptView?.setCourierValues(values: payment,index : 0)
                }
            }else{
                if let payment = self.orderDetailData?.order?.order_invoice {
                    self.receiptView?.setFoodieValues(values: payment)
                }
            }
            
            self.receiptView?.show(with: .bottom, completion: nil)
            showDimView(view: self.receiptView ?? DisputeStatusView())
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
    }
    
    private func showDisputeStatus(isDispute: Bool){
        if self.disputeStatusView == nil, let disputeStatusView = Bundle.main.loadNibNamed(OrderConstant.DisputeStatusView, owner: self, options: [:])?.first as? DisputeStatusView {
            
            disputeStatusView.frame = CGRect(x: 0, y: self.view.frame.height - disputeStatusView.frame.size.height + 100, width: self.view.frame.width, height:  disputeStatusView.frame.size.height)

            self.disputeStatusView = disputeStatusView
            var disputeString = ""
            var bottom:CGFloat = 0
            if #available(iOS 11.0, *) {
                let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
                let bottomPadding = window?.safeAreaInsets.bottom
                bottom = bottomPadding ?? 0
            }

            var heightValue = 0
            if isDispute {
                if selectedServiceType == .orders {
                    if let dispute = self.orderDetailData?.order?.dispute {
                        if let disputenameString = self.orderDetailData?.order?.dispute?.dispute_name {
                            
                            if let commentString = self.orderDetailData?.order?.dispute?.comments {
                                disputeString = disputenameString + commentString
                                heightValue = 160
                            }else {
                                disputeString = disputenameString
                                heightValue = 120
                            }
                        }
                        disputeStatusView.setValues(values: dispute)
                    }
                }else if selectedServiceType == .service {
                    if let dispute = self.orderDetailData?.service?.dispute {
                        if let disputenameString = self.orderDetailData?.service?.dispute?.dispute_name {
                            
                            if let commentString = self.orderDetailData?.service?.dispute?.comments {
                                disputeString = disputenameString + commentString
                                heightValue = 160
                            }else {
                                disputeString = disputenameString
                                heightValue = 120
                            }
                        }
                        disputeStatusView.setValues(values: dispute)
                    }
                }else if selectedServiceType == .delivery {
                    if let dispute = self.orderDetailData?.delivery?.dispute {
                        if let disputenameString = self.orderDetailData?.delivery?.dispute?.dispute_name {
                            
                            if let commentString = self.orderDetailData?.delivery?.dispute?.comments {
                                disputeString = disputenameString + commentString
                                heightValue = 160
                            }else {
                                disputeString = disputenameString
                                heightValue = 120
                            }
                        }
                        disputeStatusView.setValues(values: dispute)
                    }
                }else{
                    if let dispute = self.orderDetailData?.transport?.dispute {
                        
                        if let disputenameString = self.orderDetailData?.transport?.dispute?.dispute_name {
                           
                            if let commentString = self.orderDetailData?.transport?.dispute?.comments {
                                disputeString = disputenameString + commentString
                                 heightValue = 160
                            }else {
                                disputeString = disputenameString
                                 heightValue = 120
                            }
                        }
            
                        disputeStatusView.setValues(values: dispute)
                    }
                    disputeStatusView.DisputeStatusViewHeight.constant = disputeString.heightOfString(usingFont: UIFont.setCustomFont(name: .light, size: .x12), width: disputeStatusView.frame.width-150) + CGFloat(heightValue)
                
                    disputeStatusView.frame = CGRect(x: 0, y: self.view.frame.height - disputeStatusView.DisputeStatusViewHeight.constant - bottom, width: self.view.frame.width, height: disputeStatusView.DisputeStatusViewHeight.constant)
                   
                    
                    self.disputeStatusView = disputeStatusView
                }
            }else{
                 var lostString = ""
                 var heightValue = 0
                if let lostItem = self.orderDetailData?.transport?.lost_item {
                    disputeStatusView.setLostItem(values: lostItem)
                   
                    if let lostnameString = self.orderDetailData?.transport?.lost_item?.lost_item_name {
                        
                        if let lostcommentString = self.orderDetailData?.transport?.lost_item?.comments {
                            lostString = lostnameString + lostcommentString
                            heightValue = 160
                        }else {
                            lostString = lostnameString
                            heightValue = 120
                        }
                    }
                    disputeStatusView.DisputeStatusViewHeight.constant = lostString.heightOfString(usingFont: UIFont.setCustomFont(name: .light, size: .x12), width: disputeStatusView.frame.width-150) + CGFloat(heightValue)
                    disputeStatusView.frame = CGRect(x: 0, y: self.view.frame.height - disputeStatusView.DisputeStatusViewHeight.constant - bottom, width: self.view.frame.width, height: disputeStatusView.DisputeStatusViewHeight.constant)
                    
                    self.disputeStatusView = disputeStatusView
                }
            }
            self.disputeStatusView?.show(with: .bottom, completion: nil)
            showDimView(view: self.disputeStatusView ?? DisputeStatusView())
        }
    }


    private func showDimView(view: UIView) {
        let dimView = UIView(frame: self.view.frame)
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        dimView.addSubview(view)
        self.view.addSubview(dimView)
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
    
    func reloadSubView() {
        ordersPresenter?.getOrderDetail(id:tripId.toString(),type:selectedServiceType.currentType)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if self.disputeStatusView != nil {
            self.disputeStatusView?.superview?.dismissView(onCompletion: {
                self.disputeStatusView = nil
            })
        }
    }
    
    private func setTransportValues() {
        DispatchQueue.main.async {
            if let transportData = self.orderDetailData?.transport {
                if let dateStr = self.orderDetailData?.transport?.created_time {
                    let dateValue = self.dateFormatConvertion(dateString: dateStr)
                    self.setDateAndTime(dateString: dateValue)
                }
                self.orderIDLabel.text = transportData.booking_id ?? ""
                self.orderTypeLabel.text = (transportData.ride?.vehicle_name?.giveSpace ?? "") + (transportData.provider_vehicle?.vehicle_no ?? "")
                if transportData.dispute  != nil {
                    self.disputeButton.setTitle(OrderConstant.disputeStatus.localized, for: .normal)
                }else{
                    self.disputeButton.setTitle(OrderConstant.dispute.localized, for: .normal)
                }
            }
        }
    }
    
    private func setCourierValues() {
           DispatchQueue.main.async {
               if let transportData = self.orderDetailData?.delivery {
                   if let dateStr = transportData.created_time {
                       let dateValue = self.dateFormatConvertion(dateString: dateStr)
                       self.setDateAndTime(dateString: dateValue)
                   }
                   self.orderIDLabel.text = transportData.booking_id ?? ""
                self.orderTypeLabel.text = transportData.service?.vehicle_name
                   if transportData.dispute  != nil {
                       self.disputeButton.setTitle(OrderConstant.disputeStatus.localized, for: .normal)
                   }else{
                       self.disputeButton.setTitle(OrderConstant.dispute.localized, for: .normal)
                   }
               }
           }
       }
    
    private func setServiceValues() {
        DispatchQueue.main.async {
            if let transportData = self.orderDetailData?.service {
                if let dateStr = self.orderDetailData?.service?.created_time {
                    let dateValue = self.dateFormatConvertion(dateString: dateStr)
                    self.setDateAndTime(dateString: dateValue)
                }
                var bookId = transportData.booking_id ?? ""
                bookId = bookId+" ("+(transportData.provider_rated?.toString() ?? "")+" Rating)"
                self.orderIDLabel.text = bookId
                self.orderTypeLabel.text = transportData.service?.service_name
                if transportData.dispute  != nil {
                    self.disputeButton.setTitle(OrderConstant.disputeStatus.localized, for: .normal)
                }else{
                    self.disputeButton.setTitle(OrderConstant.dispute.localized, for: .normal)
                }
            }
        }
    }
    
    private func setFoodieValues() {
        DispatchQueue.main.async {
            if let foodieValue = self.orderDetailData?.order {
               
                if let dateStr = foodieValue.created_time {
                    let dateValue = self.dateFormatConvertion(dateString: dateStr)
                    self.setDateAndTime(dateString: dateValue)
                }
                self.orderIDLabel.text = foodieValue.store_order_invoice_id
                self.orderTypeLabel.text = foodieValue.pickup?.store_name
                
                if foodieValue.dispute  != nil {
                    self.disputeButton.setTitle(OrderConstant.disputeStatus.localized, for: .normal)
                }else{
                    self.disputeButton.setTitle(OrderConstant.dispute.localized, for: .normal)
                }
            }
        }
    }
}

extension OrderDetailController: DisputeViewDelegate {
    func updateDisputeViewStatus() {
        self.initialLoads()
    }
}

extension OrderDetailController:  OrderPresenterToOrderViewProtocol {
    func getOrderDetail(orderDetailEntity: OrderDetailEntity) {
        
        self.orderDetailData = orderDetailEntity.responseData
        if selectedServiceType == .trips {
            self.setTransportValues()
        }else if selectedServiceType == .orders {
            self.setFoodieValues()
        }else if selectedServiceType == .delivery {
            self.setCourierValues()
        }
        else{
            self.setServiceValues()
        }

        locationTableView.reloadData()

    }
}

extension OrderDetailController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: OrderConstant.ProfileCell, for: indexPath) as! ProfileCell
            if let orderdata = self.orderDetailData {
                cell.setValues(data: orderdata)
            }
            return cell

        }else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: OrderConstant.SourceTableViewCell, for: indexPath) as! SourceTableViewCell
            if selectedServiceType == .trips {
                cell.sourceLabel.text = self.orderDetailData?.transport?.s_address
            }else if selectedServiceType == .orders {
                cell.sourceLabel.text = self.orderDetailData?.order?.pickup?.store_location
            }else if selectedServiceType == .delivery {
                cell.sourceLabel.text = self.orderDetailData?.delivery?.s_address
            }else{
                cell.sourceLabel.text = self.orderDetailData?.service?.s_address
            }
            return cell
        }else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: OrderConstant.SourceDestinationCell, for: indexPath) as! SourceDestinationCell
            if selectedServiceType == .trips {
                cell.destinationLabel.text = self.orderDetailData?.transport?.d_address
            }else if selectedServiceType == .orders {
                cell.destinationLabel.text = self.orderDetailData?.order?.delivery?.map_address
            }else if selectedServiceType == .delivery {
                let delivery = self.orderDetailData?.delivery?.deliveries?[indexPath.row]
                cell.destinationLabel.text = delivery?.d_address
            }
            if indexPath.row == ((self.orderDetailData?.delivery?.deliveries?.count ?? 0) - 1) {
                cell.centerStatusView.isHidden = true
            }else{
               cell.centerStatusView.isHidden = false
            }
            
            return cell
        }else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: OrderConstant.DetailOrderCell, for: indexPath) as! DetailOrderCell
            if let orderdata = self.orderDetailData {
                cell.setValues(data: orderdata)
                cell.commentOuterView.isHidden = false

            }
            cell.onClickLostItem = { [weak self] () in
                guard let self = self else {
                    return
                }
                if self.orderDetailData?.transport?.lost_item != nil {
                    self.showDisputeStatus(isDispute: false)
                }else {
                    self.disputeNavigation(isDispuite: false)
                }
            }
            
            return cell
            
        }
        return UITableViewCell()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if section == 0 || section == 1 || section == 3{
            count = 1
        }else if section == 2 {
            if selectedServiceType == .trips || selectedServiceType == .orders{
                count = 1
            }else if selectedServiceType == .delivery {
                count = self.orderDetailData?.delivery?.deliveries?.count ?? 0
            }
        }
        return count
    }
    
}
