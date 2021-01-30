//
//  FoodieItemsTableViewCell.swift
//  GoJekUser
//
//  Created by Thiru on 07/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class FoodieItemsTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlet
    @IBOutlet weak var itemNotAvailableLabel: UILabel!
    @IBOutlet weak var itemNotAvailableView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var itemsaddView: PlusMinusView!
    @IBOutlet weak var customizableLabel: UILabel!
    @IBOutlet weak var addonsLabel: UILabel!
    @IBOutlet weak var customizeButton: UIButton!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var itemDisableLabel: UILabel!
    @IBOutlet weak var itemDisableVw: UIStackView!
    @IBOutlet weak var delBtn: UIButton!
    @IBOutlet weak var qtyLabel: UILabel!
    @IBOutlet weak var vegImgVw: UIImageView!
    @IBOutlet weak var imageOuterView: UIView!
    @IBOutlet weak var overView: UIStackView!


    var foodieAddonsgaDelegate: ShowAddonsDelegates?
    
    var isVeg: Bool = false {
          didSet {
              vegImgVw.image = UIImage(named: isVeg ? FoodieConstant.ic_veg : FoodieConstant.ic_nonveg)
          }
      }

    override func awakeFromNib() {
        super.awakeFromNib()
        initialLoad()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        itemsaddView.setCornerRadius()
//        itemImageView?.applyshadowWithCorner(containerView : imageOuterView, cornerRadious : 5.0)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

//MARK: - LocalMethod
extension FoodieItemsTableViewCell {
    
    private func initialLoad() {
        itemDisableLabel.layer.borderColor = UIColor.lightGray.cgColor
        itemDisableLabel.layer.borderWidth = 1
        
        addonsLabel.isHidden = true
        customizeButton.isHidden = true
        customizeButton.setTitleColor(.foodieColor, for: .normal)
        itemsaddView.buttonColor = .foodieColor
        itemNotAvailableView.backgroundColor = .foodieColor
        contentView.backgroundColor = .backgroundColor
        priceLabel.font = UIFont.setCustomFont(name: .medium, size: .x16)
        customizableLabel.text = FoodieConstant.Customizable.localized
        itemNotAvailableLabel.text = FoodieConstant.itemNotAvailable.localized
        customizableLabel.font = UIFont.setCustomFont(name: .medium, size: .x12)
        customizableLabel.textColor = .lightGray
        itemNameLabel.font = UIFont.setCustomFont(name: .medium, size: .x16)
        priceLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        customizeButton.titleLabel?.font = UIFont.setCustomFont(name: .medium, size: .x12)
        addonsLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        itemNotAvailableLabel.font  = UIFont.setCustomFont(name: .medium, size: .x12)
        customizeButton.setTitle(FoodieConstant.customize.localized, for: .normal)
//        customizeButton.setImage(UIImage(named: FoodieConstant.ic_downarrow)?.imageTintColor(color1: .foodieColor), for: .normal)
        customizeButton.addTarget(self, action: #selector(tapCustomize(_:)), for: .touchUpInside)
//        if CommonFunction.checkisRTL() {
//            customizeButton.changeToRight(spacing: -6)
//        }else {
//            customizeButton.semanticContentAttribute = .forceRightToLeft
//            customizeButton.sizeToFit()
//            customizeButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//
//        }
        qtyLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        qtyLabel.textColor = .lightGray
        itemDisableLabel.font = UIFont.setCustomFont(name: .medium, size: .x12)
        delBtn.setBothCorner()
        itemDisableLabel.textAlignment = .center
        itemDisableLabel.text = FoodieConstant.itemnotavail.localized
        itemDisableLabel.textColor = .red
          
        delBtn.setImage(UIImage(named:FoodieConstant.ic_delete), for: .normal)
        delBtn.imageView?.tintColor = .lightGray
        addonsLabel.textColor = .lightGray
        itemNotAvailableLabel.textColor = .white

        DispatchQueue.main.async {
            self.backView.addShadow(radius: 5.0, color: UIColor.foodieColor.withAlphaComponent(0.1))
        }
        setDarkMode()
    }
    
    private func setDarkMode(){
        self.backView.backgroundColor = .boxColor
    }
    @objc func tapCustomize(_ sender: UIButton){
        
        foodieAddonsgaDelegate?.addonsCustomize(tag: sender.tag)
    }
    
     func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0,y: 0,width:  width,height:  CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text

        label.sizeToFit()
        return label.frame.height
    }
    
}
protocol ShowAddonsDelegates {
    
    func addonsCustomize(tag: Int)
}



