//
//  FoodieOrderDetailTableViewCell.swift
//  GoJekUser
//
//  Created by Thiru on 10/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class FoodieOrderDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var orderDetailLabel: UILabel!
    @IBOutlet weak var orderTableView:  UITableView!
    @IBOutlet weak var deliveryDateLabel: UILabel!
    
    var orderItem:[FoodieItems] = []

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

extension FoodieOrderDetailTableViewCell {
    private func initialLoads() {
        orderDetailLabel.textColor = .foodieColor
        deliveryDateLabel.textColor = .darkGray
        orderDetailLabel.text = FoodieConstant.orderDetails.localized.capitalized
        orderDetailLabel.font = UIFont.setCustomFont(name: .medium, size: .x16)
        deliveryDateLabel.font = UIFont.setCustomFont(name: .medium, size: .x12)

        orderTableView.register(UINib(nibName: FoodieConstant.OrderDetailListCell, bundle: nil), forCellReuseIdentifier: FoodieConstant.OrderDetailListCell)
        orderTableView.delegate = self
        orderTableView.dataSource = self
        orderTableView.reloadData()
        orderTableView.backgroundColor = .boxColor
    }
}

//MARK: - Tableview delegate datasource
extension FoodieOrderDetailTableViewCell: UITableViewDataSource,UITableViewDelegate  {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderItem.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.orderTableView.dequeueReusableCell(withIdentifier: FoodieConstant.OrderDetailListCell, for: indexPath) as! OrderDetailListCell
        let orderDict = orderItem[indexPath.row]
       // cell.isVeg = (indexPath.row % 2 == 0)
        if orderDict.product?.is_veg == "Non Veg"
        {
           cell.isVeg  = false
        }else{
            cell.isVeg  = true

        }
        cell.priceLabel.text = Double(orderDict.total_item_price ?? 0).setCurrency()
        let orderName = (orderDict.product?.item_name ?? "")
       // let orderBank = " ("
      //  let orderPrice = (orderDict.quantity?.toString() ?? "") + "x" + (orderDict.item_price?.toString() ?? "")
       // let backorderBank = ")"

       // let foodname = orderName + orderBank + orderPrice + backorderBank
        let orderQty = "  x " + (orderDict.quantity?.toString() ?? "")
        let foodname = orderName + orderQty
        cell.foodNameLabel.attributeString(string: foodname, range: NSRange(location: orderName.count, length: orderQty.count), color: .lightGray)
        let cartDetails = self.getCartAddOnValue(values: orderDict.cartaddon ?? [])
        
        cell.AddonsLabel.text = cartDetails
        
        return cell
    }
    func getCartAddOnValue(values: [Itemsaddon]) -> (String) {
        var cartName:String = ""
        for cart in values {
            cartName = cartName + (cart.addonName ?? "") + ","
        }
        cartName = String(cartName.dropLast())
        return (cartName)
    }
}
