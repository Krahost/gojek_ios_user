//
//  DisputeStatusView.swift
//  TranxitUser
//
//  Created by Ansar on 19/01/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class DisputeStatusView: UIView {
    
    @IBOutlet private weak var tableview : UITableView!
    @IBOutlet private weak var lblHeading : UILabel!
    @IBOutlet private weak var btnCall : UIButton!
    @IBOutlet private weak var viewHeader : UIView!
    @IBOutlet weak var DisputeStatusViewHeight: NSLayoutConstraint!
    
    enum disputeStatus: String {
        case open = "open"
        case close  = "closed"
        
        var disputeColor:UIColor {
            switch self {
            case .open:
                return .appPrimaryColor
            case .close:
                return .systemGreen
           
            }
        }
    }
    
    var isDispute:Bool = false
    var onClickClose : ((Bool)->Void)?

    var disputeData: Dispute?
    var lostItemData: Lost_item?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialLoads()
    }
    
    private func initialLoads() {
        self.alpha = 1
        self.tableview.delegate = self
        self.tableview.dataSource = self
        self.tableview.register(nibName: OrderConstant.DisputeSenderCell)
        self.tableview.register(nibName: OrderConstant.DisputeReceiverCell)
        self.btnCall.addTarget(self, action: #selector(tapCall), for: .touchUpInside)
        self.btnCall.setTitleColor(.appPrimaryColor, for: .normal)
        self.btnCall.setImage(UIImage(named: Constant.phoneImage), for: .normal)
        self.btnCall.tintColor = .appPrimaryColor
        self.btnCall.isHidden = true
        setDarkMode()
    }

    func setValues(values: Dispute)  {
        self.lblHeading.text = OrderConstant.disputeStatus.localized
        self.isDispute  = true
        self.disputeData = values
        tableview.reloadInMainThread()
    }
    
    func setLostItem(values: Lost_item)  {
        self.lblHeading.text = OrderConstant.lostItemStatus.localized
        self.isDispute  = false
        self.lostItemData = values
        tableview.reloadInMainThread()
    }
    
    @IBAction func tapCall() {
        
    }
    
    @objc func tapClose() {
        onClickClose!(true)
    }
    
    private func setDarkMode(){
        self.backgroundColor = .boxColor
        self.viewHeader.backgroundColor = .boxColor
        self.tableview.backgroundColor = .boxColor
    }
    
    
}

// MARK:- UITableViewDelegate
extension DisputeStatusView : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return self.getCell(for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    private func getCell(for indexPath:IndexPath) -> UITableViewCell {
        if isDispute {
            if indexPath.row == 0 {
                if self.disputeData?.dispute_type == "user" {
                    if let tableCell = tableview.dequeueReusableCell(withIdentifier: OrderConstant.DisputeSenderCell, for: indexPath) as? DisputeSenderCell {
                        let userDetail = AppManager.shared.getUserDetails()
                        tableCell.imgProfile.setImage(with: userDetail?.picture, placeHolder: UIImage(named: "ic_applogo_white"))
                        tableCell.lblName.text = OrderConstant.you.localized
                        tableCell.lblContent.text = self.disputeData?.dispute_name
                        tableCell.lblStatus.text = self.disputeData?.status?.uppercased()
                        if let status = disputeStatus(rawValue: self.disputeData?.status ?? "")  {
                            tableCell.viewStatus.backgroundColor  = status.disputeColor.withAlphaComponent(0.3)
                            tableCell.lblStatus.textColor = status.disputeColor
                        }
                        return tableCell
                    }
                }
            }else{
                if let adminComment = self.disputeData?.comments{
                    if let tableCell = tableview.dequeueReusableCell(withIdentifier: OrderConstant.DisputeReceiverCell, for: indexPath) as? DisputeReceiverCell {
                        tableCell.lblContent.text = adminComment
                        tableCell.lblName.text = "Admin"
                        tableCell.imgProfile.image = UIImage(named: "ic_applogo_white")
                        return tableCell
                    }
                }
            }
        }else{
            if indexPath.row == 0 {
                if let tableCell = tableview.dequeueReusableCell(withIdentifier: OrderConstant.DisputeSenderCell, for: indexPath) as? DisputeSenderCell {
                    let userDetail = AppManager.shared.getUserDetails()
                    tableCell.imgProfile.setImage(with: userDetail?.picture, placeHolder: UIImage(named: "ic_applogo_white"))
                    tableCell.lblName.text = OrderConstant.you.localized
                    tableCell.lblContent.text = self.lostItemData?.lost_item_name
                    tableCell.lblStatus.text = self.lostItemData?.status?.uppercased()
                    if let status = disputeStatus(rawValue: self.lostItemData?.status ?? "")  {
                        tableCell.viewStatus.backgroundColor  = status.disputeColor.withAlphaComponent(0.3)
                        tableCell.lblStatus.textColor = status.disputeColor
                    }
                    return tableCell
                }
            }else{
                if let adminComment = self.lostItemData?.comments{
                    if let tableCell = tableview.dequeueReusableCell(withIdentifier: OrderConstant.DisputeReceiverCell, for: indexPath) as? DisputeReceiverCell {
                        tableCell.lblContent.text = adminComment
                        tableCell.lblName.text = "Admin"
                        tableCell.imgProfile.image = UIImage(named: "ic_applogo_white")
                        return tableCell
                    }
                }
            }
        }
        let cell = UITableViewCell()
        cell.contentView.backgroundColor = .boxColor
        return cell
    }
    
}
