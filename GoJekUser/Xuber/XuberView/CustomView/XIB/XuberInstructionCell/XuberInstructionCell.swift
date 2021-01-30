//
//  XuberInstructionCell.swift
//  GoJekUser
//
//  Created by Ansar on 19/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class XuberInstructionCell: UITableViewCell {
    
    @IBOutlet weak var documentOuterView: UIView!
    @IBOutlet weak var instructionTextView: UITextView!
    
    @IBOutlet weak var documentIcon: UIImageView!
    @IBOutlet weak var instructionImage: UIImageView!
    
    @IBOutlet weak var instructionStaticLabel: UILabel!
    @IBOutlet weak var instructionMsgLabel: UILabel!
    
    var onTapImage:(()->Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        instructionTextView.delegate = self
        instructionTextView.text = XuberConstant.enterInstruction.localized
        instructionTextView.textColor = .lightGray
        instructionTextView.setBorder(width: 1.0, color: .lightGray)
        documentOuterView.backgroundColor = UIColor.xuberColor.withAlphaComponent(0.3)
        documentIcon.image = UIImage(named: XuberConstant.documentImage)
        documentIcon.imageTintColor(color1: .xuberColor)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapImage))
        self.instructionImage.addGestureRecognizer(gesture)
        self.instructionImage.setCornerRadiuswithValue(value: 5)
        setFont()
        localize()
        instructionMsgLabel.textColor = .xuberColor
        setDarkMode()
    }
    
    private func setDarkMode(){
        self.contentView.backgroundColor = .boxColor
//        self.instructionTextView.textColor = .blackColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        instructionTextView.setCornerRadiuswithValue(value: 5.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func tapImage() {
        self.endEditing()
        self.onTapImage!()
    }
    
    private func setFont() {
        instructionStaticLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        instructionTextView.font = UIFont.setCustomFont(name: .medium, size: .x14)
 
        instructionMsgLabel.font = UIFont.setCustomFont(name: .medium, size: .x8)
    }
    
    private func localize() {
        instructionStaticLabel.text = XuberConstant.instruction.localized
        instructionMsgLabel.text = XuberConstant.uploadImage.localized
    }
}


extension XuberInstructionCell: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == XuberConstant.enterInstruction.localized {
            textView.text = .empty
            textView.textColor = .blackColor
        }
        return true
    }
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text == .empty {
            self.instructionTextView?.text = XuberConstant.enterInstruction.localized
            self.instructionTextView?.textColor = .lightGray
        }
        if textView.text.count > 0 {
            SendRequestInput.shared.instruction = textView.text
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
}
