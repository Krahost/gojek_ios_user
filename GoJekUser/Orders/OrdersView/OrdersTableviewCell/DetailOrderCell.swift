//
//  DetailOrderCell.swift
//  GoJekUser
//
//  Created by Sudar on 06/07/20.
//  Copyright © 2020 Appoets. All rights reserved.
//

import UIKit

class DetailOrderCell: UITableViewCell {
    
    // Payment view
    @IBOutlet weak var staticPaymentLabel: UILabel!
    @IBOutlet weak var cardOrCashLabel: UILabel!
    @IBOutlet weak var paymentImageView: UIImageView!
    
    // Status View
    @IBOutlet weak var staticStatusLabel: UILabel!
    @IBOutlet weak var statusValueLabel: UILabel!
    
    // Commentes View
    @IBOutlet weak var commentOuterView: UIView!
    @IBOutlet weak var staticCommentLabel: UILabel!
    @IBOutlet weak var commentValueLabel: UILabel!
    @IBOutlet weak var paymentOuterView: UIView!

    // Items missing View
    @IBOutlet weak var lostItemOuterView: UIView!
    @IBOutlet weak var staticLostLabel: UILabel!
    @IBOutlet weak var staticLostDescLabel: UILabel!
    @IBOutlet weak var lostItemSubView: UIView!
    @IBOutlet weak var statusOuterView: UIView!

    var onClickLostItem:(()->Void)?
    


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initalLoads()
    }
    
      private func setDarkMode(){
        self.statusOuterView.backgroundColor = .boxColor
        self.lostItemOuterView.backgroundColor = .boxColor
        self.paymentOuterView.backgroundColor = .boxColor
        self.commentOuterView.backgroundColor = .boxColor
        self.lostItemSubView.backgroundColor = .boxColor

       }
    
    private func initalLoads(){
        if  let lostImage = lostItemSubView.subviews.first as? UIImageView {
            lostImage.image = UIImage(named: OrderConstant.alertImage)
            lostImage.imageTintColor(color1: .appPrimaryColor)
        }
        let lostGesture = UITapGestureRecognizer(target: self, action: #selector(tapLostItem))
        self.lostItemSubView.addGestureRecognizer(lostGesture)
        self.paymentImageView.image = UIImage(named: Constant.payment)
        self.paymentImageView.imageTintColor(color1: .lightGray)
        lostItemSubView.isUserInteractionEnabled = true
        setFont()
        setColors()
        localize()
        setDarkMode()
        lostItemOuterView.isHidden = true

    }
    
    private func setFont() {
        staticStatusLabel.font = UIFont.setCustomFont(name: .bold, size: .x12)
        statusValueLabel.font = UIFont.setCustomFont(name: .light, size: .x12)
        staticPaymentLabel.font = UIFont.setCustomFont(name: .bold, size: .x12)
        cardOrCashLabel.font = UIFont.setCustomFont(name: .light, size: .x12)
        staticCommentLabel.font = UIFont.setCustomFont(name: .bold, size: .x12)
        commentValueLabel.font = UIFont.setCustomFont(name: .light, size: .x12)
        staticLostLabel.font = UIFont.setCustomFont(name: .bold, size: .x12)
        staticLostDescLabel.font = UIFont.setCustomFont(name: .bold, size: .x12)
    }
    
    @objc func tapLostItem() {
        onClickLostItem!()
    }
    
    private func localize() {
           staticPaymentLabel.text = OrderConstant.paymentVia.localized
           staticLostDescLabel.text = OrderConstant.presstheicon.localized
           staticStatusLabel.text = OrderConstant.status.localized
    }
    
    private func setColors() {
        lostItemSubView.backgroundColor = UIColor.appPrimaryColor.withAlphaComponent(0.3)
        staticLostDescLabel.textColor = .appPrimaryColor
    }
    
    func setValues(data: OrderDetailReponseData) {
        DispatchQueue.main.async {
            if let transportData = data.transport {
                self.staticCommentLabel.text = OrderConstant.commentsfor.localized.giveSpace + ServiceType.trips.rawValue
                self.lostItemOuterView.isHidden = false

                self.cardOrCashLabel.text = transportData.payment_mode ?? ""
                
                if let paymentImage = PaymentType(rawValue: transportData.payment_mode ?? "")?.image {
                    self.paymentImageView.image = paymentImage
                }

                if let comment = transportData.rating?.user_comment, comment.count != 0 ,comment != "null"  {
                    self.commentValueLabel.text = comment
                }else{
                    self.commentValueLabel.text = OrderConstant.noComment.localized
                }
                
                if let status = tripStatus(rawValue: transportData.status ?? "") {
                    self.statusValueLabel.text = status.statusString
                }
                self.staticLostLabel.text = transportData.lost_item == nil ? OrderConstant.didyoulosesomething.localized : OrderConstant.knowLostItemStatus.localized
                
                if transportData.payment == nil {
                    self.paymentOuterView.isHidden = true
                }
            }
          
            if let serviceData = data.service {
                self.staticCommentLabel.text = OrderConstant.commentsfor.localized.giveSpace + ServiceType.service.rawValue
                
                self.lostItemOuterView.isHidden = true
                self.cardOrCashLabel.text = serviceData.payment_mode
                
                if let paymentImage = PaymentType(rawValue: serviceData.payment_mode ?? "")?.image {
                    self.paymentImageView.image = paymentImage
                }
                
                if let comment = serviceData.rating?.user_comment , comment.count != 0,comment != "null"  {
                    self.commentValueLabel.text = comment
                }else{
                    self.commentValueLabel.text = OrderConstant.noComment.localized
                }
                if let status = tripStatus(rawValue: serviceData.status ?? "") {
                    self.statusValueLabel.text = status.statusString
                }
                
                if serviceData.payment == nil {
                    self.paymentOuterView.isHidden = true
                }
            }
            if let foodieValue = data.order {
                self.staticCommentLabel.text = OrderConstant.commentsfor.localized.giveSpace + ServiceType.orders.rawValue
                self.lostItemOuterView.isHidden = true
                if let status = tripStatus(rawValue: foodieValue.status ?? "") {
                    self.statusValueLabel.text = status.statusString
                }
                if let paymentImage = PaymentType(rawValue: foodieValue.order_invoice?.payment_mode ?? "")?.image {
                                   self.paymentImageView.image = paymentImage
                               }
                self.cardOrCashLabel.text = foodieValue.order_invoice?.payment_mode
                if let comment = foodieValue.rating?.user_comment, comment.count != 0 ,comment != "null"  {
                    self.commentValueLabel.text = comment
                }else{
                    self.commentValueLabel.text = OrderConstant.noComment.localized
                }
                if foodieValue.order_invoice == nil {
                    self.paymentOuterView.isHidden = true
                }
            }
            if let couierValue = data.delivery {
                self.staticCommentLabel.text = OrderConstant.commentsfor.localized.giveSpace + ServiceType.service.rawValue
                
                self.lostItemOuterView.isHidden = true
                self.cardOrCashLabel.text = couierValue.payment_mode
                
                if let paymentImage = PaymentType(rawValue: couierValue.payment_mode ?? "")?.image {
                    self.paymentImageView.image = paymentImage
                }
                
                if let comment = couierValue.rating?.user_comment , comment.count != 0,comment != "null"  {
                    self.commentValueLabel.text = comment
                }else{
                    self.commentValueLabel.text = OrderConstant.noComment.localized
                }
                if let status = tripStatus(rawValue: couierValue.status ?? "") {
                    self.statusValueLabel.text = status.statusString
                }
                
                if couierValue.payment == nil {
                    self.paymentOuterView.isHidden = true
                }
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
