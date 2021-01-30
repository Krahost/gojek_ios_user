//
//  LanguageTableViewCell.swift
//  GoJekProvider
//
//  Created by CSS on 04/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class LanguageTableViewCell: UITableViewCell {

    //MARK: - IBOutlet
    @IBOutlet weak var languageNameLabel: UILabel!
    @IBOutlet weak var radioImageView: UIImageView!
    
//    var isLanguageSelect:Bool = false {
//        didSet {
//            radioImageView.image = UIImage(named: isLanguageSelect ? Constant.circleFullImage : Constant.circleImage)
//        }
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initalLoads()
    }
    
    
    private func initalLoads(){
        languageNameLabel.textColor = UIColor.lightGray
        languageNameLabel.font = UIFont.setCustomFont(name: .light, size: .x14)
        self.radioImageView.image = UIImage(named: Constant.circleImage)
        self.clipsToBounds = true
        setDarkMode()
    }
    
    
    private func setDarkMode(){
        self.contentView.backgroundColor = .boxColor
        self.radioImageView.setImageColor(color: .blackColor)
    }
    
    
    func setValues(data: Languages){
        languageNameLabel.text = data.name
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
