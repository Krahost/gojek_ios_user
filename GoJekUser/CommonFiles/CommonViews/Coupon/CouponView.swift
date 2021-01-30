//
//  CouponView.swift
//  User
//
//  Created by CSS on 17/09/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class CouponView: UIView {
    
    @IBOutlet private weak var pageControl : UIPageControl!
    @IBOutlet private weak var collectionView : UICollectionView!
    @IBOutlet private weak var couponImage: UIImageView!
    
    var currentPage = 0 {
        didSet {
            self.pageControl.currentPage = self.currentPage
        }
    }
    private var minSpacing = 20
    var applyCouponAction : ((PromocodeData?)->Void)?
    private var datasource: [PromocodeData] = []
    private var selected: PromocodeData?
    var viewColor: UIColor = .black
    
    var isSelectPromo:Bool = false {
        didSet {
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialLoads()
    }
    
}

extension CouponView {
    
    private func initialLoads() {
       
        self.pageControl.currentPage = 0
        self.pageControl.pageIndicatorTintColor = .lightGray
        self.collectionView.register(UINib(nibName: Constant.CouponCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: Constant.CouponCollectionViewCell)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.allowsSelection = false
        setDarkMode()
    }
    
    private func setDarkMode(){
        self.backgroundColor = .backgroundColor
        self.collectionView.backgroundColor = .backgroundColor
    }
    
    // coupons list
    func set(values: [PromocodeData]) {
        
        self.datasource = values
        self.pageControl.numberOfPages = values.count
        self.collectionView.reloadData()
    }
    
    func isSelectedPromo(values:PromocodeData?) {
        self.selected = values
    }

    func setValues(color: UIColor){
        viewColor = color
        self.pageControl.currentPageIndicatorTintColor = color
        self.couponImage.image = UIImage(named: Constant.couponImage)
    }
    
}

extension CouponView : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier:  Constant.CouponCollectionViewCell, for: indexPath) as? CouponCollectionViewCell{
            collectionViewCell.addDashLine(strokeColor: .darkGray, lineWidth: 2.0)
            collectionViewCell.isSelected = self.datasource[indexPath.row].id ?? 0 == self.selected?.id
            collectionViewCell.set(values: [self.datasource[indexPath.item]])
            collectionViewCell.applyButton.setTitleColor(viewColor, for: .normal)
            collectionViewCell.onClickApply = { [weak self] (promoVal) in
                guard let self = self else {
                    return
                }
                self.selected = self.selected?.id == promoVal?.id ? nil : promoVal
                self.applyCouponAction!(promoVal)
            }
            return collectionViewCell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width-40, height: collectionView.frame.height)
    }
    
}

//MARK: - UIScrollViewDelegate

extension CouponView: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        let currentPage = Int(ceil(x/w))
        self.currentPage = currentPage
    }
}
