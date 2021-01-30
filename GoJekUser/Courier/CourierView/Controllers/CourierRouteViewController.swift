//
//  CourierRouteViewController.swift
//  GoJekUser
//
//  Created by Thiru on 02/06/20.
//  Copyright © 2020 Appoets. All rights reserved.
//

import UIKit
import CoreLocation

class CourierRouteViewController: UIViewController {
    
    
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var headerStatusVw: UIView!
    @IBOutlet weak var statusStackVw: UIStackView!
    @IBOutlet weak var vehicleTypeBgVw: UIView!
    @IBOutlet weak var vehicleTypeImgVw: UIImageView!
    @IBOutlet weak var vehicleTypeLbl: UILabel!
    @IBOutlet weak var vehicleTypeLineVw: UIView!
    @IBOutlet weak var routeBgVw: UIView!
    @IBOutlet weak var routeImgVw: UIImageView!
    @IBOutlet weak var routeLbl: UILabel!
    @IBOutlet weak var routeRightLineVw: UIView!
    @IBOutlet weak var routeLeftLineVw: UIView!
    @IBOutlet weak var priceBgVw: UIView!
    @IBOutlet weak var priceLeftLineVw: UIView!
    @IBOutlet weak var priceImgVw: UIImageView!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var routeTblVw: UITableView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var routeTblVwHeight: NSLayoutConstraint!
    @IBOutlet weak var addAddressBtn: UIButton!
    @IBOutlet weak var fromLbl: UILabel!
    @IBOutlet weak var toLbl: UILabel!
    @IBOutlet weak var sourceLbl: UILabel!
    
    @IBOutlet weak var addressBGVw: UIView!
    
    
    var VWeight = Int()
    var VHeight = Int()
    var VLength = Int()
    var VBreadth = Int()
    var deliveryTypeID = Int()
    var sourceLocationDetail = SourceDestinationLocation() {
        didSet {
            DispatchQueue.main.async {
                
            }
        }
    }
    var destinationLocationDetail = SourceDestinationLocation() {
        didSet {
            
        }
    }
    
    var serviceTypeID = Int()
    var courierRequestArray = [CourierData]()
    var emptyValue : CourierRequestEntity?
    var xmapView: XMapView?
    var routeArray = [Int]()
    
    var height : CGFloat = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialLoad()
        
    }
    override func viewDidLayoutSubviews() {
        headerStatusVw.addShadow(radius: 5, color: .lightGray)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.removeMapView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.isNavigationBarHidden = true
        self.addMapView()
    }
}
extension CourierRouteViewController {
    

    
    private func initialLoad(){
        routeTblVw.register(nibName: CourierConstant.HeaderRouteCell)
        routeTblVw.register(nibName: CourierConstant.FooterRouteCell)
        routeTblVw.register(nibName: CourierConstant.RouteTableViewCell)
        
        routeTblVw.delegate = self
        routeTblVw.dataSource = self
        setColors()
        setText()
        setFont()
        nextBtn.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        backBtn.addTarget(self, action: #selector(tapBack), for: .touchUpInside)
        addAddressBtn.addTarget(self, action: #selector(tapAddress), for: .touchUpInside)
        
        vehicleTypeImgVw.image = UIImage.init(named: CourierConstant.redTapeImg)
        routeImgVw.image = UIImage.init(named: CourierConstant.redTapeImg)
        priceImgVw.image = UIImage.init(named: CourierConstant.ic_gray_icon)
        priceImgVw.tintColor = .lightGray
        nextBtn.setCornerRadiuswithValue(value: 5)
        addAddressBtn.setTitle(CourierConstant.addAddress.localized, for: .normal)
        fromLbl.text = CourierConstant.from.localized
        toLbl.text = CourierConstant.to.localized
        sourceLbl.text = sourceLocationDetail.address!
        setDarkMode()
    }
    
    
    private func setDarkMode(){
        mapView.backgroundColor = .whiteColor
        self.headerStatusVw.backgroundColor = .boxColor
        self.backBtn.tintColor = .blackColor
    }
    
    @objc private func tapBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func addMapView() {
        DispatchQueue.main.async {

            self.xmapView = XMapView(frame: self.mapView.bounds)
            self.xmapView?.tag = 100
            guard let _ = self.xmapView else {
            return
        }
        self.mapView.addSubview(self.xmapView!)
        
        self.xmapView?.didDragMap = { [weak self] (isDrag,_) in
            guard let self = self else {
                return
            }
            self.addressBGVw.isHidden = isDrag
        }
            self.viewWillAppearCustom()
        }

    }
    
    private func removeMapView() {
        for subView in mapView.subviews where subView.tag == 100 {
            xmapView?.clearAll()
            subView.removeFromSuperview()
            xmapView?.currentLocation = nil
            xmapView = nil
        }
    }
    
    
    func storeCurrentLocation(location:LocationDetail) {
        self.sourceLocationDetail = SourceDestinationLocation(address: location.address,locationCoordinate: LocationCoordinate(latitude: (location.coordinate.latitude), longitude: (location.coordinate.longitude)))
        self.xmapView?.showCurrentLocation()
    }
    
    //Getting current location detail
    private func getCurrentLocationDetails() {
        xmapView?.getCurrentLocationDetail { [weak self] (location) in
            guard let self = self else {
                return
            }
            
            DispatchQueue.main.async
                {
                    if let cLocation = self.sourceLocationDetail.locationCoordinate,cLocation.latitude == 0 {
                        self.storeCurrentLocation(location: location)
                    } else {
                        self.storeCurrentLocation(location: location)
                        
                    }
            }
        }
    }
    
    private func viewWillAppearCustom() {
        self.hideTabBar()
        
        self.xmapView?.didUpdateLocation = { [weak self] (location) in
            guard let self = self else {
                return
            }
            let currentLocation = CLLocation(latitude: location.latitude ?? 0, longitude: location.longitude ?? 0)
            if self.sourceLocationDetail.locationCoordinate == nil {
                self.xmapView?.currentLocation = currentLocation
            }else{
                self.xmapView?.moveCameraPosition(lat: self.sourceLocationDetail.locationCoordinate?.latitude ?? APPConstant.defaultMapLocation.latitude, lng: self.sourceLocationDetail.locationCoordinate?.longitude ?? APPConstant.defaultMapLocation.longitude)
            }
        }
        DispatchQueue.main.async {
            self.xmapView?.clearAll()
            self.setSourceDestinationAndPolyline()
        }
        
    }
    
}

// MARK: - UITableViewDataSource

extension CourierRouteViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.routeTblVw.dequeueReusableCell(withIdentifier: CourierConstant.RouteTableViewCell, for: indexPath) as! RouteTableViewCell
        cell.buttonRemove.tag = indexPath.row
        cell.buttonRemove.addTarget(self, action: #selector(removeObject(sender:)), for: .touchUpInside)
        cell.deliveryAddressLabel.text = self.courierRequestArray[indexPath.row].d_address
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return courierRequestArray.count > 0 ? courierRequestArray.count : 0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let courierAddAddressController = CourierRouter.courierStoryboard.instantiateViewController(withIdentifier: CourierConstant.CourierAddAddressController) as! CourierAddAddressController
        courierAddAddressController.delegate = self
        courierAddAddressController.editData = courierRequestArray[indexPath.row]
        courierAddAddressController.editIndex = indexPath.row
        courierAddAddressController.isEdit = true
        self.navigationController?.pushViewController(courierAddAddressController, animated: true)
    }
    
}
// MARK: - UITableViewDelegate

extension CourierRouteViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return courierRequestArray.count > 0 ? 50 : 0
    }
    
    @IBAction func removeObject(sender:UIButton){
        
        self.courierRequestArray.remove(at:sender.tag)
        
        if CourierConstant.deliveryType == CourierConstant.singleDelivery {
            height = height - 50
            addAddressBtn.isHidden = false
        }else{
            height = height - 50
        }
        self.routeTblVwHeight.constant = height
        routeTblVw.reloadData()
        self.routeTblVw.layoutIfNeeded()
        DispatchQueue.main.async {
            self.xmapView?.clearAll()
            self.setSourceDestinationAndPolyline()
        }
    }
}


extension CourierRouteViewController : AddRequest
{
    func sendBackAddedValues(values: CourierData, isEdited: Bool, editIndex: Int) {
        if(isEdited == true){
            courierRequestArray[editIndex] = values
        }
        else{
            courierRequestArray.append(values)
        }
        if CourierConstant.deliveryType == CourierConstant.singleDelivery {
            height = CGFloat(courierRequestArray.count * 50)
            addAddressBtn.isHidden = true
            
        }else{
            height = CGFloat(courierRequestArray.count * 50)
            
        }
        self.routeTblVwHeight.constant = height
        routeTblVw.reloadInMainThread()
        self.routeTblVw.layoutIfNeeded()
        //  xmapView?.removePolylines()
        DispatchQueue.main.async {
            self.xmapView?.clearAll()
            self.setSourceDestinationAndPolyline()
        }
        // setSourceDestinationAndPolyline()
        //  self.mapView.layoutIfNeeded()
    }
    
    
}
extension CourierRouteViewController {
    private func setFont() {
        
        vehicleTypeLbl.font = .setCustomFont(name: .medium, size: .x12)
        routeLbl.font = .setCustomFont(name: .medium, size: .x12)
        priceLbl.font = .setCustomFont(name: .medium, size: .x12)
        nextBtn.titleLabel?.font = .setCustomFont(name: .medium, size: .x16)
        addAddressBtn.titleLabel?.font = .setCustomFont(name: .medium, size: .x14)
        fromLbl.font = .setCustomFont(name: .medium, size: .x14)
        fromLbl.textColor = .lightGray
        toLbl.font = .setCustomFont(name: .medium, size: .x14)
        toLbl.textColor = .lightGray
        sourceLbl.font = .setCustomFont(name: .medium, size: .x14)
        
    }
    private func setColors() {
        
        vehicleTypeLbl.textColor = .lightGray
        routeLbl.textColor = .lightGray
        priceLbl.textColor = .lightGray
        nextBtn.backgroundColor = .courierColor
        routeTblVw.backgroundColor = .clear
        
    }
    private func setText(){
        vehicleTypeLbl.text = CourierConstant.vehicleType
        routeLbl.text = CourierConstant.route
        priceLbl.text = CourierConstant.price
    }
    @objc func tapAddress() {
        if self.courierRequestArray.count <=  3 {
            let courierAddAddressController = CourierRouter.courierStoryboard.instantiateViewController(withIdentifier: CourierConstant.CourierAddAddressController) as! CourierAddAddressController
            courierAddAddressController.delegate = self

            self.navigationController?.pushViewController(courierAddAddressController, animated: true)
        }else{
            ToastManager.show(title: CourierConstant.dropAlert.localized , state: .error)
            
        }
    }
    
    @objc func nextAction() {
        
        if courierRequestArray.count > 0 {
            
            let pricingVC = CourierRouter.courierStoryboard.instantiateViewController(withIdentifier: CourierConstant.CourierPricingViewController) as! CourierPricingViewController
            pricingVC.sourceLocation = self.sourceLocationDetail
            pricingVC.serviceID = serviceTypeID
            pricingVC.courierRequestArray = self.courierRequestArray
            pricingVC.deliveryTypeID = self.deliveryTypeID
            navigationController?.pushViewController(pricingVC, animated: true)
        }
        else
        {
            ToastManager.show(title: "Please Add address details to Procees", state: .error)
            
        }
        
    }
    
    private func setSourceDestinationAndPolyline() {
        DispatchQueue.main.async {
            self.setSourceDestinationMarker()
            for i in 0..<self.courierRequestArray.count {
               
                self.destinationLocationDetail = SourceDestinationLocation(address: self.courierRequestArray[i].d_address ?? "", locationCoordinate: CLLocationCoordinate2D(latitude: self.courierRequestArray[i].d_latitude ?? 0, longitude: self.courierRequestArray[i].d_longitude ?? 0))
                self.xmapView?.drawCourierPolyLineFromSourceToDestination(source: self.sourceLocationDetail.locationCoordinate ?? APPConstant.defaultMapLocation, destination: self.destinationLocationDetail.locationCoordinate ?? APPConstant.defaultMapLocation, lineColor: .courierColor)
            }
        }
    }
    private func setSourceDestinationMarker() {
        DispatchQueue.main.async {
            
            for i in 0..<self.courierRequestArray.count {
           
                self.destinationLocationDetail = SourceDestinationLocation(address: self.courierRequestArray[i].d_address ?? "", locationCoordinate: CLLocationCoordinate2D(latitude: self.courierRequestArray[i].d_latitude ?? 0, longitude: self.courierRequestArray[i].d_longitude ?? 0))
                self.xmapView?.setCourierSourceLocationMarker(sourceCoordinate: self.sourceLocationDetail.locationCoordinate ?? APPConstant.defaultMapLocation, marker: UIImage(named: "sorcepinnew") ?? UIImage(),titleStr:"Source")
                self.xmapView?.setCourierDestinationLocationMarker(destinationCoordinate: self.destinationLocationDetail.locationCoordinate ?? APPConstant.defaultMapLocation, marker: UIImage(named: "destinationpinnew") ?? UIImage(),titleStr:"Point\(i+1)")
            }
        }
    }
}
