//
//  LocationTableView.swift
//  GoJekUser
//
//  Created by Ansar on 01/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import GooglePlaces

class LocationTableView: UIView {
    
    @IBOutlet weak var locationTableView: UITableView!
    
    var datasource: [GMSAutocompletePrediction] = []
    var onSelectedLocation : ((SourceDestinationLocation)->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        locationTableView.delegate = self
        locationTableView.dataSource = self
        setDarkMode()
        locationTableView.register(UINib(nibName: Constant.LocationTableViewCell, bundle: nil), forCellReuseIdentifier: Constant.LocationTableViewCell)
    }
    
    func setDarkMode(){
        self.backgroundColor = .whiteColor
        self.locationTableView.backgroundColor = .whiteColor
        if #available(iOS 13.0, *) {
            if(UITraitCollection.current.userInterfaceStyle == .dark){
                self.locationTableView.borderColor = .white
                self.locationTableView.borderLineWidth = 0.5
            }
            else{
                
            }
        } else {
            
        }
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
        self.setDarkMode()
    }
    
    func setValues(values:[GMSAutocompletePrediction]) {
        datasource = values
        locationTableView.reloadInMainThread()
    }
}

extension LocationTableView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  datasource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = locationTableView.dequeueReusableCell(withIdentifier: Constant.LocationTableViewCell, for: indexPath) as? LocationTableViewCell, datasource.count>indexPath.row{
            
            cell.imageLocationPin.image = #imageLiteral(resourceName: "ic_location_pin")
            cell.imageLocationPin.setImageColor(color: .blackColor)
            let placesClient = GMSPlacesClient.shared()
            placesClient.lookUpPlaceID(datasource[indexPath.row].placeID , callback: { (place, error) -> Void in
                if let error = error {
                    print("lookup place id query error: \(error.localizedDescription)")
                    return
                }
                if let place = place {
                    let formatAddress = place.formattedAddress
                    let addressName = place.name
                    let formatAddressString = formatAddress!.replacingOccurrences(of: "\(addressName ?? ""), ", with: "", options: .literal, range: nil)
                    cell.lblLocationTitle.text = addressName
                    cell.lblLocationSubTitle.text = formatAddressString
                }
            })
            return cell
        }
        return UITableViewCell()
    }
}


extension LocationTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let placesClient = GMSPlacesClient.shared()
        placesClient.lookUpPlaceID(datasource[indexPath.row].placeID , callback: { [weak self] (place, error) -> Void in
            guard let self = self else {
                return
            }
            if let error = error {
                print("lookup place id query error: \(error.localizedDescription)")
                return
            }
            if let place = place {
                var selectedAddress = SourceDestinationLocation()
                selectedAddress.address = place.formattedAddress
                selectedAddress.locationCoordinate = LocationCoordinate(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
                self.onSelectedLocation!(selectedAddress)
            }
        })
    }
}
