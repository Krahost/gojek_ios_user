//
//  ChatTypeMessageView.swift
//  GoJekUser
//
//  Created by CSS15 on 10/05/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class ChatTypeMessageView: UIView {
    
    weak var sendBtn: UIButton?
    weak var messageTextView: UITextView!
    weak var textViewHeightConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        
        super.init(frame: frame) // calls designated initializer
        self.translatesAutoresizingMaskIntoConstraints = false
        self.sendBtn?.isUserInteractionEnabled = false
        self.backgroundColor = .white
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews() {
        
        let messageTextView = UITextView()
        messageTextView.translatesAutoresizingMaskIntoConstraints = false
        messageTextView.backgroundColor = .veryLightGray
        messageTextView.textColor = .black
        messageTextView.layer.cornerRadius = 10.0
        messageTextView.font = UIFont.setCustomFont(name: .light, size: .x16)
        messageTextView.layer.masksToBounds = true
        messageTextView.tintColor = .appPrimaryColor
        messageTextView.keyboardDismissMode = .onDrag
        self.addSubview(messageTextView)
        self.messageTextView = messageTextView
        self.messageTextView.centerVertically()

        let sendBtn = UIButton.CustomButton(target: self, selector: nil)
        sendBtn.layer.cornerRadius = ScreenConstants.proportionalValueForValue(value: 20.0)
        sendBtn.layer.masksToBounds = true
        sendBtn.backgroundColor = .veryLightGray
        let image = UIImage(named: "send-button")?.withRenderingMode(.alwaysTemplate)
        sendBtn.setImage(image, for: .normal)
        sendBtn.tintColor = .white
        self.addSubview(sendBtn)
        self.sendBtn = sendBtn
        
        setUpConstraint()
    }
    
    func setUpConstraint() {
        
        //messageTextView
        messageTextView?.leadingAnchor.constraint(equalTo: (self.messageTextView?.superview?.leadingAnchor)!, constant: ScreenConstants.proportionalValueForValue(value: 20.0)).isActive = true
        messageTextView?.trailingAnchor.constraint(equalTo: (messageTextView?.superview?.trailingAnchor)!, constant: -ScreenConstants.proportionalValueForValue(value: 70.0)).isActive = true
        messageTextView?.topAnchor.constraint(equalTo: (messageTextView?.superview?.topAnchor)!, constant: ScreenConstants.proportionalValueForValue(value: 16.0)).isActive = true
        let textViewHeightConstraint = messageTextView?.heightAnchor.constraint(equalToConstant: 40.0)
        textViewHeightConstraint?.isActive = true
        self.textViewHeightConstraint = textViewHeightConstraint!
        messageTextView?.bottomAnchor.constraint(equalTo: (messageTextView?.superview?.bottomAnchor)!, constant: -ScreenConstants.proportionalValueForValue(value: 16.0)).isActive = true
        
        //sendBtn
        self.sendBtn?.trailingAnchor.constraint(equalTo: (self.sendBtn?.superview?.trailingAnchor)!, constant: -ScreenConstants.proportionalValueForValue(value: 16.0)).isActive = true
        self.sendBtn?.widthAnchor.constraint(equalToConstant: ScreenConstants.proportionalValueForValue(value: 40.0)).isActive = true
        self.sendBtn?.heightAnchor.constraint(equalToConstant: ScreenConstants.proportionalValueForValue(value: 40.0)).isActive = true
        self.sendBtn?.centerYAnchor.constraint(equalTo: (self.sendBtn?.superview?.centerYAnchor)!, constant: 0.0).isActive = true
    }
}

