//
//  FoodieOrderStatusTableViewCell.swift
//  GoJekUser
//
//  Created by Thiru on 09/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class FoodieOrderStatusTableViewCell: UITableViewCell {
    
    @IBOutlet weak var orderStatusTableView: UITableView!
    var orderComplete:(()->Void)?
    
    var orderType = ""
    var orderReadystatus = 0
    
    var orderStatus: foodieOrderStatus = .searching {
        didSet {
            if orderStatus != .completed {
                self.orderStatusTableView.reloadInMainThread()
            }
        }
    }
    
    var statusTakeAwayImage = [FoodieConstant.ic_process,FoodieConstant.ic_delivery]
    var statusTakeAwayStr = [FoodieConstant.orderProcess,FoodieConstant.orderDeliver]
    
    var statusImage = [FoodieConstant.ic_process,FoodieConstant.cateringImage,FoodieConstant.scooterImage,FoodieConstant.ic_ondway,FoodieConstant.ic_delivery]
    var statusStr = [FoodieConstant.orderProcess.localized,FoodieConstant.orderAssign.localized,FoodieConstant.orderReach.localized,FoodieConstant.orderOndway.localized,FoodieConstant.orderDeliver.localized]
    var statusDesc = [FoodieConstant.orderProcessDesc.localized,FoodieConstant.orderOndwayDesc.localized,FoodieConstant.orderDeliverDesc.localized]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialLoads()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//MARK: - Methods

extension FoodieOrderStatusTableViewCell  {
    private func initialLoads() {
        orderStatusTableView.delegate = self
        orderStatusTableView.dataSource = self
        orderStatusTableView.register(UINib(nibName: FoodieConstant.OrderStatusCell, bundle: nil), forCellReuseIdentifier: FoodieConstant.OrderStatusCell)
    }
    
   
}

//MARK: - Tableview delegate datasource


extension FoodieOrderStatusTableViewCell: UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if orderType == "TAKEAWAY" {
            return 2
        }else{
            return 5
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  60
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.orderStatusTableView.dequeueReusableCell(withIdentifier: FoodieConstant.OrderStatusCell, for: indexPath) as! OrderStatusCell
        if orderType == "TAKEAWAY" {
            cell.statusImage.image = UIImage(named: statusTakeAwayImage[indexPath.row])?.imageTintColor(color1: .foodieColor)
            cell.statusLabel.text = statusTakeAwayStr[indexPath.row]
            if orderStatus.rawValue == "ORDERED" {
                cell.statusDescLabel.text = FoodieConstant.orderedStatus
                cell.isCurrentState = indexPath.row == 0
            }else if orderReadystatus == 0 && orderStatus.rawValue == "RECEIVED" {
                cell.statusDescLabel.text = FoodieConstant.recievedStatus
                cell.isCurrentState = indexPath.row == 0
            }else if orderReadystatus == 1 && orderStatus.rawValue == "RECEIVED" {
                cell.statusDescLabel.text = FoodieConstant.pickupStatus
                cell.isCurrentState = indexPath.row == 1
            }else if orderReadystatus == 1 && orderStatus.rawValue == "COMPLETED" {
                cell.statusDescLabel.text = FoodieConstant.orderDeliverDesc
                cell.isCurrentState = indexPath.row == 1
            }else if orderReadystatus == 0 && orderStatus.rawValue == "STORECANCELLED" {
                cell.statusDescLabel.text = FoodieConstant.orderedStatus
                cell.isCurrentState = indexPath.row == 0
            }
            
        }else{
            cell.statusImage.image = UIImage(named: statusImage[indexPath.row])?.imageTintColor(color1: .foodieColor)
            cell.statusLabel.text = statusStr[indexPath.row]
            cell.statusDescLabel.text = orderStatus.statusStr
            cell.isCurrentState = indexPath.row == orderStatus.index
        }
    
        return cell
    }

}
