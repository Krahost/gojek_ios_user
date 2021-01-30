//
//  FoodieSearchTableViewCell.swift
//  GoJekUser
//
//  Created by Thiru on 01/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class FoodieSearchTableViewCell: UITableViewCell {

    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descrLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        initialLoad()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension FoodieSearchTableViewCell {
    
    private func initialLoad() {
        
        DispatchQueue.main.async {
            self.backGroundView.setCornerRadiuswithValue(value: 5)
            self.itemImageView.setCornerRadiuswithValue(value: 5)
        }
    }
}
