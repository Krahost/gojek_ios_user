//
//  OfferCouponCell.swift
//  GoJekUser
//
//  Created by Ansar on 07/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import SDWebImage

class OfferCouponCell: UITableViewCell {
    
    @IBOutlet weak var outterView: UIView!
    @IBOutlet weak var offerCouponLabel: InsetLabel!
    @IBOutlet weak var recommendedLabel: InsetLabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorImageView: UIImageView!
    
    
    var promoCodeListArr:[PromocodeData] = [] {
        didSet{
            collectionView.reloadInMainThread()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialLoads()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setCouponCellData(couponData:[PromocodeData]) {
        
        offerCouponLabel.text = HomeConstant.offerCoupons.localized
        recommendedLabel.text = HomeConstant.FeaturedServices.localized
        errorLabel.text = HomeConstant.nocoupons.localized
        promoCodeListArr = couponData
        if promoCodeListArr.count != 0 {
            promoCodeListArr = couponData
            errorView.isHidden = true
        } else {
            errorView.isHidden = false
        }
    }
    
}

extension OfferCouponCell {
    
    private func initialLoads() {
        offerCouponLabel.font = .setCustomFont(name: .bold, size: .x16)
        recommendedLabel.font = .setCustomFont(name: .bold, size: .x16)
        collectionView.backgroundColor = .clear
        collectionView?.register(UINib(nibName: HomeConstant.OffersCollectionCell, bundle: nil), forCellWithReuseIdentifier: HomeConstant.OffersCollectionCell)
        collectionView.delegate = self
        collectionView.dataSource = self
        offerCouponLabel.text = HomeConstant.offerCoupons.localized
        recommendedLabel.text = HomeConstant.FeaturedServices.localized
        
        let flowLayout = UPCarouselFlowLayout()
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.size.width * 0.75, height: collectionView.frame.size.height)
        flowLayout.scrollDirection = .horizontal
        flowLayout.sideItemScale = 0.8
        flowLayout.sideItemAlpha = 1.0
        flowLayout.spacingMode = .fixed(spacing: 5.0)
        flowLayout.minimumLineSpacing = 5
        collectionView.collectionViewLayout = flowLayout
        errorImageView.image = UIImage(named: HomeConstant.discountVoucher)
        errorLabel.text = HomeConstant.nocoupons.localized
        errorLabel.font = .setCustomFont(name: .medium, size: .x14)
        errorView.isHidden = true
        setDarkMode()
    }
    
    private func setDarkMode(){
        self.outterView.backgroundColor = .backgroundColor
        self.contentView.backgroundColor = .backgroundColor
        self.collectionView.backgroundColor = .backgroundColor
    }
    
    private func dateFormatConvertion(dateString: String) -> String {
        let baseConfig = AppConfigurationManager.shared.baseConfigModel
        let dateFormat = Int(baseConfig?.responseData?.appsetting?.date_format ?? "0")
        let dateFormatTo = dateFormat == 1 ? DateFormat.yyyy_mm_dd_hh_mm_ss : DateFormat.yyyy_mm_dd_hh_mm_ss_a
        let dateFormatReturn = dateFormat == 1 ? DateFormat.ddMMMyy24 : DateFormat.ddMMMyy12
        return AppUtils.shared.dateToString(dateStr: dateString, dateFormatTo: dateFormatTo, dateFormatReturn: dateFormatReturn)
    }
}

//MARK:- UICollectionViewDataSource

extension OfferCouponCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return promoCodeListArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeConstant.OffersCollectionCell, for: indexPath) as! OffersCollectionCell
        let promoDict = promoCodeListArr[indexPath.row]
        
        
        cell.offerImage.sd_setImage(with: URL(string: promoDict.picture ?? ""), placeholderImage:#imageLiteral(resourceName: "ImagePlaceHolder"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
            // Perform operation.
            if (error != nil) {
                // Failed to load image
                cell.offerImage.image = #imageLiteral(resourceName: "ImagePlaceHolder")
            } else {
                // Successful in loading image
                cell.offerImage.image = image
            }
        })
        cell.offerDescLabel.text = promoDict.promo_description
        cell.couponCodeLabel.text = promoDict.promo_code
        cell.offerDescLabel.textColor = UIColor.white
        return cell
    }
}

//MARK:- UICollectionViewDelegate

extension OfferCouponCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = HomeRouter.homeStoryboard.instantiateViewController(withIdentifier: HomeConstant.CouponViewController) as! CouponViewController
        vc.promo_code = promoCodeListArr[indexPath.row].promo_code ?? ""
        vc.promo_description = promoCodeListArr[indexPath.row].promo_description ?? ""
        let dateStr = promoCodeListArr[indexPath.row].expiration ?? ""
        let assignedAt = dateFormatConvertion(dateString: dateStr)
        vc.expiration = assignedAt
        UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
}

