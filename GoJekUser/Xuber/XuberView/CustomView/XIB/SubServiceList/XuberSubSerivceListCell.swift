//
//  XuberSubSerivceListCell.swift
//  GoJekUser
//
//  Created by Ansar on 06/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class XuberSubSerivceListCell: UITableViewCell {
    
    @IBOutlet weak var circleImage: UIImageView!
    @IBOutlet weak var subServiceLabel: UILabel!
    
    @IBOutlet weak var overView: UIView!
    @IBOutlet weak var plusMinusView: PlusMinusView!

    var isImageSelected: Bool = false {
        didSet {
            circleImage.image = UIImage(named: isImageSelected ? Constant.circleFullImage : Constant.circleImage)
            circleImage.imageTintColor(color1: .xuberColor)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialLoads()
        
    }
    override func layoutSubviews() {
        overView.addShadow(radius: 8, color: .lightGray)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension  XuberSubSerivceListCell  {
    
    private func initialLoads() {
        plusMinusView.buttonColor = .xuberColor
        plusMinusView.minusButton.setTitleColor(.xuberColor, for: .normal)
        plusMinusView.plusButton.setTitleColor(.white, for: .normal)
        subServiceLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        circleImage.imageTintColor(color1: .xuberColor)
        setDarkMode()
    }
    
    private func setDarkMode(){
             self.contentView.backgroundColor = .backgroundColor
            self.overView.backgroundColor = .boxColor
    }
}
