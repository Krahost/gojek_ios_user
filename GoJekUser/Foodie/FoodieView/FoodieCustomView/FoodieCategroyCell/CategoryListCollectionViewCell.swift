//
//  CategoryListCollectionViewCell.swift
//  Weeyay
//
//  Created by Thiru on 15/06/20.
//  Copyright © 2020 Appoets. All rights reserved.
//

import UIKit

class CategoryListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var categoryLbl: UILabel!
    
    
    override var isSelected: Bool {
           didSet {
            self.categoryLbl.backgroundColor = isSelected ? UIColor.foodieColor : UIColor.clear
            self.categoryLbl.textColor = isSelected ? UIColor.white : UIColor.gray
              // self.categoryLbl.alpha = isSelected ? 0.75 : 1.0
           }
         }
       
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      categoryLbl.backgroundColor = .lightGray
        categoryLbl.textColor = .gray
        categoryLbl.font = UIFont.setCustomFont(name: .bold, size: .x14)
        
    }
    
    override func layoutSubviews() {
    super.layoutSubviews()
        if categoryLbl.isHighlighted {
            categoryLbl.backgroundColor = .foodieColor
        }else{
             categoryLbl.backgroundColor = .clear
        }
               categoryLbl.layer.masksToBounds = true
               categoryLbl.layer.cornerRadius = self.frame.height/2
          
    }
}
