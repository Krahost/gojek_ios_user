//
//  DisputeViewController.swift
//  GoJekUser
//
//  Created by apple on 04/07/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

protocol DisputeViewDelegate {
    func updateDisputeViewStatus()
}

class DisputeViewController: UIViewController {
    
    // MARK:- IBOutlet
    
    @IBOutlet weak var tableview : UITableView!
    @IBOutlet weak var outterView: UIView!
    @IBOutlet weak var labelTitle : UILabel!
    @IBOutlet weak var buttonSubmit : UIButton!
    @IBOutlet weak var otherTextView: UITextView!
    @IBOutlet weak var heightTextView: NSLayoutConstraint!
    @IBOutlet weak var viewHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var overView: UIView!
    @IBOutlet weak var buttonOverView : UIButton!

    // MARK:- LocalVariable
    var isDispute: Bool = false
    var tripId: Int = 0
    
   
    
    var delegate: DisputeViewDelegate?
    var selectedServiceType: ServiceType = .trips
    var orderDetailData: OrderDetailReponseData?
    var disputeList: [DisputeListData] = []
    
    private var datasource: [String] = []
    private var selectedIndexPath = IndexPath(row: -1, section: -1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialLoad()
         tableview.delegate = self
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let key = touches.first?.key else { return }
//        if key.keybo == true {
//            self.dismissKeyboard()
//        } else  {
//            self.dismissView()
//        }
//    }
}

// MARK:- LocalMethod

extension DisputeViewController {
    
    private func initialLoad() {
        
        self.labelTitle.text = isDispute ? OrderConstant.dispute.localized : OrderConstant.lostItem.localized

        tableview.register(nibName: OrderConstant.DisputeCell)
        buttonSubmit.setBothCorner()
        buttonSubmit.addTarget(self, action: #selector(self.tapSubmit), for: .touchUpInside)
        buttonOverView.addTarget(self, action: #selector(self.tapOverView), for: .touchUpInside)
        
        otherTextView?.enablesReturnKeyAutomatically = true
        otherTextView?.borderLineWidth = 1
        otherTextView?.cornerRadius = 10
        otherTextView.isHidden = true
        otherTextView.delegate = self
        
        heightTextView.constant = 0
        viewHeightConstant.constant = 300
        
        
        setCustomFont()
        setCustomColor()
        setCustomLocalization()
        
        if selectedServiceType == .trips {
            ordersPresenter?.getDisputeList(type: "ride")
        }
        else if selectedServiceType == .orders {
            ordersPresenter?.getDisputeList(type: "order")
            
        }else if selectedServiceType == .delivery {
            ordersPresenter?.getDisputeList(type: "delivery")
            
        } else {
            ordersPresenter?.getDisputeList(type: "services")

        }
        setDarkMode()
    }
     @objc func tapDimView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setCustomColor() {
        buttonSubmit.backgroundColor = .appPrimaryColor
        otherTextView?.borderColor = .lightGray
        otherTextView?.backgroundColor = .veryLightGray
        otherTextView?.textColor = .lightGray
    }
    
    private func setDarkMode(){
        self.tableview.backgroundColor = .boxColor
        self.outterView.backgroundColor = .boxColor
    }
    
    private func setCustomFont() {
        labelTitle.font = .setCustomFont(name: .bold, size: .x18)
        buttonSubmit.titleLabel?.font = .setCustomFont(name: .bold, size: .x16)
    }
    
    private func setCustomLocalization() {
        buttonSubmit.setTitle(Constant.SSubmit.localized, for: .normal)
        otherTextView?.text = Constant.writingSomething.localized
    }
    
    private func set(value: [DisputeListData]?)  {
        self.datasource.removeAll()
        for dispute in value ?? [] {
            self.datasource.append(dispute.dispute_name ?? "")
        }
        if isDispute {
            self.datasource.append(OrderConstant.others)
        }
        if self.isDispute {
            self.otherTextView.isHidden = true
            self.heightTextView.constant = 0
            self.tableview.isHidden = false
        }else{
            self.otherTextView.isHidden = false
            self.heightTextView.constant = 175
            self.tableview.isHidden = true
        }
        self.tableview.reloadInMainThread()
    }
}

// MARK:- IBAction

extension DisputeViewController {
    
    @objc private func tapOverView() {
        self.dismiss(animated: true, completion: {
            self.delegate?.updateDisputeViewStatus()
        })
    }
    
    @objc private func tapSubmit() {
        if isDispute && self.selectedIndexPath.row < 0{
            ToastManager.show(title: OrderConstant.selectDispute, state: .error)
            return
        }
        
        if isDispute && self.selectedIndexPath.row == self.datasource.count-1 && self.otherTextView?.text == Constant.writingSomething.localized, let text = otherTextView?.text, !text.isEmpty {
            otherTextView.becomeFirstResponder()
            ToastManager.show(title: OrderConstant.enterComment, state: .error)
            return
        }
        
        if !isDispute {
            guard let text = otherTextView?.text, text != Constant.writingSomething.localized, !text.isEmpty else {
                otherTextView.becomeFirstResponder()
                ToastManager.show(title: OrderConstant.enterComment, state: .error)
                return
            }
        }
        
        var param: Parameters = [:]
        if isDispute { // Dispute
            param   = [OrderConstant.dispute_type : userType.user.rawValue]
            if self.selectedServiceType == .orders  {
                param[OrderConstant.id] = self.orderDetailData?.order?.id ?? 0
                param[OrderConstant.store_order_id] = self.orderDetailData?.order?.store_id ?? 0
                param[OrderConstant.provider_id] = self.orderDetailData?.order?.provider_id ?? 0
                param[OrderConstant.user_id] = self.orderDetailData?.order?.user_id ?? 0
            } else if self.selectedServiceType == .service  {
                param[OrderConstant.provider_id] = self.orderDetailData?.service?.provider_id ?? 0
                param[OrderConstant.user_id] = self.orderDetailData?.service?.user_id ?? 0
                param[OrderConstant.id] = self.orderDetailData?.service?.id ?? 0
            }else if self.selectedServiceType == .delivery  {
                param[OrderConstant.provider_id] = self.orderDetailData?.delivery?.provider_id ?? 0
                param[OrderConstant.user_id] = self.orderDetailData?.delivery?.user_id ?? 0
                param[OrderConstant.id] = self.orderDetailData?.delivery?.id ?? 0
            } else {
                param[OrderConstant.id] = self.tripId
                param[OrderConstant.user_id] = self.orderDetailData?.transport?.user_id ?? 0
                param[OrderConstant.provider_id] = self.orderDetailData?.transport?.provider_id ?? 0
            }
            if selectedIndexPath.row == datasource.count-1  {
                param[OrderConstant.dispute_name] = self.otherTextView?.text ?? ""

            }else{
                param[OrderConstant.dispute_name] = datasource[selectedIndexPath.row]


            }
            self.ordersPresenter?.addDispute(param: param,type: self.selectedServiceType)
        } else { //Lost Item
            param   = [OrderConstant.id : self.tripId.toString(),
                       OrderConstant.lost_item_name: self.otherTextView?.text ?? ""]
            self.ordersPresenter?.addLostItem(param: param)
        }
    }
}

// MARK:- UITableViewDataSource

extension DisputeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let tableCell = tableview.dequeueReusableCell(withIdentifier: OrderConstant.DisputeCell, for: indexPath) as? DisputeCell, self.datasource.count > indexPath.row {
            tableCell.lblTitle.text = self.datasource[indexPath.row].localized
            tableCell.isSelect = selectedIndexPath == indexPath
            return tableCell
        }
        return UITableViewCell()
    }
}

// MARK:- UITableViewDelegate

extension DisputeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        var cell = tableView.cellForRow(at: selectedIndexPath) as? DisputeCell
        self.selectedIndexPath = indexPath
        cell = tableView.cellForRow(at: selectedIndexPath) as? DisputeCell
        cell?.isSelect = selectedIndexPath == indexPath
        DispatchQueue.main.async {
            if cell?.lblTitle.text?.uppercased() == OrderConstant.others.uppercased() {
                if cell?.isSelect ?? false {
                    self.otherTextView.isHidden = false
                    self.heightTextView.constant = 75
                    self.viewHeightConstant.constant = 375
                } else {
                    self.otherTextView.isHidden = true
                    self.heightTextView.constant = 0
                    self.viewHeightConstant.constant = 300
                    
                }
            } else {
                self.otherTextView.isHidden = true
                self.heightTextView.constant = 0
                self.viewHeightConstant.constant = 300
            }
        }
        self.tableview.reloadInMainThread()
        self.view.layoutIfNeeded()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK:- UITextViewDelegate

extension DisputeViewController: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == Constant.writingSomething.localized {
            textView.text = .empty
            textView.textColor = .black
        }
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text == .empty {
            textView.text = Constant.writingSomething.localized
            textView.textColor = .lightGray
        }
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    private func dismissView() {
        self.dismiss(animated: true, completion: {
            self.delegate?.updateDisputeViewStatus()
        })
    }
}

extension DisputeViewController: OrderPresenterToOrderViewProtocol {
    
    func getDisputeList(disputeList: DisputeListEntity) {
        self.disputeList = disputeList.responseData ?? []
        self.set(value: disputeList.responseData ?? [])
    }
    
    func addDispute(disputeEntity: SuccessEntity) {
        ToastManager.show(title: OrderConstant.disputeCreatedMsg.localized, state: .success)
        self.dismissView()
    }
    
    func addLostItem(disputeEntity: SuccessEntity) {
        ToastManager.show(title: OrderConstant.lostItemCreatedMsg.localized, state: .success)
        self.dismissView()
    }
}

