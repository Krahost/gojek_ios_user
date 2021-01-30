//
//  SaveLocationController.swift
//  GoJekUser
//
//  Created by  on 19/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class SaveLocationController: UIViewController {
    
    @IBOutlet weak var locationTableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    
    var savedLocationArr = [Constant.Shome.localized,Constant.Swork.localized,Constant.other.localized]
    var savedLocImageArr = [Constant.locationHome,Constant.ic_work,Constant.ic_location_pin]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoads()
    }
    
}

//MARK: - Methods

extension SaveLocationController {
    private func initialLoads() {
        locationTableView.register(nibName: Constant.SavedLocationCell)
        view.backgroundColor = .veryLightGray
        backButton.addTarget(self, action: #selector(tapBack), for: .touchUpInside)
    }
    
    @objc func tapBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func tapViewMore() {
        print("View more")
    }
}

//MARK: - Tableview Delegate Datasource

extension SaveLocationController: UITableViewDelegate {
    
}

extension SaveLocationController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : savedLocationArr.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: section == 0 ? 0 : 40))
        headerView.backgroundColor = .clear
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: headerView.frame.width-40, height: headerView.frame.height))
        label.text = HomeConstant.savedLocation.localized
        headerView.addSubview(label)
        return section == 0 ? nil : headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0,width: view.frame.width, height: 40))
        footerView.layer.cornerRadius = 5.0
        footerView.backgroundColor  = .white
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        button.setTitle(HomeConstant.viewMore.localized, for: .normal)
        button.setTitleColor(.appPrimaryColor, for: .normal)
        button.addTarget(self, action: #selector(tapViewMore), for: .touchUpInside)
        footerView.addSubview(button)
        return section == 0 ? nil : footerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 40
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SavedLocationCell = locationTableView.dequeueReusableCell(withIdentifier: Constant.SavedLocationCell, for: indexPath) as! SavedLocationCell
        cell.setCornerRadiuswithValue(value: 5.0)
        if indexPath.section == 0 {
            cell.locationImage.image = UIImage(named: Constant.ic_current_location)
            cell.locationTitleLabel.text = HomeConstant.currentLocation.localized
            cell.locationDetailsLabel.text = HomeConstant.enableLocation.localized
        }else{
            cell.locationImage.image = UIImage(named: savedLocImageArr[indexPath.row])
            cell.locationTitleLabel.text = savedLocationArr[indexPath.row]
            cell.locationDetailsLabel.text = "Lorem ipsum"
        }
        cell.locationImage.imageTintColor(color1: .lightGray)
        cell.locationDetailsLabel.textColor = .lightGray
        return cell
    }
}
