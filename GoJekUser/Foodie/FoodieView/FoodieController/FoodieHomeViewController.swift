//
//  FoodieHomeViewController.swift
//  GoJekUser
//
//  Created by Thiru on 27/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class FoodieHomeViewController: UIViewController {
    
    //NavigationView
    @IBOutlet weak var filterBtnView: RoundedView!
    @IBOutlet weak var restaurantListTableView: UITableView!
    
    //Variables
    var bannerView: HomeBannerView!
    var filterView: FoodieScheduleTimeView!
    var shopArrList:[ShopsListData] = []
    var promoCodeListArr:[PromocodeData] = []
    private var mapViewHelper:GoogleMapsHelper?
    
    var lat = 0.0
    var long = 0.0
    var isFoodie = false

    //MARK: View LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoads()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        hideTabBar()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        FLocationManager.shared.stop()
    }
    
    
}
extension FoodieHomeViewController {
    
    private func initialLoads() {
        LoadingIndicator.show()
        
        restaurantListTableView.register(UINib(nibName: FoodieConstant.RestaurantTableViewCell, bundle: nil), forCellReuseIdentifier: FoodieConstant.RestaurantTableViewCell)
        restaurantListTableView.register(UINib(nibName: FoodieConstant.EmptyShopTableCell, bundle: nil), forCellReuseIdentifier: FoodieConstant.EmptyShopTableCell)
        
        FLocationManager.shared.start { (info) in
            print(info.longitude ?? 0.0)
            print(info.latitude ?? 0.0)
            self.lat = info.latitude ?? 0.0
            self.long = info.longitude ?? 0.0
            let param: Parameters = ["latitude":info.latitude ?? 0.0,
                                     "longitude":info.longitude ?? 0.0]
            self.foodiePresenter?.getListOfStores(Id: AppManager.shared.getSelectedServices()?.menu_type_id ?? 0, param: param)
        }
        
        showHomeBanner()
        let recong = UITapGestureRecognizer(target: self, action: #selector(tapFilter))
        filterBtnView.addGestureRecognizer(recong)
        title = ""
        view.backgroundColor = .veryLightGray
        DispatchQueue.main.async {
            self.filterBtnView.setCornerRadius()
            self.filterBtnView.backgroundColor = .foodieColor
            self.filterBtnView.setCenterImage = UIImage(named: FoodieConstant.ic_filter)?.imageTintColor(color1: .white)
        }
        
        self.setNavigationTitle()
        self.setLeftBarButtonWith(color: .blackColor)
        
        
        
        let rightBarButton = UIBarButtonItem.init(image: UIImage.init(named: Constant.ic_search), style: .plain, target: self, action: #selector(rightBarButtonAction))
        navigationItem.rightBarButtonItem = rightBarButton
        setDarkMode()
    }
    
    
    private func setDarkMode(){
        self.view.backgroundColor = .backgroundColor
        self.restaurantListTableView.backgroundColor = .backgroundColor
    }
    
    //Left navigation bar button action
    @objc func rightBarButtonAction() {
         if guestLogin() {
        let foodieSearchViewController = FoodieRouter.foodieStoryboard.instantiateViewController(withIdentifier: FoodieConstant.FoodieSearchViewController) as! FoodieSearchViewController
        if shopArrList.first?.storetype?.category != FoodieConstant.food {
            foodieSearchViewController.isFoodieCatgory = false
        }else{
            foodieSearchViewController.isFoodieCatgory = true
            
        }
        navigationController?.pushViewController(foodieSearchViewController, animated: true)
        }
    }
    
    private func showHomeBanner() {
        
        if self.bannerView == nil, let bannerView = Bundle.main.loadNibNamed(FoodieConstant.HomeBannerView, owner: self, options: [:])?.first as? HomeBannerView {
            
            bannerView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.frame.width, height: bannerView.frame.height))
            bannerView.delegate = self
            self.bannerView = bannerView
            
            self.view.addSubview(bannerView)
            bannerView.show(with: .right, completion: nil)
        }
    }
    
    @objc func tapFilter() {
        
        let foodieItemsVC = FoodieRouter.foodieStoryboard.instantiateViewController(withIdentifier: FoodieConstant.FoodieFilterController) as! FoodieFilterController
        foodieItemsVC.delegate = self
        if(shopArrList.count != 0)
        {
        foodieItemsVC.isFoodie = shopArrList.first?.storetype?.category == FoodieConstant.food
        }
        else
        {
          foodieItemsVC.isFoodie = isFoodie
        }
        
        navigationController?.present(foodieItemsVC, animated: true, completion: nil)
    }
}

//MARK: UITableViewDelegate

extension FoodieHomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if shopArrList.count != 0 {
            let foodieItem = shopArrList[indexPath.row]

                let foodieItemsVC = FoodieRouter.foodieStoryboard.instantiateViewController(withIdentifier: FoodieConstant.FoodieItemsViewController) as! FoodieItemsViewController
                foodieItemsVC.restaurentId = foodieItem.id ?? 0
                foodieItemsVC.isFoodie = isFoodie
                if foodieItem.shopstatus != "CLOSED" {
                    foodieItemsVC.isClosed = false
                }
                else
               {
                foodieItemsVC.isClosed = true
               }
                navigationController?.pushViewController(foodieItemsVC, animated: true)
          //  }
        }
    }
}

//MARK: - UITableViewDataSource

extension FoodieHomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if shopArrList.count == 0 {
            count = 1
        }else{
            count = shopArrList.count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         if shopArrList.count == 0 {
       
            let cell = restaurantListTableView.dequeueReusableCell(withIdentifier: FoodieConstant.EmptyShopTableCell, for: indexPath) as! EmptyShopTableCell
                      
              
                      
                      return cell
         }else{
             let cell = restaurantListTableView.dequeueReusableCell(withIdentifier: FoodieConstant.RestaurantTableViewCell, for: indexPath) as! RestaurantTableViewCell
                    
                    cell.setShopListData(data: shopArrList[indexPath.row])
                    
                    return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return bannerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return bannerView.frame.height
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
}

//MARK: - FoodiePresenterToFoodieViewProtocol

extension FoodieHomeViewController: FoodiePresenterToFoodieViewProtocol {
    
    func getListOfStoresResponse(getStoreResponse: StoreListEntity) {
        let params:Parameters = ["" : ""]
        foodiePresenter?.getPromoCodeList(param: params)
        shopArrList = getStoreResponse.responseData ?? []
        title = APPConstant.appName + " " + (getStoreResponse.responseData?.first?.storetype?.name?.capitalized ?? "")
        isFoodie = getStoreResponse.responseData?.first?.storetype?.category == FoodieConstant.food
        bannerView.filterButton.isHidden = getStoreResponse.responseData?.first?.storetype?.category != FoodieConstant.food
        restaurantListTableView.reloadData()
        LoadingIndicator.hide()
    }
    
    func getPromoCodeResponse(getPromoCodeResponse: PromocodeEntity) {

        promoCodeListArr = getPromoCodeResponse.responseData ?? []
        bannerView.promoCodeList = promoCodeListArr
        if bannerView.promoCodeList.count == 0 {
            bannerView.errorView.isHidden = false
        }else{
            bannerView.errorView.isHidden = true
        }
        bannerView.bannerCollectionView.reloadData()
        
    }
    
    func getFilterRestaurantResponse(getFilterRestaurantResponse: StoreListEntity) {
        shopArrList = getFilterRestaurantResponse.responseData ?? []

        restaurantListTableView.reloadData()
    }
}

//MARK: - HomeBannerViewDelegate

extension FoodieHomeViewController: HomeBannerViewDelegate,FoodieFilterControllerDelegate {
    func applyFilterAction(filterArr:String,qfilter:String){
        
        let param: Parameters = ["latitude":lat,
                                 "longitude":long]
        self.foodiePresenter?.getFilterRestaurant(Id: AppManager.shared.getSelectedServices()?.menu_type_id ?? 0, filter: filterArr, qFilter: qfilter, param: param)
        
    }
    
    func applyFilterAction(vegOrNonVeg:String) {
        
        let param: Parameters = ["latitude":lat, "longitude":long]
        self.foodiePresenter?.getFilterRestaurant(Id: AppManager.shared.getSelectedServices()?.menu_type_id ?? 0, filter: "", qFilter: vegOrNonVeg, param: param)
    }
}


