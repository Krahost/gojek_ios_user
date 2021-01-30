//
//  FoodieRatingView.swift
//  GoJekUser
//
//  Created by CSS on 08/05/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation
import UIKit

class FoodieRatingView: UIView {
    
@IBOutlet weak var providerRateView: UIView!
@IBOutlet weak var ratingProviderView: UIView!
@IBOutlet weak var ratingTitleLabel: UILabel!
@IBOutlet weak var userNameLabel: UILabel!
@IBOutlet weak var ratingCountLabel: UILabel!
@IBOutlet weak var rateDriverLabel: UILabel!
@IBOutlet weak var restaurantRatingView: FloatRatingView!
@IBOutlet weak var rateRestaurantLabel: UILabel!
@IBOutlet weak var submitButton: UIButton!
@IBOutlet weak var leaveCommentTextView: UITextView!
@IBOutlet weak var userNameView: UIView!
@IBOutlet weak var ratingOuterView: UIView!
@IBOutlet weak var userNameImage: UIImageView!
@IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var providerInnerView: UIView!

var onClickSubmit:((_ rating: Int, _ comments: String, _ shopRating: Int)->Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        initialLoads()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async {
            if CommonFunction.checkisRTL() {
                self.userNameView.setOneSideCorner(corners: [.topRight,.bottomRight], radius: self.userNameView.frame.height/2)
            }else {
                self.userNameView.setOneSideCorner(corners: [.topLeft,.bottomLeft], radius: self.userNameView.frame.height/2)
            }
            self.userNameImage.setCornerRadius()
        }
    }
}

extension FoodieRatingView {
    
    private func setDarkMode(){
        self.ratingOuterView.backgroundColor = .boxColor
        self.ratingTitleLabel.textColor = .blackColor
        self.leaveCommentTextView.textColor = .blackColor
        self.leaveCommentTextView.backgroundColor = .backgroundColor
        self.providerInnerView.backgroundColor = .boxColor
        self.userNameView.backgroundColor = .backgroundColor
        rateDriverLabel.textColor = .blackColor
        
    }
    private func initialLoads() {
        setRating()
        self.submitButton.addTarget(self, action: #selector(tapSubmit), for: .touchUpInside)
        self.leaveCommentTextView.delegate = self
        self.ratingOuterView.backgroundColor = .veryLightGray
        rateDriverLabel.text = Constant.rateDriver.localized
        ratingTitleLabel.text = Constant.rating.localized
        rateRestaurantLabel.text = Constant.rateRestaurant.localized
        self.submitButton.setTitle(Constant.SSubmit.localized, for: .normal)
        self.leaveCommentTextView.text = Constant.leaveComment.localized
        self.leaveCommentTextView.textColor = .lightGray
        ratingTitleLabel.textColor = .black
        rateDriverLabel.textColor = .black
        shopsRating()
        ratingView.type = .wholeRatings
        setFont()
        setDarkMode()
    }
    
    private func setFont(){
        submitButton.titleLabel?.font = .setCustomFont(name: .bold, size: .x18)
        userNameLabel.font = .setCustomFont(name: .medium, size: .x18)
        rateRestaurantLabel.font = .setCustomFont(name: .light, size: .x14)
        ratingTitleLabel.font = .setCustomFont(name: .medium, size: .x24)
        rateDriverLabel.font = .setCustomFont(name: .medium, size: .x16)
        leaveCommentTextView.font = .setCustomFont(name: .light, size: .x16)
    }
    
    private func shopsRating() {
        self.restaurantRatingView.minRating = 1
        self.restaurantRatingView.maxRating = 5
        self.restaurantRatingView.rating = 5
        self.restaurantRatingView.emptyImage = UIImage(named: Constant.ratingEmptyImage)
        self.restaurantRatingView.fullImage = UIImage(named: Constant.ratingFull)
        self.restaurantRatingView.emptyTintColor = .lightGray
    }
    
    private func setRating() {
        self.ratingView.minRating = 1
        self.ratingView.maxRating = 5
        self.ratingView.rating = 5
        self.ratingView.emptyImage = UIImage(named: Constant.ratingEmptyImage)
        self.ratingView.fullImage = UIImage(named: Constant.ratingFull)
        self.ratingView.emptyTintColor = .lightGray
    }
    
    func setValues(color: UIColor) {
        self.submitButton.backgroundColor = color
        self.ratingCountLabel.textColor = color
    }
    
    @objc func tapSubmit() {
        var comment = ""
        if leaveCommentTextView.text != Constant.leaveComment.localized {
            comment = leaveCommentTextView.text
        }
        self.onClickSubmit!(Int(ratingView.rating),comment, Int(restaurantRatingView.rating))
    }

}


extension FoodieRatingView: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == Constant.leaveComment.localized {
            textView.text = .empty
            textView.textColor = .blackColor
        }
        return true
    }
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text == .empty {
            self.leaveCommentTextView.text = Constant.leaveComment.localized
            self.leaveCommentTextView.textColor = .lightGray
        }
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
}
