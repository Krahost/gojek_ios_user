//
//  OrderUpcomingDetailController.swift
//  GoJekUser
//
//  Created by Ansar on 15/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

class OrderUpcomingDetailController: UIViewController {
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var backButtonView: UIView!
    @IBOutlet weak var orderIDLabel: UILabel!
    @IBOutlet weak var orderTypeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
 
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var liveTrackButton: UIButton!
    @IBOutlet weak var viewDetailsButton: UIButton!
    @IBOutlet weak var courierStatusView: UIStackView!

    @IBOutlet weak var locationtableView: UITableView!


    var selectedId: Int = 0
        
    var selectedServiceType:ServiceType = .trips
    
    var orderDetailData: OrderDetailReponseData?
    
    var tableView: CustomTableView?
    
    var reasonData:[ReasonData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoads()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.hideTabBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cancelButton.setBothCorner()
        viewDetailsButton.setBothCorner()
        liveTrackButton.setBothCorner()
        liveTrackButton.addShadow(color: .lightGray, fillColor: .red)
        viewDetailsButton.addShadow(color: .lightGray, fillColor: .red)


    }
}

//MARK: - Methods

extension OrderUpcomingDetailController {
    private func initialLoads() {
        setFont()
        localize()
        
        self.view.backgroundColor = .veryLightGray
        self.timeLabel.textColor = .appPrimaryColor
        self.dateLabel.textColor = .appPrimaryColor
        self.cancelButton.backgroundColor =  .appPrimaryColor
        navigationView.addShadow(radius: 0, color: .lightGray)
        ordersPresenter?.getUpcomingDetail(id: selectedId.toString(), type: selectedServiceType.currentType)
        cancelButton.addTarget(self, action: #selector(tapCancel), for: .touchUpInside)
        let backAction = UITapGestureRecognizer(target: self, action: #selector(tapBack))
        self.backButtonView.addGestureRecognizer(backAction)
        viewDetailsButton.backgroundColor = .appPrimaryColor
        liveTrackButton.backgroundColor = .appPrimaryColor
        viewDetailsButton.setTitleColor(.white, for: .normal)
        liveTrackButton.setTitleColor(.white, for: .normal)
        locationtableView.register(nibName: OrderConstant.SourceTableViewCell)
        locationtableView.register(nibName: OrderConstant.DetailOrderCell)
        locationtableView.register(nibName: OrderConstant.SourceDestinationCell)
        locationtableView.delegate = self
        locationtableView.dataSource = self
        
//        if selectedServiceType == .delivery {
//            courierStatusView.isHidden = false
//        }else{
            courierStatusView.isHidden = true

//        }
           
    }
    
    private func setFont() {
        orderIDLabel.font = UIFont.setCustomFont(name: .bold, size: .x16)
        orderTypeLabel.font = UIFont.setCustomFont(name: .medium, size: .x12)
        dateLabel.font = UIFont.setCustomFont(name: .medium, size: .x12)
        timeLabel.font = UIFont.setCustomFont(name: .medium, size: .x12)
        cancelButton.titleLabel?.font = UIFont.setCustomFont(name: .medium, size: .x16)
        viewDetailsButton.titleLabel?.font = UIFont.setCustomFont(name: .medium, size: .x16)
        liveTrackButton.titleLabel?.font = UIFont.setCustomFont(name: .medium, size: .x16)
    }
    
    private func localize() {
        cancelButton.setTitle(OrderConstant.cancel.localized, for: .normal)
        viewDetailsButton.setTitle(OrderConstant.viewDetails.localized, for: .normal)
        liveTrackButton.setTitle(OrderConstant.liveTrack.localized, for: .normal)
    }
    
    private func dateFormatConvertion(dateString: String) -> String {
        let baseConfig = AppConfigurationManager.shared.baseConfigModel
        let dateFormat = baseConfig?.responseData?.appsetting?.date_format
        let dateFormatTo = dateFormat == "1" ? DateFormat.dd_mm_yyyy_hh_mm_ss : DateFormat.dd_mm_yyyy_hh_mm_ss_a
        let dateFormatReturn = dateFormat == "1" ? DateFormat.ddMMMyy24 : DateFormat.ddMMMyy12
        return AppUtils.shared.dateToString(dateStr: dateString, dateFormatTo: dateFormatTo, dateFormatReturn: dateFormatReturn)
    }
    
    private func setTransportValues() {
        DispatchQueue.main.async {
            if self.selectedServiceType == .trips {
                if let transportData = self.orderDetailData?.transport {
                    if let dateStr = transportData.schedule_time {
                        let assignedAt = self.dateFormatConvertion(dateString: dateStr)
                        let seperatedStrArr  = assignedAt.components(separatedBy: ",")
                        self.timeLabel.text = String.removeNil(seperatedStrArr[1])
                        self.dateLabel.text =  String.removeNil(seperatedStrArr[0])
                    }
                    self.orderIDLabel.text = transportData.booking_id ?? ""
                    self.orderTypeLabel.text = (transportData.ride?.vehicle_name ?? "")
                }
            }else if self.selectedServiceType == .service {
                if let serviceData = self.orderDetailData?.service {
                    if let dateStr = serviceData.schedule_time {
                        let assignedAt = self.dateFormatConvertion(dateString: dateStr)
                        let seperatedStrArr  = assignedAt.components(separatedBy: ",")
                        self.timeLabel.text = String.removeNil(seperatedStrArr[1])
                        self.dateLabel.text =  String.removeNil(seperatedStrArr[0])
                    }
                    self.orderIDLabel.text = serviceData.booking_id ?? ""
                    self.orderTypeLabel.text = (serviceData.service?.service_name ?? "")
                }
            }else if self.selectedServiceType == .delivery {
                if let serviceData = self.orderDetailData?.delivery {
                    if let dateStr = serviceData.schedule_time {
                        let assignedAt = self.dateFormatConvertion(dateString: dateStr)
                        let seperatedStrArr  = assignedAt.components(separatedBy: ",")
                        self.timeLabel.text = String.removeNil(seperatedStrArr[1])
                        self.dateLabel.text =  String.removeNil(seperatedStrArr[0])
                    }
                    self.orderIDLabel.text = serviceData.booking_id ?? ""
                    self.orderTypeLabel.text = (serviceData.service?.vehicle_name ?? "")
                }
            }

        }
    }
    
    private func showCancelTable() {
        if self.tableView == nil, let tableView = Bundle.main.loadNibNamed(Constant.CustomTableView, owner: self, options: [:])?.first as? CustomTableView {
            
            let height = (self.view.frame.height/100)*35
            tableView.frame = CGRect(x: 20, y: (self.view.frame.height/2)-(height/2), width: self.view.frame.width-40, height: height)
            tableView.heading = Constant.chooseReason.localized
            self.tableView = tableView
            self.tableView?.setCornerRadiuswithValue(value: 10.0)
            var reasonArr:[String] = []
            for reason in self.reasonData {
                reasonArr.append(reason.reason ?? "")
            }
            if !reasonArr.contains(Constant.other) {
                reasonArr.append(Constant.other)
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
        self.tableView?.selectedItem = { [weak self] selectedReason in
            guard let self = self else {
                return
            }
            var param: Parameters = [OrderConstant.reason: selectedReason ]
            switch self.orderDetailData?.type?.uppercased() {
            case Constant.transport.uppercased():
                param[OrderConstant.id] = self.orderDetailData?.transport?.id ?? 0
                break
            case Constant.service.uppercased():
                param[OrderConstant.id] = self.orderDetailData?.service?.id ?? 0
                break
            case Constant.delivery.uppercased():
                param[OrderConstant.id] = self.orderDetailData?.delivery?.id ?? 0
                break
            default:
                break
            }
            self.ordersPresenter?.cancelRequest(param: param, type: self.selectedServiceType.currentType)
            //Working fine
        }
    }

    private func showDimView(view: UIView) {
        let dimView = UIView(frame: self.view.frame)
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        dimView.addSubview(view)
        self.view.addSubview(dimView)
    }
    
    @objc func tapBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func tapCancel() {
        showCancelTable()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.tableView != nil {
            self.tableView?.superview?.dismissView(onCompletion: {
                self.tableView = nil
            })
        }
    }
}

//MARK: -  API

extension OrderUpcomingDetailController: OrderPresenterToOrderViewProtocol  {
    
    func getUpcomingDetail(upcomingEntity: OrderDetailEntity) {
        self.orderDetailData = upcomingEntity.responseData
        setTransportValues()
        locationtableView.reloadData()
        
        self.ordersPresenter?.getReasons(param: [OrderConstant.type:selectedServiceType.currentType])
    }
    
    func getReasons(reasonEntity: ReasonEntity) {
        self.reasonData = reasonEntity.responseData ?? []
    }
   
    func getCancelRequest(reasonEntity: SuccessEntity) {
        ToastManager.show(title: reasonEntity.message ?? "", state: .success)
        self.navigationController?.popViewController(animated: true)
    }
}


extension OrderUpcomingDetailController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
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
        }else if indexPath.section == 1{
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

        }else if indexPath.section == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: OrderConstant.DetailOrderCell, for: indexPath) as! DetailOrderCell
                if let orderdata = self.orderDetailData {
                    if selectedServiceType == .trips {
                        cell.cardOrCashLabel.text = orderdata.transport?.payment_mode

                    }else if selectedServiceType == .service {
                        cell.cardOrCashLabel.text = orderdata.service?.payment_mode

                    }else if selectedServiceType == .delivery {
                        cell.cardOrCashLabel.text = orderdata.delivery?.payment_mode

                    }

                }
            cell.lostItemOuterView.isHidden = true
            cell.commentOuterView.isHidden = true
            cell.statusOuterView.isHidden = true
            cell.paymentOuterView.isHidden = false

                return cell
                
            }
        return UITableViewCell()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if section == 0 || section == 2{
            count = 1
        }else if section == 1 {
            if selectedServiceType == .trips || selectedServiceType == .orders{
                count = 1
            }else if selectedServiceType == .delivery {
                count = self.orderDetailData?.delivery?.deliveries?.count ?? 0
            }
        }
        return count
    }
    
}
