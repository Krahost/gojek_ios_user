//
//  GoogleMapsHelper.swift
//  User
//
//  Created by CSS on 09/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import Foundation
import GoogleMaps
import MapKit

typealias LocationCoordinate = CLLocationCoordinate2D
typealias AddressDetail = (FormatAddress)
var currentCountryISO = String()


struct TestMarkerDetails {
    var view: UIImage
    var position: LocationCoordinate
}

struct MarkerDetails {
    var image: UIImage
    var position: LocationCoordinate
}

private struct Places : Decodable {

    var results : [Addresses]?

}

private struct AddressesComponent : Decodable {
    var long_name : String?
}

private struct Addresses : Decodable {
    var address_components : [AddressesComponent]?
    var formatted_address : String?
    var geometry : Geometryy?
}

private struct Geometryy : Decodable {

    var location : Locations?

}

private struct Locations : Decodable {

    var lat : Double?
    var lng : Double?
}

struct FormatAddress: Decodable {
    var locality: String?
    var subThoroughfare: String?
    var subAdministrativeArea: String?
    var streetName: String?
    var cityName: String?
    var postCode: String?
    var state: String?
    var country: String?
}


class GoogleMapsHelper : NSObject {
    
    var mapView : GMSMapView?
    var locationManager : CLLocationManager?
    private var currentLocation : ((CLLocation)->Void)?
    var pinMarker: UIImageView?
   
    func getMapView(withDelegate delegate: GMSMapViewDelegate? = nil, in view : UIView, withPosition position :LocationCoordinate = APPConstant.defaultMapLocation, zoom : Float = 15) {
        
        mapView = GMSMapView(frame: view.frame)
        mapView?.tag = 100
        self.setMapStyle(to : mapView)
        mapView?.isMyLocationEnabled = true
        mapView?.delegate = delegate
        mapView?.camera = GMSCameraPosition.camera(withTarget: position, zoom: 15)
        view.addSubview(mapView!)
        addCurrentLocationPin()
    }
    
    func getCurrentLocation(onReceivingLocation : @escaping ((CLLocation)->Void)){
        
        locationManager = CLLocationManager()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestAlwaysAuthorization()
        locationManager?.distanceFilter = 50
        locationManager?.startUpdatingLocation()
        locationManager?.delegate = self
        self.currentLocation = onReceivingLocation
    }
    
    func moveTo(location : LocationCoordinate = APPConstant.defaultMapLocation, with center : CGPoint) {
        
        CATransaction.begin()
        CATransaction.setValue(2, forKey: kCATransactionAnimationDuration)
        CATransaction.setCompletionBlock {
            self.mapView?.animate(to: GMSCameraPosition.camera(withTarget: location, zoom: 15))
        }
        CATransaction.commit()
        DispatchQueue.main.async {
             self.mapView?.center = center  //  Getting current location marker to center point
        }
    }
    
    func addCurrentLocationPin() {
       
        pinMarker = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        pinMarker?.tag = 100
        pinMarker?.image = #imageLiteral(resourceName: "ic_pin")
        pinMarker?.tintColor = #colorLiteral(red: 0, green: 0.5647058824, blue: 0.3176470588, alpha: 1)
        pinMarker?.contentMode = .scaleAspectFit
        pinMarker?.center = (self.mapView?.center)!
        self.mapView?.addSubview(pinMarker ?? UIImageView())
        
    }
    func updateMapFrame(frame:CGRect,centerPoint:CGPoint) {
        self.mapView?.frame = frame
        if let pin = pinMarker {
            pin.center = centerPoint
        }
    }
    
    func addMarker(markers:MarkerDetails) {
        let marker = GMSMarker()
        marker.icon = markers.image.resizeImageFrame(scaledToSize: CGSize(width: 30, height: 30))
        marker.position = markers.position
        marker.map = self.mapView
        
    }
    
    func removerPinMarker() {
        if let _ = pinMarker {
            pinMarker?.removeFromSuperview()
        }
    }
    // Setting Map Style
    private func setMapStyle(to mapView: GMSMapView?){
        do {
            
            var style = "Map_style"
            if #available(iOS 13.0, *) {
                if(UITraitCollection.current.userInterfaceStyle == .dark){
                    style = "Dark_Map_style"
                }
            } else {
                style = "Map_style"
            }
            // Set the map style by passing a valid JSON string.
            if let url = Bundle.main.url(forResource: style, withExtension: "json") {
                mapView?.mapStyle = try GMSMapStyle(contentsOfFileURL: url)
            }else {
                print("error")
            }
            
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
    }
    func getPlaceAddress(from location : LocationCoordinate, on completion : @escaping ((LocationDetail)->())){
        
        /*if !geoCoder.isGeocoding {
            
            geoCoder.reverseGeocodeLocation(CLLocation(latitude: location.latitude, longitude: location.longitude)) { (placeMarks, error) in
                
                guard error == nil, let placeMarks = placeMarks else {
                    print("Error in retrieving geocoding \(error?.localizedDescription ?? .Empty)")
                    return
                }
            
                
                
                guard let placemark = placeMarks.first, let address = (placeMarks.first?.addressDictionary!["FormattedAddressLines"] as? Array<String>)?.joined(separator: ","), let coordinate = placemark.location else {
                    print("Error on parsing geocoding ")
                    return
                }
                
                
                completion((address,coordinate.coordinate))
                
                print(placeMarks)
                
            }
            
        } */
        
        
        let urlString = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(location.latitude),\(location.longitude)&key=\(CommonFunction.setGoogleMapKey())"
        
        guard let url = URL(string: urlString) else {
            print("Error in creating URL Geocoding")
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataValue = data else{
                return
            }
            guard let json = (try? JSONSerialization.jsonObject(with: dataValue)) as? [String: Any] else {
                return
            }
            print(json)
            if let places = data?.getDecodedObject(from: Places.self), let address = places.results?.first?.formatted_address, let lattitude = places.results?.first?.geometry?.location?.lat, let longitude = places.results?.first?.geometry?.location?.lng, let _ = places.results?.first?.address_components {
               // print(addressComponent.count)
                
                completion((address , LocationCoordinate(latitude: lattitude, longitude: longitude)))
            }else{
                CommonFunction.isMapKeyExpired = true
            }
            
            
        }.resume()
    
        
    }
    
    
}


extension GoogleMapsHelper: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
          print("Location: \(location)")
          self.currentLocation?(location)
        }
        
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        @unknown default:
            break
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager?.stopUpdatingLocation()
        print("Error: \(error)")
    }
   
    
    
}
