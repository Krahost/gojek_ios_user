//
//  PaymentController.swift
//  GoJekUser
//
//  Created by Ansar on 08/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

class PaymentController: UIViewController {
    
    @IBOutlet weak var walletButton: UIButton!
    @IBOutlet weak var transactionButton: UIButton!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var underLineView: UIView!
    @IBOutlet weak var topView: UIView!
    
    var paymentView: PaymentView?
    
    var transactionTableView = UITableView()
    
    var isWalletSelect: Bool = false {
        didSet {
            UIUpdates()
        }
    }
    
    var transactionList:[TransactionList] = []
    var isUpdate = false
    var offset = 0
    var totalValues = "10"
    var totalRecord = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        
        self.accountPresenter?.fetchUserProfileDetails()
        self.hideTabBar()
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.transactionTableView.tableHeaderView?.frame.size.height = self.transactionList.count == 0 ? -40 : self.view.frame.size.width * 0.15
    }
}

//MARK:- Methods

extension PaymentController {
    
    func initialLoad() {
        self.setNavigationBar()
        self.setLeftBarButtonWith(color: .blackColor)
        self.walletButton.titleLabel?.font = UIFont.setCustomFont(name: .medium, size: .x18)
        self.transactionButton.titleLabel?.font = UIFont.setCustomFont(name: .medium, size: .x18)
        self.walletButton.addTarget(self, action: #selector(tapWallet), for: .touchUpInside)
        self.transactionButton.addTarget(self, action: #selector(tapTransaction), for: .touchUpInside)
        self.topView.addSubview(underLineView)
        self.walletButton.setTitle(AccountConstant.wallet.localized, for: .normal)
        self.transactionButton.setTitle(AccountConstant.transaction.localized, for: .normal)
        self.addPaymentView()
        self.isWalletSelect = true
        self.transactionTableView.register(nibName: AccountConstant.TransactionTableCell)
        setHeaderTableBackground()
        addTransactionView()
        transactionTableView.separatorStyle = .none
        transactionTableView.backgroundColor = .clear
        transactionTableView.showsVerticalScrollIndicator = false
        
        //Get card status
        self.accountPresenter?.postAppsettings(param: [LoginConstant.salt_key: APPConstant.salt_key])
        setDarkMode()
    }
    
    
    private func setDarkMode(){
        self.view.backgroundColor = .backgroundColor
        self.contentView.backgroundColor = .backgroundColor
        self.paymentView?.backgroundColor = .backgroundColor
    }
    
    private func setNavigationBar() {
        setNavigationTitle()
        self.title = AccountConstant.wallet.localized
        let rightBarButton = UIBarButtonItem.init(image: UIImage(named: AccountConstant.ic_qrcode)?.resizeImage(newWidth: 25), style: .plain, target: self, action: #selector(rightBarButtonAction))
        navigationItem.rightBarButtonItem = rightBarButton
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    @objc func rightBarButtonAction() {
        if guestLogin() {
            AppActionSheet.shared.showActionSheet(viewController: self,message: AccountConstant.qrCOde.localized, buttonOne: AccountConstant.qrreceiveAmount.localized, buttonTwo: AccountConstant.qrsendAmount.localized,buttonThird: nil)
            AppActionSheet.shared.onTapAction = { [weak self] tag in
                guard let self = self else {
                    return
                }
                if tag == 0 {
                    let myQRCodeViewController = AccountRouter.accountStoryboard.instantiateViewController(withIdentifier: AccountConstant.myQRCodeViewController) as! MyQRCodeViewController
                    self.navigationController?.pushViewController(myQRCodeViewController, animated: true)
                }else if tag == 1 {
                    let scanQRCodeViewController = AccountRouter.accountStoryboard.instantiateViewController(withIdentifier: AccountConstant.scanQRCodeViewController) as! ScanQRCodeViewController
                    self.navigationController?.pushViewController(scanQRCodeViewController, animated: true)
                }
            }
        }
    }
    
    private func setHeaderTableBackground() {
        if let headerView = Bundle.main.loadNibNamed(AccountConstant.TransactionHeaderView, owner: self, options: [:])?.first as? TransactionHeaderView {
            self.transactionTableView.tableHeaderView = transactionList.count == 0 ? UIView() : headerView
            transactionTableView.tableHeaderView?.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
            
        }
        if transactionList.count == 0 {
            transactionTableView.tableHeaderView = nil
            self.transactionTableView.setBackgroundImageTitleWithoutTint(imageName: Constant.ic_empty_card, title: AccountConstant.noTransaction.localized)
        }
        else{
            self.transactionTableView.backgroundView = nil
        }
        
    }
    
    @objc func tapWallet() {
        isWalletSelect = true
    }
    
    @objc func tapTransaction() {
        self.view.endEditing()
        isWalletSelect = false
        accountPresenter?.getTransactionList(offet: offset, limit: totalValues, ishideLoader: true)
        
    }
    
    @objc func addAmountButtonTapped() {
        
        if guestLogin() {
        
        let cashTxt = paymentView?.cashTextField.text
        
        guard let cashStr = cashTxt, !cashStr.isEmpty else {
            paymentView?.cashTextField.becomeFirstResponder()
            ToastManager.show(title: AccountConstant.cardEmptyField, state: .error)
            return
        }
        
        if Int(cashTxt!) == 0 {
            paymentView?.cashTextField.becomeFirstResponder()
            ToastManager.show(title: AccountConstant.validAmount, state: .error)
            return
        }
        
        let paymentSelectViewController = self.storyboard?.instantiateViewController(withIdentifier: AccountConstant.PaymentSelectViewController) as! PaymentSelectViewController
        paymentSelectViewController.walletAmount = cashTxt!
        paymentSelectViewController.isFromAddAmountWallet = true
        self.navigationController?.pushViewController(paymentSelectViewController, animated: true)
        }
    }
    
    private func UIUpdates() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, animations: {
                self.underLineView.frame = CGRect(x: self.isWalletSelect ? self.walletButton.frame.origin.x : self.transactionButton.frame.origin.x, y: self.underLineView.frame.origin.y, width: self.walletButton.frame.width, height: 2)
                
                self.paymentView?.frame = CGRect(origin: CGPoint(x: self.isWalletSelect ? 0 : self.contentView.frame.width, y: 0), size: CGSize(width: self.contentView.frame.width, height: self.contentView.frame.height))
                
                self.transactionTableView.frame = CGRect(origin: CGPoint(x: !self.isWalletSelect ? 10 : self.contentView.frame.width, y: 0), size: CGSize(width: self.contentView.frame.width-20, height: self.contentView.frame.height))
            })
        }
        self.underLineView.backgroundColor = .appPrimaryColor
        self.walletButton.setTitleColor(isWalletSelect ? .appPrimaryColor : .lightGray, for: .normal)
        self.transactionButton.setTitleColor(isWalletSelect ? .lightGray : .appPrimaryColor, for: .normal)
    }
    
    private func addPaymentView() {
        if self.paymentView == nil, let paymentView = Bundle.main.loadNibNamed(Constant.paymentView, owner: self, options: [:])?.first as? PaymentView {
            
            paymentView.frame = CGRect(origin: CGPoint(x: isWalletSelect ? 0 : self.contentView.frame.width, y: 0), size: CGSize(width: self.contentView.frame.width, height: self.contentView.frame.height))
            self.paymentView = paymentView
            self.paymentView?.addAmountButton.addTarget(self, action: #selector(addAmountButtonTapped), for: .touchUpInside)
            self.contentView.addSubview(paymentView)
        }
    }
    
    private func addTransactionView() {
        self.transactionTableView.frame = CGRect(origin: CGPoint(x: !isWalletSelect ? 10 : self.view.frame.width, y: 0), size: CGSize(width: self.contentView.frame.width-20, height: contentView.frame.height))
        self.transactionTableView.delegate = self
        self.transactionTableView.dataSource = self
        self.contentView.addSubview(transactionTableView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing()
    }
}

extension PaymentController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.transactionList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TransactionTableCell = self.transactionTableView.dequeueReusableCell(withIdentifier: AccountConstant.TransactionTableCell, for: indexPath) as! TransactionTableCell
        if self.transactionList.count > indexPath.row {
            cell.setValues(values: self.transactionList[indexPath.section])
            cell.selectionStyle = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastCell = (self.transactionList.count) - 3
        if indexPath.section == lastCell {
            if self.transactionList.count < totalRecord {
                self.isUpdate = true
                offset = offset + 10
                
                accountPresenter?.getTransactionList(offet: offset, limit: totalValues, ishideLoader: false)
                
            }
        }
    }
}

extension PaymentController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30)
        headerView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        let headerLbl = UILabel()
        headerLbl.frame = CGRect(x: 15, y: 5, width: tableView.frame.width - (2 * 15), height: 20)
        headerLbl.text = transactionList[section].transaction_alias
        headerLbl.textColor = UIColor.black
        headerLbl.textAlignment = .left
        headerView.addSubview(headerLbl)
        return headerView
    }
}

extension PaymentController: AccountPresenterToAccountViewProtocol {
    
    func getTransactionList(transactionEntity: TransactionEntity) {
        
        if self.isUpdate  {
            if (transactionEntity.responseData?.transactionList?.count ?? 0) > 0
            {
                for i in 0..<(transactionEntity.responseData?.transactionList?.count ?? 0)
                {
                    let dict = transactionEntity.responseData?.transactionList?[i]
                    self.transactionList.append(dict!)
                }
            }
        }else{
            self.transactionList = transactionEntity.responseData?.transactionList ?? []
            
        }
        totalRecord  = transactionEntity.responseData?.total ?? 0
        setHeaderTableBackground()
        self.transactionTableView.reloadInMainThread()
    }
    
    func showUserProfileDtails(details: UserProfileResponse) {
        
        var userDetails:UserProfileEntity = UserProfileEntity()
        userDetails = details.responseData ?? UserProfileEntity()
        DispatchQueue.main.async {
            let wallet = Constant.wallet.localized
            var walletBalance = userDetails.wallet_balance?.setCurrency()
            walletBalance = "(\(walletBalance ?? ""))"
            self.paymentView?.walletLabel.attributeString(string: wallet+(walletBalance ?? ""), range: NSRange(location: wallet.count, length: walletBalance?.count ?? 0), color: .lightGray)
            self.paymentView?.walletAmtLabel.text = userDetails.wallet_balance?.setCurrency()
            self.paymentView?.cashTextField.text = ""
        }
        AppManager.shared.setUserDetails(details: userDetails)
    }
    
    func postAppsettingsResponse(baseEntity: BaseEntity) {
        AppConfigurationManager.shared.setBasicConfig(data: baseEntity)
        let baseModel = AppConfigurationManager.shared.baseConfigModel
        let paymetArray = baseModel?.responseData?.appsetting?.payments ?? []
        for paymentDic in paymetArray {
            if paymentDic.status == "0" {
                self.paymentView?.walletOuterView?.isHidden = true
                self.paymentView?.addAmountButton.isHidden = true
            }else {
                self.paymentView?.walletOuterView?.isHidden = false
                self.paymentView?.addAmountButton.isHidden = false
                
            }
        }
    }
}
