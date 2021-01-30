//
//  XuberProviderListController.swift
//  GoJekUser
//
//  Created by on 14/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import SDWebImage

class XuberProviderListController: UIViewController {
    
    @IBOutlet weak var listButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var providerTableView: UITableView!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var overView: UIView!
    @IBOutlet weak var providerTableViewStackview: UIStackView!
    
    var isList:Bool = false{
        didSet{
            updateUI()
        }
    }
    
    var userLocationDetail = SourceDestinationLocation()
    
    var xmapView : XMapView?
    
    var providerList:[Provider_service] = [] {
        didSet {
            self.providerTableView.reloadInMainThread()
        }
    }
    
    var selectedProviderName:String = ""
    
    var onTapMarkerCount:Int = 0
    var markers: [GMSMarker] = []
    var mapImage:UIImage!
    
    
    // Filtered Data
    private var filterProviderList = [Provider_service]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoads()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addMapView()
        showProviderOnMap()
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeMapView()
        markers.removeAll()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.xmapView?.frame = self.mapView.bounds
        overView.setCornerRadiuswithValue(value: 8)
    }
}

//MARK:- Methods

extension XuberProviderListController{
    
    private func initialLoads() {
        self.view.backgroundColor = .veryLightGray
        self.setNavigationBar()
        isList = true
        listButton.titleLabel?.font = UIFont.setCustomFont(name: .medium, size: .x16)
        mapButton.titleLabel?.font = UIFont.setCustomFont(name: .medium, size: .x16)
        listButton.addTarget(self, action: #selector(tapList), for: .touchUpInside)
        mapButton.addTarget(self, action: #selector(tapMap), for: .touchUpInside)
        listButton.setTitle(XuberConstant.list.localized, for: .normal)
        mapButton.setTitle(XuberConstant.map.localized, for: .normal)
        self.providerTableView.register(nibName: XuberConstant.XuberProviderCell)
        SendRequestInput.shared.s_latitude = userLocationDetail.locationCoordinate?.latitude ?? 0.0
        SendRequestInput.shared.s_longitude = userLocationDetail.locationCoordinate?.longitude ?? 0.0
        
        var param:Parameters = [XuberInput.lat: SendRequestInput.shared.s_latitude ?? 0.0,
                                XuberInput.long: SendRequestInput.shared.s_longitude ?? 0.0,
                                XuberInput.id: SendRequestInput.shared.serviceId ?? 0 ]
        if SendRequestInput.shared.isAllowQuantity ?? false{
            param[XuberInput.qty] = SendRequestInput.shared.quantity ?? 1
        }
        xuberPresenter?.getProviderList(param: param)
        self.searchTextField.placeholder = XuberConstant.searchBy
        self.searchTextField.setLeftView(imageStr: Constant.ic_search)
        self.searchTextField.clearButtonMode = .whileEditing
        searchTextField.delegate = self
        self.searchTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        setDarkMode()
    }
    
    private func setDarkMode(){
        mapView.backgroundColor = .whiteColor
        self.view.backgroundColor = .backgroundColor
        self.overView.backgroundColor = .boxColor
        self.providerTableView.backgroundColor = .boxColor
    }
    
    private func setNavigationBar() {
        self.setNavigationTitle()
        self.setLeftBarButtonWith(color: .blackColor)
        self.title = XuberConstant.serviceProvider.localized
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    private func updateUI() {
        mapButton.setTitleColor(!isList ? .xuberColor : .lightGray, for: .normal)
        mapButton.backgroundColor = !isList ? UIColor.xuberColor.withAlphaComponent(0.15) : .boxColor
        listButton.backgroundColor = isList ? UIColor.xuberColor.withAlphaComponent(0.15) : .boxColor
        listButton.setTitleColor(isList ? .xuberColor : .lightGray, for: .normal)
        providerTableViewStackview.isHidden = !isList
        mapView.isHidden = isList
        DispatchQueue.main.async {
            self.providerTableViewStackview.frame = CGRect(origin: CGPoint(x: self.buttonStackView.frame.origin.x, y: self.buttonStackView.frame.maxY), size: CGSize(width: self.buttonStackView.frame.width, height: self.view.frame.height-self.buttonStackView.frame.maxY-30))
            
            self.mapView.frame = CGRect(origin: CGPoint(x: self.buttonStackView.frame.origin.x, y: self.buttonStackView.frame.maxY), size: CGSize(width: self.buttonStackView.frame.width, height: self.view.frame.height-self.buttonStackView.frame.maxY-30))
        }
    }
    
    @objc func tapList() {
        self.isList = true
    }
    
    @objc func tapMap() {
        self.isList = false
    }
    
    private func addMapView() {
        xmapView = XMapView(frame: self.mapView.bounds)
        xmapView?.tag = 100
        guard let _ = xmapView else {
            return
        }
        self.mapView.addSubview(self.xmapView!)
        
        self.xmapView?.didTapMap = { [weak self]  (marker) in
            guard let self = self else {
                return
            }
            
            for i in 0..<self.providerList.count{
                let user = marker.userData as! Provider_service
                if user.id == self.providerList[i].id{
                    let vc = XuberRouter.xuberStoryboard.instantiateViewController(withIdentifier: XuberConstant.XuberProviderReviewController)  as! XuberProviderReviewController
                    vc.selectedProvider = self.providerList[i]
                    let fareDetails = getFareDetails(provider: self.filterProviderList[i])
                    SendRequestInput.shared.fareType = ServiceFareType(rawValue: fareDetails.1)
                    SendRequestInput.shared.price = Double(fareDetails.0)
                    SendRequestInput.shared.providerId = self.filterProviderList[i].id
                    self.navigationController?.pushViewController(vc, animated: true)
                    self.selectedProviderName = self.providerList[i].first_name ?? ""
                    return
                }
            }
            
        }
    }
    
    private func removeMapView() {
        for subView in mapView.subviews where subView.tag == 100 {
            xmapView?.clearAll()
            subView.removeFromSuperview()
            xmapView = nil
        }
    }
    
    func showProviderOnMap() {
        if self.providerList.count > 0 {
            
            for i in 0..<providerList.count{
             
               let providerMarker = providerList[i]
                
                let pic  = providerMarker.picture
            
                if pic != "" && pic != nil {
                    if let imageUrl = URL(string: pic ?? "")  {
                         getData(from: imageUrl) { data, response, error in
                             guard let data = data, error == nil else { return }
                            // print(response?.suggestedFilename ?? imageUrl.lastPathComponent)
                             print("Download Finished")
                             DispatchQueue.main.async() {
                              self.mapImage = UIImage(data: data)
                                 let image = UIImage(data: data)
                                let position = self.checkIfMutlipleCoordinates(latitude: providerMarker.latitude ?? 0.0, longitude: providerMarker.longitude ?? 0.0)
                                let mapMarker = TestMarkerDetails(view: image ?? UIImage(), position:position)
                                self.addMarker(markers: mapMarker,provider: providerMarker)
                             }
                         }
                    }
                }else{
                    let imge = #imageLiteral(resourceName: "ic_user")
                  mapImage = imge
                    let position = self.checkIfMutlipleCoordinates(latitude: providerMarker.latitude ?? 0.0, longitude: providerMarker.longitude ?? 0.0)
                    let mapMarker = TestMarkerDetails(view: imge, position:position)
                    self.addMarker(markers: mapMarker,provider: providerMarker)
                }
                
                print("Marker Set \(String(describing: providerMarker.latitude))")
                
            }
            self.xmapView?.moveCameraPosition(lat: self.providerList.first?.latitude ?? 0.0, lng:  self.providerList.first?.longitude ?? 0.0)
        }
    }
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func addMarker(markers:TestMarkerDetails,provider:Provider_service) {
       
         // Set profile image in markers
        
        let markerImage = UIImageView()
        markerImage.contentMode = .scaleAspectFill
        markerImage.setBorder(width: 1.0, color: .xuberColor)
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        markerImage.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.width, height: view.frame.height)
        view.setBorder(width: 1.0, color: .xuberColor)
        view.setCornerRadius()
        
       //markerImage.image = markers.view  //change line
        markerImage.image = mapImage
        view.addSubview(markerImage)
        
        DispatchQueue.main.async {
            self.view.bringSubviewToFront(markerImage)
        }
        
        let marker = GMSMarker()
        marker.iconView = view
        marker.position = markers.position
        marker.userData = provider
        marker.title = (provider.first_name?.giveSpace ?? "")
        if let fareType = ServiceFareType(rawValue: provider.fare_type ?? "")?.fareString,let price = Double(provider.base_fare ?? "0") {
            marker.snippet = price.setCurrency()+fareType
        }
        self.markers.append(marker)
        marker.map = self.xmapView
       
    }
    
    func checkIfMutlipleCoordinates(latitude : Double , longitude : Double) -> CLLocationCoordinate2D{
        
        var lat = latitude
        var lng = longitude
        
        let arrTemp = self.providerList.filter {
            
            return (((latitude == $0.latitude) && (longitude == $0.longitude)))
        }
        
        if arrTemp.count > 1{
            // Core Logic giving minor variation to similar lat long
            
            let variation = (randomFloat(min: 0.0, max: 2.0) - 0.5) / 1500
            lat = lat + variation
            lng = lng + variation
        }
        let finalPos = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(lng))
        return  finalPos
    }
    
    func randomFloat(min: Double, max:Double) -> Double {
        return (Double(arc4random()) / 0xFFFFFFFF) * (max - min) + min
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let text = textField.text ?? ""
        if text.isDouble() {
            filterProviderList = self.providerList.filter({
                ($0.rating?.toString())?.contains(text) ?? false
            })
        }else{
            filterProviderList = self.providerList.filter({ ($0.first_name)?.lowercased().contains(text.lowercased()) ?? true})
        }
        if textField.text == ""{
            self.filterProviderList = self.providerList
            
        }
        self.providerTableView.reloadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing()
    }
}

extension XuberProviderListController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filterProviderList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell:XuberProviderCell = self.providerTableView.dequeueReusableCell(withIdentifier: XuberConstant.XuberProviderCell, for: indexPath) as? XuberProviderCell{
            if filterProviderList.count != 0 {
                cell.setValues(provider: self.filterProviderList[indexPath.row])
                
            }else{
                cell.setValues(provider: self.providerList[indexPath.row])
                
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = XuberRouter.xuberStoryboard.instantiateViewController(withIdentifier: XuberConstant.XuberProviderReviewController)  as! XuberProviderReviewController
        
        vc.selectedProvider = self.filterProviderList[indexPath.row]
        let fareDetails = getFareDetails(provider: self.filterProviderList[indexPath.row])
        SendRequestInput.shared.fareType = ServiceFareType(rawValue: fareDetails.1)
        SendRequestInput.shared.price = fareDetails.0
        SendRequestInput.shared.providerId = self.filterProviderList[indexPath.row].id
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


// MARK:- MapView

extension XuberProviderListController : GMSMapViewDelegate {
    
}

extension XuberProviderListController: XuberPresenterToXuberViewProtocol {
    func getProviderList(providerListEntity: XuberProviderEntity) {
        self.providerList = providerListEntity.responseData?.provider_service ??  []
        self.filterProviderList = self.providerList
        if self.providerList.count == 0 {
            self.searchTextField.isHidden = true
            self.providerTableView.setBackgroundTitle(title: XuberConstant.noProvidersAvailable.localized)
        }else{
            self.providerTableView.backgroundView = nil
        }
        showProviderOnMap()
    }
}

extension XuberProviderListController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing()
        return true
    }
}
