//
//  ManageAddressController.swift
//  GoJekUser
//
//  Created by Ansar on 25/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

protocol ManageAddressDelegate {
    func selectedAddress(address: AddressResponseData)
    func addressValue(addressArr: [AddressResponseData])
    
}

class ManageAddressController: UIViewController {
    
    @IBOutlet weak var addressTableView: UITableView!
    @IBOutlet weak var addNewAddressButton: UIButton!
    
    var addressDatasource: [AddressResponseData] = Array()
    var addressTypeArray: [String] = Array()
    var delegate: ManageAddressDelegate?
    
    var isFromCartView: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialLoads()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.hideTabBar()
        self.accountPresenter?.getSavedAddress()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.addNewAddressButton.setBothCorner()
    }
}

//MARK: - Methods

extension ManageAddressController {
    
    private func initialLoads() {
        self.view.backgroundColor = .veryLightGray
        self.addNewAddressButton.backgroundColor = .appPrimaryColor
        self.addNewAddressButton.setTitleColor(.white, for: .normal)
        self.addNewAddressButton.titleLabel?.font = UIFont.setCustomFont(name: .medium, size: .x18)
        self.addressTableView.register(UINib(nibName: AccountConstant.SavedAddressCell, bundle: nil), forCellReuseIdentifier: AccountConstant.SavedAddressCell)
        
        self.addNewAddressButton.addTarget(self, action: #selector(tapAddAddress), for: .touchUpInside)
        self.setLocalize()
        self.setNavigationBar()
        setDarkMode()
    }
    
    private func setDarkMode(){
              self.view.backgroundColor = .backgroundColor
             self.addressTableView.backgroundColor = .backgroundColor
          }
        
    @objc override func leftBarButtonAction() {
        delegate?.addressValue(addressArr: self.addressDatasource)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    private func setLocalize(){
        self.addNewAddressButton.setTitle(AccountConstant.addNewAddress.localized, for: .normal)
        self.title = AccountConstant.manageAddress.localized
    }
    
    private func setNavigationBar() {
        setNavigationTitle()
        setLeftBarButtonWith(color: .blackColor)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    @objc func tapAddAddress(_ sender: UIButton) {
        if guestLogin() {

        let vc = AccountRouter.accountStoryboard.instantiateViewController(withIdentifier: AccountConstant.AddAddressController) as! AddAddressController
        vc.addressTypeArray = addressTypeArray
        self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func tapEditAddress(_ sender: UIButton) {
        let vc = AccountRouter.accountStoryboard.instantiateViewController(withIdentifier: AccountConstant.AddAddressController) as! AddAddressController
        let currentAddress = self.addressDatasource[sender.tag]
        vc.address =  currentAddress
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func tapDeleteAddress(_ sender: UIButton) {
        AppAlert.shared.simpleAlert(view: self, title: AccountConstant.deleteMsg.localized, message: String.empty, buttonOneTitle: Constant.SYes.localized, buttonTwoTitle: Constant.SNo.localized)
        AppAlert.shared.onTapAction = { [weak self] tag in
            guard let self = self else {
                return
            }
            if tag == 0 {
                self.accountPresenter?.deleteAddress(id: self.addressDatasource[sender.tag].id?.toString() ?? "0")
            }
        }
    }
}

//MARK: - Table view Delegate and Datasource

extension ManageAddressController:UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if addressDatasource.count == 0  {
            self.addressTableView.setBackgroundTitle(title: Constant.noSavedAddress.localized)
        }else{
            self.addressTableView.backgroundView = nil
        }
        return addressDatasource.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRect(x: 16, y: 10, width: self.addressTableView.frame.width, height: addressDatasource.count > 0 ? 40 : 0))
        label.font = UIFont.setCustomFont(name: .bold, size: .x18)
        label.backgroundColor = .clear
        label.text = addressDatasource.count > 0 ? AccountConstant.savedLocation.localized : String.empty
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:SavedAddressCell = self.addressTableView.dequeueReusableCell(withIdentifier: AccountConstant.SavedAddressCell, for: indexPath) as! SavedAddressCell
        let currentAddress = self.addressDatasource[indexPath.row]
        cell.setCellValues(values: currentAddress)
        cell.deleteButton.tag = indexPath.row
        cell.editButton.tag = indexPath.row
        cell.editButton.addTarget(self, action: #selector(tapEditAddress(_:)), for: .touchUpInside)
        cell.deleteButton.addTarget(self, action: #selector(tapDeleteAddress(_:)), for: .touchUpInside)
        
        return cell
    }
}

//MARK: - AccountPresenterToAccountViewProtocol

extension ManageAddressController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentAddress = self.addressDatasource[indexPath.row]
        delegate?.selectedAddress(address: currentAddress)
        if isFromCartView {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

//MARK: - AccountPresenterToAccountViewProtocol

extension ManageAddressController: AccountPresenterToAccountViewProtocol {
    
    func savedAddressSuccess(addressEntity: SavedAddressEntity) {
        addressDatasource = addressEntity.responseData ?? []
        addressTypeArray.removeAll()
        for addressTypeDic in addressDatasource {
            if let addressType = addressTypeDic.address_type, addressType.uppercased() == AddressType.Other.rawValue {
                if let addressTitle = addressTypeDic.title {
                    addressTypeArray.append(addressTitle.uppercased())
                }
                else {
                    addressTypeArray.append(addressType.uppercased())
                }
            }
        }
        self.addressTableView.reloadInMainThread()
    }
    
    func deleteAddressSuccess(addressEntity: SuccessEntity) {
        ToastManager.show(title: addressEntity.message ?? "", state: .success)
        self.accountPresenter?.getSavedAddress()
    }
}
