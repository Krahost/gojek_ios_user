//
//  FoodieFilterController.swift
//  GoJekUser
//
//  Created by Ansar on 19/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class FoodieFilterController: UIViewController {
    
    @IBOutlet weak var filterTableView: UITableView!
    @IBOutlet weak var applyFiterButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var headingLabel: UILabel!
    
    @IBOutlet weak var closeBgButton: UIButton!
    @IBOutlet weak var bottomLine: UIView!
    
    var appliedFilter:Bool = false
    var cusineList:[CusineResponseData] = []
    var showRestaurantList = [FoodieConstant.pureVeg,FoodieConstant.nonVeg,FoodieConstant.freeDelivery]
    var qfilterArr = NSMutableArray()
    var filterArr = NSMutableArray()
    weak var delegate: FoodieFilterControllerDelegate?
    var isFoodie:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoads()
    }
    
    
}

//MARK: - Methods

extension FoodieFilterController {
    private func initialLoads()  {
        self.closeBgButton.addTarget(self, action: #selector(tapCloseButton), for: .touchUpInside)
        self.resetButton.addTarget(self, action: #selector(tapResetButton), for: .touchUpInside)
        applyFiterButton.addTarget(self, action: #selector(tapapplyFilterButton), for: .touchUpInside)
        self.filterTableView.register(nibName: FoodieConstant.FoodieFilterTableViewCell)
        self.closeButton.setImage(UIImage(named: Constant.closeImage), for: .normal)
        self.applyFiterButton.backgroundColor = .red
        resetButton.setTitleColor(.foodieColor, for: .normal)
        bottomLine.backgroundColor = .veryLightGray
        
        setFont()
        setLocalize()
        foodiePresenter?.getCusineList(Id: AppManager.shared.getSelectedServices()?.menu_type_id ?? 0)
        setDarkMode()
    }
    
    
    private func setDarkMode(){
        self.view.backgroundColor = .backgroundColor
        self.closeButton.tintColor = .blackColor

    }
    
    func setLocalize(){
        self.headingLabel.text = FoodieConstant.filter.localized.uppercased()
        self.resetButton.setTitle(FoodieConstant.reset.localized.uppercased(), for: .normal)
        applyFiterButton.setTitle(FoodieConstant.applyFilter.localized.uppercased(), for: .normal)
    }
    
    func setFont(){
        applyFiterButton.titleLabel?.font = UIFont.setCustomFont(name: .medium, size: .x16)
        resetButton.titleLabel?.font = UIFont.setCustomFont(name: .medium, size: .x16)
        headingLabel.font = UIFont.setCustomFont(name: .bold, size: .x18)
    }
    
    @objc func tapCloseButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func tapapplyFilterButton() {
        
        for item in qfilterArr {
            let itemStr = item as! String
            if itemStr == FoodieConstant.pureVeg {
                qfilterArr.remove(item)
                qfilterArr.add(RestaurantType.veg.rawValue)
            }else if itemStr == FoodieConstant.nonVeg{
                qfilterArr.remove(item)
                qfilterArr.add(RestaurantType.nonveg.rawValue)
            }else if itemStr == FoodieConstant.freeDelivery {
                qfilterArr.remove(item)
                qfilterArr.add(RestaurantType.freedelivery.rawValue)
            }
        }
        let filterstr = filterArr.componentsJoined(by: ",")
        let qFilterstr = qfilterArr.componentsJoined(by: ",")
        
        delegate?.applyFilterAction(filterArr: filterstr, qfilter: qFilterstr)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @objc func tapResetButton() {
        filterArr.removeAllObjects()
        qfilterArr.removeAllObjects()
        filterTableView.reloadData()
    }
}

//MARK: - Tableview Delegate Datasource

extension FoodieFilterController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.filterTableView.cellForRow(at: indexPath) as! FoodieFilterTableViewCell
        cell.isSelectedItem = !cell.isSelectedItem
        
        if !isFoodie {
            if cell.isSelectedItem {
                filterArr.add(cusineList[indexPath.row].id ?? 0)
            }else{
                if filterArr.contains(cusineList[indexPath.row].id ?? 0) {
                    filterArr.remove(cusineList[indexPath.row].id ?? 0)
                }
            }
        }else{
            if indexPath.section == 0 {
                if cell.isSelectedItem {
                    qfilterArr.add(self.showRestaurantList[indexPath.row])
                }else{
                    if qfilterArr.contains(self.showRestaurantList[indexPath.row]) {
                        qfilterArr.remove(cusineList[indexPath.row].id ?? 0)
                    }
                }
            }else{
                if cell.isSelectedItem {
                    filterArr.add(cusineList[indexPath.row].id ?? 0)
                }else{
                    if filterArr.contains(cusineList[indexPath.row].id ?? 0) {
                        filterArr.remove(cusineList[indexPath.row].id ?? 0)
                    }
                }
            }
        }
    }
}

extension FoodieFilterController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return isFoodie ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !isFoodie {
            return cusineList.count
        }else{
            return section == 0 ? showRestaurantList.count: cusineList.count
        }
    }
    

    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30))
        headerView.backgroundColor = .backgroundColor
        
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: headerView.frame.width-40, height: headerView.frame.height))
        label.font = UIFont.setCustomFont(name: .medium, size: .x16)
        if !isFoodie {
            label.text = FoodieConstant.category.localized
        }else{
            label.text = section == 0 ? FoodieConstant.showShops.localized : FoodieConstant.category.localized
        }
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:FoodieFilterTableViewCell = self.filterTableView.dequeueReusableCell(withIdentifier: FoodieConstant.FoodieFilterTableViewCell, for: indexPath) as! FoodieFilterTableViewCell

        if !isFoodie {
            if filterArr.contains(cusineList[indexPath.row].id ?? 0) {
                cell.isSelectedItem = true
            }else{
                cell.isSelectedItem = false
                
            }
            cell.setFilterData(data: cusineList[indexPath.row])
        }else{
            if indexPath.section == 0 {
                cell.titleLabel.text = self.showRestaurantList[indexPath.row]
                if qfilterArr.contains(self.showRestaurantList[indexPath.row]) {
                    cell.isSelectedItem = true
                }else{
                    cell.isSelectedItem = false
                }
            }else{
                if filterArr.contains(cusineList[indexPath.row].id ?? 0) {
                    cell.isSelectedItem = true
                }else{
                    cell.isSelectedItem = false
                    
                }
                cell.setFilterData(data: cusineList[indexPath.row])
            }
        }
        return cell
    }
    
}
extension FoodieFilterController: FoodiePresenterToFoodieViewProtocol{
    func cusineListResponse(getCusineListResponse: CusineListEntity) {
        cusineList = getCusineListResponse.responseData ?? []
        filterTableView.reloadInMainThread()
    }
}

// MARK: - Protocol
protocol FoodieFilterControllerDelegate: class {
    func applyFilterAction(filterArr:String,qfilter:String)
}
