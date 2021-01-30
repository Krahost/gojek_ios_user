//
//  ChatViewController.swift
//  GoJekUser
//
//  Created by CSS15 on 10/05/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire
import IQKeyboardManagerSwift

var isChatOpened = false
class ChatViewController: UIViewController {
    
    fileprivate weak var chatTypeMsgView: ChatTypeMessageView?
    fileprivate weak var chatCollectionView: UICollectionView?
    fileprivate weak var typeMessageViewBottomConstraint: NSLayoutConstraint?

    var messageMutableArray: [ChatDataEntity] = Array()
    
    var requestId: String?
    var userName: String?
    var providerName: String?
    var userId: String?
    var providerId: String?
    var adminServiceId: String?
    var chatRequestFrom: String?
    
    var isChatPresented:Bool = false // avoiding multiple screens redirectns,if same push comes multiple times
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isChatPresented = true
        isChatOpened = true
        self.title = providerName ?? Constant.tChat
        getUserChatHistory()
        setNavigationTitle()
        setUpSubView()
        self.setNavigationBar()
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.enable = false
        hideMyKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self,
           selector: #selector(self.keyboardWasShown(notification:)),
           name: UIResponder.keyboardWillShowNotification,
           object: nil)
        NotificationCenter.default.addObserver(self,
                 selector: #selector(self.keyboardWasHide(notification:)),
                 name: UIResponder.keyboardDidHideNotification,
                 object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)

    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
      }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        setSocket()
        self.hideTabBar()

    }
    private func setNavigationBar() {
        self.setNavigationTitle()
        self.setLeftBarButtonWith(color: .blackColor)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           isChatOpened = false
           IQKeyboardManager.shared.enableAutoToolbar = true
           IQKeyboardManager.shared.enable = true
       }
}

extension ChatViewController {
    
    fileprivate func setUpSubView() {
        
        self.view.backgroundColor = .backgroundColor
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let collecttionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collecttionView.translatesAutoresizingMaskIntoConstraints = false
        collecttionView.showsVerticalScrollIndicator = false
        collecttionView.showsHorizontalScrollIndicator = false
        collecttionView.delegate = self
        collecttionView.dataSource = self
        collecttionView.backgroundColor = .backgroundColor
        collecttionView.register(ChatUserCollectionViewCell.self, forCellWithReuseIdentifier: ChatUserCollectionViewCell.reuseIdentifier)
        self.view.addSubview(collecttionView)
        self.chatCollectionView = collecttionView
        let chatTypeView = ChatTypeMessageView()
        chatTypeView.messageTextView.delegate = (self as UITextViewDelegate)
        chatTypeView.sendBtn?.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        self.view.addSubview(chatTypeView)
        self.chatTypeMsgView = chatTypeView
        
        setupViewContraints()
    }
    
    func setupViewContraints() {
        
        //chatCollectionView

        if #available(iOS 11.0, *) {
            
            self.chatCollectionView?.topAnchor.constraint(equalTo: ((chatCollectionView?.superview!.safeAreaLayoutGuide.topAnchor)!)).isActive = true

            self.typeMessageViewBottomConstraint =  chatTypeMsgView?.bottomAnchor.constraint(equalTo: (chatTypeMsgView?.superview?.bottomAnchor)!)
            
            self.chatCollectionView?.contentInsetAdjustmentBehavior = .never
            self.chatCollectionView?.contentInset = .init(top: 30, left: 0, bottom: 25, right: 0)
            
        } else {
            
            self.automaticallyAdjustsScrollViewInsets = false
            
            self.chatCollectionView?.topAnchor.constraint(equalTo: (self.chatCollectionView?.superview?.topAnchor)!).isActive = true

            self.typeMessageViewBottomConstraint =  chatTypeMsgView?.bottomAnchor.constraint(equalTo: (chatTypeMsgView?.superview?.bottomAnchor)!)
        }
        
        self.typeMessageViewBottomConstraint?.isActive = true
        
        self.chatCollectionView?.leadingAnchor.constraint(equalTo: (self.chatCollectionView?.superview?.leadingAnchor)!).isActive = true
        self.chatCollectionView?.trailingAnchor.constraint(equalTo: (self.chatCollectionView?.superview?.trailingAnchor)!).isActive = true
        self.chatCollectionView?.bottomAnchor.constraint(equalTo: (self.chatTypeMsgView?.topAnchor)!).isActive = true
        
        
        //chatTypeMessageView
        self.chatTypeMsgView?.leadingAnchor.constraint(equalTo: (self.chatTypeMsgView?.superview?.leadingAnchor)!, constant: 0).isActive = true
        self.chatTypeMsgView?.trailingAnchor.constraint(equalTo: (self.chatTypeMsgView?.superview?.trailingAnchor)!, constant: 0).isActive = true
        
//         self.chatTypeMsgView?.heightAnchor.constraint(greaterThanOrEqualToConstant: 50)
    }

    func getUserChatHistory() {
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
   
        //Get all message
            let param: Parameters = [Constant.adminService: self.chatRequestFrom ?? String.empty,
                                     Constant.id: self.requestId ?? String.empty]
        self.homePresenter?.getUserChatHistory(param: param)
//         }
    }
    
    func retriveMessageData() {
        
        UIView.animate(withDuration: 0.0, animations: {
            
            self.chatCollectionView?.reloadData()
            
        }, completion: { (finished) in
            
            if self.messageMutableArray.count > 0 {
                self.chatCollectionView?.scrollToLastItem(animated: false)
            }
        })
    }
    
    @objc func willEnterForeground() {
//        BackGroundRequestManager.share.resetBackGroudTask()
        setSocket()
        self.getUserChatHistory()
    }
    
    
    func setSocket(){
        let saltKey = APPConstant.salt_key.fromBase64()
        let inputString = "room_\(saltKey ?? String.empty)_R\(requestId ?? String.empty)_U\(userId ?? String.empty)_P\(providerId ?? String.empty)_\(chatRequestFrom?.uppercased() ?? String.empty)"
        XSocketIOManager.sharedInstance.chatCheckSocketRequest(input: inputString) { [weak self] (response) in
            guard let self = self else {
                return
            }
            self.getUserChatHistory()

//            self.messageMutableArray.append(response)
//            self.chatTypeMsgView?.textViewHeightConstraint?.constant = ScreenConstants.proportionalValueForValue(value: 40.0)
//            self.chatTypeMsgView?.layoutIfNeeded()
//            self.retriveMessageData()
        }
    }
}

//MARK: - IBAction

extension ChatViewController {
    
    public func hideMyKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissMyKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboard() {
            self.typeMessageViewBottomConstraint?.constant = 0
            self.chatTypeMsgView?.messageTextView.resignFirstResponder()
    }
    
    
    @objc func valuechanged(_ textView: UITextView) {
        
        let count = self.trimWhiteSpace(textView).count
        if (count > 0) {
            self.chatTypeMsgView?.sendBtn?.backgroundColor = .appPrimaryColor
            self.chatTypeMsgView?.sendBtn?.isUserInteractionEnabled = true
        }
        else {
            self.chatTypeMsgView?.sendBtn?.backgroundColor = .lightGray
            self.chatTypeMsgView?.sendBtn?.isUserInteractionEnabled = false
        }
    }
    
    
    @objc func keyboardWasShown(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        self.typeMessageViewBottomConstraint?.constant = -(keyboardFrame.size.height)
    }
    
    
    @objc func keyboardWasHide(notification: NSNotification) {
        self.typeMessageViewBottomConstraint?.constant = 0
    }
    
    @objc func sendMessage(_ sender: UIButton) {
        
        guard let messge = self.chatTypeMsgView?.messageTextView.text else {
            return
        }
        
        let baseUrl = AppConfigurationManager.shared.getBaseUrl()
        let saltKey = APPConstant.salt_key
        let inputString = "room_\(saltKey.fromBase64() ?? String.empty)_R\(requestId ?? String.empty)_U\(userId ?? String.empty)_P\(providerId ?? String.empty)_\(chatRequestFrom?.uppercased() ?? String.empty)"
        let socketMessagew = [Constant.adminService: chatRequestFrom?.uppercased() ?? String.empty,
                              Constant.saltKey: saltKey,
                              Constant.PUrl: baseUrl+AccountAPI.KChat,
                              Constant.id: requestId ?? String.empty,
                              Constant.provider: userName ?? String.empty,
                              Constant.user: providerName ?? String.empty,
                              Constant.message: messge,
                              Constant.type: Constant.user,
                              Constant.room: inputString]
        
        XSocketIOManager.sharedInstance.setChatToSocketRequest(input: socketMessagew)
        self.getUserChatHistory()

        DispatchQueue.main.async {
            self.chatTypeMsgView?.messageTextView.text = String.empty
            self.chatTypeMsgView?.sendBtn?.backgroundColor = .lightGray
            self.chatTypeMsgView?.sendBtn?.isUserInteractionEnabled = false
            self.chatTypeMsgView?.textViewHeightConstraint?.constant = 40
            self.chatTypeMsgView?.layoutIfNeeded()


        }
    }
}

//MARK: - UITextViewDelegate

extension ChatViewController: UITextViewDelegate {
   
    
    func textViewDidChange(_ textView: UITextView) {
        self.valuechanged(textView)
        let numLines = Int(textView.contentSize.height) / Int((textView.font?.lineHeight)!)
        if(numLines <= 6) {
            chatTypeMsgView?.textViewHeightConstraint?.constant = textView.contentSize.height + 10
        }
    }
    
    func trimWhiteSpace(_ textView: UITextView) -> String {
        
        return textView.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    
}

//MARK: - UICollectionViewDataSource
extension ChatViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return messageMutableArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatUserCollectionViewCell.reuseIdentifier, for: indexPath) as? ChatUserCollectionViewCell
        
        let chatDetail = messageMutableArray[indexPath.row]
        let message = chatDetail.message ?? ""
        let text = message.trimmingCharacters(in: .whitespacesAndNewlines)
        let currentUser = chatDetail.type?.uppercased() == Constant.provider.uppercased() ? false : true
        cell?.loadChatMessages(message: text, currentUser: currentUser)
        return cell!
    }
}

//MARK: - UICollectionViewDelegate

extension ChatViewController: UICollectionViewDelegate {
    
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ChatViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if (self.messageMutableArray.count > 0) {
            let chatDetail = self.messageMutableArray[indexPath.row]
            let message = chatDetail.message
            let text = message?.trimmingCharacters(in: .whitespacesAndNewlines)
            let maximumWidth = collectionView.bounds.width - ScreenConstants.proportionalValueForValue(value: 100.0)
            let messageRect = NSString(string: text!).boundingRect(with: CGSize(width: maximumWidth, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.setCustomFont(name: .light, size: .x16)], context: nil)
            let textMessageContentHeight = messageRect.height
            let messageHeight = (textMessageContentHeight + ScreenConstants.proportionalValueForValue(value: 40.0))
            return CGSize(width: collectionView.frame.width, height: messageHeight)
        }
        else {
            return CGSize(width: 0, height: 0)
        }
    }
}

//MARK: - AccountPresenterToAccountViewProtocol

extension ChatViewController: HomePresenterToHomeViewProtocol {

    func getUserChatHistoryResponse(chatEntity: ChatEntity) {
        let chatList = chatEntity.responseData?.first
        self.messageMutableArray = []
        self.messageMutableArray = chatList?.data ?? []
        self.retriveMessageData()
    }
}
