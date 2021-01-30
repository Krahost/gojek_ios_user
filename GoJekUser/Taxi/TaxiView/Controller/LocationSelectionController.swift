//
//  LocationSelectionView.swift
//  GoJekUser
//
//  Created by Ansar on 28/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

class LocationSelectionController: UIViewController {
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var topView:UIView!
    @IBOutlet weak var bottomView:UIView!
    @IBOutlet weak var centerMarkerImage: UIImageView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var savedLocationLabel: UILabel!
    @IBOutlet weak var locationTableView: UITableView!
    @IBOutlet weak var locationBottomView: UIView!
    
    var isExtendTrip:Bool = false
      var isFromCourier = false
    
    var isExtendTripSelectedLocation:((SourceDestinationLocation)->Void)?
    
    var locationName = [Constant.Shome.localized,
                        Constant.Swork.localized,
                        Constant.Swork.localized]
    
    private var locationView:LocationTableView!
    
    private var mapViewHelper:GoogleMapsHelper?
    
    var locationDelegate: LocationDelegate?
    
    private var isUserInteractingWithMap = false
    
    private  var googlePlacesHelper : GooglePlacesHelper?
    
    private var datasource: [GMSAutocompletePrediction] = []   // Predictions List
    
//    var taxiPresenter: TaxiViewToTaxiPresenterProtocol?
   
    
    var locationDataSource: [AddressResponseData]?
    
    private var xmapView: XMapView?
    
    var isSource:Bool = false
    var sourceDestinationDetail = SourceDestinationLocation() {
        didSet {
            DispatchQueue.main.async {
                self.locationTextField.text = self.sourceDestinationDetail.address
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoads()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        hideTabBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar()
        setDarkMode()
        viewWillAppearCustom()

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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //        mapViewHelper?.mapView?.frame = mapView.bounds
        xmapView?.frame = mapView.bounds
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        XCurrentLocation.shared.latitude = 0
        XCurrentLocation.shared.longitude = 0
        removeMapView()
    }
    
}

//MARK: - Methods

extension LocationSelectionController {
    
    private func initialLoads() {
        locationTextField.clearButtonMode = .whileEditing
        setNavigationBar()
       doneButton.backgroundColor = isFromCourier ? .courierColor : .taxiColor
        doneButton.setTitle(Constant.SDone.localized, for: .normal)
        savedLocationLabel.text = TaxiConstant.savedLocation.localized
        locationTextField.placeholder = Constant.enterLocation.localized
        locationTableView.register(UINib(nibName: Constant.SavedLocationCell, bundle: nil), forCellReuseIdentifier: Constant.SavedLocationCell)
        
        DispatchQueue.main.async {
            self.doneButton.setBothCorner()
            self.locationTableView.cornerRadius = 5.0
        }
        doneButton.addTarget(self, action: #selector(tapDone), for: .touchUpInside)
        googlePlacesHelper = GooglePlacesHelper()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        locationDataSource = AppManager.shared.getSavedAddress()
        if locationDataSource == nil || locationDataSource?.count == 0 {
            locationBottomView.isHidden = true
        }else {
            locationBottomView.isHidden = false
        }
        
        setFont()
    }
    
    private func setDarkMode(){
        mapView.backgroundColor = .whiteColor
        bottomView.backgroundColor = .backgroundColor
        locationTableView.backgroundColor = .backgroundColor
        self.locationTextField.textColor = .blackColor
           locationTextField.backgroundColor = .whiteColor
           topView.backgroundColor = .whiteColor
           if(isDarkMode){
               topView.borderColor = .white
               topView.borderLineWidth = 0.5
           }
    }
    
    private func viewWillAppearCustom() {
        addMapView()
        navigationController?.isNavigationBarHidden = false
        getCurrentLocationDetails()
    }
    
    private func setNavigationBar() {
        self.setNavigationTitle()
        self.setLeftBarButtonWith(color: .blackColor)
        var navTitle = String()
        if isSource {
            navTitle = TaxiConstant.pickLocation.localized
        }else {
            navTitle = TaxiConstant.dropLocation.localized
        }
        title = navTitle
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
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
            print(locationDetails?.latitude ?? 0)
            if !isDrag && ((locationDetails?.latitude ?? 0) != 0) {
                DispatchQueue.main.async {
                    self.xmapView?.getLocationFromMovement(lat: locationDetails?.latitude ?? 0, long: locationDetails?.longitude ?? 0, completion: { (moveMentLcation) in
                        self.sourceDestinationDetail = moveMentLcation
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
    
    func showLocationView(predictValues:[GMSAutocompletePrediction]) {
        if locationView == nil , let locationView = Bundle.main.loadNibNamed(Constant.LocationTableView, owner: self, options: [:])?.first as? LocationTableView {
            locationView.frame = CGRect(x: topView.frame.origin.x, y: (topView.frame.minY+topView.frame.height)+5, width: topView.frame.width, height: view.frame.height-(bottomView.frame.minY))
            if predictValues.count > 0 {
                locationView.setValues(values: predictValues)
            }
            locationView.show(with: .bottom, completion: nil)
            view.addSubview(locationView)
            self.locationView = locationView
        }else{
            locationView.setValues(values: predictValues)
        }
        locationView.onSelectedLocation = { [weak self] location in
            guard let self = self else {
                return
            }
            self.locationView?.removeFromSuperview()
            self.locationView = nil
            
            self.sourceDestinationDetail = location
            self.xmapView?.moveCameraPosition(lat: location.locationCoordinate?.latitude ?? APPConstant.defaultMapLocation.latitude, lng: location.locationCoordinate?.longitude ?? APPConstant.defaultMapLocation.longitude)
        }
    }
    
    private func getPredications(from string : String?) {
       
        xmapView?.getPredictions(addressString: string ?? "", completion: { [weak self] (predictions) in
            guard let self = self else {
                return
            }
            self.showLocationView(predictValues: predictions)
        })
    }
    
    func isMapInteracted(_ isHide : Bool){
        
        UIView.animate(withDuration: 0.2) {
            self.bottomView?.alpha = isHide ? 0 : 1
        }
    }
    
    //Getting current location detail
    private func getCurrentLocationDetails() {
        mapViewHelper?.getCurrentLocation(onReceivingLocation: { [weak self] (location) in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                self.xmapView?.moveCameraPosition(lat: location.coordinate.latitude , lng: location.coordinate.longitude)
            }
        })
    }
    
    @objc func tapDone(){
        guard !(locationTextField.text?.isEmpty ?? false) else {
            AppAlert.shared.simpleAlert(view: self, title: Constant.chooseLocation.localized, message: nil)
            return
        }
        navigationController?.popViewController(animated: true)
        locationDelegate?.selectedLocation(isSource: isSource, addressDetails: sourceDestinationDetail)
        if isExtendTrip == true {
            isExtendTripSelectedLocation!(sourceDestinationDetail)
        }
    }
    
    private func setFont() {
        locationTextField.font = .setCustomFont(name: .medium, size: .x14)
        doneButton.titleLabel?.font = .setCustomFont(name: .bold, size: .x18)
        savedLocationLabel.font = .setCustomFont(name: .medium, size: .x16)
    }
}

//MARK: - Tableview Delegate & Datasource

extension LocationSelectionController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let data = locationDataSource else { return 0 }
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.SavedLocationCell, for: indexPath) as? SavedLocationCell else { return UITableViewCell() }
        cell.setLocationDetails(addressDetails: (locationDataSource?[indexPath.row])!)
        return cell
    }
}

extension LocationSelectionController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return locationTableView.frame.height/2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedLocation = locationDataSource?[indexPath.row]
        sourceDestinationDetail = SourceDestinationLocation(address: selectedLocation?.locationAddress(),locationCoordinate: LocationCoordinate(latitude: (selectedLocation?.latitude ?? APPConstant.defaultMapLocation.latitude), longitude: (selectedLocation?.longitude ?? APPConstant.defaultMapLocation.longitude)))
        
        self.xmapView?.moveCameraPosition(lat: selectedLocation?.latitude ?? APPConstant.defaultMapLocation.latitude, lng: selectedLocation?.longitude ?? APPConstant.defaultMapLocation.longitude)
        
        navigationController?.popViewController(animated: true)
        locationDelegate?.selectedLocation(isSource: isSource, addressDetails: sourceDestinationDetail)
        if isExtendTrip == true {
            isExtendTripSelectedLocation!(sourceDestinationDetail)
        }
    }
}

//MARK: - Textfield Delegate

extension LocationSelectionController:UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        removeSearchView()
        self.view.endEditing()
        return true
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        datasource = []
    }
    
    func removeSearchView() {
        if let _ = locationView {
            locationView.removeFromSuperview()
            locationView = nil
        }
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        datasource = []
        removeSearchView()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        guard let text = textField.text, !text.isEmpty, range.location>0 || range.length>1 else {
            textField.text = ""
            datasource = []
            removeSearchView()
            return true
        }
        
        let searchText = text+string
        getPredications(from: searchText)
        return true
    }
}

// MARK:- MapView

extension LocationSelectionController : GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        getLocationFromMovement(mapView: mapView)
        isMapInteracted(false)
    }
    
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        
        print("Gesture ",gesture)
        isUserInteractingWithMap = gesture
        if isUserInteractingWithMap {
            isMapInteracted(true)
        }
    }
    
    func getLocationFromMovement(mapView:GMSMapView){
        let geocoder = GMSGeocoder()
        let latitute = mapView.camera.target.latitude
        let longitude = mapView.camera.target.longitude
        let position = CLLocationCoordinate2DMake(latitute, longitude)
        geocoder.reverseGeocodeCoordinate(position) { [weak self] response , error in
            guard let self = self else {
                return
            }
            if error != nil {
                print("GMSReverseGeocode Error: \(String(describing: error?.localizedDescription))")
            }else {
                let result = response?.results()?.first
                let address = result?.lines?.reduce("") { $0 == "" ? $1 : $0 + ", " + $1 }
                self.sourceDestinationDetail = SourceDestinationLocation(address: address,locationCoordinate: LocationCoordinate(latitude: (result?.coordinate.latitude ?? APPConstant.defaultMapLocation.latitude), longitude: (result?.coordinate.longitude ?? APPConstant.defaultMapLocation.longitude)))
            }
        }
    }
}


