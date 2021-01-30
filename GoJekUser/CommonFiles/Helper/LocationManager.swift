//
//  LocationManager.swift
//  GoJekUser
//
//  Created by Ansar on 03/08/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation
import CoreLocation

class FLocationManager: NSObject, CLLocationManagerDelegate {

    static let shared = FLocationManager()
    let locationManager : CLLocationManager
    var locationInfoCallBack: ((_ info:LocationInformation)->())!

    override init() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLLocationAccuracyHundredMeters
        super.init()
        locationManager.delegate = self
    }

    func start(locationInfoCallBack:@escaping ((_ info:LocationInformation)->())) {
        self.locationInfoCallBack = locationInfoCallBack
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }

    func stop() {
        locationManager.stopUpdatingLocation()
    }
    
    func latLong(lat: Double,long: Double,completion : @escaping ((String)->()))  {

        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: lat , longitude: long)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placeMark, error) -> Void in

            if error != nil {
                
            } else {
                var address = ""
                let place = placeMark as [CLPlacemark]?
                if (place?.count ?? 0) > 0 {
                    let place = placeMark?[0]
                    if place?.thoroughfare != nil { // Street name
                        address = address + (place?.thoroughfare ?? "")
                    }
                    if place?.subThoroughfare != nil { // Street name
                        address = address + (place?.subThoroughfare ?? "")
                    }
                    if place?.locality != nil { // City Name
                        address = address + (place?.locality ?? "")
                    }
                    if place?.postalCode != nil { // Postal
                        address = address + (place?.postalCode ?? "")
                    }
                    if place?.subAdministrativeArea != nil { // State
                        address = address + (place?.subAdministrativeArea ?? "")
                    }
                    if place?.country != nil { // Country
                        address = address + (place?.country ?? "")
                    }
                }
                completion(address)
            }
        })
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let mostRecentLocation = locations.last else {
            return
        }
        print(mostRecentLocation)
        let info = LocationInformation()
        info.latitude = mostRecentLocation.coordinate.latitude
        info.longitude = mostRecentLocation.coordinate.longitude


        //now fill address as well for complete information through lat long ..
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(mostRecentLocation) { (placemarks, error) in
            guard let placemarks = placemarks, let placemark = placemarks.first else { return }
            if let city = placemark.locality,
                let state = placemark.administrativeArea,
                let zip = placemark.postalCode,
                let locationName = placemark.name,
                let thoroughfare = placemark.thoroughfare,
                let country = placemark.country {
                info.city     = city
                info.state    = state
                info.zip = zip
                info.address =  locationName + ", " + (thoroughfare as String)
                info.country  = country
            }
            self.locationInfoCallBack(info)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        locationManager.stopUpdatingLocation()
    }
}

class LocationInformation {
    var city:String?
    var address:String?
    var latitude:CLLocationDegrees?
    var longitude:CLLocationDegrees?
    var zip:String?
    var state :String?
    var country:String?
    init(city:String? = "",address:String? = "",latitude:CLLocationDegrees? = Double(0.0),longitude:CLLocationDegrees? = Double(0.0),zip:String? = "",state:String? = "",country:String? = "") {
        self.city    = city
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.zip        = zip
        self.state = state
        self.country = country
    }
}
