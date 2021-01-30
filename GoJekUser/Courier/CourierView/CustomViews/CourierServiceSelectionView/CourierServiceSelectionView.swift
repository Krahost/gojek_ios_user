//
//  SeviceSelectionView.swift
//  GoJekUser
//
//  Created by Ansar on 26/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class CourierServiceSelectionView: UIView {
    
    @IBOutlet weak var serviceCollectionView: UICollectionView!
    @IBOutlet weak var getPricingButton: UIButton!

    @IBOutlet weak var nextBtn: UIButton!
    private var selectedRow = -1
    
    var serviceTypeArr = [TaxiConstant.hatchBag,TaxiConstant.sedan,TaxiConstant.suv]
    
//var paymentMode:PaymentType = .CASH {
//    didSet {
//        paymentImage.image = paymentMode.image
//        cardOrCashLabel.text = paymentMode.rawValue
//    }
//}
//
//private var selectedRow = -1
//
//var serviceTypeArr = [TaxiConstant.hatchBag,TaxiConstant.sedan,TaxiConstant.suv]
//
var tapService:((Services)->Void)?
//var tapNextBtn: ->Void)?

var serviceDetails:[Services] = [] {
    didSet{
        serviceCollectionView.reloadInMainThread()
    }
}

// clouser for payment
var paymentChangeClick: ((PaymentType,CardResponseData)-> Void)?


    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialLoads()
    }
}

//MARK: - Methods

extension CourierServiceSelectionView {
    
    private func initialLoads() {
        setColorAndBorder()
        setFont()
        localize()
        serviceCollectionView.delegate = self
        serviceCollectionView.dataSource = self
        serviceCollectionView.register(UINib(nibName: CourierConstant.CourierServiceTypeCell,bundle: nil), forCellWithReuseIdentifier: CourierConstant.CourierServiceTypeCell)
       // getPricingButton.addTarget(self, action: #selector(onClickGetPricing), for: .touchUpInside)
       setDarkMode()
    }
    
    func setDarkMode(){
        self.backgroundColor = .backgroundColor
        self.serviceCollectionView.backgroundColor = .backgroundColor

    }
    
    private func localize() {
   
        nextBtn.setTitle(CourierConstant.next.localized.uppercased(), for: .normal)
    }
    
    private func setFont() {

        nextBtn.titleLabel?.font = .setCustomFont(name: .medium, size: .x18)
    
    }
    
    private func setColorAndBorder() {
 
        nextBtn.backgroundColor = .courierColor
        nextBtn.cornerRadius = 5.0
        nextBtn.setTitleColor(.white, for: .normal)
    }
}

//MARK: - Collectionview delegate & datasource
extension CourierServiceSelectionView: UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return serviceDetails.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell:CourierServiceTypeCell = serviceCollectionView.dequeueReusableCell(withReuseIdentifier: CourierConstant.CourierServiceTypeCell, for: indexPath) as? CourierServiceTypeCell,indexPath.row <= serviceTypeArr.count {
           
         // cell.serviceImage.image = #imageLiteral(resourceName: "ImagePlaceHolder")
            
            cell.serviceNameLbl.text = serviceDetails[indexPath.row].vehicle_name
            cell.estimationtimeLbl.text = serviceDetails[indexPath.row].estimated_time
            cell.serviceImage.sd_setImage(with:  URL(string: self.serviceDetails[indexPath.row].vehicle_image ?? ""), placeholderImage:#imageLiteral(resourceName: "ImagePlaceHolder"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                 // Perform operation.
                    if (error != nil) {
                        // Failed to load image
                        cell.serviceImage.image = #imageLiteral(resourceName: "ImagePlaceHolder")
                    } else {
                        // Successful in loading image
                        cell.serviceImage.image = image
                    }
                })
             cell.serviceImage.makeRounded()
             cell.isCurrentService = selectedRow == indexPath.row
            
            return cell
        }
        return UICollectionViewCell()
    }
}

extension CourierServiceSelectionView:UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < serviceDetails.count {
            tapService?(serviceDetails[indexPath.row]) //Double tap service and get rate card
            selectedRow = indexPath.row
            serviceCollectionView.reloadInMainThread()
        }
        
        
    }
}

extension CourierServiceSelectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width/3)
        let height = collectionView.frame.height
        return CGSize(width: width, height: height)
    }
}
