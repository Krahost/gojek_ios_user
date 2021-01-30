//
//  CartPageTableViewCell.swift
//  GoJekUser
//
//  Created by CSS on 03/07/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

protocol CartHeaderViewDelegate {
    func addRemoveNote()
    func editNote()
    
}

class CartPageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var noteView: UIStackView!
    @IBOutlet weak var cartHeaderBGView: UIView!
    @IBOutlet weak var reastaurantLogoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descrLabel: UILabel!
    @IBOutlet weak var faviIcon: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var itemAvailLabel: UILabel!
    @IBOutlet weak var addNoteButton: UIButton!
    
    @IBOutlet weak var editNoteButton: UIButton!
    
    var addNoteView: FoodieAddNoteView!
    var delegate: CartHeaderViewDelegate?
    
    var isRemoveNote: Bool = false {
        didSet {
            self.editNoteButton.isHidden = !isRemoveNote
            self.addNoteButton.setTitle(!isRemoveNote ? FoodieConstant.addNote.localized.uppercased() : FoodieConstant.removeNote.localized.uppercased(), for: .normal)
        }
    }
    
    override func layoutSubviews() {
        DispatchQueue.main.async {
            self.cartHeaderBGView.setCornerRadiuswithValue(value: 5)
            self.reastaurantLogoImageView.setCornerRadiuswithValue(value: 5)
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
    
}
extension CartPageTableViewCell {
    
    private func initialLoad() {
        contentView.backgroundColor = .backgroundColor
        noteView.isHidden = true
        reastaurantLogoImageView.image = UIImage.init(named: FoodieConstant.imagePlaceHolder)
        editNoteButton.setImage(UIImage(named: Constant.editImage), for: .normal)
        editNoteButton.tintColor = .foodieColor
        isRemoveNote = false
        editNoteButton.addTarget(self, action: #selector(tapEditNote), for: .touchUpInside)
        addNoteButton.addTarget(self, action: #selector(addNoteAction), for: .touchUpInside)
        faviIcon.isHidden = true
        itemAvailLabel.text = FoodieConstant.itemAvailbale.localized.uppercased()
        nameLabel.font = .setCustomFont(name: .medium, size: .x20)
        descrLabel.font = .setCustomFont(name: .light, size: .x14)
        ratingLabel.font = .setCustomFont(name: .light, size: .x18)
        itemAvailLabel.font = .setCustomFont(name: .medium, size: .x16)
        addNoteButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x16)
        
        faviIcon.image = UIImage.init(named: FoodieConstant.ic_resFav)
        ratingImageView.image = UIImage.init(named: FoodieConstant.ic_starfilled)?.imageTintColor(color1: .foodieColor)
        setColors()
    }
    
    private func setColors() {
        
        self.cartHeaderBGView.backgroundColor = .boxColor
    }
    

    @objc func addNoteAction() {
        delegate?.addRemoveNote()
    }
    
    @objc func tapEditNote() {
        delegate?.editNote()
    }
}
