//
//  FoodieAddOns.swift
//  GoJekUser
//
//  Created by CSS on 07/05/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class FoodieAddOns: UIView {

    @IBOutlet weak var outterView: UIView!
    @IBOutlet weak var addOnsTableView: UITableView!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var closeImageView: UIImageView!
  
    @IBOutlet weak var closeView: UIView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var addOnHeight: NSLayoutConstraint!
    
    var onClickClose:(()->Void)?
    var AddonsArr:[Itemsaddon] = []
    var CartAddonsArr:[Cartaddon] = []

    var addonsItem:NSMutableArray = []
    weak var delegate: FoodieAddOnsProtocol?
    var tagCount = 0
    var index = 0
    var isplus = false
    var isCartPage = false

    override func awakeFromNib() {
        super.awakeFromNib()
        initialLoad()
    }
    
    private func initialLoad(){
        DispatchQueue.main.async {
            self.itemImageView.setCornerRadiuswithValue(value: 8)
        }
        self.addOnsTableView.register(UINib(nibName: FoodieConstant.FoodieAddOnsCell,bundle: nil), forCellReuseIdentifier: FoodieConstant.FoodieAddOnsCell)
        setFont()
        
        closeImageView.image = UIImage(named: Constant.closeImage)?.imageTintColor(color1: .lightGray)
        let closeViewGesture = UITapGestureRecognizer(target: self, action: #selector(closeButtonAction(_:)))
        self.closeView.addGestureRecognizer(closeViewGesture)

        doneButton.addTarget(self, action: #selector(doneButtonAction), for: .touchUpInside)

        doneButton.backgroundColor = .foodieColor
        doneButton.setTitle(FoodieConstant.SAdd.localized.uppercased(), for: .normal)
        doneButton.setTitleColor(UIColor.white, for: .normal)
        doneButton.setBothCorner()
        itemPriceLabel.textColor = .lightGray
        
     
        
        addOnsTableView.delegate = self
        addOnsTableView.dataSource = self
        addOnsTableView.alwaysBounceVertical = false
        addOnsTableView.tableFooterView = UIView()
        addOnsTableView.reloadData()
//        cell.setSelectedAddons(isSelected: self.CartAddonsArr.contains(where: { (element) -> Bool in
//                       if element.store_item_addons_id == addOnsArr.id {
//                           addonsItem.replaceObject(at: indexPath.row, with: addOnsArr.id?.toString() ?? "")
//                           return true
//                       } else {
//                           return false
//                       }
//                   }))
        
        outterView.backgroundColor = .boxColor
    }
    
    @objc func closeButtonAction(_ sender: UITapGestureRecognizer) {
        self.onClickClose!()

    }
    private func setFont(){
        itemNameLabel.font = UIFont.setCustomFont(name: .medium, size: .x16)
        itemPriceLabel.font = UIFont.setCustomFont(name: .medium, size: .x16)
        doneButton.titleLabel?.font = UIFont.setCustomFont(name: .medium, size: .x14)

    }
    
    @objc func doneButtonAction(){
        delegate?.ondoneAction(addonsItem: addonsItem,indexPath:index,tag:tagCount,isplus: isplus)

    }

}

extension FoodieAddOns: UITableViewDataSource {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
         if isCartPage {
            return AddonsArr.count
         }else{
            return AddonsArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.addOnsTableView.dequeueReusableCell(withIdentifier: FoodieConstant.FoodieAddOnsCell, for: indexPath) as! FoodieAddOnsCell
        
        if isCartPage {
            let addOnsArr = AddonsArr[indexPath.row]
           
            if addonsItem.contains(addOnsArr.id?.toString() ?? "") {
                cell.addOnsImageView.image = UIImage(named: Constant.circleFullImage)

            }else{
                cell.addOnsImageView.image = UIImage(named: Constant.circleImage)

            }
            cell.addOnsNameLabel.text = addOnsArr.addonName
            cell.priceLabel.text = Double(addOnsArr.price ?? 0).setCurrency()
        }else{
            let addOnsArr = AddonsArr[indexPath.row]
            cell.addOnsNameLabel.text = addOnsArr.addonName
            cell.priceLabel.text = Double(addOnsArr.price ?? 0).setCurrency()
            
            if addonsItem.contains(addOnsArr.id?.toString() ?? "") {
                cell.addOnsImageView.image = UIImage(named: Constant.circleFullImage)

            }else{
                cell.addOnsImageView.image = UIImage(named: Constant.circleImage)

            }
        }
     
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        headerView.backgroundColor = .boxColor
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = FoodieConstant.Addons.localized
        label.font =  UIFont.setCustomFont(name: .medium, size: .x16) // my custom font
        label.textColor = .blackColor // my custom colour
        
        headerView.addSubview(label)
        
        return headerView
    }
}

extension FoodieAddOns: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if AddonsArr.count > 2 {
            addOnHeight.constant = CGFloat(AddonsArr.count*8)
        }else{
            addOnHeight.constant = CGFloat(AddonsArr.count)
        }
        return  44
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        // remove bottom extra 20px space.
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = addOnsTableView.cellForRow(at: indexPath) as! FoodieAddOnsCell
        if isCartPage {
            let addOnsArr = AddonsArr[indexPath.row]
            
            if cell.addOnsImageView.image?.isEqual(to: UIImage(named: Constant.circleImage) ?? UIImage()) ??  false  {
               // cell.addOnsImageView.image = UIImage(named: Constant.circleFullImage)
                addonsItem.replaceObject(at: indexPath.row, with: addOnsArr.id?.toString() ?? "")
            }else{
                //cell.addOnsImageView.image = UIImage(named: Constant.circleImage)
                addonsItem.replaceObject(at: indexPath.row, with: "")
            }
        }else{
            let addOnsArr = AddonsArr[indexPath.row]
            
            if cell.addOnsImageView.image?.isEqual(to: UIImage(named: Constant.circleImage) ?? UIImage()) ?? false  {
                cell.addOnsImageView.image = UIImage(named: Constant.circleFullImage)
                addonsItem.replaceObject(at: indexPath.row, with: addOnsArr.id?.toString() ?? "")
            }else{
                cell.addOnsImageView.image = UIImage(named: Constant.circleImage)
                addonsItem.replaceObject(at: indexPath.row, with: "")
            }
        }
        addOnsTableView.reloadData()

    }
}

//Forward process
protocol FoodieAddOnsProtocol: class {
    
    func ondoneAction(addonsItem: NSMutableArray,indexPath:Int,tag:Int,isplus: Bool)
}
