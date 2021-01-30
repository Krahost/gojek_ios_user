//
//  MapCell.swift
//  CoreDataSample
//
//  Created by Ansar on 05/04/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class MapCell: UITableViewCell {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var centerMarkerImage: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var topView:UIView!
    @IBOutlet weak var mapView: UIView!
    
    private var mapViewHelper: GoogleMapsHelper?
    private var googlePlacesHelper: GooglePlacesHelper?
    private var datasource: [GMSAutocompletePrediction] = []
    private var locationView: LocationTableView!
    
    var addAdressBool = Bool()
    var isUserInteractingWithMap = false
    
    var tapBack: (() -> Void)?
    var addressDetails: ((AddressDetails) -> Void)?
    var sourceDestinationDetail = SourceDestinationLocation() {
        didSet {
            DispatchQueue.main.async {
                self.locationTextField.text = self.sourceDestinationDetail.address
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialLoads()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.mapViewHelper?.mapView?.frame = mapView.bounds
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
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
        self.initialLoads()
    }
    
}

extension MapCell {
    
    private func initialLoads() {
        
        self.locationTextField.delegate = self
        self.locationTextField.placeholder = Constant.enterLocation.localized
        self.locationTextField.textColor = .blackColor
        self.locationTextField.backgroundColor = .whiteColor
        if(isDarkMode){
            locationTextField.borderColor = .white
            locationTextField.borderLineWidth = 0.5
        }

        self.backButton.addTarget(self, action: #selector(tapBackAction), for: .touchUpInside)
        self.googlePlacesHelper = GooglePlacesHelper()
        
        self.addMapView()
    }
    
    func setCellValues(values: AddressResponseData)  {
        
        self.sourceDestinationDetail = SourceDestinationLocation(address: values.locationAddress(), locationCoordinate: CLLocationCoordinate2D(latitude: values.latitude ?? 0, longitude: values.longitude ?? 0))
        self.mapViewHelper?.moveTo(location: CLLocationCoordinate2D(latitude: values.latitude ?? 0, longitude: values.longitude ?? 0), with: self.mapView.center)
    }
    
    func setAddNewAddress() {
        
        getCurrentLocationDetails()
    }
    
    private func addMapView() {
        
        self.mapViewHelper = GoogleMapsHelper()
        self.mapViewHelper?.getMapView(withDelegate: self, in: self.mapView)
        self.mapViewHelper?.removerPinMarker()
    }
    
    private func showLocationView(predictValues:[GMSAutocompletePrediction]) {
        if self.locationView == nil,
            let locationView = Bundle.main.loadNibNamed(Constant.LocationTableView, owner: self, options: [:])?.first as? LocationTableView {
            locationView.frame = CGRect(x: self.topView.frame.origin.x, y: (self.topView.frame.minY+self.topView.frame.height) - 10, width: self.topView.frame.width, height: self.frame.height-(250))
            if predictValues.count > 0 {
                locationView.setValues(values: predictValues)
            }
            locationView.show(with: .bottom, completion: nil)
            self.addSubview(locationView)
            self.locationView = locationView
        }
        else {
            self.locationView.setValues(values: predictValues)
        }
        
        self.locationView.onSelectedLocation = { [weak self] location in
            guard let self = self else {
                return
            }
            self.locationView.removeFromSuperview()
            self.locationView = nil
            self.sourceDestinationDetail = location
        }
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
    
    private func isMapInteracted(_ isHide : Bool) {
        
        UIView.animate(withDuration: 0.2) {
            
        }
    }
    
    //Getting current location detail
    private func getCurrentLocationDetails() {
        self.mapViewHelper?.getCurrentLocation(onReceivingLocation: { [weak self] (location) in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                self.mapViewHelper?.moveTo(location: location.coordinate, with: self.mapView.center)
            }
        })
    }
    
    @objc func tapBackAction() {
        self.tapBack!()
    }
}


//MARK: - Textfield Delegate

extension MapCell: UITextFieldDelegate {
    
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

//MARK:- MapView

extension MapCell: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        if self.isUserInteractingWithMap {
            
            getLocationFromMovement(mapView: mapView)
        }
        self.isMapInteracted(false)
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        
        print("Gesture ",gesture)
        self.isUserInteractingWithMap = gesture
        
        if self.isUserInteractingWithMap {
            self.isMapInteracted(true)
        }
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
        getLocationFromMovement(mapView: mapView)
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
                let gettingAddress = AddressDetails(location: result?.subLocality ?? "",flatno: result?.thoroughfare ?? "",latitude: result?.coordinate.latitude ?? 0.0, longitude: result?.coordinate.longitude ?? 0.0)
                self.addressDetails?(gettingAddress)
            }
        }
    }
}
