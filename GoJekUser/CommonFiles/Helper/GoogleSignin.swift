//
//  GoogleSignin.swift
//  GoJekUser
//
//  Created by Ansar on 26/07/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation
import GoogleSignIn

class GoogleSignin: NSObject {
    
    static let share = GoogleSignin()
    
    private var googleCompletion : ((GIDGoogleUser?,String?) -> Void)?
    
    func getGoogleData(completion: @escaping ((GIDGoogleUser?,String?) -> Void)) {
        GIDSignIn.sharedInstance().delegate = self
       // GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().signIn()
        googleCompletion = completion
    }
    
}

//MARK:- Google Implementation

extension GoogleSignin : GIDSignInDelegate{

    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard user != nil else {
            self.googleCompletion?(nil, error.localizedDescription)
            return
        }
        self.googleCompletion?(user,nil)
        print("Auth : \(user.authentication.accessToken ?? "")")
        print("Name: \(user.profile.name ?? "")")
        print("Last name: \(user.profile.familyName ?? "")")
        print("Email: \(user.profile.email ?? "")")
    }

    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        if error != nil {
            self.googleCompletion?(nil,error.localizedDescription)
        }
    }

    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {

        UIApplication.topViewController()?.present( viewController, animated: true, completion: nil)
    }

    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        UIApplication.topViewController()?.dismiss(animated: true, completion: nil)
    }
}
