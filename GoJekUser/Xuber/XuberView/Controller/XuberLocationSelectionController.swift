//
//  XuberLocationSelectionController.swift
//  GoJekUser
//
//  Created by on 14/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class XuberLocationSelectionController: UIViewController {
    
    @IBOutlet weak var goButton :UIButton!
    @IBOutlet weak var savedLocationButton: UIButton!
    @IBOutlet weak var suggestLocationButton: UIButton!
    
    @IBOutlet weak var searchLocationTextField:UITextField!
    
    @IBOutlet weak var locationTableView: UITableView!
    
    @IBOutlet weak var textFieldStackView: UIStackView!
        
    var addressDatasource: [AddressResponseData] = []
    
    var userLocationDetail = SourceDestinationLocation() {
        didSet {
            DispatchQueue.main.async {
                self.searchLocationTextField.text = self.userLocationDetail.address
            }
        }
    }
    
    var isSavedLocation: Bool = false {
        didSet {
            savedLocationButton.backgroundColor = isSavedLocation ? .xuberColor : .white
            savedLocationButton.setTitleColor(isSavedLocation ? .white : .xuberColor, for: .normal)
            suggestLocationButton.backgroundColor = !isSavedLocation ? .xuberColor : .white
            suggestLocationButton.setTitleColor(!isSavedLocation ? .white : .xuberColor, for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoads()
    }
    
}

//MARK: - Methods
extension XuberLocationSelectionController {
    
    private func initialLoads() {
        self.setNavigationBar()
        suggestLocationButton.isHidden = true //no need now
        goButton.titleLabel?.font = UIFont.setCustomFont(name: .medium, size: .x16)
        savedLocationButton.titleLabel?.font = UIFont.setCustomFont(name: .medium, size: .x16)
        suggestLocationButton.titleLabel?.font = UIFont.setCustomFont(name: .medium, size: .x14)
        searchLocationTextField.font = UIFont.setCustomFont(name: .medium, size: .x16)
        self.locationTableView.register(nibName: XuberConstant.XuberLocationCell)
        self.locationTableView.separatorColor = .veryLightGray
        goButton.backgroundColor = .xuberColor
        self.view.backgroundColor = .veryLightGray
        self.savedLocationButton.addTarget(self, action: #selector(tapSavedLocation), for: .touchUpInside)
        self.suggestLocationButton.addTarget(self, action: #selector(tapSuggestLocation), for: .touchUpInside)
        self.goButton.addTarget(self, action: #selector(tapGoButton), for: .touchUpInside)
        savedLocationButton.setTitle(XuberConstant.savedLocation.localized, for: .normal)
        suggestLocationButton.setTitle(XuberConstant.suggestLocation, for: .normal)
        searchLocationTextField.placeholder = XuberConstant.searchLocation
//        isSavedLocation = true
        self.xuberPresenter?.getSavedAddress()
        setDarkMode()
    }
    
    private func setNavigationBar() {
        self.setNavigationTitle()
        self.setLeftBarButtonWith(color: .blackColor)
        self.title = XuberConstant.selectLocation.localized
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
 private func setDarkMode(){
         self.view.backgroundColor = .backgroundColor
         self.searchLocationTextField.textColor = .black
         self.savedLocationButton.setTitleColor(.blackColor, for: .normal)
        }
    
    @objc func tapSavedLocation() {
        isSavedLocation = true
    }
    
    @objc func tapSuggestLocation() {
        isSavedLocation = false
    }
    
    @objc func tapGoButton() {
        guard !(self.searchLocationTextField.text?.isEmpty ?? false) else {
            ToastManager.show(title: XuberConstant.chooseLocation, state: .error)
            return
        }
        let vc = XuberRouter.xuberStoryboard.instantiateViewController(withIdentifier: XuberConstant.XuberProviderListController) as! XuberProviderListController
        vc.userLocationDetail = self.userLocationDetail
        SendRequestInput.shared.s_address = self.userLocationDetail.address
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK: - Tableview Delegate Datasource

extension XuberLocationSelectionController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
       
        return self.addressDatasource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:XuberLocationCell = self.locationTableView.dequeueReusableCell(withIdentifier: XuberConstant.XuberLocationCell, for: indexPath) as! XuberLocationCell
        cell.setCellValues(values: self.addressDatasource[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = XuberRouter.xuberStoryboard.instantiateViewController(withIdentifier: XuberConstant.XuberProviderListController) as! XuberProviderListController
        if let latitude = self.addressDatasource[indexPath.row].latitude, let longitude = self.addressDatasource[indexPath.row].longitude {
            vc.userLocationDetail = SourceDestinationLocation(address: self.addressDatasource[indexPath.row].locationAddress(), locationCoordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
            SendRequestInput.shared.s_address = self.addressDatasource[indexPath.row].locationAddress()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        if (tableView == self.locationTableView)
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
            
            if (indexPath.row == 0 && indexPath.row == addressDatasource.count-1)
            {
                cell.layer.mask = shapeLayerAll
            }
            else if (indexPath.row == 0)
            {
                cell.layer.mask = shapeLayerTop
            }
            else if (indexPath.row == addressDatasource.count-1)
            {
                cell.layer.mask = shapeLayerBottom
            }
        }
    }
}

//MARK: - Textfield Delegate

extension XuberLocationSelectionController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == searchLocationTextField {
            if guestLogin() {
            let vc = XuberRouter.xuberStoryboard.instantiateViewController(withIdentifier: XuberConstant.XuberMapSelectionController) as! XuberMapSelectionController
            vc.locationDelegate = self
            self.navigationController?.pushViewController(vc, animated: true)
            }
            return false
        }
        return  true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing()
        return true
    }
}


//MARK: - API

extension XuberLocationSelectionController: XuberPresenterToXuberViewProtocol {
    
    func getSavedAddress(addressEntity: SavedAddressEntity) {
        addressDatasource = addressEntity.responseData ?? []
        if addressDatasource.count == 0 {
            self.locationTableView.setBackgroundImageAndTitle(imageName: XuberConstant.addressImage, title: Constant.noSavedAddress.localized, tintColor: UIColor.xuberColor)
        }else{
            self.locationTableView.backgroundView = nil
        }
        self.locationTableView.reloadInMainThread()
    }
}

extension  XuberLocationSelectionController : LocationDelegate {
    
    func selectedLocation(isSource: Bool, addressDetails: SourceDestinationLocation) {
        self.userLocationDetail = addressDetails
    }
    
}
