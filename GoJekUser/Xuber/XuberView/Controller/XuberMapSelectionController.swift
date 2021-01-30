//
//  XuberMapSelectionController.swift
//  GoJekUser
//
//  Created by Ansar on 23/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class XuberMapSelectionController: UIViewController {
    
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var topView:UIView!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
     @IBOutlet weak var viewCurrentLocation: UIView!
    
    
    private var mapViewHelper:GoogleMapsHelper?
    private var locationView:LocationTableView!
    private var googlePlacesHelper : GooglePlacesHelper?
    var locationDelegate: LocationDelegate?
    var isSelectLocation:Bool = true
    var xmapView: XMapView?
    private var datasource: [GMSAutocompletePrediction] = []   // Predictions List
    var userLocationDetail = SourceDestinationLocation() {
        didSet {
            DispatchQueue.main.async {
                self.locationTextField.text = self.userLocationDetail.address
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoads()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.mapViewHelper?.mapView?.frame = mapView.bounds
        doneButton.setBothCorner()
        viewCurrentLocation.setRadiusWithShadow()
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
        initialLoads()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeMapView()
    }
}

extension XuberMapSelectionController {
    
    private func initialLoads() {
        self.locationTextField.clearButtonMode = .whileEditing
        self.setNavigationBar()
        locationTextField.font = UIFont.setCustomFont(name: .medium, size: .x14)
        doneButton.titleLabel?.font = UIFont.setCustomFont(name: .bold, size: .x18)
        doneButton.setTitle(Constant.SDone.localized, for: .normal)
        doneButton.addTarget(self, action: #selector(tapDone), for: .touchUpInside)
        doneButton.backgroundColor = .appPrimaryColor
        self.googlePlacesHelper = GooglePlacesHelper()
        self.getCurrentLocationDetails()
        let locationViewGesture = UITapGestureRecognizer(target: self, action: #selector(tapCurrentLocation(_:)))
        self.viewCurrentLocation.addGestureRecognizer(locationViewGesture)
        locationTextField.textColor = .black
        addXMapView()
        mapView.backgroundColor = .whiteColor
        self.locationTextField.textColor = .blackColor
        locationTextField.backgroundColor = .whiteColor
        topView.backgroundColor = .whiteColor
        if(isDarkMode){
            topView.borderColor = .white
            topView.borderLineWidth = 0.5
        }
    }
    
    private func addXMapView() {
        xmapView = XMapView(frame: self.mapView.bounds)
        xmapView?.tag = 100
        guard let _ = xmapView else {
            return
        }
        self.mapView.addSubview(self.xmapView!)
        self.xmapView?.didDragMap = { [weak self] (isDrag,_) in
            guard let self = self else {
                return
            }
        }
    }
    
    
    @objc func tapCurrentLocation(_ sender: UITapGestureRecognizer){
        
        self.xmapView?.showCurrentLocation()
    }
    
    
    
    
    private func setNavigationBar() {
        self.setNavigationTitle()
        self.setLeftBarButtonWith(color: .blackColor)
        self.title = XuberConstant.selectLocation.localized
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    private func removeMapView() {
        for subView in self.mapView.subviews where subView.tag == 100 {
            subView.removeFromSuperview()
            self.mapViewHelper?.mapView = nil
            self.mapViewHelper = nil
        }
    }
    
    @objc func tapDone()  {
        guard !(locationTextField.text?.isEmpty ?? false) else {
            AppAlert.shared.simpleAlert(view: self, title: Constant.chooseLocation.localized, message: nil)
            return
        }
        self.navigationController?.popViewController(animated: true)
        self.locationDelegate?.selectedLocation(isSource: false, addressDetails: self.userLocationDetail) //isSource Unused
    }
    
    private func addMapView() {
        self.mapViewHelper = GoogleMapsHelper()
        self.mapViewHelper?.getMapView(withDelegate: self, in: self.mapView)
        self.mapViewHelper?.removerPinMarker()
    }

    //Getting current location detail
    private func getCurrentLocationDetails() {
        self.addMapView()
        self.mapViewHelper?.getCurrentLocation(onReceivingLocation: { [weak self] (location) in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                self.mapViewHelper?.moveTo(location: location.coordinate, with: self.mapView.center)
                self.xmapView?.showCurrentLocation()
            }
        })
    }
    
    private func getPredications(from string : String?){
        
        self.googlePlacesHelper?.getAutoComplete(with: string, with: { [weak self] (predictions) in
            guard let self = self else {
                return
            }
            if predictions.count > 0 {
                self.showLocationView(predictValues: predictions)
            }
        })
    }
    
    func showLocationView(predictValues:[GMSAutocompletePrediction]) {
        if self.locationView == nil , let locationView = Bundle.main.loadNibNamed(Constant.LocationTableView, owner: self, options: [:])?.first as? LocationTableView {
            let height = (self.view.frame.height/100)*40
            locationView.frame = CGRect(x: topView.frame.origin.x, y: (self.topView.frame.maxY+5), width: self.topView.frame.width, height: height)
            if predictValues.count > 0 {
                locationView.setValues(values: predictValues)
            }
            locationView.show(with: .bottom, completion: nil)
            self.view.addSubview(locationView)
            self.locationView = locationView
        }else{
            self.locationView.setValues(values: predictValues)
        }
        self.locationView.onSelectedLocation = { [weak self] location in
            guard let self = self else {
                return
            }
            self.locationView.dismissView(onCompletion: {
               self.locationView = nil
            })
            self.isSelectLocation = false
            self.mapViewHelper?.moveTo(location: location.locationCoordinate ?? APPConstant.defaultMapLocation, with: self.mapView.center)
            self.xmapView?.moveCameraPosition(lat: location.locationCoordinate?.latitude ?? APPConstant.defaultMapLocation.latitude, lng: location.locationCoordinate?.longitude ?? APPConstant.defaultMapLocation.longitude)
            self.userLocationDetail = location
        }
    }
    
}

//MARK: - Textfield Delegate

extension XuberMapSelectionController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return textField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        self.datasource = []
        self.getPredications(from: textField.text)
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.datasource = []
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        guard let text = textField.text, !text.isEmpty, range.location>0 || range.length>1 else {
            self.datasource = []
            return true
        }
        
        let searchText = text+string
        self.getPredications(from: searchText)
        
        return true
        
    }
}



// MARK:- MapView

extension XuberMapSelectionController : GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        if isSelectLocation {
            getLocationFromMovement(mapView: mapView)
        }else{
            isSelectLocation = true
        }
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        
        print("Gesture ",gesture)
        
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        if self.locationView != nil {
            self.locationView.dismissView(onCompletion: {
                self.locationView = nil
            })
        }
        self.isSelectLocation = false
        self.locationTextField.text = ""
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
        //        getLocationFromMovement(mapView: mapView)
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
                self.userLocationDetail = SourceDestinationLocation(address: address,locationCoordinate: LocationCoordinate(latitude: (result?.coordinate.latitude ?? APPConstant.defaultMapLocation.latitude), longitude: (result?.coordinate.longitude ?? APPConstant.defaultMapLocation.longitude)))
            }
        }
    }
}
