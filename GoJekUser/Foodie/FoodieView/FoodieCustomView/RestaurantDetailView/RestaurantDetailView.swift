//
//  RestaurantDetailView.swift
//  GoJekUser
//
//  Created by Thiru on 06/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class RestaurantDetailView: UIView {
    
    //MARK: - IBOutlets
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descrLabel: UILabel!
    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeValueLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingValueLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceValue: UILabel!
    @IBOutlet weak var availLabel: UILabel!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var rateView: UIView!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var storeLocationLbl: UILabel!
    @IBOutlet weak var closedLabel: UILabel!
    @IBOutlet weak var categoryBgVw: UIView!
    @IBOutlet weak var categoryCollectionVw: UICollectionView!
    
    //MARK: - LocalVariable
    var headerView: RestaurantDetailView!
    weak var delegate: FoodieItemsViewControllerDelegate?
    var cateList:[Categories] = []
    var firstIndexpath: IndexPath!
      // var selectedIndexPath:IndexPath!
     var isClickCell: Bool = false
     var tempCount = 0
     var isClosed = false

    var selectedIndexPath : IndexPath = IndexPath(item: 0, section: 0) {
        didSet {
            self.categoryCollectionVw.reloadItems(at: [selectedIndexPath])
        }
    }
    // LifeCycles
    override func awakeFromNib() {
        super.awakeFromNib()
        initialLoad()
    }
}

//MARK: - LocalMethod
extension RestaurantDetailView: AppActionSheetDelegate {
    
    private func initialLoad() {
      closedLabel.isHidden = true
        filterButton.isHidden = true
        categoryCollectionVw.allowsMultipleSelection = false
        
        if CommonFunction.checkisRTL() {
            filterButton.changeToRight(spacing: -10)
            self.descrLabel.textAlignment = .right

        }else {
            filterButton.contentHorizontalAlignment = .left
        }

        self.filterButton.addTarget(self, action: #selector(ShowAction), for: .touchUpInside)
        self.favoriteImageView.image = UIImage.init(named: FoodieConstant.ic_resFav)
        self.ratingImageView.image = UIImage.init(named: FoodieConstant.ic_starfilled)?.imageTintColor(color1: .foodieColor)
        
        DispatchQueue.main.async {
            self.timeView.setCornerRadiuswithValue(value: 5)
            self.rateView.setCornerRadiuswithValue(value: 5)
            self.priceView.setCornerRadiuswithValue(value: 5)
        }
        
        self.setCustomFont()
        self.setCustomColor()
        self.setCustomLocalization()
        
        categoryCollectionVw.backgroundColor = .clear
               categoryCollectionVw.delegate = self
               categoryCollectionVw.dataSource = self
               self.categoryCollectionVw.register(UINib(nibName: FoodieConstant.CategoryListCollectionViewCell,bundle: nil), forCellWithReuseIdentifier: FoodieConstant.CategoryListCollectionViewCell)
              
        favoriteImageView.isHidden = true
        filterButton.tintColor = .foodieColor
//        closedLabel.isHidden = isClosed
        setDarkMode()
    }
    
    private func setDarkMode(){
        self.backGroundView.backgroundColor = .boxColor
        self.storeLocationLbl.textColor = .blackColor
        self.timeValueLabel.textColor = .blackColor
        self.categoryBgVw.backgroundColor = .clear
    }
    
    private func setCustomFont() {
        
        self.titleLabel.font = UIFont.setCustomFont(name: .bold, size: .x18)
        self.availLabel.font = UIFont.setCustomFont(name: .bold, size: .x16)
        self.descrLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        self.storeLocationLbl.font = UIFont.setCustomFont(name: .medium, size: .x14)
        self.timeLabel.font = UIFont.setCustomFont(name: .light, size: .x12)
        self.timeValueLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        self.ratingLabel.font = UIFont.setCustomFont(name: .light, size: .x12)
        self.ratingValueLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        self.priceLabel.font = UIFont.setCustomFont(name: .light, size: .x12)
        self.priceValue.font = UIFont.setCustomFont(name: .medium, size: .x14)
        self.filterButton.titleLabel?.font = UIFont.setCustomFont(name: .medium, size: .x14)
        closedLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        closedLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
               closedLabel.setCornerRadiuswithValue(value: 8)
               closedLabel.text = FoodieConstant.closed.localized
    }
    
    private func setCustomColor() {
        
        self.availLabel.textColor = .foodieColor
        self.backGroundView.addShadow(radius: 5.0, color: .lightGray)
        self.descrLabel.textColor = .lightGray
        closedLabel.textColor = .white
        self.storeLocationLbl.textColor = .black
        self.timeView.backgroundColor = UIColor.foodieColor.withAlphaComponent(0.1)
        self.priceView.backgroundColor = UIColor.foodieColor.withAlphaComponent(0.1)
        self.rateView.backgroundColor = UIColor.foodieColor.withAlphaComponent(0.1)
        filterButton.setTitleColor(UIColor.lightGray, for: .normal)

    }
    
    private func setCustomLocalization() {
        
        self.filterButton.setImage(UIImage(named: FoodieConstant.ic_downarrow)?.imageTintColor(color1: .foodieColor), for: .normal)
        self.filterButton.setTitle(FoodieConstant.all.localized, for: .normal)
        self.availLabel.text = FoodieConstant.itemAvailbale.localized.uppercased()
        self.timeLabel.text = FoodieConstant.timeing.localized
        self.ratingLabel.text = FoodieConstant.rating.localized
        self.priceLabel.text = FoodieConstant.price.localized
        if CommonFunction.checkisRTL() {
            filterButton.changeToRight(spacing: -10)
        }else {
            filterButton.changeToRight(spacing: 10)
        }
      //  filterButton.sizeToFit()
    }
    
    @objc func ShowAction() {
        AppActionSheet.shared.showActionSheet(viewController: UIApplication.topViewController()!, buttonOne: FoodieConstant.nonVeg.localized, buttonTwo: FoodieConstant.veg.localized, buttonThird: FoodieConstant.all.localized)
        AppActionSheet.shared.delegate = self
    }
    
    func actionSheetDelegate(tag: Int) {
        if tag == 0 {
            filterButton.setTitle(FoodieConstant.nonVeg.localized, for: .normal)
            
            if CommonFunction.checkisRTL() {
                filterButton.changeToRight(spacing:-10)
            }else {
                filterButton.changeToRight(spacing: 10)
            }
            delegate?.applyFilterAction(vegOrNonVeg:  RestaurantType.nonveg.rawValue)
            
        }else if tag == 1 {
            filterButton.setTitle(FoodieConstant.veg.localized, for: .normal)
            
            if CommonFunction.checkisRTL() {
                filterButton.changeToRight(spacing: -10)
            }else {
                filterButton.changeToRight(spacing: 10)
            }
            delegate?.applyFilterAction(vegOrNonVeg:  RestaurantType.veg.rawValue)
            
        }
        else{
            filterButton.setTitle(FoodieConstant.all.localized, for: .normal)
            if CommonFunction.checkisRTL() {
                filterButton.changeToRight(spacing: -10)
            }else {
                filterButton.changeToRight(spacing: 10)
            }
            delegate?.applyFilterAction(vegOrNonVeg:  RestaurantType.all.rawValue)
            
        }
        self.filterButton.setImage(UIImage(named: FoodieConstant.ic_downarrow)?.imageTintColor(color1: .foodieColor), for: .normal)
    }
}

// MARK: - Protocol
protocol FoodieItemsViewControllerDelegate: class {
    func applyFilterAction(vegOrNonVeg:String)
    func categoriesSelectionAction(id:Int)
}
//MARK: - Collectionview delegate & datasource

extension RestaurantDetailView : UICollectionViewDelegate,UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       // self.pageControl.numberOfPages = promoCodeList.count
        return cateList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
   
        let cell:CategoryListCollectionViewCell = self.categoryCollectionVw.dequeueReusableCell(withReuseIdentifier: FoodieConstant.CategoryListCollectionViewCell, for: indexPath) as! CategoryListCollectionViewCell
        cell.categoryLbl.text =  cateList[indexPath.row].store_category_name ?? "LB"
        if  isClickCell == false {
        if indexPath.row == 0 {
            firstIndexpath = indexPath  as IndexPath
            cell.isSelected = true
        }
        }
        
        if firstIndexpath == indexPath {
             cell.isSelected = true
        }
        
        cell.categoryLbl.tag = indexPath.row
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(">>>INT>>>>>>",indexPath)
       self.categoryCollectionVw.scrollToItem(at: indexPath, at: [ .centeredHorizontally], animated: true)
        delegate?.categoriesSelectionAction(id: cateList[indexPath.row].id ?? 0)
    }
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: firstIndexpath) {
                   cell.isSelected = false
            
            isClickCell = true
               }
        
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.isSelected = true
            firstIndexpath = indexPath
        }
    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
    
        
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.isSelected = false
        }
    }
    
}
extension RestaurantDetailView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width/2.5)
        let height = collectionView.frame.height
        return CGSize(width: width-15, height: height)
    }
    @objc func scrollToNextCell(){
      
        
    
        if categoryCollectionVw != nil {
            if cateList.count > 0{
                let indexPath = IndexPath(item: tempCount, section: 0)
                self.categoryCollectionVw.scrollToItem(at: indexPath, at: [ .centeredHorizontally], animated: true)
                tempCount += 1
                if tempCount == self.cateList.count {
                    tempCount = 0
                }
            }
        }
    
    }
}
