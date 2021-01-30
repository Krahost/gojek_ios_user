//
//  AppleSignin.swift
//  applesignin
//
//  Created by Ansar on 06/12/19.
//  Copyright © 2019 Ansar's MacBook Pro. All rights reserved.
//

import UIKit
import AuthenticationServices

class AppleSignin: NSObject {

    static var shared = AppleSignin()
    
    private var onSuccess:((AppleDetails)->())?
    
    @available(iOS 13.0, *)
    public func initAppleSignin(scope: [ASAuthorization.Scope]?,completion: @escaping (AppleDetails)->Void) {
        self.onSuccess = completion
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = scope
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.presentationContextProvider = self
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
}

//MARK:- Delegate

extension AppleSignin: ASAuthorizationControllerDelegate {
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential
        {
        case let credential as ASAuthorizationAppleIDCredential:
            let userIdentifier = credential.user

            DispatchQueue.main.async {
                let userid = credential.user
                let email = credential.email ?? Keychain.email ?? ""
                let firstName = credential.fullName?.givenName ?? Keychain.firstName ?? ""
                let lastName = credential.fullName?.familyName ?? Keychain.lastName ?? ""
                
                Keychain.userid = userid
                Keychain.firstName = firstName
                Keychain.lastName = lastName
                Keychain.email = email
                
                let appleData = AppleDetails(userId: userIdentifier, firstName: firstName, lastName: lastName, email: email, error: nil)
                self.onSuccess?(appleData)
            }
            
            break
        default:
            break
        }
        
        func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
            let appleData = AppleDetails(userId: nil, firstName: nil, lastName: nil, email: nil, error: error.localizedDescription)
            self.onSuccess?(appleData)
        }
        
        
    }
    
    
}

extension AppleSignin: ASAuthorizationControllerPresentationContextProviding {
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
       let keyWindow = UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first
        return keyWindow!
    }
    
}

class AppleDetails {
    
    var userId: String?
    var firstName: String?
    var lastName: String?
    var email: String?
    var error: String?
    
    init(userId: String?, firstName: String?, lastName: String?, email: String?, error: String?) {
        
        self.userId = userId
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.error = error
        
    }
}
