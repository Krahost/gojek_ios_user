//
//  FoodieItemsCell.swift
//  GoJekUser
//
//  Created by CSS on 21/06/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class FoodieItemsCell: UITableViewCell {
    
    //MARK: - IBOutlet
    @IBOutlet weak var itemNotAvailableLabel: UILabel!
    @IBOutlet weak var itemNotAvailableView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var itemsaddView: PlusMinusView!
    @IBOutlet weak var customizableLabel: UILabel!
    @IBOutlet weak var discountPriceLabel: UILabel!
    @IBOutlet weak var qtyLabel: UILabel!
    @IBOutlet weak var vegImgVw: UIImageView!
    @IBOutlet weak var imageOuterView: UIView!
    @IBOutlet weak var bestsellerBGVw: UIView!
    @IBOutlet weak var bestsellerImgVw: UIImageView!
    @IBOutlet weak var bestsellerLbl: UILabel!
    
    
    var foodieAddonsgaDelegate: ShowAddonsDelegates?

    var isVeg: Bool = false {
          didSet {
              vegImgVw.image = UIImage(named: isVeg ? FoodieConstant.ic_veg : FoodieConstant.ic_nonveg)
          }
      }
    var isItemAvailable = false{
        didSet{
            if(isItemAvailable == true){
                itemsaddView.isHidden = false
                customizableLabel.isHidden = false
                itemNotAvailableView.isHidden = true
                self.backgroundView?.alpha = 1.0
            }
            else{
                itemsaddView.isHidden = true
                customizableLabel.isHidden = true
                itemNotAvailableView.isHidden = false
                self.backgroundView?.alpha = 0.5
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initialLoad()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
//        itemImageView?.applyshadowWithCorner(containerView : imageOuterView, cornerRadious : 5.0)
    }
    
}
//MARK: - LocalMethod
extension FoodieItemsCell {
    
    private func initialLoad() {
        
        self.itemsaddView.buttonColor = .foodieColor
        contentView.backgroundColor = .clear
   
     //   bestsellerImgVw.imageTintColor(color1: .foodieColor)
        bestsellerImgVw.image = UIImage.init(named: "ic_bestseller")
        bestsellerLbl.textColor = .white
            
       // bestsellerLbl.text = "BESTSELLER"
        bestsellerImgVw.imageTintColor(color1: .foodieColor)
        self.priceLabel.font = UIFont.setCustomFont(name: .medium, size: .x16)
        customizableLabel.text = FoodieConstant.Customizable.localized
        customizableLabel.font = UIFont.setCustomFont(name: .medium, size: .x12)
        customizableLabel.textColor = .lightGray
        qtyLabel.textColor = .lightGray
        itemNotAvailableView.backgroundColor = .foodieColor
        itemNameLabel.font = UIFont.setCustomFont(name: .medium, size: .x16)
        priceLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        qtyLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        itemNotAvailableLabel.font  = UIFont.setCustomFont(name: .medium, size: .x10)
        itemNotAvailableLabel.text = FoodieConstant.itemNotAvailable.localized
        bestsellerLbl.font = UIFont.setCustomFont(name: .medium, size: .x12)
        DispatchQueue.main.async {
            self.itemImageView.setCornerRadiuswithValue(value: 5.0)
//            self.backView.addShadow(radius: 5.0, color: UIColor.foodieColor.withAlphaComponent(0.1))
        }

        setDarkMode()
    }
    
    
    private func setDarkMode(){
        backView.backgroundColor = .boxColor
    }
    
    @objc func tapCustomize(_ sender: UIButton){
        
        foodieAddonsgaDelegate?.addonsCustomize(tag: sender.tag)
    }
    
}

