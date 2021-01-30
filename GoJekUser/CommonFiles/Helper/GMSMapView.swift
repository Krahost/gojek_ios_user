//
//  GMSMapView.swift
//  User
//
//  Created by CSS on 17/02/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import GoogleMaps
/*
private struct MapPath : Decodable{
    
    var routes : [Route]?
    
}

private struct Route : Decodable{
    
    var overview_polyline : OverView?
    var legs : [LegsObject]?
}

private struct OverView : Decodable {
    
    var points : String?
}

private struct LegsObject : Decodable {
    var duration : DurationObject?
}

private struct DurationObject : Decodable {
    var text : String?
} */

extension GMSMapView {
    
    //MARK:- Call API for polygon points
    
    func drawPolygon(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D,lineColor: UIColor){
        self.getGoogleResponse(between: source, to: destination) { [weak self] (mapPath) in
            if let points = mapPath.routes?.first?.overview_polyline?.points {
                
                self?.drawPath(with: points,lineColor: lineColor)
                //gmsPath = GMSPath.init(fromEncodedPath: points)!
               
            }
        }
    }
    
    
    // MARK;- Get estimation between coordinates
    
    func getEstimation(between source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, completion : @escaping((String)->Void)) {
        self.getGoogleResponse(between: source, to: destination) { (mapPath) in
            if let estimationString = mapPath.routes?.first?.legs?.first?.duration?.text {
                completion(estimationString)
            }
        }
    }
    
    // Get response Between Coordinates
    private func getGoogleResponse(between source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, completion : @escaping((MapPath)->Void)) {
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        guard let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=false&mode=driving&key=\(CommonFunction.setGoogleMapKey())") else {
            return
        }
        
        DispatchQueue.main.async {
            
            session.dataTask(with: url) { (data, response, error) in
                print("Inside Polyline ", data != nil)
                guard data != nil else {
                    return
                }
                
                if
                    let responseData = data,
                    let utf8Text = String(data: responseData, encoding: .utf8),
                    let route = MapPath.init(JSONString: utf8Text) {
                    completion(route)
                }
                
                }.resume()
        }
    }
    
//    func clearMap() {
//        self.clear()
//    }
    
    //MARK:- Draw polygon
    
    private func drawPath(with points : String,lineColor: UIColor){
        
       // print("Drawing Polyline ", points)
        
        DispatchQueue.main.async {
            guard let path = GMSMutablePath(fromEncodedPath: points) else { return }
            let polyline = GMSPolyline(path: path)
            self.clear()
            polyline.map = nil
           // polyLinePath = polyline
            polyline.strokeWidth = 3.0
            polyline.strokeColor = lineColor
            polyline.map = self
            var bounds = GMSCoordinateBounds()
            for index in 0...path.count()-1 {
                bounds = bounds.includingCoordinate(path.coordinate(at: index))
            }
            self.animate(with: .fit(bounds))
            
          //  self.animatePolylinePath(path: path, color: lineColor)

        }
        
    }
}


