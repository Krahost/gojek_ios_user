//
//  OrderTableViewCell.swift
//  MySample
//
//  Created by CSS01 on 20/02/19.
//  Copyright © 2019 CSS01. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {
    
    
    // Outlets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var orderListLabel: UILabel!
    @IBOutlet weak var orderTypeLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var trackButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    
    @IBOutlet weak var trackOuterView: UIView!
    @IBOutlet weak var callOuterView: UIView!
    @IBOutlet weak var chatOuterView: UIView!
    @IBOutlet weak var ratingOuterView: UIView!
    @IBOutlet weak var restaurantRatingView: UIView!
    @IBOutlet weak var orderTypeOuterView: UIView!
    @IBOutlet weak var dateBackgroundView: UIView!
    @IBOutlet weak var backGroundView: UIView!
    
    @IBOutlet weak var bottomView: UIView!
    
    var onTapCall:(()->Void)?
    var onTapTrack:(()->Void)?
    var onTapChat:(()->Void)?
    
    enum OrderStatus:String {
        case COMPLETED = "COMPLETED"
        case CANCELLED = "CANCELLED"
        case SEARCHING = "SEARCHING"
        case ACCEPTED = "ACCEPTED"
        case STARTED = "STARTED"
        case ARRIVED = "ARRIVED"
        case PICKEDUP = "PICKEDUP"
        case DROPPED = "DROPPED"
        case SCHEDULED = "SCHEDULED"
        case None =  ""
        
        var orderColor:UIColor {
            switch self {
            case .COMPLETED,.SCHEDULED:
                return UIColor(red: 101/255.0, green: 176/255.0, blue: 76/255.0, alpha: 1.0)
            case .CANCELLED:
                return UIColor.red
            case .SEARCHING, .ACCEPTED, .STARTED, .ARRIVED, .PICKEDUP, .DROPPED:
                return UIColor(red: 238/255, green: 98/255, blue: 145/255, alpha: 1)
            default:
                return UIColor.clear
            }
        }
        
        var statusStr:String {
            switch self {
            case .COMPLETED:
                return "Completed"
            case .CANCELLED:
                return "Cancelled"
            case .SEARCHING, .ACCEPTED, .STARTED, .ARRIVED, .PICKEDUP, .DROPPED:
                return "On Ride"
            case .SCHEDULED:
                return "Scheduled"
            default:
                return ""
            }
        }
        
    }
    
    var historyType:historyType = .past {
        didSet {
            updateUI()
        }
    }
    // LifeCycles
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initialLoads()
        setDarkMode()
    }
    
    
    private func setDarkMode(){
        self.backGroundView.backgroundColor = .boxColor
        self.backGroundView.backgroundColor = .boxColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    private func dateFormatConvertion(dateString: String) -> String {
        let baseConfig = AppConfigurationManager.shared.baseConfigModel
        let dateFormat = Int(baseConfig?.responseData?.appsetting?.date_format ?? "0")
        let dateFormatTo = dateFormat == 1 ? DateFormat.dd_mm_yyyy_hh_mm_ss : DateFormat.dd_mm_yyyy_hh_mm_ss_a
        let dateFormatReturn = dateFormat == 1 ? DateFormat.ddMMMyy24 : DateFormat.ddMMMyy12
        return AppUtils.shared.dateToString(dateStr: dateString, dateFormatTo: dateFormatTo, dateFormatReturn: dateFormatReturn)
    }
    
    func setTransportValues(values: Transport,type:ServiceType) {
        self.orderIdLabel.text = values.booking_id ?? ""
        if type == .service {
            if let commets = values.rating?.user_comment, commets != .empty{
                self.orderListLabel.text = "\(type.currentType.capitalizingFirstLetter()), \(values.service?.service_name ?? "") \n\n\(commets.replacingOccurrences(of: OrderConstant.null, with: ""))"
            }else {
                self.orderListLabel.text = "\(type.currentType.capitalizingFirstLetter()), \(values.service?.service_name ?? "")"
            }
        }else{
            if let commets = values.rating?.user_comment, commets != .empty {
                self.orderListLabel.text = "\(type.currentType.capitalizingFirstLetter()), \(values.ride?.vehicle_name ?? "") \n\n\(commets.replacingOccurrences(of: OrderConstant.null, with: ""))"
            }else {
                self.orderListLabel.text = "\(type.currentType.capitalizingFirstLetter()), \(values.ride?.vehicle_name ?? "")"
            }
        }
        self.ratingOuterView.isHidden = true
        
        if let dateStr = values.status == OrderStatus.SCHEDULED.rawValue ? values.schedule_time : values.assigned_time {
            let dateValue = dateFormatConvertion(dateString: dateStr)
            setDateAndTime(dateString: dateValue)
        }
        
        
        if let status = OrderStatus(rawValue: values.status ?? "None") {
            
            if status.rawValue == OrderStatus.ACCEPTED.rawValue ||  status.rawValue == OrderStatus.STARTED.rawValue || status.rawValue == OrderStatus.ARRIVED.rawValue {
                chatOuterView.isHidden = false
                callOuterView.isHidden = false
            }else{
                chatOuterView.isHidden = true
                callOuterView.isHidden = true
            }
            self.orderTypeLabel.text = status.statusStr
            self.orderTypeLabel.textColor = status.orderColor
            self.orderTypeOuterView.backgroundColor = status.orderColor.withAlphaComponent(0.2)
            self.ratingOuterView.isHidden = values.status == OrderStatus.CANCELLED.rawValue
            self.bottomView.isHidden = values.status == OrderStatus.CANCELLED.rawValue
        }
        
        if values.dispute_count == 1{
            trackOuterView.isHidden = false
        }else{
            trackOuterView.isHidden = true
        }
        
        if let rating = values.rating {
            self.ratingLabel.text = rating.user_rating?.toString()
        }else{
            self.ratingOuterView.isHidden = true
        }
    }
    
    
    func setCourierValues(values: CourierHistoryEntity) {
        
             orderIdLabel.text = values.booking_id
             if let commets = values.rating?.user_comment, commets != "" {
              orderListLabel.text = (values.service?.vehicle_name?.capitalizingFirstLetter() ?? "") + "\n\n\(commets.replacingOccurrences(of: OrderConstant.null, with: ""))"
             } else {
              orderListLabel.text = values.service?.vehicle_name?.capitalizingFirstLetter() ?? ""
             }
          if let rating = values.rating {
              ratingLabel.text = rating.user_rating?.toString()
             }else {
                 ratingOuterView.isHidden = true
             }
             
             if let dateStr = values.assigned_time {
                 let dateValue = dateFormatConvertion(dateString: dateStr)
                 setDateAndTime(dateString: dateValue)
             }
             
             if let status = OrderStatus(rawValue: values.status ?? "None") {
                 orderTypeLabel.text = status.statusStr.capitalizingFirstLetter()
                 orderTypeLabel.textColor = status.orderColor
                 orderTypeOuterView.backgroundColor = status.orderColor.withAlphaComponent(0.2)
                 self.ratingOuterView.isHidden = status == .CANCELLED
                 self.bottomView.isHidden = status == .CANCELLED
             }
         }
    
    func setDateAndTime(dateString:String) {
        print("dateString---->",dateString)
        let seperatedStrArr = dateString.components(separatedBy: ",")
        if seperatedStrArr.count > 1 {
            self.timeLabel.text = String.removeNil(seperatedStrArr[1])
            self.dateLabel.text =  String.removeNil(seperatedStrArr[0])
        } else  {
            self.timeLabel.text = ""
            self.dateLabel.text =  String.removeNil(seperatedStrArr[0])
        }
    }
    
    
    func setOrderValues(values: FoodieHistoryData,historyType: historyType) {
        if let commets = values.rating?.user_comment, commets != .empty {
            self.orderIdLabel.text = values.store_order_invoice_id ?? "" + commets.replacingOccurrences(of: OrderConstant.null, with: "")
        } else {
            self.orderIdLabel.text = values.store_order_invoice_id ?? ""
        }
        self.orderListLabel.text = values.pickup?.store_name
        self.restaurantRatingView.isHidden  = true
        
        if let dateStr = values.status == OrderStatus.SCHEDULED.rawValue ? values.schedule_datetime : values.created_time {
            let dateValue = dateFormatConvertion(dateString: dateStr)
            setDateAndTime(dateString: dateValue)
        }
        
        if let status = OrderStatus(rawValue: values.status ?? "None") {
            self.orderTypeLabel.text = status.statusStr
            self.orderTypeLabel.textColor = status.orderColor
            self.orderTypeOuterView.backgroundColor = status.orderColor.withAlphaComponent(0.2)
            self.ratingOuterView.isHidden = values.status == OrderStatus.CANCELLED.rawValue
            self.bottomView.isHidden = values.status == OrderStatus.CANCELLED.rawValue
        }
        self.ratingOuterView.isHidden = historyType != .past
        if let rating = values.rating {
            self.ratingLabel.text = rating.user_rating?.toString()
        }else{
            self.ratingOuterView.isHidden = true
        }
    }
    
}

//MARK: Methods

extension OrderTableViewCell {
    private func initialLoads() {
        
        self.dateBackgroundView.backgroundColor = .appPrimaryColor
        //        self.orderListLabel.textColor = UIColor.appPrimaryColor.withAlphaComponent(0.5)
        self.backGroundView.setCornerRadiuswithValue(value: 5)
        self.orderTypeOuterView.setCornerRadius()
        self.callButton.setTitle(OrderConstant.call.localized, for: .normal)
        self.callButton.setImage(UIImage(named: Constant.phoneImage), for: .normal)
        if CommonFunction.checkisRTL() {
            self.callButton.setImageTitle(spacing: -8)
        }else {
            self.callButton.setImageTitle(spacing: 10)
        }
        
        self.callButton.addTarget(self, action: #selector(tapCall(_:)), for: .touchUpInside)
        
        self.chatButton.setTitle(OrderConstant.chat.localized, for: .normal)
        self.chatButton.setImage(UIImage(named: OrderConstant.helpImage), for: .normal)
        if CommonFunction.checkisRTL() {
            self.chatButton.setImageTitle(spacing: -10)
        }else {
            self.chatButton.setImageTitle(spacing: 10)
        }
        
        self.chatButton.addTarget(self, action: #selector(tapChat(_:)), for: .touchUpInside)
        self.trackButton.tintColor = .red
        self.trackButton.setTitleColor(.red, for: .normal)
        self.trackButton.setTitle(OrderConstant.dispute, for: .normal)
        self.trackButton.setImage(UIImage.init(named: OrderConstant.ic_dispute), for: .normal)
        self.trackButton.setImageTitle(spacing: 5)

      //  self.trackButton.addTarget(self, action: #selector(tapCancel(_:)), for: .touchUpInside)
        //self.trackButton.setTitle(Constant.SCancel.localized, for: .normal)
        self.chatButton.imageEdgeInsets = UIEdgeInsets(top: 6, left: 0, bottom: 6, right: 2)
        self.chatButton.imageView?.contentMode = .scaleAspectFit
        self.callButton.imageEdgeInsets = UIEdgeInsets(top: 6, left: 0, bottom: 6, right: 2)
        self.callButton.imageView?.contentMode = .scaleAspectFit
        ratingLabel.textColor = .darkGray
        setFont()
    }
    
    private func setFont() {
        
        orderIdLabel.font = UIFont.setCustomFont(name: .bold, size: .x14)
        orderTypeLabel.font = UIFont.setCustomFont(name: .bold, size: .x10)
        orderListLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        dateLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        timeLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        ratingLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        chatButton.titleLabel?.font = UIFont.setCustomFont(name: .medium, size: .x14)
        callButton.titleLabel?.font = UIFont.setCustomFont(name: .medium, size: .x14)
        trackButton.titleLabel?.font = UIFont.setCustomFont(name: .medium, size: .x14)
    }
    
    // UiDesign
    
    private func updateUI() {
        if historyType == .past {
            self.callOuterView.isHidden = true
            self.chatOuterView.isHidden = true
            self.trackOuterView.isHidden = true
            self.ratingOuterView.isHidden = false
            self.orderTypeOuterView.isHidden = false
           self.trackOuterView.isHidden = true
            self.chatOuterView.isHidden = true
        }
        else if historyType == .ongoing {
            self.callOuterView.isHidden = false
            self.chatOuterView.isHidden = true
            self.trackOuterView.isHidden = true
            self.ratingOuterView.isHidden = true
            self.orderTypeOuterView.isHidden = true
            self.trackOuterView.isHidden = true
            self.chatOuterView.isHidden = false
        }
        else {
            self.callOuterView.isHidden = true
            self.chatOuterView.isHidden = false
            self.trackOuterView.isHidden = true
            self.ratingOuterView.isHidden = true
            self.orderTypeOuterView.isHidden = true
            self.trackOuterView.isHidden = true
            self.chatOuterView.isHidden = true
        }
    }
    
    @objc func tapChat(_ sender: UIButton) {
        self.onTapChat!()
    }
    
    @objc func tapCall(_ sender: UIButton) {
        self.onTapCall!()
    }
    
    @objc func tapCancel(_ sender: UIButton) {
        self.onTapTrack!()
    }
}
