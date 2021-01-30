//
//  XMapView.swift
//  CustomMapView
//
//  Created by apple on 05/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces


//public var routePolyline: GMSPolyline!
//typealias LocationCoordinate = CLLocationCoordinate2D
typealias LocationDetail = (address : String, coordinate :LocationCoordinate)
var animationPolyline:GMSPolyline?

struct XCurrentLocation {
    
    static var shared = XCurrentLocation()
    
    var latitude: Double?
    var longitude: Double?
   
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude ?? 0, longitude: longitude ?? 0)
    }
}

class XMapView: GMSMapView {
     var timeStr: String?
    var didUpdateLocation:((XCurrentLocation)->Void)?
    var locationUpdate : XmapLocationUpdateProtocol?
    var locationManager : CLLocationManager?
    var currentLocation: CLLocation?
    //    var infoWindow: EtaView?
    //    var currentAddress = String()
    var zoomLevel: Float = 15.0
    
    var isAPIProcessing:Bool  = false //Restrict if API hits more time
    var isMapInteractionEnable:Bool?
    
    var sourceMarker: GMSMarker!
    var destinationMarker: GMSMarker!
    var currentLocationMarker: GMSMarker!
    var infoWindowMarker: GMSMarker!
    
    var pastCoordinate: CLLocationCoordinate2D!
    
    var carMovement: XCarMovement?
    var currentPolyLine: GMSPolyline!
    
    var currentLocationMarkerImage: UIImage!
    
    private var polyLineColor: UIColor!
    
    var didDragMap:((Bool,CLLocationCoordinate2D?)->Void)?
    var onTapMarkerCount:Int = 0
    var didTapMap:((GMSMarker)->Void)?
    
    var token = GMSAutocompleteSessionToken()
    let placesClient = GMSPlacesClient()
    var currentCountry = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        mapViewSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        mapViewSetup()
    }
    
    //Map view setup
    private func mapViewSetup() {
        if XCurrentLocation.shared.latitude != 0 {
            self.moveCameraPosition(lat: XCurrentLocation.shared.latitude ?? 0, lng: XCurrentLocation.shared.longitude ?? 0)
        }
        
        self.backgroundColor = .whiteColor
        isVisibleCurrentLocation(visible: true)
        carMovement = XCarMovement()
        carMovement?.delegate = self
        token = GMSAutocompleteSessionToken.init()
        setMapStyle()
        currentLocationViewSetup()
        self.delegate  = self
        
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
        self.setMapStyle()
    }
    
    func setDestinationLocationMarkers(destinationCoordinate: CLLocationCoordinate2D) {
        
        guard let _ = self.destinationMarker else {
            self.destinationMarker = GMSMarker(position: destinationCoordinate)
            let markerImageView = UIImageView(image: UIImage(named: "ic_destination_marker"))
            self.destinationMarker.iconView = markerImageView
            self.destinationMarker.map = self
            return
        }
        self.destinationMarker.position = destinationCoordinate
    }
    
    //MARK : Add Map Markers
    func setProviderCurrentLocationMarkerPosition(coordinate:CLLocationCoordinate2D) {
        
        DispatchQueue.main.async {
            guard let _ = self.currentLocationMarker else {
                if  coordinate.latitude == 0 || coordinate.longitude == 0 {
                    return
                }
                self.currentLocationMarker = GMSMarker(position: coordinate)
                let markerImageView = UIImageView(image: self.currentLocationMarkerImage ?? #imageLiteral(resourceName: "car_marker"))
                self.currentLocationMarker.iconView = markerImageView
                self.currentLocationMarker.tracksViewChanges = true
                self.currentLocationMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
                self.currentLocationMarker.map = self
                return
            }
            CATransaction.begin()
            CATransaction.setAnimationDuration(2.0)
            self.currentLocationMarker.position = coordinate
            CATransaction.commit()
//            self.currentLocationMarker.position = coordinate
        }
    }
    
    func setSourceLocationMarker(sourceCoordinate: CLLocationCoordinate2D, marker: UIImage) {
        
        guard let _ = self.sourceMarker else {
            print("Source Marker Set")
            self.sourceMarker = GMSMarker(position: sourceCoordinate)
            let markerImageView = UIImageView(image: marker)
            self.sourceMarker.iconView = markerImageView
            self.sourceMarker.map = self
            return
        }
        self.sourceMarker.position = sourceCoordinate
    }
    
    func isVisibleCurrentLocation(visible:Bool) {
        self.isMyLocationEnabled = visible
    }
    
    func setETAView(destCoordinate: CLLocationCoordinate2D, etaTime: String) {
        if infoWindowMarker != nil {
            infoWindowMarker.map = nil
            infoWindowMarker = nil
        }
        guard let _ = self.infoWindowMarker else {
            infoWindowMarker = GMSMarker(position: destCoordinate)
            let infoWindow = Bundle.main.loadNibNamed("EtaView", owner: self, options: nil)!.first as! EtaView
            infoWindow.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
            infoWindow.overView.setCornerRadius()
            infoWindow.etaTimeLabel.text = etaTime
            infoWindowMarker.iconView = infoWindow
            infoWindowMarker.position = destCoordinate
            infoWindowMarker.map = self
            return
        }
    }
    
    func setDestinationLocationMarker(destinationCoordinate: CLLocationCoordinate2D, marker: UIImage) {
        
        guard let _ = self.destinationMarker else {
            print("Destination Marker Set")
            destinationMarker = GMSMarker(position: destinationCoordinate)
            let markerImageView = UIImageView(image: marker)
            destinationMarker.iconView = markerImageView
            destinationMarker.map = self
            setZoomLevelBasedOnMarker(markers: [self.sourceMarker ?? GMSMarker() ,self.destinationMarker ?? GMSMarker()])
            return
        }
        destinationMarker.position = destinationCoordinate
    }
    
    func setZoomLevelBasedOnMarker(markers:[GMSMarker]) {
        let bounds = markers.reduce(GMSCoordinateBounds()) {
            $0.includingCoordinate($1.position)
        }
        self.animate(with: .fit(bounds, withPadding: 100.0))
    }
    
    // Setting Map Style
    func currentLocationViewSetup() {
        
        locationManager = CLLocationManager()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestAlwaysAuthorization()
        locationManager?.distanceFilter = 50
        locationManager?.startUpdatingLocation()
        locationManager?.delegate = self
    }
    
    func enableProviderMovement(providerId: Int) {
        guard providerId != 0 else { // if provider zero - stop receiving data
            return
        }
        XSocketIOManager.sharedInstance.checkProviderNewLocation { [weak self] (location) in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                self.currentLocationMarkerMovement(location: LocationCoordinate(latitude: location.lat ?? 0, longitude: location.lng ?? 0))
                self.checkPolyLineBounds(currentLocation: LocationCoordinate(latitude: location.lat ?? 0, longitude: location.lng ?? 0))
            }
        }
    }
    
    func showCurrentLocation() {
        let camera = GMSCameraPosition.camera(withLatitude: currentLocation?.coordinate.latitude ?? APPConstant.defaultMapLocation.latitude ,
                                              longitude: currentLocation?.coordinate.longitude ?? APPConstant.defaultMapLocation.longitude,
                                              zoom: zoomLevel)
        self.animate(to: camera)
    }
    
    func moveCameraPosition(lat: Double, lng: Double) {
        let camera = GMSCameraPosition.camera(withLatitude: lat , longitude: lng, zoom: zoomLevel)
        self.animate(to: camera)
    }
    
    func drawPolyLineFromSourceToDestination(source:CLLocationCoordinate2D, destination:CLLocationCoordinate2D,lineColor: UIColor) {
        
        
        print("Source Location \(source)   Destination Location \(destination)")
        guard let _ = sourceMarker else {
            print("No Source")
            self.setSourceLocationMarker(sourceCoordinate: source, marker: UIImage(named: Constant.sourcePin) ?? UIImage())
            return
        }
        print("Source marker passed")
        guard let _ = currentPolyLine else {
            self.removePolylines()
            self.polyLineColor = lineColor
            print("start draw poly line")
            if !self.isAPIProcessing {
                self.isAPIProcessing = true
                self.drawPolyline(from: source, to: destination, color: self.polyLineColor) { [weak self] (polyline) in
                    guard let self = self else {
                        return
                    }
                    self.isAPIProcessing = false
                    self.currentPolyLine = polyline
                    self.currentPolyLine.map = self
                    print("polyline draw")
                }
            }
            return
        }
    }
    
  
    
    //Get current location address detail from lat & lon
    func getCurrentLocationDetail(completion : @escaping ((LocationDetail)->())){
        
        guard let currentCoordinate = currentLocation?.coordinate else { return }
        let urlString: String = APPConstant.googleGeocodeURL+"\(currentCoordinate.latitude),\(currentCoordinate.longitude)&key=\(CommonFunction.setGoogleMapKey())"
        /*
         &location_type=APPROXIMATE
         location_type stores additional data about the specified location. The following values are currently supported:
         
         "ROOFTOP" indicates that the returned result is a precise geocode for which we have location information accurate down to street address precision.
         "RANGE_INTERPOLATED" indicates that the returned result reflects an approximation (usually on a road) interpolated between two precise points (such as intersections). Interpolated results are generally returned when rooftop geocodes are unavailable for a street address.
         "GEOMETRIC_CENTER" indicates that the returned result is the geometric center of a result such as a polyline (for example, a street) or polygon (region).
         "APPROXIMATE" indicates that the returned result is approximate
         */
        
        guard let url = URL(string: urlString) else {
            print("Error in creating URL Geocoding")
            return
        }
        
        DispatchQueue.main.async {
            if !self.isAPIProcessing {
                self.isAPIProcessing = true
                self.callCurrentLocationAPI(url: url, completion: { (addressDetail) in
                    self.isAPIProcessing = false
                    
                    completion((addressDetail.formatted_address ?? "" , LocationCoordinate(latitude: addressDetail.geometry?.location?.lat ?? 0, longitude: addressDetail.geometry?.location?.lng ?? 0)))
                })
            }
        }
    }
    
    private func callCurrentLocationAPI(url: URL,completion : @escaping ((Address)->())) {
        print("Geocode URL \(url.absoluteString)")
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else {
                return
            }
            
            if
                let responseData = data,
                let utf8Text = String(data: responseData, encoding: .utf8),
                let placeDetail = Place.init(JSONString: utf8Text) {
                
                print(placeDetail)
                if
                    let addressDetail = placeDetail.results?.first {
                    completion(addressDetail)
                }else{
                    print("Location API Error === \(placeDetail.error_message ?? "")")
                }
            }else{
                print(error?.localizedDescription ?? "")
                if (CommonFunction.setGoogleMapKey() != APPConstant.googleKey) && !CommonFunction.isMapKeyExpired {
                    CommonFunction.isMapKeyExpired = true
                    self.callCurrentLocationAPI(url: url, completion: { (address) in
                        completion(address)
                    })
                }else {
                    CommonFunction.isMapKeyExpired = false
                }
            }
        }.resume()
    }
    
    func getAdressName(latitude: Double, longitude: Double,on completion : @escaping ((AddressDetail)->()))  {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { (placeMark, error) in
            
            if error != nil {
                
            } else {
                var address = FormatAddress()
                let place = placeMark as [CLPlacemark]?
                if (place?.count ?? 0) > 0 {
                    let place = placeMark?[0]
                    if place?.thoroughfare != nil { // Street name
                        address.streetName = place?.thoroughfare
                    }
                    if place?.subThoroughfare != nil { // Street name
                        address.subThoroughfare = place?.subThoroughfare
                    }
                    
                    if place?.locality != nil { // City Name
                        address.cityName = place?.locality
                    }
                    if place?.postalCode != nil { // Postal
                        address.postCode = place?.postalCode
                    }
                    if place?.subAdministrativeArea != nil { // State
                        address.state  = place?.subAdministrativeArea
                    }
                    if place?.country != nil { // Country
                        address.country = place?.country
                    }
                }
                completion(address)
            }
        }
    }

    
    func getPredictions(addressString:String,completion: @escaping (([GMSAutocompletePrediction])->Void)) {
       var filter : GMSAutocompleteFilter?
        filter = GMSAutocompleteFilter()
        filter?.country =  AppManager.shared.getUserDetails()?.country?.country_code ?? ""
        filter?.type = .noFilter
        placesClient.findAutocompletePredictions(fromQuery: addressString, filter: filter, sessionToken: token) { (results, error) in
            if let _ = error {
                print("PredictionError \(error?.localizedDescription ?? "")")
                return
            }
            
            if let predictionList = results  {
                completion(predictionList)
            }
        }
    }
    
    func getLocationFromMovement(lat:Double,long:Double, completion: @escaping ((SourceDestinationLocation)->Void)){
        let geocoder = GMSGeocoder()
        guard lat != 0, long != 0 else {
            return
        }
        let position = CLLocationCoordinate2DMake(lat, long)
        print("GMSReverseGeocode \(position)")
        geocoder.reverseGeocodeCoordinate(position) { (response , error) in
            if error != nil {
                print("GMSReverseGeocode Error: \(String(describing: error?.localizedDescription))")
            }else {
                let result = response?.results()?.first
                let address = result?.lines?.reduce("") { $0 == "" ? $1 : $0 + ", " + $1 }
                
                if (address?.count ?? 0) > 0 {
                    print("Geocode Location \(address ?? "")")
                    let country = result?.country ?? ""
                    if country ==  self.currentCountry {
                        completion(SourceDestinationLocation(address: address,locationCoordinate: LocationCoordinate(latitude: (result?.coordinate.latitude ?? APPConstant.defaultMapLocation.latitude), longitude: (result?.coordinate.longitude ?? APPConstant.defaultMapLocation.longitude))))
                        
                    }else{
                        self.moveCameraPosition(lat: XCurrentLocation.shared.latitude ?? 0, lng: XCurrentLocation.shared.longitude ?? 0)
                    }
                }
            }
        }
    }
}

extension XMapView {
    
    //Create route source to destination
    func createRoute(source: CLLocationCoordinate2D, destination: CLLocationCoordinate2D, with address: String,color: UIColor) {
        self.removePolylines()
        if !self.isAPIProcessing {
            self.isAPIProcessing = true
            self.drawPolyline(from: source, to: destination, color: color) { [weak self] (polyline) in
                guard let self = self else {
                    return
                }
                self.currentPolyLine = polyline
                self.isAPIProcessing = false
            }
        }
        self.setDestinationLocationMarker(destinationCoordinate: destination,marker: UIImage(named: "ic_destination_marker") ?? UIImage())
    }
    
    func addMarker(markers:MarkerDetails) {
        let marker = GMSMarker()
        marker.icon = markers.image.resizeImageFrame(scaledToSize: CGSize(width: 30, height: 30))
        marker.position = markers.position
        marker.map = self
    }
    
    func removePolylines() {
        if let _  = currentPolyLine {
            currentPolyLine.map = nil
            currentPolyLine = nil
        }
        if let _  = animationPolyline {
            animationPolyline?.map = nil
            animationPolyline = nil
        }
        self.removePolylineAnimateTimer()
    }
    
    func clearAll() {
        DispatchQueue.main.async {
            self.removePolylines()
            self.removeLocationMarkers()
            self.clear()
            self.removePolylineAnimateTimer()
        }
    }
    
    func removeLocationMarkers() {
        
        DispatchQueue.main.async {
            
            if self.sourceMarker != nil {
                self.sourceMarker.map = nil
                self.sourceMarker = nil
            }
            if self.destinationMarker != nil {
                self.destinationMarker.map = nil
                self.destinationMarker = nil
            }
        }
    }
    
    //Setting Map Style
    private func setMapStyle(){
        if(isDarkMode){
          self.alpha = 0
        }
        else{
          self.alpha = 1
        }
        do {
            var style = "Map_style"
            if #available(iOS 13.0, *) {
                if(UITraitCollection.current.userInterfaceStyle == .dark){
                    style = "Dark_Map_style"
                }
            } else {
                style = "Map_style"
            }
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: style, withExtension: "json") {
                self.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            }else {
                NSLog("Unable to find style.json")
            }
        }catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
    }
    
    //MARK: Rerouting Map Functions
    func checkPolyLineBounds(currentLocation:CLLocationCoordinate2D) {
        guard let currentPath = self.currentPolyLine else { return}
        if locationOutOfRoute(drawnPolyLine: currentPath, location: currentLocation) {
            updateTravelledPath(currentLoc: currentLocation)
        } else {
            let lastCoordinate = getLastLocation()
            DispatchQueue.main.async {
                if lastCoordinate.latitude > 0 {
                    self.removePolylines()
                    self.drawPolyLineFromSourceToDestination(source: currentLocation,destination: lastCoordinate, lineColor: self.polyLineColor ?? UIColor.darkGray)
                }
            }
        }
    }
    
    func getLastLocation() -> CLLocationCoordinate2D {
        
        guard let currentPath = self.currentPolyLine.path else { return CLLocationCoordinate2D() }
        if currentPath.count() < 1 { return CLLocationCoordinate2D() }
        let index = currentPath.count() - 1
        let pathLat = Double(currentPath.coordinate(at: index).latitude).rounded(toPlaces: 3)
        let pathLong = Double(currentPath.coordinate(at: index).longitude).rounded(toPlaces: 3)
        return CLLocationCoordinate2D(latitude: pathLat, longitude: pathLong)
    }
    
    func updateTravelledPath(currentLoc: CLLocationCoordinate2D){
        
        var index = 0
        let oldPath =  self.currentPolyLine.path ?? GMSPath()
        
        for i in 0..<oldPath.count(){
            let pathLat = Double(oldPath.coordinate(at: i).latitude).rounded(toPlaces: 3)
            let pathLong = Double(oldPath.coordinate(at: i).longitude).rounded(toPlaces: 3)
            
            let currentLat = Double(currentLoc.latitude).rounded(toPlaces: 3)
            let currentLong = Double(currentLoc.longitude).rounded(toPlaces: 3)
            
            if currentLat == pathLat && currentLong == pathLong{
                index = Int(i)
                break   //Breaking the loop when the index found
            }
        }
        
        //Creating new path from the current location to the destination
        let newPath = GMSMutablePath()
        for i in index..<Int(oldPath.count()){
            newPath.add(oldPath.coordinate(at: UInt(i)))
        }
        
        currentPolyLine.map = nil
        currentPolyLine = nil
        currentPolyLine = GMSPolyline(path: newPath)
        currentPolyLine.strokeColor = polyLineColor ?? UIColor.darkGray
        currentPolyLine.strokeWidth = 3.0
        currentPolyLine.map = self
    }
    
    
    func locationOutOfRoute(drawnPolyLine:GMSPolyline,location:CLLocationCoordinate2D) -> Bool {
        
        if GMSGeometryIsLocationOnPathTolerance(location, drawnPolyLine.path ?? GMSPath(), true, 150) {
            print("Inside polyline")
            return true
        }else {
            print("Outside polyline")
            return false
        }
    }
    
    //MARK: Marker Bearing
    func currentLocationMarkerMovement(location: CLLocationCoordinate2D) {
        if location.latitude == 0 || location.longitude == 0 {
            return
        }
        print("Moving \(location)")
        locationUpdate?.locationUpdated(location: XCurrentLocation(latitude: location.latitude, longitude: location.longitude))

        if let _ = currentLocationMarker {
//            currentLocationMarker.position = location

            if let oldCoordinate = pastCoordinate {
                self.carMovement?.arCarMovement(marker: currentLocationMarker, oldCoordinate: oldCoordinate, newCoordinate: location, mapView: self , bearing: 0)
                  self.moveCameraPosition(lat: XCurrentLocation.shared.latitude ?? 0, lng: XCurrentLocation.shared.longitude ?? 0)
                //Calculate speed
                guard
                    let polyline =  currentPolyLine,
                    let polyLineCount = polyline.path?.count() else {
                        return
                }
                
                //Speed calculation
                //Speed = TotalDistance/TotalTime
                let oldLocation: CLLocation = CLLocation.init(latitude: oldCoordinate.latitude, longitude: oldCoordinate.longitude)
                let newLocation: CLLocation = CLLocation.init(latitude: location.latitude, longitude: location.longitude)
                let timeTaken = newLocation.timestamp.timeIntervalSince(oldLocation.timestamp)
                print("TimeTaken: \(timeTaken)")
                self.timeStr = "\(timeTaken)"
                let distanceTravel = (oldLocation.distance(from: newLocation))
                var speed = distanceTravel/timeTaken
                print("Speed: \(speed)")
                
                //Total Distance calculate
                let totalDistance = distanceCalculate(polyLineCount: Int(polyLineCount))
                print("TotalDistance Km: \(totalDistance/1000)")
                
                //Estimation Time calculate
                //EtimatedTime = kilometers/speed
                
                if speed <= 0 {
                    speed = 30
                }
                
                let estimatedTotalTime = ((totalDistance/1000)*3600)/speed
                if estimatedTotalTime == .nan || estimatedTotalTime <= 0 || estimatedTotalTime == "NaN".toDouble() || estimatedTotalTime.isNaN || estimatedTotalTime.isInfinite {
                    
                    print("value ")
                    setETAView(destCoordinate: location, etaTime: "00:00")
                }else {
                    let estimatedMinutes: Int = Int((estimatedTotalTime.truncatingRemainder(dividingBy:3600))/60)
                    let estimatedHour: Int = Int(estimatedTotalTime/3600)
                    print("EstimatedTime= \(estimatedHour):\(estimatedMinutes)")
                    let stringFormat = String(format: "%0.2d:%0.2d", estimatedHour, estimatedMinutes)
                    setETAView(destCoordinate: location, etaTime: stringFormat)
                }
            }
            pastCoordinate = location
        } else {
            self.setProviderCurrentLocationMarkerPosition(coordinate: location)
        }
    }
    
    func distanceCalculate(polyLineCount: Int) -> Double  {
        
        var polyLineArray: [CLLocation] = []
        for index in (0...polyLineCount) {
            guard let value = currentPolyLine.path?.coordinate(at: UInt(index)) else {
                return 0
            }
            print(value)
            let tempLocation: CLLocation = CLLocation.init(latitude: value.latitude, longitude: value.longitude)
            polyLineArray.append(tempLocation)
        }
        
        var totalDistance = 0.0
        if polyLineArray.count != 0 {
            
            let list = [Int](1..<polyLineArray.count)
            for (index, element) in list.enumerated() {
                let distance1 = polyLineArray[index]
                let distance2 = polyLineArray[element]
                let distance: Double = (distance1.distance(from: distance2))
                
                if !distance.isNaN {
                    totalDistance = totalDistance+distance
                }
            }
        }
        return totalDistance
    }
}

//MARK: - CLLocationManagerDelegate

extension XMapView: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        currentLocation = locations.last ?? CLLocation()
        if (XCurrentLocation.shared.latitude ?? 0) == 0 || (XCurrentLocation.shared.longitude ?? 0) == 0 {
            self.didUpdateLocation?(XCurrentLocation(latitude: locations.last?.coordinate.latitude, longitude: locations.last?.coordinate.longitude))
            locationUpdate?.locationUpdated(location: XCurrentLocation(latitude: locations.last?.coordinate.latitude, longitude: locations.last?.coordinate.longitude))
            self.showCurrentLocation()
            self.isMapInteractionEnable = true
        }
        
        //Location update to storyboard
        XCurrentLocation.shared.latitude = locations.last?.coordinate.latitude
        XCurrentLocation.shared.longitude = locations.last?.coordinate.longitude
        
        if (XCurrentLocation.shared.latitude ?? 0) != 0 || (XCurrentLocation.shared.longitude ?? 0) != 0 {
            
            self.getAdressName(latitude: XCurrentLocation.shared.latitude ?? 0 , longitude: XCurrentLocation.shared.longitude ?? 0 , on: { (addr) in
                self.currentCountry = addr.country ?? ""
            })
        }
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            ToastManager.show(title: "Based on the current location we would like to access your location to get user around you.", state: .error)
        case .denied:
            ToastManager.show(title: "Based on the current location we would like to access your location to get user around you.", state: .error)
        // Display the map using the default location.
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        @unknown default:
            print("unknown")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager?.stopUpdatingLocation()
        print("Error: \(error)")
    }
    
    func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
        print("didBeginDragging")
    }
    
    func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
        print("didDrag")
    }
    
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        print("didEndDragging")
    }
}

//MARK: - GMSMapViewDelegate
extension XMapView: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        print("Gesture ",gesture)
        self.isMapInteractionEnable = gesture
        self.didDragMap?(gesture,nil)
    }
    
    
    func mapViewDidFinishTileRendering(_ mapView: GMSMapView) {
        print("Tilt Loaded")
//        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 1
//        })
    }
    
    func mapViewSnapshotReady(_ mapView: GMSMapView) {
        print("Snapshot Loaded")

    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        print("Idle \(currentLocation?.coordinate.latitude ?? 0)  isMapInteractionEnable \(isMapInteractionEnable ?? false)")
        if (self.currentLocation?.coordinate.latitude ?? 0) != 0  {
            self.didDragMap?(false,CLLocationCoordinate2D(latitude: mapView.camera.target.latitude, longitude: mapView.camera.target.longitude))
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print("Test sudar")
        self.didTapMap?(marker)

//        onTapMarkerCount += 1
//        if onTapMarkerCount  == 1 { //for double tap marker
//            
//            
//            onTapMarkerCount = 0
//            return true
//        }
        return false
    }
}

//MARK: - XCarMovementDelegate
extension XMapView: XCarMovementDelegate {
    func arCarMovementMoved(_ marker: GMSMarker) {
        self.currentLocationMarker = marker
    }
}



extension XMapView {
//For Courier Flow

    func setCourierDestinationLocationMarker(destinationCoordinate: CLLocationCoordinate2D, marker: UIImage,titleStr: String) {
    
  //  guard let _ = self.destinationMarker else {
        print("Destination Marker Set")
        destinationMarker = GMSMarker(position: destinationCoordinate)
        let markerImageView = UIImageView(image: marker)
        destinationMarker.iconView = markerImageView
        destinationMarker.map = self
    destinationMarker.title = titleStr
        setZoomLevelBasedOnMarker(markers: [self.sourceMarker ?? GMSMarker() ,self.destinationMarker ?? GMSMarker()])
     //   return
   // }
    destinationMarker.position = destinationCoordinate
}
    func setCourierSourceLocationMarker(sourceCoordinate: CLLocationCoordinate2D, marker: UIImage,titleStr: String) {
            
            guard let _ = self.sourceMarker else {
                print("Source Marker Set")
                self.sourceMarker = GMSMarker(position: sourceCoordinate)
                let markerImageView = UIImageView(image: marker)
                self.sourceMarker.iconView = markerImageView
                self.sourceMarker.map = self
                return
            }
            self.sourceMarker.position = sourceCoordinate
        }
      func drawCourierPolyLineFromSourceToDestination(source:CLLocationCoordinate2D, destination:CLLocationCoordinate2D,lineColor: UIColor) {
            
           // guard let _ = sourceMarker else {
                print("No Source")
                self.setSourceLocationMarker(sourceCoordinate: source, marker: UIImage(named: Constant.sourcePin) ?? UIImage())
               // return
           // }
            print("Source marker passed")
        //    guard let _ = currentPolyLine else {
          //      self.removePolylines()
                self.polyLineColor = lineColor
                print("start draw poly line")
               // if !self.isAPIProcessing {
                    self.isAPIProcessing = true
                    self.drawPolyline(from: source, to: destination, color: self.polyLineColor) { [weak self] (polyline) in
                        guard let self = self else {
                            return
                        }
                        self.isAPIProcessing = false
                        self.currentPolyLine = polyline
                        self.currentPolyLine.map = self
                        print("polyline draw")
                    }
               /// }
    //            return
    //        }
        }
  
}
class CustomMarker: GMSMarker {

    var label: UILabel!

    init(labelText: String) {
        super.init()

        let iconView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 50, height:    50)))
        iconView.backgroundColor = .appPrimaryColor
        iconView.cornerRadius = 25

        label = UILabel(frame: CGRect(x: 5, y: iconView.frame.height/2-30, width: iconView.frame.width-10, height: 60))
        label.text = labelText
        label.font = .setCustomFont(name: .medium, size: .x12)
        label.textAlignment = .center
        label.textColor = .white
        iconView.addSubview(label)

        self.iconView = iconView
    }
}


protocol XmapLocationUpdateProtocol : class {
    func locationUpdated(location: XCurrentLocation)
}
