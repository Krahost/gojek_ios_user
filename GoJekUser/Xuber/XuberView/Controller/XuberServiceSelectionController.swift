//
//  ServiceSelectionController.swift
//  GoJekUser
//
//  Created by Ansar on 06/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

class XuberServiceSelectionController: UIViewController {
    
    @IBOutlet weak var subServiceTableView: UITableView!
    
    var subCategoryList:[XuberSubServiceList] = [] {
        didSet {
            subServiceTableView.reloadInMainThread()
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoads()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideTabBar()
        self.navigationController?.isNavigationBarHidden = false
    }
    

}

//MARK: - Methods

extension XuberServiceSelectionController {
    
    private func initialLoads() {
        self.view.backgroundColor = .veryLightGray
        setNavigationBar()
        let leftButton = UIBarButtonItem(image: UIImage(named: Constant.ic_back)?.imageFlippedForRightToLeftLayoutDirection(), style: .plain, target: self, action: #selector(tapBack))
        self.navigationController?.navigationBar.tintColor = .blackColor
        self.navigationItem.leftBarButtonItem = leftButton

        self.subServiceTableView.register(nibName: XuberConstant.XuberServiceListCell)
        SendRequestInput.shared.clear()
        let baseEntity = AppConfigurationManager.shared.baseConfigModel.responseData
               let countryArray = AppManager.shared.getCountries()
               let countryCode = AppManager.shared.getUserDetails()?.country?.id ?? baseEntity?.appsetting?.country
                   let cityArray = countryArray?.filter({$0.id == countryCode}).first
        if let cityId = cityArray?.city?.first?.id  {
            let param: Parameters = [LoginConstant.city_id: cityId]
            
            xuberPresenter?.getSubCategory(id: (SendRequestInput.shared.mainServiceId ?? 0).toString(), param: param)
        }
    setDarkMode()
    }
    
    private func setDarkMode(){
         self.view.backgroundColor = .backgroundColor
        self.subServiceTableView.backgroundColor = .backgroundColor
     }
    
    private func setNavigationBar() {
        self.setNavigationTitle()
        self.setLeftBarButtonWith(color: .blackColor)
        self.title = SendRequestInput.shared.mainSelectedService
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    @objc private func tapBack() {
        let vc = HomeRouter.homeStoryboard.instantiateViewController(withIdentifier: HomeConstant.VHomeViewController) as! HomeViewController
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - Tableview Datasource

extension XuberServiceSelectionController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.subCategoryList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:XuberServiceListCell = self.subServiceTableView.dequeueReusableCell(withIdentifier: XuberConstant.XuberServiceListCell, for: indexPath) as! XuberServiceListCell
        cell.serviceNameLabel.text = self.subCategoryList[indexPath.row].service_subcategory_name
        cell.underLineLabel.isHidden =  self.subCategoryList.count-1 == indexPath.row
        return cell
    }
}

//MARK: - Tableview Delegate

extension  XuberServiceSelectionController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = XuberRouter.xuberStoryboard.instantiateViewController(withIdentifier: XuberConstant.XuberSubServiceController) as! XuberSubServiceController
        vc.selectedServiceId = self.subCategoryList[indexPath.row].id ?? 0
        if let selectedService = self.subCategoryList[indexPath.row].service_subcategory_name {
            vc.selectedServiceCategory = selectedService
            SendRequestInput.shared.selectedSubService = selectedService
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        if (tableView == self.subServiceTableView)
        {
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
            
            if (indexPath.row == 0 && indexPath.row == self.subCategoryList.count-1)
            {
                cell.layer.mask = shapeLayerAll
            }
            else if (indexPath.row == 0)
            {
                cell.layer.mask = shapeLayerTop
            }
            else if (indexPath.row == self.subCategoryList.count-1)
            {
                cell.layer.mask = shapeLayerBottom
            }
        }
    }
}


//MARK: - XuberPresenterToXuberViewProtocol

extension XuberServiceSelectionController: XuberPresenterToXuberViewProtocol {

    func getSubCategory(subCategoryEntity: XuberSubCategoryEntity) {
        self.subCategoryList = subCategoryEntity.responseData ?? []
    }
}

