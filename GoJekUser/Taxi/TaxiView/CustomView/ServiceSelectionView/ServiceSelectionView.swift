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

class ServiceSelectionView: UIView {
    
    @IBOutlet weak var serviceCollectionView: UICollectionView!
    @IBOutlet weak var serviceTitleLabel: UILabel!
    @IBOutlet weak var cardOrCashLabel:UILabel!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var getPricingButton: UIButton!
    @IBOutlet weak var paymentImage:UIImageView!
    @IBOutlet weak var dottedLineView:UIView!
    
    var paymentMode:PaymentType = .CASH {
        didSet {
            paymentImage.image = paymentMode.image
            cardOrCashLabel.text = paymentMode.rawValue
        }
    }
    
    private var selectedRow = -1
    
    var serviceTypeArr = [TaxiConstant.hatchBag,TaxiConstant.sedan,TaxiConstant.suv]
    
    var tapService:((Services)->Void)?
    var tapGetPricing:((Services)->Void)?
    
    var serviceDetails:[Services] = [] {
        didSet{
            serviceCollectionView.reloadInMainThread()
        }
    }
    
    // clouser for payment
    var paymentChangeClick: ((PaymentType,CardResponseData)-> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialLoads()
    }
}

//MARK: - Methods

extension ServiceSelectionView {
    
    private func initialLoads() {
        setColorAndBorder()
        setFont()
        serviceCollectionView.delegate = self
        serviceCollectionView.dataSource = self
        serviceCollectionView.register(UINib(nibName: TaxiConstant.ServiceTypeCell,bundle: nil), forCellWithReuseIdentifier: TaxiConstant.ServiceTypeCell)
        getPricingButton.addTarget(self, action: #selector(onClickGetPricing), for: .touchUpInside)
        changeButton.addTarget(self, action: #selector(changePaymentButtonTapped), for: .touchUpInside)
        paymentMode = .CASH
        localize()
        setDarkMode()
    }
    
    private func setDarkMode(){
        self.backgroundColor = .boxColor
        self.serviceCollectionView.backgroundColor = .boxColor
    }
    
    private func localize() {
        serviceTitleLabel.text = TaxiConstant.dailyRide.localized
        changeButton.setTitle(Constant.change.localized.uppercased(), for: .normal)
        getPricingButton.setTitle(TaxiConstant.getPricing.localized.uppercased().uppercased(), for: .normal)
    }
    
    private func setFont() {
        changeButton.titleLabel?.font = .setCustomFont(name: .bold, size: .x12)
        cardOrCashLabel.font = .setCustomFont(name: .medium, size: .x12)
        getPricingButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x18)
        serviceTitleLabel.font = .setCustomFont(name: .medium, size: .x20)
    }
    
    private func setColorAndBorder() {
        serviceTitleLabel.textColor = .taxiColor
        getPricingButton.backgroundColor = .taxiColor
        changeButton.backgroundColor = UIColor.taxiColor.withAlphaComponent(0.2)
        changeButton.layer.borderColor = UIColor.taxiColor.cgColor
        changeButton.textColor(color: .taxiColor)
        changeButton.borderColor = .taxiColor
        changeButton.borderLineWidth = 1.0
        changeButton.cornerRadius = 5.0
        getPricingButton.cornerRadius = 5.0
    }
    
    override func layoutSubviews() {
        dottedLineView.addSingleLineDash(color: .black, width: 0.8)
        
    }
    
    
    @objc func onClickGetPricing() {
        guard selectedRow > -1 else {
            ToastManager.show(title: TaxiConstant.selectServiceType.localized, state: .error)
            return
        }
        tapGetPricing?(serviceDetails[selectedRow])
    }
    
    // change payment before sending request
    @objc func changePaymentButtonTapped() {
        
        let paymentVC = AccountRouter.accountStoryboard.instantiateViewController(withIdentifier: AccountConstant.PaymentSelectViewController) as! PaymentSelectViewController
        paymentVC.isChangePayment = true
        paymentVC.onClickPayment = { [weak self] (type,cardEntity) in
            guard let self = self else {
                return
            }
            self.paymentMode = type
            if type == .CARD {
                self.cardOrCashLabel.text = Constant.cardPrefix + (cardEntity?.last_four ?? "")
            }else{
                self.cardOrCashLabel.text = type.rawValue
            }
            self.paymentChangeClick?(type,cardEntity ?? CardResponseData())
            //            showServiceSelectionView()
        }
        UIApplication.topViewController()?.navigationController?.pushViewController(paymentVC, animated: true)
    }

}

//MARK: - Collectionview delegate & datasource
extension ServiceSelectionView: UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return serviceDetails.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell:ServiceTypeCell = serviceCollectionView.dequeueReusableCell(withReuseIdentifier: TaxiConstant.ServiceTypeCell, for: indexPath) as? ServiceTypeCell,indexPath.row <= serviceDetails.count {
            cell.isCurrentService = selectedRow == indexPath.row ? true : false
            cell.serviceNameLabel.text = serviceDetails[indexPath.row].vehicle_name
          
            
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
            //cell.etaLabel.text = "\(indexPath.row+1) "+TaxiConstant.mins
            cell.etaLabel.text = serviceDetails[indexPath.row].estimated_time
            cell.isCurrentService = selectedRow == indexPath.row
            return cell
        }
        return UICollectionViewCell()
    }
}

extension ServiceSelectionView:UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell:ServiceTypeCell = serviceCollectionView.cellForItem(at: indexPath) as? ServiceTypeCell, indexPath.row < serviceDetails.count {
            cell.isCurrentService = false
            
            if selectedRow == indexPath.row {
                tapService?(serviceDetails[selectedRow]) //Double tap service and get rate card
            }
            selectedRow = indexPath.row
            serviceCollectionView.reloadInMainThread()
        }
    }
}

extension ServiceSelectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width/3)
        let height = collectionView.frame.height
        return CGSize(width: width, height: height)
    }
}
extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
