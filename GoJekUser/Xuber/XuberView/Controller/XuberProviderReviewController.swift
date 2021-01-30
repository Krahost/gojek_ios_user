//
//  XuberProviderReviewController.swift
//  GoJekUser
//
//  Created by on 15/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

class XuberProviderReviewController: UIViewController {
    
    @IBOutlet weak var providerTableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var outterView: UIView!
    @IBOutlet weak var providerImage: UIImageView!
    @IBOutlet weak var providerNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!

    var selectedProvider:Provider_service?
    
    var reviewList:[Review] = []
  

    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoads()
    }
    

}

//MARK:- Methods

extension XuberProviderReviewController {
    private func initialLoads() {
        self.setNavigationBar()
        self.view.backgroundColor = .veryLightGray
        nextButton.setTitle(XuberConstant.next.localized, for: .normal)
        providerTableView.register(nibName: XuberConstant.XuberProviderDetailCell)
        providerTableView.register(nibName: XuberConstant.XuberProviderReviewCell)
        self.nextButton.addTarget(self, action: #selector(tapNext), for: .touchUpInside)
        self.nextButton.backgroundColor = .xuberColor
        self.nextButton.titleLabel?.font = UIFont.setCustomFont(name: .bold, size: .x18)
        self.nextButton.setBothCorner()
       let currentPage = 1
        xuberPresenter?.getProviderReview(id: selectedProvider?.id?.toString() ?? "0",pageNo: currentPage.toString())
       setDarkMode()
    }
    
    private func setDarkMode(){
        self.view.backgroundColor = .backgroundColor
        self.outterView.backgroundColor = .boxColor
        self.providerTableView.backgroundColor = .boxColor
    }
    
    
    private func setNavigationBar() {
        self.setNavigationTitle()
        self.setLeftBarButtonWith(color: .blackColor)
        self.title = XuberConstant.review.localized
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    @objc func tapNext() {
        let vc = XuberRouter.xuberStoryboard.instantiateViewController(withIdentifier: XuberConstant.XuberConfirmBookingController) as! XuberConfirmBookingController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func tapSeeMore() {
        let vc = XuberRouter.xuberStoryboard.instantiateViewController(withIdentifier: XuberConstant.ProviderReviewDetailController) as! ProviderReviewDetailController
        vc.providerName = (selectedProvider?.first_name ?? "") + " " + (selectedProvider?.last_name ?? "")
        vc.providerId = self.selectedProvider?.id ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension XuberProviderReviewController:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else {
            if reviewList.count > 3 {
                return 3
            }else{
                return self.reviewList.count
            }
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 80
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 72
        }else{
        return  UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: section == 0 ? 0 : 80))
        headerView.backgroundColor = .clear
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: headerView.frame.width-20, height: headerView.frame.height))
        label.font = UIFont.setCustomFont(name: .medium, size: .x16)
        label.text = XuberConstant.review.localized
        let button = UIButton(frame: CGRect(origin: CGPoint(x: self.view.frame.width-210, y: 0), size: CGSize(width: 200, height: headerView.frame.height)))
        button.setTitle(XuberConstant.seeMore.localized, for: .normal)
        button.setTitleColor(.appPrimaryColor, for: .normal)
        button.titleLabel?.font = UIFont.setCustomFont(name: .medium, size: .x14)
        button.addTarget(self, action: #selector(tapSeeMore), for: .touchUpInside)
        if reviewList.count == 0 {
            label.text = XuberConstant.noReview.localized
        }
        if reviewList.count > 3 {
            headerView.addSubview(button)
        }
        headerView.addSubview(label)
        return section == 0 ? nil : headerView
    }
    
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0  {
            let cell:XuberProviderDetailCell = self.providerTableView.dequeueReusableCell(withIdentifier: XuberConstant.XuberProviderDetailCell, for: indexPath) as! XuberProviderDetailCell
            if let provider = selectedProvider {
                cell.setProviderValues(provider: provider)
            }
            return cell
        }else{
            let cell:XuberProviderReviewCell = self.providerTableView.dequeueReusableCell(withIdentifier: XuberConstant.XuberProviderReviewCell, for: indexPath) as! XuberProviderReviewCell
            cell.setValues(review: self.reviewList[indexPath.row])
            return cell
        }
    }
}

//MARK:- API

extension XuberProviderReviewController: XuberPresenterToXuberViewProtocol  {
    func getProviderReview(reviewEntity: XuberProviderReviewEntity) {
        
        for review in reviewEntity.responseData?.review ?? [] {
            if (review.user_comment ?? "").count != 0 {
                self.reviewList.append(review)
            }
        }
        self.providerTableView.reloadInMainThread()
    }
}
