//
//  WalkThroughController.swift
//  GoJekUser
//
//  Created by Ansar on 20/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Crashlytics

class WalkThroughController: UIViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var walkThroughCollectionView: UICollectionView!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var guestButton: UIButton!
    @IBOutlet weak var segmentView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var siginUpContainerView: UIView!
    
    var lottieFileArray: [AnimationModel]!
    
    //MARK:- Local Variable
    var currentPage = 0 {
        didSet {
            UIView.animate(withDuration: 0.1) {
                for view in self.stackView.subviews {
                    view.setCornerRadius()
                    if view.tag == self.currentPage {
                        view.backgroundColor = .appPrimaryColor
                    }else{
                        view.backgroundColor = .veryLightGray
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoads()
        lottieFileArray = [AnimationModel]()
        lottieFileArray.append(AnimationModel(title: Constant.serviceSelection, description: Constant.descriptionOne, fileName: Constant.Xjek_User_01))
        lottieFileArray.append(AnimationModel(title: Constant.serviceOngoing, description: Constant.descriptionTwo, fileName: Constant.Xjek_User_02))
        lottieFileArray.append(AnimationModel(title: Constant.rateService, description: Constant.descriptionThree, fileName: Constant.Xjek_User_03))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let theTouch = touches.first {
            let touchLocation = theTouch.location(in: self.view)
            let x = touchLocation.x
            let y = touchLocation.y
            if y > siginUpContainerView.frame.origin.y { return }
            let val = (x/self.view.frame.size.width)
            DispatchQueue.main.async {
                LottieViewManager.lottieView.currentProgress = val
            }
        }
    }
}

//MARK: - ButtonAction

extension WalkThroughController {
    
    @objc func tapSignIn() {
        isGuestAccount = false
        let loginViewcontroller =  LoginRouter.loginStoryboard.instantiateViewController(withIdentifier: LoginConstant.SignInController)
        navigationController?.pushViewController(loginViewcontroller, animated: true)
    }
    
    @objc func tapSignUp() {
        isGuestAccount = false
        let vc = LoginRouter.loginStoryboard.instantiateViewController(withIdentifier: LoginConstant.SignUpController)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func tapGuest() {
        isGuestAccount = true
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        appDelegate.window?.rootViewController = TabBarController().listTabBarController()
        appDelegate.window?.makeKeyAndVisible()
    }
}

//MARK: - UICollectionViewDataSource

extension WalkThroughController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: WalkThroughCell = walkThroughCollectionView.dequeueReusableCell(withReuseIdentifier: LoginConstant.WalkThroughCell, for: indexPath) as! WalkThroughCell
        cell.playAnimation(animationDetails: lottieFileArray[indexPath.row])
        
        return cell
    }
}


//MARK: - UICollectionViewDelegate

extension WalkThroughController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        cell.alpha = 0
        cell.layer.transform = CATransform3DMakeScale(0.5, 0.5, 0.5)
        UIView.animate(withDuration: 0.5) {
            cell.alpha = 1
            cell.layer.transform = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
            let cell:WalkThroughCell = self.walkThroughCollectionView.dequeueReusableCell(withReuseIdentifier: LoginConstant.WalkThroughCell, for: indexPath) as! WalkThroughCell
            cell.contentView.backgroundColor = .backgroundColor
            cell.playAnimation()
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension WalkThroughController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: walkThroughCollectionView.frame.width, height: walkThroughCollectionView.frame.height)
    }
}

//MARK: - Local Methods

extension WalkThroughController {
    
    //View initial loads
    private func initialLoads() {
        signInButton.layer.borderWidth = 2.0
        signInButton.layer.borderColor = UIColor.appPrimaryColor.cgColor
        signInButton.textColor(color: .appPrimaryColor)
        signUpButton.textColor(color: .white)
        guestButton.textColor(color: .black)
        guestButton.layer.shadowColor = UIColor.lightGray.cgColor
        signUpButton.backgroundColor = .appPrimaryColor
        signInButton.addTarget(self, action: #selector(tapSignIn), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(tapSignUp), for: .touchUpInside)
        guestButton.addTarget(self, action: #selector(tapGuest), for: .touchUpInside)
        signInButton.setTitle(LoginConstant.signIn.localized, for: .normal)
        signUpButton.setTitle(LoginConstant.signUp.localized, for: .normal)
        guestButton.setTitle(LoginConstant.connectGuest.localized, for: .normal)
        currentPage = 0
        
        //Tableview cell nib setup
        walkThroughCollectionView.register(nibName: LoginConstant.WalkThroughCell)
        
        DispatchQueue.main.async {
            self.signInButton.setBothCorner()
            self.signUpButton.setBothCorner()
            self.guestButton.setBothCorner()
        }
        setFont()
        setDarkMode()
    }
    
    func setDarkMode(){
        self.view.backgroundColor = .backgroundColor
        self.walkThroughCollectionView.backgroundColor = .backgroundColor
    }
    
    private func setFont() {
        signUpButton.titleLabel?.font = .setCustomFont(name: .bold, size: .x16)
        signInButton.titleLabel?.font = .setCustomFont(name: .bold, size: .x16)
        guestButton.titleLabel?.font = .setCustomFont(name: .bold, size: .x16)
    }
    
    private func checkAlreadyLogin() -> Bool {
        let fetchData = try! PersistentManager.shared.context.fetch(LoginData.fetchRequest()) as? [LoginData]
        if (fetchData?.count ?? 0) <= 0 {
            return false
        }
        AppManager.shared.accessToken = fetchData?.first?.access_token
        print(fetchData?.first?.access_token ?? "")
        return (fetchData?.count ?? 0) > 0
    }
}

//MARK: - UIScrollViewDelegate

extension WalkThroughController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        let currentPage = Int(ceil(x/w))
        self.currentPage = currentPage
    }
}

