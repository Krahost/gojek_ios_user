//
//  FoodieFilterTableViewCell.swift
//  GoJekUser
//
//  Created by Thiru on 11/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class FoodieFilterTableViewCell: UITableViewCell {

    @IBOutlet weak var selectImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var isSelectedItem: Bool = false {
        didSet {
            selectImageView.image = UIImage(named: isSelectedItem ? Constant.squareFill : Constant.sqaureEmpty)
            selectImageView.imageTintColor(color1: .red)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       
    }
    
    func setFilterData(data: CusineResponseData){
        titleLabel.text = data.name
    }
    
}
