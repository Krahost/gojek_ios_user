//
//  ScheduleView.swift
//  GoJekUser
//
//  Created by Ansar on 06/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class ScheduleView: UIView {
    
    @IBOutlet weak var staticDateLabel: UILabel!
    @IBOutlet weak var staticTimeLabel: UILabel!
    @IBOutlet weak var scheduleTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var scheduleButton: UIButton!
    
    var onClickScheduleNow:((String,String)->Void)?
    var selectedDate:String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialLoads()
    }
}

extension ScheduleView {
    private func initialLoads() {
        
        staticDateLabel.text = Constant.date.localized
        staticTimeLabel.text = Constant.time.localized
        scheduleTitleLabel.text = Constant.scheduleDateTime.localized
        scheduleButton.setTitle(TaxiConstant.scheduleNow.localized, for: .normal)
        scheduleButton.backgroundColor = .taxiColor
        scheduleButton.addTarget(self, action: #selector(tapScheduleNow), for: .touchUpInside)
        for view in stackView.subviews {
            view.backgroundColor = .boxColor
            let gesture = UITapGestureRecognizer(target: self, action: #selector(tapViews(_:)))
            view.addGestureRecognizer(gesture)
            if let imageView = view.subviews.first as? UIImageView{
                imageView.image =  UIImage(named: imageView.tag == 10 ? TaxiConstant.calendarImage : TaxiConstant.clockImage)
            }
        }
        setDarkMode()
    }
    
    func setDarkMode(){
        self.backgroundColor = .backgroundColor
    }
    
    private func setFont() {
        staticDateLabel.font = .setCustomFont(name: .medium, size: .x14)
        staticTimeLabel.font = .setCustomFont(name: .medium, size: .x14)
        scheduleTitleLabel.font = .setCustomFont(name: .medium, size: .x14)
        dateLabel.font = .setCustomFont(name: .medium, size: .x14)
        timeLabel.font = .setCustomFont(name: .medium, size: .x14)
        scheduleButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x14)
    }
    
    @objc func tapViews(_ sender: UITapGestureRecognizer) {
        if sender.view?.tag == 0 {
            PickerManager.shared.showDatePicker(selectedDate: "", minDate: Date()) { [weak self] (selectedDate) in
                guard let self = self else {
                    return
                }
                self.dateLabel.text = selectedDate
                self.selectedDate = selectedDate
            }
        }
        else{
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let mystring = dateFormatter.string(from: date)
            var minTime:Date!
            if mystring == selectedDate {
                minTime = Date().adding(minutes: 20)
            }
            
            PickerManager.shared.showTimePicker(selectedDate: "",minDate: minTime) { [weak self] (selectedTime) in
                guard let self = self else {
                    return
                }
                self.timeLabel.text = selectedTime
            }
        }
    }
    
    @objc func tapScheduleNow() {
        
        var dateVal:String?
        var timeVal:String?
        
        if dateLabel.text == Constant.date || timeLabel.text == Constant.time {
            dateVal = ""
            timeVal = ""
        }
        else {
            dateVal = dateLabel.text
            timeVal = timeLabel.text
        }
        
        onClickScheduleNow!(dateVal ?? "", timeVal ?? "")
    }
}
