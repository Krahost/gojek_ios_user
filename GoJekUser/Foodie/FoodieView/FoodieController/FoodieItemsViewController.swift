//
//  FoodieItemsViewController.swift
//  GoJekUser
//
//  Created by Thiru on 07/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class FoodieItemsViewController: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var itemListTableView: UITableView!
    @IBOutlet weak var errorImageView: UIImageView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var errorView: UIView!
    
    
    var headerView: RestaurantDetailView!
    var cartView: ViewCartView?
    
    var shopDetail: ShopDetail?
    var productList: [FoodieDetailProduct] = []
    var AllproductList: [FoodieDetailProduct] = []
    var foodieCartList: CartListResponse?
    var restaurentId: Int?
    
    
    var priceSymbol = AppManager.shared.getUserDetails()
    var foodieAddOnsView: FoodieAddOns?
    var totalStoreCount = 0
    var cateSelectionId = 0
    var isClosed = false
    var isFoodie = false
    
    //ViewLife Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.isNavigationBarHidden = false
        hideTabBar()
        
        getItemAvailable(filter: .all)
    }
    
    override func viewDidLayoutSubviews() {
        itemListTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: (cartView?.bounds.height ?? 0), right: 0)
        
    }
}

extension FoodieItemsViewController {
    
    private func initialLoad() {
        
        self.setNavigationTitle()
        self.setLeftBarButtonWith(color: .blackColor)
        
        //Tableview cell register
        itemListTableView.register(UINib(nibName: FoodieConstant.FoodieItemsCell, bundle: nil), forCellReuseIdentifier: FoodieConstant.FoodieItemsCell)
        
        //headerView
        if headerView == nil, let bannerView = Bundle.main.loadNibNamed(FoodieConstant.RestaurantDetailView, owner: self, options: [:])?.first as? RestaurantDetailView {
            
            bannerView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.frame.width, height: bannerView.frame.height))
            headerView = bannerView
            headerView.closedLabel.isHidden = !isClosed
            self.view.addSubview(bannerView)
            bannerView.show(with: .bottom, completion: nil)
        }
        headerView.delegate = self
        self.view.backgroundColor = .veryLightGray
        errorView.isHidden = false
        errorImageView.image = UIImage(named: FoodieConstant.orderEmpty)
        errorLabel.text = FoodieConstant.StoreDetail.localized
        setDarkMode()
    }
    
    func setDarkMode(){
        self.view.backgroundColor = .backgroundColor
        self.itemListTableView.backgroundColor = .backgroundColor
    }
    
    //API Call
    private func getItemAvailable(filter: RestaurantType) {
        let param: Parameters = [FoodieConstant.search: "",
                                 FoodieConstant.Pqfilter: filter.rawValue]
        foodiePresenter?.getStoresDetail(with: restaurentId ?? 0, param: param)
    }
    
    private func showCartBottomView() {
        if cartView == nil, let cartView = Bundle.main.loadNibNamed(FoodieConstant.ViewCartView, owner: self, options: [:])?.first as? ViewCartView {
            DispatchQueue.main.async {
                
                if #available(iOS 11.0, *) {
                    let insets = self.view.window?.safeAreaInsets
                    let bottom = insets?.bottom
                    let subViewHeight = cartView.frame.size.height + bottom! + 5
                    cartView.frame = CGRect(origin: CGPoint(x: 20, y: self.view.frame.height-subViewHeight), size: CGSize(width: self.view.frame.width-40, height: cartView.frame.size.height))
                }
                
                self.cartView = cartView
                self.view.addSubview(cartView)
                cartView.show(with: .bottom, completion: nil)
            }
        }
        
        DispatchQueue.main.async {
            let userDetail = AppManager.shared.getUserDetails()
            let currency = userDetail?.currency ?? ""
            self.cartView?.priceLabel.text = "\(self.foodieCartList?.totalCart ?? 0) Items \(currency)\(self.foodieCartList?.totalItemPrice ?? 0)"
        }
    }
    
    private func updateCartViewValue() {
        if let cartCount = foodieCartList?.carts?.count, cartCount > 0 {
            showCartBottomView()
        }
        else {
            cartView?.dismissView(onCompletion: {
                //Close cart view
                self.cartView = nil
            })
        }
    }
    
    private func addOnsButton(index: Int,tag: Int,isplus: Bool) { //count tag-cell tag
        if foodieAddOnsView == nil, let foodieAddOnsView = Bundle.main.loadNibNamed(FoodieConstant.FoodieAddOns, owner: self, options: [:])?.first as? FoodieAddOns {
            
            self.foodieAddOnsView?.addonsItem.removeAllObjects()
            
            foodieAddOnsView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.frame.width, height: self.view.frame.height))
            foodieAddOnsView.delegate = self
            self.foodieAddOnsView = foodieAddOnsView
            self.view.addSubview(foodieAddOnsView)
        }
        foodieAddOnsView?.onClickClose = { [weak self] in
            guard let self = self else {
                return
            }
            self.foodieAddOnsView?.dismissView(onCompletion: {
                self.foodieAddOnsView = nil
            })
        }
        let productDetail = productList[tag]
        
        foodieAddOnsView?.index = index
        foodieAddOnsView?.tagCount = tag
        foodieAddOnsView?.isCartPage = false
        
        foodieAddOnsView?.isplus = isplus
        foodieAddOnsView?.AddonsArr = productDetail.itemsaddon ?? []
        foodieAddOnsView?.itemNameLabel.text = productDetail.itemName
        
        foodieAddOnsView?.itemImageView.sd_setImage(with: URL(string: productDetail.picture ?? "") , placeholderImage:UIImage.init(named: FoodieConstant.imagePlaceHolder),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
            // Perform operation.
            if (error != nil) {
                // Failed to load image
                self.foodieAddOnsView?.itemImageView.image = UIImage.init(named: FoodieConstant.imagePlaceHolder)
            } else {
                // Successful in loading image
                self.foodieAddOnsView?.itemImageView.image = image
            }
        })
        totalStoreCount = 1
        
        foodieAddOnsView?.itemPriceLabel.text = Double(productDetail.product_offer ?? 0).setCurrency()
        let addOnsCount = productDetail.itemsaddon?.count ?? 0
        for _ in 0..<addOnsCount{
            foodieAddOnsView?.addonsItem.add("")
            
        }
        foodieAddOnsView?.addOnsTableView.reloadData()
    }
    
    @objc func backAction() {
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - UITableViewDataSource
extension FoodieItemsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: FoodieConstant.FoodieItemsCell, for: indexPath) as! FoodieItemsCell
        let productDetail = productList[indexPath.row]
        if (productDetail.itemsaddon?.count == 0) || (shopDetail?.shopstatus == "CLOSED") || (self.isFoodie == false){
            cell.customizableLabel.isHidden = true
        }else{
            cell.customizableLabel.isHidden = false
        }
        
        
        if shopDetail?.shopstatus != "CLOSED" && productDetail.itemStatus == "Available" {
//            cell.itemsaddView.isHidden = true
            cell.isItemAvailable = true
          }else{
//            cell.itemsaddView.isHidden = false
            cell.isItemAvailable = false
            if shopDetail?.shopstatus == "CLOSED"{
                cell.itemNotAvailableView.isHidden = true
            }
        }
        
        
        
        cell.itemsaddView.tag = indexPath.row
        cell.itemsaddView.delegate = self
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.itemsaddView.currentType = .Order
        if productDetail.shop_status != nil && productDetail.shop_status != "" {
        cell.bestsellerLbl.text = productDetail.shop_status?.localized
            cell.bestsellerBGVw.isHidden = false
        }else{
            cell.bestsellerBGVw.isHidden = true
        }
        cell.itemNameLabel.text = productDetail.itemName
        
        if totalStoreCount == 0 && (shopDetail?.usercart ?? 0) > 0 {
            cell.itemsaddView.isDisable = true
        }
        
        
        
        var quantity = 0
        for quantityVal in productDetail.itemcart ?? [] {
            quantity = quantity+(quantityVal.quantity ?? 0)
        }
        cell.itemsaddView.count = quantity
        cell.priceLabel.text = "\(priceSymbol?.currency ?? "") \(productDetail.itemPrice ?? 0.0)"
        cell.priceLabel.textColor = .lightGray
        
        if (productDetail.offer ?? 0) == 1 {
            cell.priceLabel.isHidden = false
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: cell.priceLabel.text ?? "")
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            cell.priceLabel.attributedText = attributeString
        }else{
            cell.priceLabel.isHidden = true
            
        }
        if productDetail.isVeg == "Non Veg" {
            cell.isVeg  = false
        }else{
            cell.isVeg  = true
        }
        
        
        if productDetail.quantity != nil && productDetail.quantity != 0  {
            cell.qtyLabel.isHidden = false
            cell.qtyLabel.text = "Qty \(String(productDetail.quantity ?? 0))"
            if productDetail.unit != nil  {
                cell.qtyLabel.text = (cell.qtyLabel.text ?? "") + " " + "\(String(productDetail.unit?.name ?? ""))"
            }
        }else{
            cell.qtyLabel.isHidden = true
        }
        cell.discountPriceLabel.text = "\(priceSymbol?.currency ?? "") \(productDetail.product_offer ?? 0.0)"
        
        
        
        cell.itemImageView.sd_setImage(with: URL(string: productDetail.picture ?? "") , placeholderImage:UIImage.init(named: FoodieConstant.imagePlaceHolder),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
            // Perform operation.
            if (error != nil) {
                // Failed to load image
                cell.itemImageView.image = UIImage.init(named: FoodieConstant.imagePlaceHolder)
            } else {
                // Successful in loading image
                cell.itemImageView.image = image
            }
        })
        
        return cell
    }
}

//MARK: - UITableviewDelegate
extension FoodieItemsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerView.frame.height
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAtindexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK: - PlusMinusDelegates
extension FoodieItemsViewController: PlusMinusDelegates {
    
    func countChange(count: Int, tag: Int, isplus: Bool) {
        if guestLogin() {
            
            print("Count \(count) Tag \(tag)")
            let cell:FoodieItemsCell = itemListTableView.cellForRow(at: IndexPath(row: tag, section: 0)) as? FoodieItemsCell ?? FoodieItemsCell()
            let productDetail = productList[tag]
            let cardId = productDetail.itemcart?.first?.id ?? 0
            
            func changeItemValue() {
                self.totalStoreCount = 1
                if isplus {
                    cell.itemsaddView.count = cell.itemsaddView.count + 1
                } else {
                    cell.itemsaddView.count = cell.itemsaddView.count - 1
                }
                
                if cell.itemsaddView.count == 0 {
                    if cardId != 0 {
                        
                        let param: Parameters = [FoodieConstant.cartId: cardId]
                        self.foodiePresenter?.postRemoveCart(param: param)
                    }
                }
                else {
                    var param: Parameters = [:]
                    
                    if cardId != 0 {
                        param = [FoodieConstant.itemId: productDetail.id!,
                                 FoodieConstant.cartId: cardId,
                                 FoodieConstant.qty: cell.itemsaddView.count,
                                 FoodieConstant.repeatVal: 1,
                                 FoodieConstant.Pcustomize: 0]
                    } else {
                        param = [FoodieConstant.itemId: productDetail.id!,
                                 FoodieConstant.qty: cell.itemsaddView.count,
                                 FoodieConstant.repeatVal: 0,
                                 FoodieConstant.Pcustomize: 0]
                    }
                    self.foodiePresenter?.postAddToCart(param: param)
                }
            }
            
            //Validation of item
            if totalStoreCount == 0 && (shopDetail?.usercart ?? 0) > 0 {
                AppAlert.shared.simpleAlert(view: self, title: "", message: FoodieConstant.anotherRestaurant.localized, buttonOneTitle: Constant.SYes.localized, buttonTwoTitle: Constant.SNo.localized)
                AppAlert.shared.onTapAction = { [weak self] tag in
                    guard let self = self else {
                        return
                    }
                    if tag == 0 {
                        if productDetail.itemcart?.count == 0 {
                            if productDetail.itemsaddon?.count != 0 {
                                self.addOnsButton(index: count,tag: tag,isplus: isplus)
                            }else{
                                changeItemValue()
                            }
                        }else{
                            changeItemValue()
                        }
                    }
                }
            }else {
                if productDetail.itemsaddon?.count != 0 {
                    if !isplus {
                        if  let quantity = productDetail.itemcart?.count, quantity == 1, cardId != 0  {
                            cell.itemsaddView.count = cell.itemsaddView.count - 1
                            if cell.itemsaddView.count == 0 {
                                let param: Parameters = [FoodieConstant.cartId: cardId]
                                self.foodiePresenter?.postRemoveCart(param: param)
                            } else {
                                let param: Parameters = [FoodieConstant.itemId: productDetail.id!,
                                                         FoodieConstant.cartId: cardId,
                                                         FoodieConstant.qty: cell.itemsaddView.count,
                                                         FoodieConstant.repeatVal: 1,
                                                         FoodieConstant.Pcustomize: 0]
                                self.foodiePresenter?.postAddToCart(param: param)
                            }
                        } else {
                            let foodiecartVC = FoodieRouter.foodieStoryboard.instantiateViewController(withIdentifier: FoodieConstant.FoodieCartViewController)
                            navigationController?.pushViewController(foodiecartVC, animated: true)
                        }
                    } else {
                        if cell.itemsaddView.count > 0 {
                            AppAlert.shared.simpleAlert(view: self, title: "", message: FoodieConstant.repeatLast.localized, buttonOneTitle: Constant.SChoose.localized, buttonTwoTitle: Constant.SRepeat.localized)
                            AppAlert.shared.onTapAction = { [weak self] alertTag in
                                guard let self = self else {
                                    return
                                }
                                switch alertTag {
                                case 0:
                                    self.addOnsButton(index: count,tag: tag,isplus: isplus)
                                    break
                                case 1:
                                    cell.itemsaddView.count = cell.itemsaddView.count + 1
                                    let param: Parameters = [FoodieConstant.itemId: productDetail.id!,
                                                             FoodieConstant.cartId: 0,
                                                             FoodieConstant.qty: 0,
                                                             FoodieConstant.repeatVal: 1,
                                                             FoodieConstant.Pcustomize: 0]
                                    self.foodiePresenter?.postAddToCart(param: param)
                                    break
                                default:
                                    break
                                }
                            }
                        } else {
                            self.addOnsButton(index: count,tag: tag,isplus: isplus)
                        }
                    }
                } else {
                    changeItemValue()
                }
            }
        }
    }
}

//MARK: - FoodiePresenterToFoodieViewProtocol
extension FoodieItemsViewController: FoodiePresenterToFoodieViewProtocol {
    
    //    func getListOfProductsResponse(getProducntsResponse: ProductList) {
    //        productList = getProducntsResponse.responseData ?? []
    //        if productList.count == 0 {
    //            itemListTableView.setBackgroundImageAndTitle(imageName: "", title: FoodieConstant.StoreDetail.localized,tintColor: .black)
    //           // headerView.categoryBgVw.isHidden = true
    //                       headerView.availLabel.isHidden = true
    //        }else{
    //            itemListTableView.backgroundView = nil
    //            headerView.categoryBgVw.isHidden = false
    //                       headerView.availLabel.isHidden = false
    //        }
    //        itemListTableView.reloadData()
    //        foodiePresenter?.getCartList()
    //    }
    
    func getStoresDetailResponse(foodieDetailEntity: FoodieDetailEntity) {
        //Product list with reload tableview
        AllproductList = foodieDetailEntity.responseData?.products ?? []
        //  productList = productList.filter({$0.storeCategoryId == 0})
        shopDetail = foodieDetailEntity.responseData
        
        
        
        if cateSelectionId == 0 {
            productList.removeAll()
            for i in 0..<(foodieDetailEntity.responseData?.products?.count ?? 0) {
                
                if self.shopDetail?.categories?.first?.id == foodieDetailEntity.responseData?.products?[i].storeCategoryId {
                    productList.append((foodieDetailEntity.responseData?.products?[i])!)
                    
                }else{
                    // productList.replaceObject(at: i, with: "")
                }
                
            }
        }else{
            productList.removeAll()
            for i in 0..<(foodieDetailEntity.responseData?.products?.count ?? 0) {
                
                if cateSelectionId == foodieDetailEntity.responseData?.products?[i].storeCategoryId {
                    productList.append((foodieDetailEntity.responseData?.products?[i])!)
                    
                }else{
                    // productList.replaceObject(at: i, with: "")
                    //dfgssadfs
                    
                    
                    
                    
                    
                }                   }
        }
        
        
        
        if productList.count == 0 {
            
            errorView.isHidden = false
            headerView.availLabel.isHidden = true
        }else{
            errorView.isHidden = true
            itemListTableView.backgroundView = nil
            headerView.categoryBgVw.isHidden = false
            headerView.availLabel.isHidden = false
        }
        
        
        //            if productList.count == 0 {
        //                   itemListTableView.setBackgroundImageAndTitle(imageName: "", title: FoodieConstant.StoreDetail.localized,tintColor: .black)
        //              //  headerView.categoryBgVw.isHidden = true
        //                           headerView.availLabel.isHidden = true
        //               }else{
        //                   itemListTableView.backgroundView = nil
        //                   headerView.categoryBgVw.isHidden = false
        //                   headerView.availLabel.isHidden = false
        //               }
        itemListTableView.reloadData()
        foodiePresenter?.getCartList()
        //itemListTableView.reloadData()
        self.title = foodieDetailEntity.responseData?.storeName
        //Display tableview data
        
        totalStoreCount = shopDetail?.totalstorecart ?? 0
        // headerView.filterButton.isHidden = foodieDetailEntity.responseData?.storetype?.category != FoodieConstant.food
        headerView.filterButton.isHidden = true
        headerView.timeView.isHidden = foodieDetailEntity.responseData?.storetype?.category != FoodieConstant.food
        
        
        if shopDetail?.shopstatus != "CLOSED" {
            headerView.closedLabel.isHidden = true
        }else{
            headerView.closedLabel.isHidden = false
        }
        
        DispatchQueue.main.async {
            self.headerView.titleLabel.text = self.shopDetail?.storeName ?? ""
            //            let locationDetail = self.shopDetail?.storeLocation ?? ""
            let categories = self.shopDetail?.categories
            self.headerView.cateList = categories ?? []
            self.headerView.categoryCollectionVw.reloadData()
            let categoriesName: [String] = (categories?.map{ $0.store_category_description }) as! [String]
            self.headerView.descrLabel.text = "\((categoriesName.joined(separator: ", ")))"
            self.headerView.storeLocationLbl.text = self.shopDetail?.storeLocation ?? ""
            self.headerView.timeValueLabel.text = "\(foodieDetailEntity.responseData?.estimatedDeliveryTime ?? "0") Mins"
            let rateValue = Double(self.shopDetail?.rating ?? 0).rounded(.awayFromZero)
            self.headerView.ratingValueLabel.text = rateValue.toString()
            self.headerView.priceValue.text = "\(self.priceSymbol?.currency ?? "") \(self.shopDetail?.offerMinAmount ?? "0.0")"
            self.headerView.closedLabel.isHidden = !self.isClosed
        }
        
        
        //API Call
        foodiePresenter?.getCartList()
    }
    
    func postAddToCartResponse(addCartEntity: FoodieCartListEntity) {
        //API Call
        foodieCartList = addCartEntity.responseData
        getItemAvailable(filter: .all)
        
        updateCartViewValue()
    }
    
    func getCartListResponse(cartListEntity: FoodieCartListEntity) {
        foodieCartList = cartListEntity.responseData
        
        updateCartViewValue()
    }
    
    func postRemoveCartResponse(cartListEntity: FoodieCartListEntity) {
        //API Call
        foodieCartList = cartListEntity.responseData
        getItemAvailable(filter: .all)
        
        updateCartViewValue()
    }
}

//MARK: - FoodieItemsViewControllerDelegate

extension FoodieItemsViewController: FoodieItemsViewControllerDelegate {
    func categoriesSelectionAction(id: Int) {
        cateSelectionId = id
        
        
        productList.removeAll()
        for i in 0..<(AllproductList.count ) {
            
            if id == AllproductList[i].storeCategoryId {
                productList.append((AllproductList[i]))
                
            }else{
                // productList.replaceObject(at: i, with: "")
            }
        }
        
        itemListTableView.reloadData()
        if productList.count == 0 {
            errorView.isHidden = false
            headerView.availLabel.isHidden = true
        }else{
            errorView.isHidden = true
            headerView.categoryBgVw.isHidden = false
            headerView.availLabel.isHidden = false
            itemListTableView.backgroundView = nil
        }
        headerView.closedLabel.isHidden = !isClosed
        foodiePresenter?.getCartList()
    }
    
    func applyFilterAction(vegOrNonVeg:String) {
        //API Call
        let param: Parameters = [FoodieConstant.search: "",
                                 FoodieConstant.Pqfilter: vegOrNonVeg]
        foodiePresenter?.getStoresDetail(with: restaurentId ?? 0, param: param)
        
    }
}

//MARK: - FoodieAddOnsProtocol

extension FoodieItemsViewController: FoodieAddOnsProtocol{
    
    func ondoneAction(addonsItem: NSMutableArray,indexPath:Int,tag:Int,isplus: Bool){
        let cell:FoodieItemsCell = itemListTableView.cellForRow(at: IndexPath(row: tag, section: 0)) as? FoodieItemsCell ?? FoodieItemsCell()
        let productDetail = productList[tag]
        let cardId = productDetail.itemcart?.first?.id ?? 0
        foodieAddOnsView?.dismissView(onCompletion: {
            self.foodieAddOnsView = nil
            
            var addOnsArr:[String] = []
            for i in 0..<addonsItem.count {
                if let addonsStr = addonsItem[i] as? String {
                    if !addonsStr.isEmpty {
                        addOnsArr.append(addonsStr)
                    }
                }
            }
            
            let addOnsStr = addOnsArr.joined(separator: ",")
            if isplus {
                cell.itemsaddView.count = cell.itemsaddView.count + 1
            }else{
                cell.itemsaddView.count = cell.itemsaddView.count - 1
            }
            if cell.itemsaddView.count == 0 {
                if cardId != 0 {
                    let param: Parameters = [FoodieConstant.cartId: cardId]
                    self.foodiePresenter?.postRemoveCart(param: param)
                }
            }
            else {
                let param: Parameters = [FoodieConstant.itemId: productDetail.id!,
                                         FoodieConstant.qty: 1,
                                         FoodieConstant.addons: addOnsStr,
                                         FoodieConstant.repeatVal: 0,
                                         FoodieConstant.Pcustomize: 0]
                self.foodiePresenter?.postAddToCart(param: param)
            }
        })
    }
}
