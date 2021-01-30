//
//  SourceDestinationCell.swift
//  GoJekUser
//
//  Created by Sudar on 01/07/20.
//  Copyright © 2020 Appoets. All rights reserved.
//

import UIKit

class SourceDestinationCell: UITableViewCell {
    
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var staticDestinationLabel: UILabel!
    @IBOutlet weak var centerStatusView: UIView!
    @IBOutlet weak var destinationView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setDarkMode()
        destinationLabel.textColor = .lightGray
        destinationLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        staticDestinationLabel.font = UIFont.setCustomFont(name: .bold, size: .x14)
        staticDestinationLabel.text = OrderConstant.destination.localized
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    private func setDarkMode(){
           self.contentView.backgroundColor = .boxColor
       }
    
}
