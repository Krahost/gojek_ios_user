//
//  AddCardViewController.swift
//  GoJekUser
//
//  Created by Sravani on 26/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Stripe
import CreditCardForm
import Alamofire



class AddCardViewController: UIViewController {

    @IBOutlet weak var creditCardView: CreditCardFormView!
    
    //MARK:- Local Variable
    let paymentTextField = STPPaymentCardTextField()
        
    var backDelegate:PaymentBackDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initialLoads()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
}

extension AddCardViewController {
    
    func initialLoads() {
        self.setNavigationBar()
        let userDetails = AppManager.shared.getUserDetails()
        self.creditCardView.cardHolderString = (userDetails?.first_name ?? "") + " " + (userDetails?.last_name ?? "")
        self.creditCardView.defaultCardColor = .appPrimaryColor
        self.creditCardView.backgroundColor = .backgroundColor
        self.createTextField()
        self.view.backgroundColor = .backgroundColor
    
    }
    
    private func setNavigationBar() {
        setNavigationTitle()
        self.title = AccountConstant.addCard.localized
        let leftButton = UIBarButtonItem(image: UIImage(named: Constant.ic_back)?.imageFlippedForRightToLeftLayoutDirection(), style: .plain, target: self, action: #selector(tapBack))
        self.navigationItem.leftBarButtonItem  = leftButton
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: Constant.SDone.localized, style: .done, target: self, action: #selector(self.doneButtonClick))
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    @objc func doneButtonClick() {
        
            self.view.endEditing(true)
            
            if paymentTextField.cardParams.number == nil {
                paymentTextField.becomeFirstResponder()
                ToastManager.show(title: AccountConstant.cardEmpty.localized , state: .error)
            }else if paymentTextField.cardParams.expYear == 0 {
                paymentTextField.becomeFirstResponder()
                ToastManager.show(title: AccountConstant.yearEmpty.localized , state: .error)
                
            }else if paymentTextField.cardParams.expMonth == 0 {
                paymentTextField.becomeFirstResponder()
                ToastManager.show(title: AccountConstant.monthEmpty.localized , state: .error)
                
            }else if paymentTextField.cardParams.cvc == nil {
                paymentTextField.becomeFirstResponder()
                ToastManager.show(title: AccountConstant.cvvEmpty.localized , state: .error)
                
            }else{
                LoadingIndicator.show()
                let cardParam = STPCardParams()
                cardParam.cvc = paymentTextField.cardParams.cvc
                cardParam.number = paymentTextField.cardParams.number
                cardParam.expYear = paymentTextField.cardParams.expYear as! UInt
                cardParam.expMonth = paymentTextField.cardParams.expMonth as! UInt
                
                STPAPIClient.shared().createToken(withCard: cardParam) { (stpToken, error) in
                    print(stpToken?.tokenId ?? "")
                    guard let token = stpToken?.tokenId else {
                        LoadingIndicator.hide()
                        return
                    }
                    
                    let param: Parameters = [AccountConstant.stripeToken: token]
                    self.accountPresenter?.addCard(param: param)
            }
        }
    }
    
    @objc func tapBack() {
        backDelegate?.isFromCard()
        self.navigationController?.popViewController(animated: true)
    }
    
    func createTextField() {
        paymentTextField.frame = CGRect(x: 15, y: 199, width: self.view.frame.size.width - 30, height: 44)
        paymentTextField.delegate = self
        paymentTextField.translatesAutoresizingMaskIntoConstraints = false
        paymentTextField.borderWidth = 0
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: paymentTextField.frame.size.height - width, width:  paymentTextField.frame.size.width, height: paymentTextField.frame.size.height)
        border.borderWidth = width
        paymentTextField.layer.addSublayer(border)
        paymentTextField.layer.masksToBounds = true
        paymentTextField.numberPlaceholder = "XXXX XXXX XXXX XXXX"
        paymentTextField.postalCodeEntryEnabled = false
        view.addSubview(paymentTextField)
        
        NSLayoutConstraint.activate([
            paymentTextField.topAnchor.constraint(equalTo: creditCardView.bottomAnchor, constant: 20),
            paymentTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            paymentTextField.widthAnchor.constraint(equalToConstant: self.view.frame.size.width-20),
            paymentTextField.heightAnchor.constraint(equalToConstant: 44)
            ])
    }
    
}

// MARK:- STPPaymentCardTextFieldDelegate

extension AddCardViewController : STPPaymentCardTextFieldDelegate {

    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        self.navigationItem.rightBarButtonItem?.isEnabled = textField.isValid
        creditCardView.paymentCardTextFieldDidChange(cardNumber: textField.cardNumber, expirationYear: textField.expirationYear, expirationMonth: textField.expirationMonth, cvc: textField.cvc)
    }
    
    func paymentCardTextFieldDidEndEditingExpiration(_ textField: STPPaymentCardTextField) {
        creditCardView.paymentCardTextFieldDidEndEditingExpiration(expirationYear: textField.expirationYear)
    }
    
    func paymentCardTextFieldDidBeginEditingCVC(_ textField: STPPaymentCardTextField) {
        creditCardView.paymentCardTextFieldDidBeginEditingCVC()
    }
    
    func paymentCardTextFieldDidEndEditingCVC(_ textField: STPPaymentCardTextField) {
        creditCardView.paymentCardTextFieldDidEndEditingCVC()
    }
}

//MARK:- PostViewProtocol

extension AddCardViewController: AccountPresenterToAccountViewProtocol {
   
    func addCardSuccess(addCardResponse: CardEntityResponse) {

        print(addCardResponse.message ?? "")
        LoadingIndicator.hide()
        AppAlert.shared.simpleAlert(view: self, title: addCardResponse.message ?? "", message: "", buttonTitle: Constant.SOk.localized)
        AppAlert.shared.onTapAction = { [weak self] tag in
            guard let self = self else {
                return
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
}

