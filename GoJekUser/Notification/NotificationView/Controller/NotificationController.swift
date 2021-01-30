//
//  NotificationController.swift
//  GoJekUser
//
//  Created by CSS01 on 22/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class NotificationController: UIViewController {
    
    @IBOutlet weak var notificationTableView:UITableView!
    
    
    var notificationData:[NotificationData] = []
    var cellHeights: [IndexPath : CGFloat] = [:]
    
    var isUpdate = false
    var currentPage = 1
    var nextUrl = ""
    
    var isAppPresentTapOnPush:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if guestLogin() {
            self.initialLoads()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if guestLogin() {
            self.title = NotificationConstant.TNotification.localized
            //Webservice call
            isUpdate = false
            currentPage = 1
            getNotification()
        }
     
       
        showTabBar()
    }
}

//MARK: Methods

extension NotificationController {
    
    private func initialLoads() {
        self.setNavigationBar()
        self.notificationTableView.register(UINib(nibName: NotificationConstant.NotificationTableViewCell, bundle: nil), forCellReuseIdentifier: NotificationConstant.NotificationTableViewCell)
        self.view.backgroundColor = .veryLightGray
        setDarkMode()
    }
    private func setDarkMode(){
        self.view.backgroundColor = .backgroundColor
    }
    
    private func setNavigationBar() {
        setNavigationTitle()
        self.title = NotificationConstant.TNotification.localized
    }
    
    private func getNotification() {
        self.notificationPresenter?.getNotification(param: [NotificationConstant.PPage:currentPage], isHideIndicator: isUpdate)
    }
    
    
}

extension NotificationController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let height = cellHeights[indexPath] else { return 170.0 }
        
        return height
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.notificationData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationConstant.NotificationTableViewCell, for: indexPath) as! NotificationTableViewCell
        cell.setValues(values: self.notificationData[indexPath.row])
        cell.showButton.addTarget(self, action: #selector(self.tapShowMoreLess(btn:)), for: .touchUpInside)
        cell.showButton.tag = indexPath.row
        cell.layoutSubviews()
        return cell
    }
    
    @objc func tapShowMoreLess(btn:UIButton) {
        let indexPath = IndexPath.init(row: btn.tag, section: 0)
        let cell = self.notificationTableView.cellForRow(at: indexPath) as! NotificationTableViewCell
        if cell.isShowMoreLess {
            cell.isShowMoreLess = false
            cell.notificationDetailLabel.numberOfLines = 3
            cell.showButton.setTitle(HomeConstant.showMore.localize(), for: .normal)
            
        }else{
            cell.isShowMoreLess = true
            cell.notificationDetailLabel.numberOfLines = 0
            cell.showButton.setTitle(HomeConstant.showLess.localize(), for: .normal)
            
        }
        notificationTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
        
        let lastCell = (self.notificationData.count) - 2
        if self.notificationData.count >= 10 {
            if indexPath.row == lastCell {
                if nextUrl != ""{
                    self.isUpdate = true
                    currentPage = currentPage + 1
                    getNotification()
                }
            }
        }
    }
    
}

extension NotificationController:  NotificationPresenterToNotificationViewProtocol {
    
    func getNotification(notificationEntity: NotificationEntity) {
        self.nextUrl = notificationEntity.responseData?.notification?.next_page_url ?? ""

        if self.isUpdate  {
            if (notificationEntity.responseData?.notification?.data?.count ?? 0) > 0
            {
                for i in 0..<(notificationEntity.responseData?.notification?.data?.count ?? 0)
                {
                    let dict = notificationEntity.responseData?.notification?.data?[i]
                    self.notificationData.append(dict!)
                }
            }
        }else{
            self.notificationData.removeAll()
            self.notificationData = notificationEntity.responseData?.notification?.data ?? []
        }
        if self.notificationData.count == 0 {
            self.notificationTableView.setBackgroundImageAndTitle(imageName: NotificationConstant.noNotification, title: NotificationConstant.notificationEmpty.localized,tintColor: .blackColor)
        }else{
            self.notificationTableView.backgroundView = nil
        }
        
        
        self.notificationTableView.reloadData()
    }
    
}

