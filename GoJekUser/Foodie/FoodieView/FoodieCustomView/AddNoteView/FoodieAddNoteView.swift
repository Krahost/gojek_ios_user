//
//  FoodieAddNoteView.swift
//  GoJekUser
//
//  Created by Thiru on 07/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class FoodieAddNoteView: UIView {
    
    @IBOutlet weak var addnoteBGView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    
    var onClickClose:(()->Void)?
    var onClickSubmit:(()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialLoad()
    }
    
}
extension FoodieAddNoteView {
    
    private func initialLoad() {
        
        DispatchQueue.main.async {
            self.addnoteBGView.setCornerRadiuswithValue(value: 5)
            self.notesTextView.setCornerRadiuswithValue(value: 5)
        }
        self.notesTextView.text = FoodieConstant.writeNote.localized
        self.notesTextView.textColor = .lightGray
        self.notesTextView.delegate = self
        submitButton.addTarget(self, action: #selector(submitAciton), for: .touchUpInside)
    }

    @objc func submitAciton() {
        
        self.onClickSubmit!()
    }
}

extension FoodieAddNoteView: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == FoodieConstant.writeNote.localized {
            textView.text = .empty
            textView.textColor = .black
        }
        return true
    }
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text == .empty {
            self.notesTextView.text = FoodieConstant.writeNote.localized
            self.notesTextView.textColor = .lightGray
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.onClickClose!()
        self.endEditing(true)
    }
}
