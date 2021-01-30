//
//  ScheduleView.swift
//  GoJekUser
//
//  Created by Ansar on 06/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class XuberScheduleView: UIView {
    
    @IBOutlet weak var staticDateLabel: UILabel!
    @IBOutlet weak var staticTimeLabel: UILabel!
    @IBOutlet weak var scheduleTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var timeButton: UIButton!
    @IBOutlet weak var dateButton: UIButton!
    
    @IBOutlet weak var scheduleButton: UIButton!
    
    var onClickScheduleNow:((String,String)->Void)?
    
    var selectedTime:String = ""
    var selectedDate:String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialLoads()
    }
    
}

extension XuberScheduleView {
    private func initialLoads() {
        self.staticDateLabel.text = Constant.date.localized
        self.staticTimeLabel.text = Constant.time.localized
        self.dateLabel.text = XuberConstant.selectDate.localized
        self.timeLabel.text = XuberConstant.selectTime.localized
        self.scheduleTitleLabel.text = Constant.scheduleDateTime.localized
        self.scheduleButton.setTitle(XuberConstant.schedule.localized.uppercased(), for: .normal)
        self.scheduleButton.backgroundColor = .xuberColor
        self.scheduleTitleLabel.textColor = .xuberColor
        self.scheduleButton.addTarget(self, action: #selector(tapScheduleNow), for: .touchUpInside)
        self.timeButton.addTarget(self, action: #selector(tapButton(_:)), for: .touchUpInside)
        self.dateButton.addTarget(self, action: #selector(tapButton(_:)), for: .touchUpInside)
        for view in stackView.subviews {
            view.backgroundColor = .boxColor
            if let imageView = view.subviews.first as? UIImageView{
                imageView.image =  UIImage(named: imageView.tag == 10 ? XuberConstant.calendarImage : XuberConstant.clockImage)
                imageView.imageTintColor(color1: .xuberColor)
            }
        }
        setFont()
        setDarkMode()
    }
    
    private func setDarkMode(){
            self.backgroundColor = .boxColor
        }
    
    func setFont()  {
        self.staticDateLabel.font = UIFont.setCustomFont(name: .medium, size: .x12)
        self.staticTimeLabel.font = UIFont.setCustomFont(name: .medium, size: .x12)
        self.scheduleTitleLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        self.dateLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        self.timeLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        self.scheduleButton.titleLabel?.font = UIFont.setCustomFont(name: .medium, size: .x14)
    }
    
    @objc func tapButton(_ sender: UIButton) {
        if sender.tag == 0 {
            PickerManager.shared.showDatePicker(selectedDate: selectedDate,minDate: Date()) { [weak self] (selectedDate) in
                guard let self = self else {
                    return
                }
                print(selectedDate)
                self.dateLabel.text = selectedDate
            }
        }else{
            PickerManager.shared.showTimePicker(selectedDate: "",minDate: Date().adding(minutes: 20)) { [weak self] (selectedTime) in
                guard let self = self else {
                    return
                }
                print(selectedTime)
                self.timeLabel.text = selectedTime
            }
        }
    }
    
    @objc func tapScheduleNow() {
        guard let dateStr = self.dateLabel.text, dateStr != XuberConstant.selectDate.localized else {
            ToastManager.show(title: XuberConstant.dateErrorMsg.localized, state: .error)
            return
        }
        guard let timeStr = self.timeLabel.text, timeStr != XuberConstant.selectTime.localized else {
            ToastManager.show(title: XuberConstant.timeErrorMsg.localized, state: .error)
            return
        }
        
        self.onClickScheduleNow!(dateStr,timeStr)
    }
}
