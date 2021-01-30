//
//  FoodieSearchViewController.swift
//  GoJekUser
//
//  Created by Thiru on 01/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class FoodieSearchViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var closeButtonView: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchResultTableView: UITableView!
    
    //MARK: - LocalVariable
    var headerView: UIView!
    var restaurantButton: UIButton!
    var dishButton: UIButton!
    var foodieSearchArr:[SearchResponseData] = []
    var isFoodieCatgory = false
    var xmapView: XMapView?

    var isrestaurantSelect = false {
        didSet {
            if isrestaurantSelect {
                UIView.animate(withDuration: 0.3) {
                    self.restaurantButton.setTitleColor(UIColor.red, for: .normal)
                    self.dishButton.setTitleColor(UIColor.gray, for: .normal)
                }
            }
            else{
                UIView.animate(withDuration: 0.3) {
                    self.restaurantButton.setTitleColor(UIColor.gray, for: .normal)
                    self.dishButton.setTitleColor(UIColor.red, for: .normal)
                }
            }
            self.searchResultTableView.reloadData()
        }
    }
    
    //MARK: - View LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialLoad()
        
    }
    
    
    override func viewDidLayoutSubviews() {
        navigationView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        navigationView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        navigationView.layer.shadowOpacity = 1.0
        navigationView.layer.shadowRadius = 0.0
        navigationView.layer.masksToBounds = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
        self.hideTabBar()

    }
}

//MARK: - LocalMethod
extension FoodieSearchViewController {
    
    private func initialLoad() {
        addMapView()

        searchTextField.placeholder = FoodieConstant.searchRestaurant.localized
        searchTextField.delegate = self
       
        self.searchResultTableView.register(UINib(nibName: FoodieConstant.RestaurantTableViewCell, bundle: nil), forCellReuseIdentifier: FoodieConstant.RestaurantTableViewCell)
        
        closeButtonView.isUserInteractionEnabled = true
        let closeGesture = UITapGestureRecognizer(target: self, action: #selector(closeAction))
        closeButtonView.addGestureRecognizer(closeGesture)
        self.searchTextField.addTarget(self, action: #selector(searchTextChanged(sender:)), for: .editingChanged)
        createSearchButton()
        creatHeaderView()
        isrestaurantSelect = true
        
        xmapView?.didUpdateLocation = { [weak self] (location) in
            
            let param: Parameters = ["latitude":location.latitude ?? 0,
                                     "longitude":location.longitude ?? 0]
            
            self?.isrestaurantSelect = true
            
            self?.foodiePresenter?.searchRestaurantList(id: AppManager.shared.getSelectedServices()?.menu_type_id ?? 0, type: self?.isrestaurantSelect ?? true ? FoodieConstant.store : FoodieConstant.dishes, searchStr: self?.searchTextField.text ?? "", param: param)
        }
        
        XCurrentLocation.shared.latitude = 0.0
        XCurrentLocation.shared.longitude = 0.0
        searchTextField.backgroundColor = UIColor.veryLightGray
        searchTextField.textColor = .black
        self.view.backgroundColor = .backgroundColor
        self.closeButtonView.setImageColor(color: .blackColor)
        self.searchResultTableView.backgroundColor = .backgroundColor
        self.headerView.backgroundColor = .backgroundColor
    }
    
    
    private func addMapView() {
        self.xmapView = XMapView(frame: self.view.bounds)
        self.xmapView?.delegate = self.xmapView
        guard let _ = self.xmapView else {
            return
        }
    }
}
//MARK: - IBAction
extension FoodieSearchViewController {
    @objc func createSearchButton() {
        
        searchTextField.rightViewMode = .unlessEditing
        let searchButton = UIButton(type: .custom)
        searchButton.setImage(UIImage(named: Constant.ic_search), for: .normal)
        searchButton.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -16, bottom: 0, right: 0)
        searchButton.frame = CGRect(x: CGFloat(searchTextField.frame.size.width - 20), y: CGFloat(5), width: CGFloat(20), height: CGFloat(20))
        searchButton.imageView?.contentMode = .scaleAspectFit
        searchButton.addTarget(self, action: #selector(self.serchAction), for: .touchUpInside)
        searchTextField.rightView = searchButton
        searchTextField.rightViewMode = .always
    }
    
    @objc func creatHeaderView() {
        
        headerView = UIView()
        headerView.frame = CGRect(x: 20, y: 0, width: self.searchResultTableView.frame.size.width, height: self.view.frame.size.height/13)
        
        restaurantButton = UIButton.init(frame: CGRect(x: 20, y: 0, width: headerView.frame.size.width/3, height: headerView.frame.size.height))
        restaurantButton.textColor(color: .black)
        restaurantButton.titleLabel?.font = UIFont.setCustomFont(name: .medium, size: .x16)
        restaurantButton.setTitle(FoodieConstant.TShop.localized.uppercased(), for: .normal)
        restaurantButton.addTarget(self, action: #selector(self.retaurantClickAction), for: .touchUpInside)
        headerView.addSubview(restaurantButton)
        
        dishButton = UIButton.init(frame: CGRect(x: restaurantButton.frame.maxX, y: 0, width: headerView.frame.size.width/3.5, height: headerView.frame.size.height))
        dishButton.textColor(color:  .black)
        dishButton.titleLabel?.font = UIFont.setCustomFont(name: .medium, size: .x16)
        if isFoodieCatgory {
            dishButton.setTitle(FoodieConstant.TDishes.localized.uppercased(), for: .normal)
        }else{
            dishButton.setTitle(FoodieConstant.TItems.localized.uppercased(), for: .normal)
            
        }
        dishButton.addTarget(self, action: #selector(self.dishesClickAction), for: .touchUpInside)
        headerView.addSubview(dishButton)
    }
    
    @objc func serchAction() {
        
    }
    
    
    @objc func searchTextChanged(sender : UITextField)
    {
        let searchText  = sender.text ?? ""        
        if searchText == "" {
              let param: Parameters = ["latitude":XCurrentLocation.shared.latitude ?? 0,
                                              "longitude":XCurrentLocation.shared.longitude ?? 0]
                     self.foodiePresenter?.searchRestaurantList(id: AppManager.shared.getSelectedServices()?.menu_type_id ?? 0, type: isrestaurantSelect ? FoodieConstant.store : FoodieConstant.dishes, searchStr: searchText, param: param)
        }else{
            let param: Parameters = ["latitude":XCurrentLocation.shared.latitude ?? 0,
                                     "longitude":XCurrentLocation.shared.longitude ?? 0]
            self.foodiePresenter?.searchRestaurantList(id: AppManager.shared.getSelectedServices()?.menu_type_id ?? 0, type: isrestaurantSelect ? FoodieConstant.store : FoodieConstant.dishes, searchStr: searchText, param: param)
        }
    }
    
    @objc func retaurantClickAction() {
        if(isrestaurantSelect == false)
        {
        searchTextField.text = ""
        let param: Parameters = ["latitude":XCurrentLocation.shared.latitude ?? 0,
                                 "longitude":XCurrentLocation.shared.longitude ?? 0]
        isrestaurantSelect = true
        self.foodiePresenter?.searchRestaurantList(id: AppManager.shared.getSelectedServices()?.menu_type_id ?? 0, type: isrestaurantSelect ? FoodieConstant.store : FoodieConstant.dishes, searchStr: searchTextField.text!, param: param)
        }

    }
    
    @objc func dishesClickAction() {
        if(isrestaurantSelect == true)
        {
        searchTextField.text = ""
        let param: Parameters = ["latitude":XCurrentLocation.shared.latitude ?? 0,
                                 "longitude":XCurrentLocation.shared.longitude ?? 0]
        isrestaurantSelect = false
        
        self.foodiePresenter?.searchRestaurantList(id: AppManager.shared.getSelectedServices()?.menu_type_id ?? 0, type: isrestaurantSelect ? FoodieConstant.store : FoodieConstant.dishes, searchStr: searchTextField.text!, param: param)
        
        }
    }
    
    @objc func closeAction() {
        
        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK: - UITableViewDataSource
extension FoodieSearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodieSearchArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.searchResultTableView.dequeueReusableCell(withIdentifier: FoodieConstant.RestaurantTableViewCell, for: indexPath) as! RestaurantTableViewCell
        if isrestaurantSelect {
            cell.setSearchShopListData(data: self.foodieSearchArr[indexPath.row], isFoodCategory: isFoodieCatgory)
            cell.ratingView.isHidden = false
            cell.timeLabel.isHidden = false
            cell.dotView.isHidden = false
        }else {
            cell.setSearchShopListData(data: self.foodieSearchArr[indexPath.row], isFoodCategory: isFoodieCatgory)
            cell.ratingView.isHidden = true
            cell.timeLabel.isHidden = true
            cell.dotView.isHidden = true
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let foodieItem = foodieSearchArr[indexPath.row]
      //  if foodieItem.shopstatus != "CLOSED" {
            let foodieItemsVC = FoodieRouter.foodieStoryboard.instantiateViewController(withIdentifier: FoodieConstant.FoodieItemsViewController) as! FoodieItemsViewController
            foodieItemsVC.restaurentId = foodieItem.store_id ?? 0

            self.navigationController?.pushViewController(foodieItemsVC, animated: true)
      //  }
    }
}

//MARK: - UITableViewDelegate
extension FoodieSearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return self.view.frame.size.height/13
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return headerView
    }
    
}
extension FoodieSearchViewController: UITextFieldDelegate {
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
//        let searchText  = textField.text ?? ""
//
//        if searchText == "" {
//              let param: Parameters = ["latitude":XCurrentLocation.shared.latitude ?? 0,
//                                              "longitude":XCurrentLocation.shared.longitude ?? 0]
//                     self.foodiePresenter?.searchRestaurantList(id: AppManager.shared.getSelectedServices()?.menu_type_id ?? 0, type: isrestaurantSelect ? FoodieConstant.store : FoodieConstant.dishes, searchStr: searchText, param: param)
//
//
//        }else{
//            let param: Parameters = ["latitude":XCurrentLocation.shared.latitude ?? 0,
//                                     "longitude":XCurrentLocation.shared.longitude ?? 0]
//            self.foodiePresenter?.searchRestaurantList(id: AppManager.shared.getSelectedServices()?.menu_type_id ?? 0, type: isrestaurantSelect ? FoodieConstant.store : FoodieConstant.dishes, searchStr: searchText, param: param)
//
//        }
        
        return true
    }
    
    @objc func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if searchTextField.placeholder == FoodieConstant.searchRestaurant.localized {
            searchTextField.text = ""
        }
       
    }
    @objc func textFieldDidEndEditing(_ textfield: UITextField) {
        if searchTextField.text == "" {
            searchTextField.placeholder = FoodieConstant.searchRestaurant.localized
            searchResultTableView.reloadData()
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
// Protocols

extension FoodieSearchViewController: FoodiePresenterToFoodieViewProtocol {
    func searchRestaturantResponse(getSearchRestuarantResponse: SearchEntity) {
        foodieSearchArr.removeAll()
        foodieSearchArr = getSearchRestuarantResponse.responseData ?? []
        
        if foodieSearchArr.count == 0 {
            foodieSearchArr = []
            searchResultTableView.setBackgroundImageAndTitle(imageName:  FoodieConstant.ic_plate, title: FoodieConstant.searchRestaurantError.localized,tintColor: .black)
        }else{
            searchResultTableView.backgroundView = nil

        }
        searchResultTableView.reloadData()

    }
}
