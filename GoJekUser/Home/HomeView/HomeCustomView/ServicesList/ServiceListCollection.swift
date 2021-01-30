//
//  ServiceListCollection.swift
//  GoJekSample
//
//  Created by Ansar on 07/03/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

protocol HomeAddMoreDelegate {
    func tapShowMore(height: Double)
    func callCheckRequest(isFlowRequest: String)
}

class ServiceListCollection: UIView {
    
    //MARK: - IBOutlet
    @IBOutlet weak var serviceCollectionView: UICollectionView!
    @IBOutlet weak var outterview: UIView!
    @IBOutlet weak var showMoreButton: UIButton!
    @IBOutlet weak var noServiceAvlLabel: UILabel!
    
    //MARK: - LocalVariable
    
    var serviceMenus: [ServicesDetails]!
    var delegate: HomeAddMoreDelegate?
    var isFirstTime = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialLoads()
    }
}

//MARK: - LocalMethod

extension ServiceListCollection {
    
    private func initialLoads() {
        showMoreButton.isHidden = true
        serviceCollectionView.register(UINib(nibName: HomeConstant.ServicesListCells, bundle: nil), forCellWithReuseIdentifier: HomeConstant.ServicesListCells)
        serviceCollectionView.delegate = self
        serviceCollectionView.dataSource = self
        self.showMoreButton.backgroundColor = .gray
        self.showMoreButton.tintColor = .clear
        self.showMoreButton.textColor(color: .white)
        self.showMoreButton.addTarget(self, action: #selector(tapShowMore(_:)), for: .touchUpInside)
        self.showMoreButton.setTitle(HomeConstant.showMore.localized, for: .normal)
        self.setFont()
        setDarkMode()
    }
    
    private func setDarkMode(){
        self.backgroundColor = .backgroundColor
        self.serviceCollectionView.backgroundColor = .boxColor
        self.outterview.backgroundColor = .boxColor
    }
    
    func setServiceDataSource(services:[ServicesDetails]) {
        serviceMenus = services
        if serviceMenus.count == 0 {
            setNoServiceLabel()
            showMoreButton.isHidden = true
        } else {
            if serviceMenus.count <= 8 {
                showMoreButton.isHidden = true
            } else {
                showMoreButton.isHidden = false
            }
            noServiceAvlLabel.isHidden = true
        }
        
        DispatchQueue.main.async {
            self.serviceCollectionView.reloadData()
        }
    }
    
    func setNoServiceLabel() {
        noServiceAvlLabel.isHidden = false
        noServiceAvlLabel.textColor = .lightGray
        noServiceAvlLabel.text = HomeConstant.noServices.localized
    }
    
    func setFont() {
        noServiceAvlLabel.font = .setCustomFont(name: .bold, size: .x16)
        showMoreButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x12)
    }
    
    func setViewHeightBasedOnContent(contentCount:Int,isExpanding:Bool) {
        
        let doubleval: Double = Double(contentCount)/4.0
        let roundedDouble = doubleval.rounded(.up)
        let cell = serviceCollectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as! ServicesListCell
        var viewHeight:Double = 0.0
        var cellHeight = cell.frame.size.height + cell.frame.size.width * 0.17
        if UIScreen.main.bounds.size.height <= 568.0 {
            cellHeight = cell.frame.size.height + cell.frame.size.width * 0.20
        }
        if isExpanding {
            if roundedDouble <= 4 { //>= 4
                viewHeight = Double(cellHeight) * 4.2   // 4.2
            } else {
                viewHeight = roundedDouble  * Double(cellHeight)
            }
        } else {
            viewHeight =  Double(cellHeight)  * 2.23
        }
        delegate?.tapShowMore(height: viewHeight)
        serviceCollectionView.reloadData()
    }
}

//MARK: - IBAction

extension ServiceListCollection {
    
    @objc func tapShowMore(_ sender: UIButton) {
        sender.backgroundColor = .gray
        sender.tintColor = .clear
        sender.textColor(color: .white)
        sender.isSelected = !sender.isSelected
        
        DispatchQueue.main.async {
            let btnTitle = sender.isSelected ? HomeConstant.showLess.localized : HomeConstant.showMore.localized
            self.showMoreButton.setTitle(btnTitle, for: .normal)
            self.setViewHeightBasedOnContent(contentCount: self.serviceMenus.count, isExpanding: sender.isSelected)
        }
    }
}

//MARK: - UICollectionViewDataSource

extension ServiceListCollection: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let data = serviceMenus else { return 0 }
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeConstant.ServicesListCells, for: indexPath) as? ServicesListCell,indexPath.row < serviceMenus.count  {
            cell.serviceCellDetails(details: serviceMenus[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
}

//MARK: - UICollectionViewDelegate

extension ServiceListCollection: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedService = serviceMenus[indexPath.row]
        AppManager.shared.setSelectedServices(service: selectedService)
        
        switch selectedService.service?.admin_service_name ?? "" {
        case MasterServices.Transport.rawValue:
            let vc = TaxiRouter.createTaxiModule(rideTypeId: self.serviceMenus[indexPath.row].menu_type_id ?? 0)
            UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
        case MasterServices.Order.rawValue:
            delegate?.callCheckRequest(isFlowRequest: Flow.foodie)
        case MasterServices.Service.rawValue:
            delegate?.callCheckRequest(isFlowRequest: Flow.service)
        case MasterServices.Delivery.rawValue:
          delegate?.callCheckRequest(isFlowRequest: Flow.courier)

        default:
            break
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ServiceListCollection: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let nbCol = 4
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left + flowLayout.sectionInset.right + (flowLayout.minimumInteritemSpacing * CGFloat(nbCol - 1))
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(nbCol))
        var height:Double = 0.0
        if serviceMenus.count <= 4 {
            height = Double(size + 3)
        }else {
            height = Double(2 * size)
        }
        if isFirstTime {
            DispatchQueue.main.async {
                self.delegate?.tapShowMore(height: height+55.0)
                self.serviceCollectionView.reloadData()
            }
            isFirstTime = false
        }
        return CGSize(width: size, height: size)
    }
}
