//
//  PaymentSelectViewController.swift
//  GoJekProvider
//
//  Created by apple on 16/05/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

class PaymentSelectViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var paymentTypeArr: [PaymentDetails] = Array()
    var cardsList = CardEntityResponse()
    var cardFooterView: CardView?
    var isFromAddAmountWallet: Bool = false
    var isChangePayment: Bool = false
    var walletAmount: String = ""
    var onClickPayment: ((PaymentType, CardResponseData?)-> Void)? //change payment mode from request

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = isFromAddAmountWallet == true || isChangePayment == true ? AccountConstant.choosePayment.localized : AccountConstant.payment.localized
        // Do any additional setup after loading the view.
        
        self.setNavigationTitle()
        self.setLeftBarButtonWith(color: .blackColor)
        self.view.backgroundColor = .veryLightGray
        self.tableView.register(nibName: AccountConstant.PaymentTypeTableViewCell)
        self.tableView.register(nibName: AccountConstant.CardView)
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.hideTabBar()
        self.accountPresenter?.getCard()
        self.hideTabBar()
        //Get card status
        self.accountPresenter?.postAppsettings(param: [LoginConstant.salt_key: APPConstant.salt_key])
        setDarkMode()
    }
    
    private func setDarkMode(){
        self.view.backgroundColor = .backgroundColor
        self.tableView.backgroundColor = .backgroundColor
    }
}

// MARK: - UITableViewDataSource

extension PaymentSelectViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.paymentTypeArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PaymentTypeTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: AccountConstant.PaymentTypeTableViewCell, for: indexPath) as! PaymentTypeTableViewCell
        cell.selectionStyle = .none
        
        let paymentDic = self.paymentTypeArr[indexPath.row]
        cell.setPaymentValue(payment: paymentDic)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if paymentTypeArr.contains(where: { ($0.name)?.uppercased()  == Constant.cash.uppercased() }) {
            return self.cardFooterView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
       
//        if paymentTypeArr.contains(where: { ($0.name)?.uppercased()  == Constant.cash.uppercased() }) {
            let header = view as? UITableViewHeaderFooterView
            header?.backgroundColor = .clear
            header?.textLabel?.font = UIFont.setCustomFont(name: .medium, size: .x18)
            header?.textLabel?.textColor = .black
            header?.textLabel?.text = AccountConstant.availablePayment.localized
//        }
       
    }
}

// MARK: - UITableViewDelegate

extension PaymentSelectViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return self.cardFooterView?.frame.height ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isChangePayment {
            self.onClickPayment?(.CASH, nil)
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension PaymentSelectViewController: AccountPresenterToAccountViewProtocol {
    
    func getCardResponse(getCardResponse: CardEntityResponse) {
        cardsList = getCardResponse
        cardFooterView?.isDeleteCancelShow = true
        cardFooterView?.isFromAnotherPage = isFromAddAmountWallet
        cardFooterView?.cardsList = getCardResponse
        cardFooterView?.paymentCardCollectionView.reloadInMainThread()
    }
    
    func deleteCardSuccess(deleteCardResponse: CardEntityResponse) {
        
        self.accountPresenter?.getCard()
    }
    
    func addMoneyToWalletSuccess(walletSuccessResponse: AddAmountEntity) {
        
        ToastManager.show(title: walletSuccessResponse.responseData?.message ?? AccountConstant.AddAmountSuccess, state: .success)
        self.navigationController?.popViewController(animated: true)
    }
    
    func addNewCardButtonClick() {
        if guestLogin() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: OrderConstant.AddCardViewController) as! AddCardViewController
        self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func postAppsettingsResponse(baseEntity: BaseEntity) {
        
        self.accountPresenter?.getCard()
        self.paymentTypeArr.removeAll()
        
        AppConfigurationManager.shared.baseConfigModel = baseEntity
        AppConfigurationManager.shared.setBasicConfig(data: baseEntity)
        
        let paymetArray = baseEntity.responseData?.appsetting?.payments ?? []
        var tempPaymentArray: [PaymentDetails] = Array()
        for paymentDic in paymetArray {
            if paymentDic.status == "1" {
                paymentTypeArr.append(paymentDic)
                tempPaymentArray.append(paymentDic)
            }
        }
        
        if isFromAddAmountWallet == true, let index = paymentTypeArr.firstIndex(where: { $0.name?.uppercased() ==  Constant.cash.uppercased()}) {
            paymentTypeArr.remove(at: index)
        }
        
        if let _ = paymentTypeArr.firstIndex(where: { $0.name?.uppercased() ==  Constant.card.uppercased()}) {
            if let index = paymentTypeArr.firstIndex(where: { $0.name?.uppercased() ==  Constant.card.uppercased()}) {
                paymentTypeArr.remove(at: index)
            }
            if self.cardFooterView == nil, let cardFooterView = Bundle.main.loadNibNamed(AccountConstant.CardView, owner: self, options: [:])?.first as? CardView {
                cardFooterView.frame = CGRect(x: 16, y: self.paymentTypeArr.count>0 ? 0 : 100, width: self.view.frame.width-32, height: cardFooterView.frame.height)
                cardFooterView.backgroundColor = .backgroundColor
                cardFooterView.delegate = self
                self.cardFooterView = cardFooterView
                self.view.addSubview(cardFooterView)
            }
        }
        
        if tempPaymentArray.count == 0 {
            self.tableView.setBackgroundImageAndTitle(imageName: Constant.ic_empty_card, title: AccountConstant.noPaymentType,tintColor: .black)
        }
        else {
            self.tableView.backgroundView = nil
        }
        self.tableView.reloadInMainThread()
    }
}

extension PaymentSelectViewController: CardViewDelegate {
    
    func deleteButtonClick() {
        AppAlert.shared.simpleAlert(view: self, title: AccountConstant.deleteMsg, message: String.empty, buttonOneTitle: Constant.SYes, buttonTwoTitle: Constant.SNo)
        AppAlert.shared.onTapAction = { [weak self] tag in
            guard let self = self else {
                return
            }
            if tag == 0 {
                self.accountPresenter?.deleteCard(cardID: self.cardFooterView?.selectedCardId ?? 0 )
            }
        }
    }
    
    func addAmountToWallet() {
        if isFromAddAmountWallet {
            let param: Parameters = [AccountConstant.amount: walletAmount,
                                     AccountConstant.card_id: cardFooterView?.selectedCard_token ?? "",
                                     AccountConstant.user_type: userType.user.rawValue,
                                     AccountConstant.payment_Mode: "CARD"]
            
            self.accountPresenter?.addMoneyToWallet(param: param)
        }
        else if isChangePayment {
            let indexVal: Int = cardFooterView?.selectedCardIndex ?? 0
            let cardDetail = cardsList.responseData?[indexVal]
            self.onClickPayment?(.CARD,cardDetail)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}



