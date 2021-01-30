//
//  DeliveryTypeViewController.swift
//  GoJekUser
//
//  Created by Sudar on 17/01/20.
//  Copyright © 2020 Appoets. All rights reserved.
//

import UIKit

class DeliveryTypeViewController: UIViewController {
    
    @IBOutlet weak var deliveryTableView: UITableView!
    var courierPackArr : CourierPackagesList?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Hide show tabbar
        hideTabBar()
        navigationController?.isNavigationBarHidden = false
        self.view.backgroundColor = .veryLightGray
        setLeftBarButtonWith(color: .blackColor)
        setDarkMode()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setColor()
        deliveryTableView.delegate = self
        deliveryTableView.dataSource = self
        deliveryTableView.register(nibName: XuberConstant.XuberServiceListCell)
        
        self.courierPresenter?.getDeliveryList()
        
    }
    
    private func setColor(){
        view.backgroundColor = .veryLightGray
    }
    
    private func setDarkMode(){
        self.view.backgroundColor = .backgroundColor
        self.deliveryTableView.backgroundColor = .boxColor
        
    }
}

// MARK: - UITableViewDataSource

extension DeliveryTypeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.courierPackArr?.responseData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:XuberServiceListCell = self.deliveryTableView.dequeueReusableCell(withIdentifier: XuberConstant.XuberServiceListCell, for: indexPath) as! XuberServiceListCell
        cell.underlineLeading.constant = 0
        cell.underlineTralling.constant = 0
        cell.serviceNameLabel.text =  self.courierPackArr?.responseData?[indexPath.row].delivery_name
        cell.underLineLabel.isHidden =  10-1 == indexPath.row
        cell.layoutIfNeeded()
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        if (tableView == self.deliveryTableView) {
            cell.backgroundColor = .white
            let radius = 10.0
            //Top Left Right Corners
            let maskPathTop = UIBezierPath(roundedRect: cell.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: radius, height: radius))
            let shapeLayerTop = CAShapeLayer()
            shapeLayerTop.frame = cell.bounds
            shapeLayerTop.path = maskPathTop.cgPath
            
            //Bottom Left Right Corners
            let maskPathBottom = UIBezierPath(roundedRect: cell.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: radius, height: radius))
            let shapeLayerBottom = CAShapeLayer()
            shapeLayerBottom.frame = cell.bounds
            shapeLayerBottom.path = maskPathBottom.cgPath
            
            //All Corners
            let maskPathAll = UIBezierPath(roundedRect: cell.bounds, byRoundingCorners: [.topLeft, .topRight, .bottomRight, .bottomLeft], cornerRadii: CGSize(width: radius, height: radius))
            let shapeLayerAll = CAShapeLayer()
            shapeLayerAll.frame = cell.bounds
            shapeLayerAll.path = maskPathAll.cgPath
            
            if (indexPath.row == 0 && indexPath.row == 10-1) {
                cell.layer.mask = shapeLayerAll
            }
            else if (indexPath.row == 0) {
                cell.layer.mask = shapeLayerTop
            }
            else if (indexPath.row == 10-1) {
                cell.layer.mask = shapeLayerBottom
            }
        }
    }
    
}

// MARK: - UITableViewDelegate

extension DeliveryTypeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if guestLogin() {
        let courierHomeVC = CourierRouter.courierStoryboard.instantiateViewController(withIdentifier: CourierConstant.CourierHomeController) as! CourierHomeController
        courierHomeVC.deliveryTypeID = self.courierPackArr?.responseData?[indexPath.row].id ?? 0
        navigationController?.pushViewController(courierHomeVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}

extension DeliveryTypeViewController: CourierPresenterToCourierViewProtocol {
    
    func courierDeliveryTypeListSuccess(requestEntity: CourierPackagesList) {
        
        courierPackArr =  requestEntity
        self.deliveryTableView.reloadData()
    }
}
