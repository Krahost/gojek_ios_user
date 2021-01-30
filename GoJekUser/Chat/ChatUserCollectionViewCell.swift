//
//  ChatUserCollectionViewCell.swift
//  GoJekUser
//
//  Created by CSS15 on 11/05/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class ChatUserCollectionViewCell: UICollectionViewCell {
    
    weak var profileImageView: UIImageView?
    weak var baseTextView: CustomCornerView?
    weak var chatMessageTextView: UITextView?
    weak var deliveredStatusLbl: UILabel?
    weak var gradiantLayer: CAGradientLayer?
    
    var currentUser: Bool = false
    var leftLayoutConstraints: [NSLayoutConstraint] = []
    var rightLayoutConstraints: [NSLayoutConstraint] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        setUpViews()
    }
    
    
    func loadChatMessages(message: String?, currentUser: Bool) {
        
        var textColor = UIColor.brown
        let devliveredText = ""
        
        self.chatMessageTextView?.text = message
        self.profileImageView?.isHidden = true
        
        if(currentUser == true) {
            self.baseTextView?.backgroundColor = .appPrimaryColor
            
            self.chatMessageTextView?.textContainerInset = UIEdgeInsets.init(top: ScreenConstants.proportionalValueForValue(value: 12), left: ScreenConstants.proportionalValueForValue(value: 8.0), bottom: ScreenConstants.proportionalValueForValue(value: 8.0), right: ScreenConstants.proportionalValueForValue(value: 12.0))
            
            textColor = .white
            
            self.baseTextView?.corners = UIRectCorner.bottomLeft.union(UIRectCorner.topRight.union(.topLeft))
            
            NSLayoutConstraint.activate(self.rightLayoutConstraints)
            NSLayoutConstraint.deactivate(self.leftLayoutConstraints)
        }
        else {
            
            self.baseTextView?.backgroundColor = .gray
            
            self.chatMessageTextView?.textContainerInset = UIEdgeInsets.init(top: ScreenConstants.proportionalValueForValue(value: 12.0), left: ScreenConstants.proportionalValueForValue(value: 8.0), bottom: ScreenConstants.proportionalValueForValue(value: 8.0), right: ScreenConstants.proportionalValueForValue(value: 12.0))
            
            textColor = .white
            
            self.baseTextView?.corners = UIRectCorner.bottomRight.union(UIRectCorner.topRight.union(.topLeft))
            NSLayoutConstraint.deactivate(self.rightLayoutConstraints)
            NSLayoutConstraint.activate(self.leftLayoutConstraints)
        }
        
        self.chatMessageTextView?.textColor = textColor
        self.deliveredStatusLbl?.text = devliveredText
    }
    
    func setUpViews(){
        
        self.contentView.backgroundColor = UIColor.clear
        
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.image = UIImage(named: "ic_user")
        profileImageView.backgroundColor = .gray
        profileImageView.layer.cornerRadius = ScreenConstants.proportionalValueForValue(value: 20.0)
        profileImageView.layer.masksToBounds = true
        self.contentView.addSubview(profileImageView)
        self.profileImageView = profileImageView
        
        let baseView = CustomCornerView.init(backgroundColor: UIColor.white, radius: ScreenConstants.proportionalValueForValue(value: 10.0), cornerValue: [.topLeft, .topRight, .bottomRight])
        self.contentView.addSubview(baseView)
        self.baseTextView = baseView
        
        let chatMessageTextView = UITextView.CommonTextView(backgroundColor: .clear, textColor: UIColor.white, textFont: UIFont.setCustomFont(name: .medium, size: .x16))
        chatMessageTextView.setContentCompressionResistancePriority(.required, for: .horizontal)
        chatMessageTextView.setContentHuggingPriority(.required, for: .horizontal)
        chatMessageTextView.isUserInteractionEnabled = false
        chatMessageTextView.isScrollEnabled = false
        chatMessageTextView.bounces = false
        chatMessageTextView.keyboardType = .default
        chatMessageTextView.layer.cornerRadius = ScreenConstants.proportionalValueForValue(value: 10.0)
        chatMessageTextView.layer.masksToBounds = true
        chatMessageTextView.textContainerInset = UIEdgeInsets.init(top: ScreenConstants.proportionalValueForValue(value: 12.0), left: ScreenConstants.proportionalValueForValue(value: 8.0), bottom: ScreenConstants.proportionalValueForValue(value: 8.0), right: ScreenConstants.proportionalValueForValue(value: 12.0))
        self.baseTextView?.addSubview(chatMessageTextView)
        self.chatMessageTextView = chatMessageTextView
        
        let deliveredStatus = UILabel()
        deliveredStatus.translatesAutoresizingMaskIntoConstraints = false
        deliveredStatus.numberOfLines = 0
        deliveredStatus.backgroundColor = UIColor.white
        deliveredStatus.textColor = UIColor.black
        deliveredStatus.font = UIFont.setCustomFont(name: .bold, size: .x14)
        deliveredStatus.textAlignment = .right
        deliveredStatus.setContentCompressionResistancePriority(.required, for: .vertical)
        deliveredStatus.setContentHuggingPriority(.required, for: .vertical)
        self.contentView.addSubview(deliveredStatus)
        self.deliveredStatusLbl = deliveredStatus
        
        setUpConstraints()
    }
    
    func setUpConstraints() {
        
        //profileImageView
        self.profileImageView?.leadingAnchor.constraint(equalTo: (self.profileImageView?.superview?.leadingAnchor)!, constant: 0).isActive = true
        self.profileImageView?.topAnchor.constraint(equalTo: (self.profileImageView?.superview?.topAnchor)!, constant: ScreenConstants.proportionalValueForValue(value: 10.0)).isActive = true
        self.profileImageView?.widthAnchor.constraint(equalToConstant: 0).isActive = true
        self.profileImageView?.heightAnchor.constraint(equalToConstant: 0).isActive = true
        
        //chatMessageTextView
        
        self.leftLayoutConstraints.append(contentsOf: [(self.baseTextView?.leadingAnchor.constraint(equalTo: (self.profileImageView?.trailingAnchor)!, constant: 20))!, (self.baseTextView?.trailingAnchor.constraint(lessThanOrEqualTo: (self.baseTextView?.superview?.trailingAnchor)!, constant: -ScreenConstants.proportionalValueForValue(value: 60.0)))!])
        
        self.rightLayoutConstraints.append(contentsOf: [(self.baseTextView?.leadingAnchor.constraint(greaterThanOrEqualTo: (self.profileImageView?.trailingAnchor)!, constant: 60))!, (self.baseTextView?.trailingAnchor.constraint(equalTo: (self.baseTextView?.superview?.trailingAnchor)!, constant: -20))!])
        
        self.baseTextView?.topAnchor.constraint(equalTo: (self.baseTextView?.superview?.topAnchor)!).isActive = true
        
        //chatMessageTextView
        self.chatMessageTextView?.leadingAnchor.constraint(equalTo: (self.chatMessageTextView?.superview?.leadingAnchor)!).isActive = true
        self.chatMessageTextView?.trailingAnchor.constraint(equalTo: (self.chatMessageTextView?.superview?.trailingAnchor)!).isActive = true
        self.chatMessageTextView?.topAnchor.constraint(equalTo: (self.chatMessageTextView?.superview?.topAnchor)!).isActive = true
        self.chatMessageTextView?.bottomAnchor.constraint(equalTo: (self.chatMessageTextView?.superview?.bottomAnchor)!).isActive = true
        
        //deliveredStatusLbl
        self.deliveredStatusLbl?.topAnchor.constraint(equalTo: (self.baseTextView?.bottomAnchor)!, constant:10).isActive = true
        self.deliveredStatusLbl?.trailingAnchor.constraint(equalTo: (self.deliveredStatusLbl?.superview?.trailingAnchor)!, constant: -ScreenConstants.proportionalValueForValue(value: 16.0)).isActive = true
        self.deliveredStatusLbl?.bottomAnchor.constraint(equalTo: (self.deliveredStatusLbl?.superview?.bottomAnchor)!, constant: 0.0).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
