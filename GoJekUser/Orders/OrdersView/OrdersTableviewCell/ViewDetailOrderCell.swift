//
//  ViewDetailOrderCell.swift
//  GoJekUser
//
//  Created by Sudar on 22/06/20.
//  Copyright © 2020 Appoets. All rights reserved.
//

import UIKit

class ViewDetailOrderCell: UITableViewCell {
    
    @IBOutlet weak var snoLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var upLabel: UILabel!
    @IBOutlet weak var downLabel: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initalLoad()
    }
    
    private func initalLoad(){
        font()
        setColor()
    }
    
    private func setColor() {
        snoLabel.textColor = UIColor.yellow
        dateLabel.textColor = UIColor.lightGray
        upLabel.backgroundColor = UIColor.lightGray
        downLabel.backgroundColor = UIColor.lightGray
    }
    
    private func font(){
        infoLabel.font =  UIFont.setCustomFont(name: .medium, size: .x14)
        snoLabel.font =  UIFont.setCustomFont(name: .medium, size: .x14)
        dateLabel.font =  UIFont.setCustomFont(name: .medium, size: .x14)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
