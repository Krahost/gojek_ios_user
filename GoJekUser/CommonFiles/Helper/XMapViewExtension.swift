//
//  XMapViewExtension.swift
//  GoJekProvider
//
//  Created by apple on 11/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import GoogleMaps

public var timerAnimation: Timer?

//GMSMapView
extension GMSMapView {
    
    func drawPolyline(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D,color:  UIColor, completionHandler: @escaping ((GMSPolyline)->Void)) {
        
        let urlString: String = APPConstant.googleRouteBaseUrl+"\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=false&mode=driving&key=\(CommonFunction.setGoogleMapKey())"
        
        guard let url = URL(string: urlString) else {
            print("Error in creating URL Geocoding")
            return
        }
        print("URL: \(urlString)")
        DispatchQueue.main.async {
            self.drawPolylineAPI(url: url, completion: { (points) in
                self.drawPath(with: points, color: color, completionHandler: { (polyline) in
                    completionHandler(polyline)
                })
            })
            print("Polyline Draw ***")
        }
    }
    
    private func drawPolylineAPI(url: URL,completion: @escaping ((String)->Void)){
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        session.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else {
                return
            }
            if
                let responseData = data,
                let utf8Text = String(data: responseData, encoding: .utf8),
                let route = MapPath.init(JSONString: utf8Text) {
                if let points = route.routes?.first?.overview_polyline?.points {
                    completion(points)
                } else {
                    print(" === MAP Error \(route.errorMsg ?? "")")
                    if route.status == "OVER_QUERY_LIMIT" {
                        if (CommonFunction.setGoogleMapKey() != APPConstant.googleKey) && !CommonFunction.isMapKeyExpired {
                            CommonFunction.isMapKeyExpired = true
                            self.drawPolylineAPI(url: url, completion: { (points) in
                                completion(points)
                            })
                        }else{
                            CommonFunction.isMapKeyExpired = false
                        }
                    }
                }
            }
            else {
                print("Failed to draw \(String(describing: error?.localizedDescription))")
            }
        }.resume()
    }
    
    private func drawPath(with points: String,color: UIColor, completionHandler: @escaping ((GMSPolyline)->Void)) {
        
        DispatchQueue.main.async {
            
            if let _ = animationPolyline {
                animationPolyline?.map = nil
                animationPolyline = nil
            }
            if timerAnimation != nil {
                timerAnimation?.invalidate()
                timerAnimation = nil
            }
            
            guard let path = GMSMutablePath(fromEncodedPath: points) else { return }
            let polyline = GMSPolyline(path: path)
            
            polyline.strokeWidth = 3.0
            polyline.strokeColor = color //.withAlphaComponent(0.5)
            polyline.map = self
            
            completionHandler(polyline)
            var bounds = GMSCoordinateBounds()
            if path.count() > 0 {
                for index in 1...path.count() {
                    bounds = bounds.includingCoordinate(path.coordinate(at: index))
                }
            }
        }
    }
    
    
    func removePolylineAnimateTimer(){
        if timerAnimation != nil {
            timerAnimation?.invalidate()
            timerAnimation = nil
        }
    }
    
    func animatePolylinePath(path: GMSMutablePath,color: UIColor) {
        
        var pos: UInt = 0
        var animationPath = GMSMutablePath()
        //        var animationPolyline = GMSPolyline()
        let polyline = GMSPolyline(path: path)
        animationPolyline = polyline
        if timerAnimation == nil {
            timerAnimation = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) {  timer in
                pos += 1
                if(pos >= path.count()){
                    pos = 0
                    animationPath = GMSMutablePath()
                    animationPolyline?.map = nil
                }
                animationPath.add(path.coordinate(at: pos))
                animationPolyline?.path = animationPath
                animationPolyline?.strokeColor = color
                animationPolyline?.strokeWidth = 3
                animationPolyline?.map = self
            }
        }
    }
}

extension GMSCircle {
    func bounds () -> GMSCoordinateBounds {
        func locationMinMax(_ positive : Bool) -> CLLocationCoordinate2D {
            let sign: Double = positive ? 1 : -1
            let dx = sign * self.radius  / 6378000 * (180 / .pi)
            let lat = position.latitude + dx
            let lon = position.longitude + dx / cos(position.latitude * .pi / 180)
            return CLLocationCoordinate2D(latitude: lat, longitude: lon)
        }
        
        return GMSCoordinateBounds(coordinate: locationMinMax(true),
                                   coordinate: locationMinMax(false))
        
    }
}


extension GMSMapView {
    func getCenterCoordinate() -> CLLocationCoordinate2D {
        let centerPoint = self.center
        let centerCoordinate = self.projection.coordinate(for: centerPoint)
        return centerCoordinate
    }
    
    func getTopCenterCoordinate() -> CLLocationCoordinate2D {
        // to get coordinate from CGPoint of your map
        let topCenterCoor = self.convert(CGPoint(x: self.frame.size.width, y: 0), from: self)
        let point = self.projection.coordinate(for: topCenterCoor)
        return point
    }
    
    func getRadius() -> CLLocationDistance {
        let centerCoordinate = getCenterCoordinate()
        let centerLocation = CLLocation(latitude: centerCoordinate.latitude, longitude: centerCoordinate.longitude)
        let topCenterCoordinate = self.getTopCenterCoordinate()
        let topCenterLocation = CLLocation(latitude: topCenterCoordinate.latitude, longitude: topCenterCoordinate.longitude)
        let radius = CLLocationDistance(centerLocation.distance(from: topCenterLocation))
        return round(radius)
    }
}
