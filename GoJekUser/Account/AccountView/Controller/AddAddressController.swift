//
//  AddAddressController.swift
//  GoJekUser
//
//  Created by Ansar on 04/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire

class AddAddressController: UIViewController,UITextViewDelegate {
    
    @IBOutlet weak var currentLocTextField: UITextField!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var centerMarkerImage: UIImageView!
    @IBOutlet weak var topView:UIView!
    
    
    @IBOutlet weak var locationTextField: CustomTextField!
    @IBOutlet weak var locTextField: UITextView!
    
    @IBOutlet weak var flatTextField: CustomTextField!
    @IBOutlet weak var landmarkTextfield: CustomTextField!
    @IBOutlet weak var saveTextField: CustomTextField!
    @IBOutlet weak var titleTextfield: CustomTextField!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var detailView: UIView!
    
    @IBOutlet weak var titleView: UIView!
    
    @IBOutlet weak var enterDetails: UILabel!
    
    var address: AddressResponseData?
    var addressDetail: AddressDetails?
    var addressTypeArray: [String] = Array()
    private var mapViewHelper:GoogleMapsHelper?
    var isUserInteractingWithMap = false
    private var googlePlacesHelper : GooglePlacesHelper?
    private var datasource: [GMSAutocompletePrediction] = []
    private var locationView:LocationTableView!
    var addressDetails:((AddressDetails)->Void)?
    var addAdressBool = Bool()
    var addressTypeArr: [String]  = []
    private var xmapView: XMapView?

    
    var sourceDestinationDetail = SourceDestinationLocation()
    {
        didSet {
            DispatchQueue.main.async {
                self.currentLocTextField.text = self.sourceDestinationDetail.address
                self.locTextField.text = self.sourceDestinationDetail.address
                
                
            }
        }
    }
    
    var isHideTitle: Bool = false {
        didSet {
            titleView.isHidden = isHideTitle
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoads()
        locTextField.sizeToFit()
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewDidLayoutSubviews()
        xmapView?.frame = mapView.bounds
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addMapView()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeMapView()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 13.0, *) {
            if UITraitCollection.current.userInterfaceStyle == .dark {
                isDarkMode = true
            }
            else {
                isDarkMode = false
            }
        }
        else{
            isDarkMode = false
        }
        setDarkMode()
    }
    
    
}

//MARK:- Methods

extension AddAddressController {
    
    private func initialLoads() {
        currentLocTextField.delegate = self
        currentLocTextField.placeholder = Constant.enterLocation.localized
        googlePlacesHelper = GooglePlacesHelper()
        setLeftBarButtonWith(color: .blackColor, leftButtonImage: Constant.ic_back)
        currentLocTextField.clearButtonMode = .whileEditing
        self.title = AccountConstant.AddAddress.localized
        confirmButton.setBothCorner()
        confirmButton.backgroundColor = .appPrimaryColor
        titleView.isHidden = true
       // locationTextField.delegate = self
        locTextField.delegate = self
        locTextField.borderColor = UIColor.black
        locTextField.textContainerInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        locTextField.setCornerRadius()
        locTextField.layer.borderWidth = 1
        flatTextField.delegate = self
        landmarkTextfield.delegate = self
        saveTextField.delegate = self
        titleTextfield.delegate = self
        self.view.backgroundColor = .veryLightGray
        detailView.setCornerRadiuswithValue(value: 5.0)
        localize()
        if !self.isUserInteractingWithMap {
            if let addressValue = address {
                setCellValues(values: addressValue)
            } else {
                setAddNewAddress()
            }
        }
        
        if address != nil {
            CellValues(values: address!)
        }
        confirmButton.addTarget(self, action: #selector(tapConfirm), for: .touchUpInside)
        if addressDetail != nil {
            flatTextField.text = self.addressDetail?.flatno
            locTextField.text = self.addressDetail?.location
        }
        setDarkMode()
    }
    
    private func setDarkMode(){
        mapView.backgroundColor = .whiteColor
        self.view.backgroundColor = .backgroundColor
        self.detailView.backgroundColor = .boxColor
        self.currentLocTextField.textColor = .blackColor
        currentLocTextField.backgroundColor = .whiteColor
        topView.backgroundColor = .whiteColor
        if(isDarkMode){
            topView.borderColor = .white
            topView.borderLineWidth = 0.5
        }
    }
    
    func setAddNewAddress() {
        getCurrentLocationDetails()
    }
    
    //Getting current location detail
    private func getCurrentLocationDetails() {
        self.mapViewHelper?.getCurrentLocation(onReceivingLocation: {  [weak self] (location) in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                self.xmapView?.moveCameraPosition(lat: location.coordinate.latitude , lng: location.coordinate.longitude)
            }
        })
    }
    
    func setCellValues(values: AddressResponseData)  {
        
        self.sourceDestinationDetail = SourceDestinationLocation(address: values.locationAddress(), locationCoordinate: CLLocationCoordinate2D(latitude: values.latitude ?? 0, longitude: values.longitude ?? 0))
        self.xmapView?.moveCameraPosition(lat: values.latitude ?? APPConstant.defaultMapLocation.latitude, lng: values.latitude ?? APPConstant.defaultMapLocation.longitude)
    }
    
    func CellValues(values: AddressResponseData)  {
        
        self.locTextField.text = values.street
        self.flatTextField.text =  values.flat_no
        self.saveTextField.text = values.address_type
        self.landmarkTextfield.text = values.landmark
        
        self.titleTextfield.text = values.title
        
        if saveTextField.text == AddressType.Other.rawValue {
            self.isHideTitle = false
            
        }else{
            self.isHideTitle = true
        }
    }
    
    private func localize() {
        self.locTextField.text = AccountConstant.location.localized
        self.flatTextField.placeholder = AccountConstant.flatNo.localized
        self.landmarkTextfield.placeholder = AccountConstant.landmark.localized
        self.saveTextField.placeholder = AccountConstant.saveAs.localized
        self.titleTextfield.placeholder = AccountConstant.title.localized
        self.enterDetails.text = AccountConstant.enterDetail.localized
        self.confirmButton.setTitle(AccountConstant.confirmLocation.localized, for: .normal)
    }
    
    
    private func addMapView() {
        xmapView = XMapView(frame: mapView.bounds)
        xmapView?.tag = 100
        guard let _ = xmapView else {
            return
        }
        mapView.addSubview(xmapView!)
        
        xmapView?.didDragMap = { [weak self] (isDrag,locationDetails) in
            guard let self = self else {
                return
            }
            if !isDrag && ((locationDetails?.latitude ?? 0) != 0) {
                DispatchQueue.main.async {
                    self.xmapView?.getLocationFromMovement(lat: locationDetails?.latitude ?? 0, long: locationDetails?.longitude ?? 0, completion: { (moveMentLcation) in
                        if self.address == nil {
                        self.sourceDestinationDetail = moveMentLcation
                        }
                    })
                }
            }
        }
    }
    
    private func removeMapView() {
        for subView in mapView.subviews where subView.tag == 100 {
            xmapView?.clearAll()
            subView.removeFromSuperview()
            xmapView = nil
        }
    }
    
    private func showTitles() {
        
        var addressTypeArr: [String]  = []
        for address in  AddressType.allCases {
            addressTypeArr.append(address.rawValue)
        }
        PickerManager.shared.showPicker(pickerData: addressTypeArr, selectedData: nil) { [weak self] (selectedType) in
            guard let self = self else {
                return
            }
            let index = AddressType.allCases.indexesOf(object: AddressType(rawValue: selectedType))
            self.saveTextField.text = selectedType
            if index == 2 { //other
                self.isHideTitle = false
                
            }
            else{
                self.isHideTitle = true
            }
          
            self.view.setNeedsUpdateConstraints()
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func tapConfirm()  {
        self.view.endEditing()
        guard let locationStr = locTextField.text, !locationStr.isEmpty else {
            locTextField.becomeFirstResponder()
            ToastManager.show(title: AccountConstant.location.localized , state: .error)
            return
        }
        
        guard let flatNo = flatTextField.text, !flatNo.isEmpty else {
            flatTextField.becomeFirstResponder()
            ToastManager.show(title: AccountConstant.flatNo.localized , state: .error)
            return
        }
        
        guard let landmark = landmarkTextfield.text, !landmark.isEmpty else {
            landmarkTextfield.becomeFirstResponder()
            ToastManager.show(title: AccountConstant.enterLandmark.localized , state: .error)
            return
        }
        
        guard let addressType = saveTextField.text, !addressType.isEmpty else {
            saveTextField.becomeFirstResponder()
            ToastManager.show(title: AccountConstant.addressType.localized , state: .error)
            return
        }
        
        if saveTextField.text == AddressType.Other.rawValue {
            guard let title = titleTextfield.text, !title.isEmpty else {
                titleTextfield.becomeFirstResponder()
                ToastManager.show(title: AccountConstant.enterTitle.localized , state: .error)
                return
            }
        }
        
        if (addressTypeArray.contains((saveTextField.text?.uppercased() ?? ""))) {
            showAddressTypeAlert()
            return
        }
        
        if (addressTypeArray.contains((titleTextfield.text?.uppercased() ?? ""))) {
            showAddressTypeAlert()
            return
        }
        
        var param:Parameters = [AccountConstant.address_type : saveTextField.text!,
                                AccountConstant.landmark : landmarkTextfield.text!,
                                AccountConstant.flat_no : flatTextField.text!,
                                AccountConstant.street : locTextField.text!,
                                AccountConstant.latitude : sourceDestinationDetail.locationCoordinate?.latitude ?? 0.0,
                                AccountConstant.longitude : sourceDestinationDetail.locationCoordinate?.longitude ?? 0.0,
                                AccountConstant.map_address : locTextField.text ?? ""]
        
        if saveTextField.text == AddressType.Other.rawValue {
            param[AccountConstant.title] = titleTextfield.text!
        }
        
        self.accountPresenter?.addAddress(param: param)
    }
    
    private func showAddressTypeAlert() {
        AppAlert.shared.simpleAlert(view: self, title: "", message:  AccountConstant.addressTypeExit, buttonOneTitle: Constant.SYes, buttonTwoTitle: Constant.SNo)
        AppAlert.shared.onTapAction = { [weak self] (tag) in
            guard let self = self else {
                return
            }
            if tag == 0 {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

//MARK:- UITableViewDelegate

extension AddAddressController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return (self.view.frame.height/100)*60
        }else {
            return UITableView.automaticDimension
        }
    }
}

//MARK:- UITextFieldDelegate

extension AddAddressController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == currentLocTextField  {
            textField.text = ""
            textField.placeholder = ""
            self.datasource = []
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == saveTextField {
            self.view.endEditing()
            self.showTitles()
            return false
        }
        return true
    }
    
   
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        datasource = []
        removeSearchView()
        return true
    }
    
    func removeSearchView() {
        if let _ = locationView {
            locationView.removeFromSuperview()
            locationView = nil
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        if textField == currentLocTextField {
            guard let text = textField.text, !text.isEmpty, range.location>0 || range.length>1 else {
                self.datasource = []
                removeSearchView()
                return true
            }
            
            let searchText = text+string
            
            self.getPredications(from: searchText)
            
            return true
        }
        
        return true
        
    }
    
    private func getPredications(from string : String?){
        
        xmapView?.getPredictions(addressString: string ?? "", completion: { [weak self] (predictions) in
            guard let self = self else {
                return
            }
            self.showLocationView(predictValues: predictions)
        })
        
        
    }
    
    func showLocationView(predictValues:[GMSAutocompletePrediction]) {
        if self.locationView == nil, let locationView = Bundle.main.loadNibNamed(Constant.LocationTableView, owner: self, options: [:])?.first as? LocationTableView {
            
            let midY = CGFloat(self.topView.frame.maxY + topView.frame.height + 10)
            print(midY)
            locationView.frame = CGRect(x: self.topView.frame.origin.x, y: midY, width: self.topView.frame.width, height: self.view.frame.height-(250))
            if predictValues.count > 0 {
                locationView.setValues(values: predictValues)
            }
            locationView.show(with: .bottom, completion: nil)
            self.view.addSubview(locationView)
            self.locationView = locationView
        }else {
            self.locationView.setValues(values: predictValues)
        }
        self.locationView.onSelectedLocation = { [weak self] (location) in
            guard let self = self else {
                return
            }
            self.locationView?.removeFromSuperview()
            self.locationView = nil
            self.sourceDestinationDetail = location
            self.xmapView?.moveCameraPosition(lat: location.locationCoordinate?.latitude ?? APPConstant.defaultMapLocation.latitude, lng: location.locationCoordinate?.longitude ?? APPConstant.defaultMapLocation.longitude)
            
        }
    }
}

//MARK:- AccountPresenterToAccountViewProtocol

extension AddAddressController: AccountPresenterToAccountViewProtocol {
    
    func addAddressSuccess(addressEntity: SuccessEntity) {
        ToastManager.show(title: AccountConstant.addedAddress.localized, state: .success)
        self.navigationController?.popViewController(animated: true)
    }
}

