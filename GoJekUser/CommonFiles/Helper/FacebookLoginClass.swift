//
//  FacebookSignIn.swift
//  GoJekUser
//
//  Created by Ansar on 25/07/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import ObjectMapper

struct FBdata: Mappable {
    var id: AnyObject?
    var first_name: String?
    var last_name: String?
    var name: String?
    var email: String?
    var picture: FBPicture?
    
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        id <- map["id"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        name <- map["name"]
        email <- map["email"]
        picture <- map["picture"]
    }
}

struct FBPicture: Mappable {
    var data: FBPictureData?
    
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        data <- map["data"]
    }
}

struct FBPictureData: Mappable {
    var height: Int?
    var url: String?
    
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        height <- map["height"]
        url <- map["url"]
    }
}


struct FBFields {
    static let email = "email"
    static let public_profile = "public_profile"
    static let id = "id"
    static let name = "name"
    static let first_name = "first_name"
    static let last_name = "last_name"
    static let picture = "picture.type(large)"
    static let fields = "fields"
    static let me = "me"
}

class FacebookLoginClass: NSObject {
    
    private var fbCompletion:((FBdata?)->())?
    
    func initializeFacebook(controller: UIViewController,completion: @escaping ((FBdata?) -> Void)) {
        let fbLoginManager : LoginManager = LoginManager()
        //        fbLoginManager.loginBehavior = .web
        fbLoginManager.logOut()
        fbCompletion = completion
        fbLoginManager.logIn(permissions: [FBFields.email,FBFields.public_profile], from: controller) { (result, error) in
            if (error == nil)
            {
                if let fbloginresult :LoginManagerLoginResult = result {
                    if(fbloginresult.grantedPermissions.contains(FBFields.email)) {
                        self.getFBUserData()
                        fbLoginManager.logOut()
                    }
                }
            }
        }
    }
    
    private func getFBUserData() {
        print("Fb called")
        if((AccessToken.current) != nil) {
            GraphRequest(graphPath: FBFields.me, parameters: [FBFields.fields: "\(FBFields.id), \(FBFields.name), \(FBFields.first_name), \(FBFields.last_name), \(FBFields.picture), \(FBFields.email)"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil)
                {
                    let userDetail = result as! [String : AnyObject]
                    print(userDetail)
                    let fbDetail = Mapper<FBdata>().map(JSONObject: userDetail)
                    self.fbCompletion?(fbDetail)
                }
            })
        }
        
    }
}

