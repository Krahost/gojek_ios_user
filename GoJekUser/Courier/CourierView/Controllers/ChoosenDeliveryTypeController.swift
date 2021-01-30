//
//  ChoosenDeliveryTypeController.swift
//  GoJekUser
//
//  Created by Sudar on 27/05/20.
//  Copyright © 2020 Appoets. All rights reserved.
//


import UIKit

class ChoosenDeliveryTypeController: UIViewController {

   @IBOutlet weak var choosenDeliveryTableView: UITableView!

    let deliveryArr = [CourierConstant.singleDelivery,CourierConstant.multipleDelivery]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Hide show tabbar
        hideTabBar()
        self.title = CourierConstant.chooseYourDelivery
        setLeftBarButtonWith(color: .blackColor)
        navigationController?.isNavigationBarHidden = false
    
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setColor()
        choosenDeliveryTableView.delegate = self
        choosenDeliveryTableView.dataSource = self
        choosenDeliveryTableView.register(nibName: XuberConstant.XuberServiceListCell)
        setDarkMode()
    }
    
    private func setColor(){
        view.backgroundColor = .veryLightGray
    }
    
    private func setDarkMode(){
        self.view.backgroundColor = .backgroundColor
        self.choosenDeliveryTableView.backgroundColor = .boxColor
        
    }

}
// MARK: - UITableViewDataSource

extension ChoosenDeliveryTypeController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
       return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deliveryArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:XuberServiceListCell = self.choosenDeliveryTableView.dequeueReusableCell(withIdentifier: XuberConstant.XuberServiceListCell, for: indexPath) as! XuberServiceListCell
        cell.underlineLeading.constant = 0
        cell.underlineTralling.constant = 0
        cell.serviceNameLabel.text = deliveryArr[indexPath.row]
        cell.underLineLabel.isHidden =  10-1 == indexPath.row
        cell.layoutIfNeeded()
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        if (tableView == self.choosenDeliveryTableView)
        {
            cell.backgroundColor = .boxColor
            
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
            
            if (indexPath.row == 0 && indexPath.row == 10-1)
            {
                cell.layer.mask = shapeLayerAll
            }
            else if (indexPath.row == 0)
            {
                cell.layer.mask = shapeLayerTop
            }
            else if (indexPath.row == 10-1)
            {
                cell.layer.mask = shapeLayerBottom
            }
        }
    }

}

// MARK: - UITableViewDelegate

extension ChoosenDeliveryTypeController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chooseCourierVC = CourierRouter.courierStoryboard.instantiateViewController(withIdentifier: CourierConstant.DeliveryTypeViewController) as! DeliveryTypeViewController
            CourierConstant.deliveryType = deliveryArr[indexPath.row]
        navigationController?.pushViewController(chooseCourierVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
extension ChoosenDeliveryTypeController: CourierPresenterToCourierViewProtocol {
    
}
