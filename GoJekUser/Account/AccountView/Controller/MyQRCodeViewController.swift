//
//  MyQRCodeViewController.swift
//  GoJekUser
//
//  Created by AppleMac on 02/03/20.
//  Copyright © 2020 Appoets. All rights reserved.
//

import UIKit
import SDWebImage

class MyQRCodeViewController: UIViewController {
    
    @IBOutlet weak var myQRImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBar()
        self.accountPresenter?.fetchUserProfileDetails()
    }
    
    private func setNavigationBar() {
        
        self.setNavigationTitle()
        self.setLeftBarButtonWith(color: .blackColor)
        self.title = AccountConstant.myQRcode.localized
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.view.backgroundColor = .backgroundColor
    }
}

//MARK:- AccountPresenterToAccountViewProtocol

extension MyQRCodeViewController: AccountPresenterToAccountViewProtocol {
    
    func showUserProfileDtails(details: UserProfileResponse) {
        if let profileDetail = details.responseData{
            AppManager.shared.setUserDetails(details: profileDetail)
            
            let tempImage = UIImage(named: AccountConstant.ic_scan)
            if let imageUrl = URL(string: profileDetail.qrcode_url ?? "") {
                
                myQRImage.sd_setImage(with: imageUrl, placeholderImage: tempImage,options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                    // Perform operation.
                    if (error != nil) {
                        // Failed to load image
                        self.myQRImage.image = tempImage
                    } else {
                        // Successful in loading image
                        self.myQRImage.image = image
                    }
                })
                self.myQRImage.imageTintColor(color1: .blackColor)
            }
        }
    }
}
