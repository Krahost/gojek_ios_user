//
//  FoodieScheduleTimeView.swift
//  GoJekUser
//
//  Created by Thiru on 01/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class FoodieScheduleTimeView: UIView {

    //Outlets
    
    @IBOutlet weak var scheduleBackView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateValueLabel: UILabel!
    @IBOutlet weak var timeValueLabel: UILabel!
    @IBOutlet weak var scheduleButton: UIButton!
    @IBOutlet weak var calendarImageView: UIImageView!
    
    @IBOutlet weak var timeImageViw: UIImageView!
    var onClickClose:(()->Void)?
    var onClickSchedule:(()->Void)?
    //LifeCycles
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initialLoad()
    }

}
extension FoodieScheduleTimeView {
    
    func initialLoad() {
        
        self.scheduleButton.addTarget(self, action: #selector(tapSchedule), for: .touchUpInside)
        
        DispatchQueue.main.async {
            
            self.scheduleBackView.setCornerRadiuswithValue(value: 5)
            self.scheduleButton.setCornerRadiuswithValue(value: 5)
            self.timeView.setCornerRadiuswithValue(value: 5)
            self.dateView.setCornerRadiuswithValue(value: 5)
            
            
        }
       setColors()
       localize()
        setFont()
        
    }
    private func setColors() {
        
    self.calendarImageView.image = UIImage(named: FoodieConstant.ic_calendar)?.imageTintColor(color1: .red)
    self.timeImageViw.image = UIImage(named: FoodieConstant.ic_clock)?.imageTintColor(color1: .red)
    }
    private func localize() {
        
        titleLabel.text = FoodieConstant.Tscheduledateandtime.localized
        dateLabel.text = FoodieConstant.TDate.localized
        timeLabel.text = FoodieConstant.TTime.localized
        scheduleButton.setTitle(FoodieConstant.TSchedule.localized, for: .normal)
        
    }
    
    private func setFont(){
        titleLabel.font = UIFont.setCustomFont(name: .medium, size: .x16)
        dateLabel.font = UIFont.setCustomFont(name: .medium, size: .x16)
        timeLabel.font = UIFont.setCustomFont(name: .medium, size: .x16)
        dateValueLabel.font = UIFont.setCustomFont(name: .medium, size: .x16)
        timeValueLabel.font = UIFont.setCustomFont(name: .medium, size: .x16)
        scheduleButton.titleLabel?.font = UIFont.setCustomFont(name: .medium, size: .x16)

    }
    
    @objc func tapSchedule() {
        self.onClickSchedule!()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.onClickClose!()
    }
}
