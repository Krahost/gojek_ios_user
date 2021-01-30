//
//  FoodieTrackingController.swift
//  GoJekUser
//
//  Created by Ansar on 20/05/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import GoogleMaps

class FoodieTrackingController: UIViewController {
    
    @IBOutlet weak var mapView: UIView!
    
    private var sourceLocationDetail = SourceDestinationLocation()
    private var destinationDetail = SourceDestinationLocation()
    
    private var xmapView: XMapView?
    
    var foodieCurrentRequest:FoodieOrderDetailEntity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewWillAppearCustom()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewDidDisappearCustom()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.xmapView?.frame = self.mapView.bounds
    }
    
}

//MARK: - Methods

extension FoodieTrackingController  {
    
    private func viewWillAppearCustom() {
        self.navigationController?.isNavigationBarHidden = false
        self.addMapView()
        mapView.backgroundColor = .whiteColor
    }
    
    private func viewDidDisappearCustom() {
        self.xmapView?.enableProviderMovement(providerId: foodieCurrentRequest?.responseData?.provider?.id ?? 0)
        self.removeMapView()
    }
    
    private func addMapView() {
        self.xmapView = XMapView(frame: self.mapView.bounds)
        self.xmapView?.tag = 100
        guard let _ = self.xmapView else {
            return
        }
        self.mapView.addSubview(self.xmapView!)
        self.xmapView?.currentLocationMarkerImage = UIImage(named: FoodieConstant.deliveryBoyImage)?.resizeImage(newWidth: 25)
        self.liveNavigation()
    }
    
    private func removeMapView() {
        for subView in self.mapView.subviews where subView.tag == 100 {
            subView.removeFromSuperview()
            self.xmapView = nil
        }
    }
    
    func liveNavigation() {
        self.sourceLocationDetail = SourceDestinationLocation(address: foodieCurrentRequest?.responseData?.pickup?.store_location
            , locationCoordinate: CLLocationCoordinate2D(latitude: foodieCurrentRequest?.responseData?.pickup?.latitude ?? 0, longitude: foodieCurrentRequest?.responseData?.pickup?.longitude ?? 0))
        self.destinationDetail = SourceDestinationLocation(address: foodieCurrentRequest?.responseData?.delivery?.map_address, locationCoordinate: CLLocationCoordinate2D(latitude: foodieCurrentRequest?.responseData?.delivery?.latitude ?? 0, longitude: foodieCurrentRequest?.responseData?.delivery?.longitude ?? 0))
        self.xmapView?.setSourceLocationMarker(sourceCoordinate: self.sourceLocationDetail.locationCoordinate ?? APPConstant.defaultMapLocation, marker: UIImage(named: FoodieConstant.deliveryBoyImage)?.resizeImage(newWidth: 25) ?? UIImage())
        self.xmapView?.setDestinationLocationMarker(destinationCoordinate: self.destinationDetail.locationCoordinate ?? APPConstant.defaultMapLocation, marker: UIImage(named: Constant.destinationPin) ?? UIImage())
        self.xmapView?.drawPolyLineFromSourceToDestination(source: self.sourceLocationDetail.locationCoordinate ?? APPConstant.defaultMapLocation, destination: self.destinationDetail.locationCoordinate ?? APPConstant.defaultMapLocation, lineColor: .foodieColor)
        
        self.xmapView?.enableProviderMovement(providerId: foodieCurrentRequest?.responseData?.provider?.id ?? 0)
        
    }
}
