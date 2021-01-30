//
//  HomeBannerView.swift
//  GoJekUser
//
//  Created by Thiru on 27/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class HomeBannerView: UIView {
    
    //Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var restaurantLabel: UILabel!
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var errorView: UIView!
    
    @IBOutlet weak var errorImageView: UIImageView!
    var promoCodeList:[PromocodeData] = []
    weak var delegate: HomeBannerViewDelegate?
    var currentPage = 0 {
        didSet {
            self.pageControl.currentPage = currentPage
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initialLoad()
    }
}

//MARK: - Initial Loads

extension HomeBannerView {
    
    func initialLoad() {
        filterButton.isHidden = true
        self.restaurantLabel.text = FoodieConstant.TShop.localized.uppercased()
        self.restaurantLabel.textColor = .foodieColor
        self.bannerCollectionView.register(UINib(nibName: FoodieConstant.HomeBannerCollectionViewCell,bundle: nil), forCellWithReuseIdentifier: FoodieConstant.HomeBannerCollectionViewCell)
        
        self.bannerCollectionView.delegate = self
        self.bannerCollectionView.dataSource = self
        self.bannerCollectionView.backgroundColor = .veryLightGray
        let flowLayout = UPCarouselFlowLayout()
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.size.width * 0.85, height: bannerCollectionView.frame.size.height)
        flowLayout.scrollDirection = .horizontal
        flowLayout.sideItemScale = 0.8
        flowLayout.sideItemAlpha = 1.0
        flowLayout.spacingMode = .fixed(spacing: 5.0)
        flowLayout.minimumLineSpacing = 5
        self.bannerCollectionView.collectionViewLayout = flowLayout
        errorView.isHidden = true
        errorView.setRadiusWithShadow(8)
        errorImageView.image = UIImage(named: FoodieConstant.error_coupon)
        errorLabel.text = FoodieConstant.couponError.localized
        filterButton.setImage(UIImage(named: "ic_downarrow"), for: .normal)
        filterButton.setTitle(FoodieConstant.all.localized, for: .normal)
        if CommonFunction.checkisRTL() {
           filterButton.changeToRight(spacing: -10)
        }else {
        filterButton.changeToRight(spacing: 10)
        }
        filterButton.tintColor = .foodieColor
        filterButton.addTarget(self, action: #selector(ShowAction), for: .touchUpInside)
        setFont()
        localize()
        setDarkMode()
    }
    
    func setDarkMode(){
        self.backgroundColor = .backgroundColor
        self.bannerCollectionView.backgroundColor = .backgroundColor
    }
    func setFont(){
        titleLabel.font = UIFont.setCustomFont(name: .bold, size: .x16)
        restaurantLabel.font = UIFont.setCustomFont(name: .bold, size: .x16)
    }

    func localize() {
        
        titleLabel.text = FoodieConstant.TOffers.localized
    }
}


//MARK: - Collectionview delegate & datasource

extension HomeBannerView : UICollectionViewDelegate,UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.pageControl.numberOfPages = promoCodeList.count
        return promoCodeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
   
        let cell:HomeBannerCollectionViewCell = self.bannerCollectionView.dequeueReusableCell(withReuseIdentifier: FoodieConstant.HomeBannerCollectionViewCell, for: indexPath) as! HomeBannerCollectionViewCell

        cell.setPromoCodeData(data: self.promoCodeList[indexPath.item])
        
        return cell
    }   
}


//MARK: ActionSheet
extension HomeBannerView : AppActionSheetDelegate {
    
    @objc func ShowAction() {
        AppActionSheet.shared.showActionSheet(viewController: UIApplication.topViewController()!, buttonOne: FoodieConstant.nonVeg.localized, buttonTwo: FoodieConstant.veg.localized, buttonThird: FoodieConstant.all.localized)
        AppActionSheet.shared.delegate = self
    }
    
    func actionSheetDelegate(tag: Int) {
        if tag == 0 {
            filterButton.setImage(UIImage(named: "ic_downarrow"), for: .normal)
            filterButton.setTitle(FoodieConstant.nonVeg.localized, for: .normal)
            if CommonFunction.checkisRTL() {
            filterButton.changeToRight(spacing: -10)
            }else {
            filterButton.changeToRight(spacing: 10)
            }
            delegate?.applyFilterAction(vegOrNonVeg: RestaurantType.nonveg.rawValue)
        }else if tag == 1{
            filterButton.setImage(UIImage(named: "ic_downarrow"), for: .normal)
            filterButton.setTitle(FoodieConstant.veg.localized, for: .normal)

            if CommonFunction.checkisRTL() {
                filterButton.changeToRight(spacing: -10)
            }else {
                filterButton.changeToRight(spacing: 10)
            }
            delegate?.applyFilterAction(vegOrNonVeg:  RestaurantType.veg.rawValue)
        }else{
            filterButton.setImage(UIImage(named: "ic_downarrow"), for: .normal)
            filterButton.setTitle(FoodieConstant.all.localized, for: .normal)
            if CommonFunction.checkisRTL() {
                filterButton.changeToRight(spacing: -10)
            }else {
                filterButton.changeToRight(spacing: 10)
            }
            delegate?.applyFilterAction(vegOrNonVeg:  RestaurantType.all.rawValue)
        }
    }
    
}

//MARK: - UIScrollViewDelegate

extension HomeBannerView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        let currentPage = Int(ceil(x/w))
        self.currentPage = currentPage
    }
}
// MARK: - Protocol
protocol HomeBannerViewDelegate: class {
    func applyFilterAction(vegOrNonVeg:String)
}
