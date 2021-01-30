//
//  ProviderReviewDetailController.swift
//  GoJekUser
//
//  Created by Ansar on 23/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class ProviderReviewDetailController: UIViewController {
    
    @IBOutlet weak var reviewTableView:  UITableView!
    
    var providerId:Int = 0
    
    var reviewList:[Review] = []
    
    var providerName: String = ""
    
   var currentPage = 1
    
    var isUpdate = false
    
    var totalRecord = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoads()
    }
    
}

extension ProviderReviewDetailController  {
    
    private func initialLoads() {
        self.setNavigationBar()
        self.view.backgroundColor = .veryLightGray
        reviewTableView.register(nibName: XuberConstant.XuberProviderReviewCell)
        currentPage = 1
        getReview()
        setDarkMode()
    }
    
    private func setDarkMode(){
        self.view.backgroundColor = .backgroundColor
        self.reviewTableView.backgroundColor = .boxColor
    }
    
    private func setNavigationBar() {
        self.setNavigationTitle()
        self.setLeftBarButtonWith(color: .blackColor)
        self.title = providerName + XuberConstant.sReview.localized
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func getReview() {
        
        xuberPresenter?.getProviderReview(id: providerId.toString(), pageNo: currentPage.toString())
    }
}

//MARK: - Tableview Delegate Datasource

extension ProviderReviewDetailController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: XuberProviderReviewCell = reviewTableView.dequeueReusableCell(withIdentifier: XuberConstant.XuberProviderReviewCell, for: indexPath) as! XuberProviderReviewCell
        cell.setValues(review: self.reviewList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if self.reviewList.count > 10 {
            let lastCell  = (self.reviewList.count) - 3
            if indexPath.row == lastCell {
                if currentPage <= totalRecord {
                    self.isUpdate = true
                    currentPage = currentPage + 1
                    self.getReview()
                }
            }
        }
    }
}

//MARK:- API

extension ProviderReviewDetailController: XuberPresenterToXuberViewProtocol  {
    
    func getProviderReview(reviewEntity: XuberProviderReviewEntity) {
         if self.isUpdate  {
            if reviewEntity.responseData?.review?.count ?? 0 > 0 {
                for i in 0..<(reviewEntity.responseData?.review?.count ?? 0) {
                    if let dict = reviewEntity.responseData?.review?[i] {
                        if (dict.provider_comment ?? "").count != 0 {
                            self.reviewList.append(dict)
                        }
                    }
                }
            }
         } else {

            self.reviewList = reviewEntity.responseData?.review ?? []
        }
        totalRecord = reviewEntity.responseData?.total_records ?? 0
        self.reviewTableView.reloadInMainThread()
    }
}
