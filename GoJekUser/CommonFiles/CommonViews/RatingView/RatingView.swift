//
//  RatingView.swift
//  GoJekUser
//
//  Created by Ansar on 05/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class RatingView: UIView {
    
    @IBOutlet weak var ratingTitleLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var rateDriverLabel: UILabel!
    @IBOutlet weak var providerInnerView: UIView!
    
    @IBOutlet weak var ratingProviderView: UIView!
    @IBOutlet weak var leaveCommentTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var userNameView: UIView!
    @IBOutlet weak var ratingOuterView: UIView!
    
    @IBOutlet weak var userNameImage: UIImageView!
    @IBOutlet weak var ratingView: FloatRatingView!
    
    var onClickSubmit:((_ rating: Int, _ comments: String)->Void)?


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

extension RatingView {
    
    
    
    private func initialLoads() {
        setFont()
//        KeyboardManager.shared.keyBoardShowHide(view: self)
        setRating()
        submitButton.addTarget(self, action: #selector(tapSubmit), for: .touchUpInside)
        leaveCommentTextView.delegate = self
        ratingOuterView.backgroundColor = .veryLightGray
        rateDriverLabel.text = Constant.rateDriver.localized
        ratingTitleLabel.text = Constant.rating.localized
        submitButton.setTitle(Constant.SSubmit.localized, for: .normal)
        leaveCommentTextView.text = Constant.leaveComment.localized
        leaveCommentTextView.textColor = .lightGray
        setFont()
        ratingView.type = .wholeRatings
        leaveCommentTextView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 0, right: 12)
        ratingTitleLabel.textColor = .black
         setDarkMode()
    }
    
    private func setDarkMode(){
        self.ratingOuterView.backgroundColor = .boxColor
        self.ratingTitleLabel.textColor = .blackColor
        self.leaveCommentTextView.textColor = .blackColor
        self.leaveCommentTextView.backgroundColor = .backgroundColor
        self.providerInnerView.backgroundColor = .boxColor
        self.userNameView.backgroundColor = .backgroundColor
    }
    
    
    private func setFont() {
        ratingTitleLabel.font = .setCustomFont(name: .medium, size: .x24)
        userNameLabel.font = .setCustomFont(name: .medium, size: .x18)
        idLabel.font = .setCustomFont(name: .medium, size: .x12)
        rateDriverLabel.font = .setCustomFont(name: .medium, size: .x16)
        leaveCommentTextView.font = .setCustomFont(name: .light, size: .x16)
        submitButton.titleLabel?.font = .setCustomFont(name: .bold, size: .x18)

    }
    
    private func setRating() {
        ratingView.minRating = 1
        ratingView.maxRating = 5
        ratingView.rating = 5
        ratingView.emptyImage = UIImage(named: Constant.ratingEmptyImage)
        ratingView.fullImage = UIImage(named: Constant.ratingFull)
    }
    
    func setValues(color: UIColor) {
        submitButton.backgroundColor = color
        idLabel.textColor = color
    }
    
    @objc func tapSubmit() {
        onClickSubmit!(Int(ratingView.rating),leaveCommentTextView.text)
    }
}


extension RatingView: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == Constant.leaveComment.localized {
            textView.text = .empty
            textView.textColor = .blackColor
        }
        return true
    }
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text == .empty {
            leaveCommentTextView.text = Constant.leaveComment.localized
            leaveCommentTextView.textColor = .backgroundColor
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        endEditing(true)
    }
}
