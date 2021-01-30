//
//  XSubServiceController.swift
//  GoJekUser
//
//  Created by Ansar on 06/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

class XuberSubServiceController: UIViewController {
    
    @IBOutlet weak var subServiceTableView: UITableView!
    @IBOutlet weak var scheduleButton: UIButton!
    @IBOutlet weak var bookNowButton: UIButton!
    
    @IBOutlet weak var scheduleShowView: UIView!
    @IBOutlet weak var scheduleDeleteView: UIView!
    @IBOutlet weak var scheduleEditView: UIView!
    @IBOutlet weak var scheduleTimeLabel: UILabel!
    
    var scheduleView: XuberScheduleView?
    var selectedServiceId:Int = 0
    
    var subCategoryList:[XuberServiceList] = [] {
        didSet {
            subServiceTableView.reloadInMainThread()
        }
    }
    
    var selectedServiceCategory:String = "" {
        didSet {
            self.title = selectedServiceCategory
        }
    }
    
    var selectedRow:Int = -1 {
        didSet {
            self.subServiceTableView.reloadInMainThread()
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoads()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
}

//MARK: - Methods
extension XuberSubServiceController {
    private func initialLoads() {
        setNavigationBar()

        scheduleButton.backgroundColor = .xuberColor
        scheduleButton.setTitle(XuberConstant.schedule.localized, for: .normal)
        self.scheduleButton.addTarget(self, action: #selector(tapSchedule), for: .touchUpInside)
        bookNowButton.backgroundColor = .xuberColor
        bookNowButton.setTitle(XuberConstant.bookNow.localized, for: .normal)
        self.bookNowButton.addTarget(self, action: #selector(tapBookNow), for: .touchUpInside)
        self.view.backgroundColor = .veryLightGray
        self.subServiceTableView.register(nibName: XuberConstant.XuberSubSerivceListCell)
        setFont()
        self.selectedRow = -1
        SendRequestInput.shared.subserviceId = selectedServiceId
        
        let editGesture = UITapGestureRecognizer(target: self, action: #selector(tapScheduleEditDelete(_:)))
        let deleteGesture = UITapGestureRecognizer(target: self, action: #selector(tapScheduleEditDelete(_:)))
        self.scheduleEditView.addGestureRecognizer(editGesture)
        self.scheduleDeleteView.addGestureRecognizer(deleteGesture)
        self.scheduleEditView.backgroundColor = .veryLightGray
        self.scheduleDeleteView.backgroundColor = .veryLightGray
        self.scheduleShowView.isHidden = true
        if let imageView = self.scheduleEditView.subviews.first as? UIImageView{
            imageView.image =  UIImage(named: Constant.editImage)
            imageView.imageTintColor(color1: .xuberColor)
        }
        if let imageView = self.scheduleDeleteView.subviews.first as? UIImageView{
            imageView.image =  UIImage(named: Constant.deleteImage)
            imageView.imageTintColor(color1: .xuberColor)
        }
        
        let param: Parameters = [LoginConstant.city_id: guestAccountCity]
        xuberPresenter?.getServiceList(id: selectedServiceId.toString(), mainId: SendRequestInput.shared.mainServiceId?.toString() ?? "0", param: param)
        setDarkMode()
    }
    
    private func setDarkMode(){
            self.view.backgroundColor = .backgroundColor
           self.subServiceTableView.backgroundColor = .backgroundColor
           self.scheduleShowView.backgroundColor = .boxColor
        }
    
    private func setNavigationBar() {
        self.setNavigationTitle()
        self.setLeftBarButtonWith(color: .blackColor)
        self.title = selectedServiceCategory
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    private func setFont() {
        scheduleTimeLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        scheduleButton.titleLabel?.font = UIFont.setCustomFont(name: .medium, size: .x18)
        bookNowButton.titleLabel?.font = UIFont.setCustomFont(name: .medium, size: .x18)
    }
    
    private func showScheduleView() {
        if self.scheduleView == nil, let scheduleView = Bundle.main.loadNibNamed(XuberConstant.XuberScheduleView, owner: self, options: [:])?.first as? XuberScheduleView {
            let viewHieght = (self.view.frame.height/100)*25
            scheduleView.frame = CGRect(origin: CGPoint(x: 10, y: (self.view.frame.height/2)-(viewHieght/2)), size: CGSize(width: self.view.frame.width-20, height: viewHieght))
            self.scheduleView = scheduleView
            self.showDimView(view: scheduleView)
            self.scheduleView?.selectedDate = SendRequestInput.shared.scheduleDate ?? ""
            scheduleView.show(with: .bottom, completion: nil)
        }
        self.scheduleView?.onClickScheduleNow = { [weak self] (selectedDate,selectedTime) in
            guard let self = self else {
                return
            }
            SendRequestInput.shared.scheduleTime = selectedTime
            SendRequestInput.shared.scheduleDate = selectedDate
            SendRequestInput.shared.isSchedule = true
            self.scheduleTimeLabel.text = XuberConstant.scheduleOn.localized + selectedDate.giveSpace + selectedTime
            self.scheduleShowView.isHidden = false
            self.scheduleButton.isHidden = true
            self.scheduleView?.superview?.dismissView(onCompletion: {
                self.scheduleView = nil
            })
        }
    }
    
    @objc func tapBookNow() {
        guard selectedRow > -1 else {
            ToastManager.show(title: XuberConstant.chooseSubservice.localized, state: .error)
            return
        }
        if (SendRequestInput.shared.isAllowQuantity ?? false) && SendRequestInput.shared.quantity == nil {
            ToastManager.show(title: XuberConstant.qtyEmpty.localized, state: .error)
        }
        let vc = XuberRouter.xuberStoryboard.instantiateViewController(withIdentifier: XuberConstant.XuberLocationSelectionController) as! XuberLocationSelectionController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func tapSchedule() {
        showScheduleView()
    }
    
    private func showDimView(view: UIView) {
        let dimView = UIView(frame: self.view.frame)
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        dimView.addSubview(view)
        self.view.addSubview(dimView)
    }
    
    @objc func tapScheduleEditDelete(_ sender: UITapGestureRecognizer) {
        if sender.view?.tag == 1 { //edit Schedule
            showScheduleView()
        }else { //delete schedule
            self.scheduleShowView.isHidden = true
            self.scheduleButton.isHidden = false
            SendRequestInput.shared.scheduleDate = ""
            SendRequestInput.shared.scheduleTime = ""
            SendRequestInput.shared.isSchedule = false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first?.view?.tag != 999  {
            if self.scheduleView != nil  {
                self.scheduleView?.superview?.dismissView(onCompletion: {
                    self.scheduleView = nil
                })
            }
        }
    }
}

//MARK:- UITableViewDelegate

extension XuberSubServiceController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedRow = self.selectedRow == indexPath.row ? -1 : indexPath.row // if select same row means to unselect
        SendRequestInput.shared.allowImage = self.subCategoryList[indexPath.row].allow_desc == 1
        if let qty = self.subCategoryList[indexPath.row].service_city?.allow_quantity {
            SendRequestInput.shared.isAllowQuantity = qty == 1
        }
        SendRequestInput.shared.quantity = 1
        SendRequestInput.shared.serviceId = self.subCategoryList[indexPath.row].id

    }
}

//MARK:- PlusMinusDeUITableViewDataSourcelegates

extension XuberSubServiceController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.subCategoryList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:XuberSubSerivceListCell = self.subServiceTableView.dequeueReusableCell(withIdentifier: XuberConstant.XuberSubSerivceListCell, for: indexPath) as! XuberSubSerivceListCell
        
        let subCategory = self.subCategoryList[indexPath.row]
        cell.subServiceLabel.text = subCategory.service_name
        if let qty = subCategory.service_city?.allow_quantity,qty == 1 {
            let count = cell.plusMinusView.count
            cell.plusMinusView.count = count == 0 ? 1 : count //if count zero show as one
            let maxQty = subCategory.service_city?.max_quantity
            print(count)
            cell.plusMinusView.isDisable = count >= maxQty ?? 0
        }else{
            cell.plusMinusView.isHidden = true
        }
        cell.plusMinusView.currentType = .Service
        cell.plusMinusView.delegate = self
        cell.plusMinusView.tag = indexPath.row
        cell.isImageSelected = self.selectedRow == indexPath.row
        return cell
    }
}

//MARK:- PlusMinusDelegates

extension XuberSubServiceController: PlusMinusDelegates {
    func countChange(count: Int, tag: Int, isplus: Bool) {
        if count < 0 {
            return
        }
        SendRequestInput.shared.quantity = count
        self.selectedRow = tag
        SendRequestInput.shared.allowImage = self.subCategoryList[tag].allow_desc == 1
        if let qty = self.subCategoryList[tag].service_city?.allow_quantity {
            SendRequestInput.shared.isAllowQuantity = qty == 1
        }
        SendRequestInput.shared.serviceId = self.subCategoryList[tag].id
        self.subServiceTableView.reloadData()
    }
}

//MARK:- XuberPresenterToXuberViewProtocol

extension XuberSubServiceController: XuberPresenterToXuberViewProtocol {

    func getServiceList(serviceEntity: XuberServiceEntity) {
         let categoryList = serviceEntity.responseData ?? []
        for i in 0..<categoryList.count {
            let servicedict = categoryList[i]
            if servicedict.service_city != nil {
                self.subCategoryList.append(servicedict)
            }
        }
    }
}
