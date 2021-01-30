//
//  WebServices.swift
//  GoJekProvider
//
//  Created by apple on 15/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

class WebServices: UIViewController {
    
    static let shared = WebServices()
    
    /**
     Call Webservice with single model
     
     - Parameter type:                   Mappable model for this API Call
     - parameter endPointURL:            EndPoint URL for this API. Default: empty string.
     - parameter urlMethod:              Http method type.
     - parameter showLoader:             Loader show and hide.
     - parameter Params:                 Parameters for this API. Default: nil
     - parameter accessTokenAdd:         Add access token for this Api.  Default: true
     - parameter failureReturen:         Failure returen to view for this Api.  Default: false
     - Completion:                       Return model response to the handler
     */
    
    func requestToApi<T: Mappable>(type: T.Type,
                                   with endPointURL: String,
                                   urlMethod: HTTPMethod!,
                                   showLoader: Bool,
                                   params: Parameters? = nil,
                                   accessTokenAdd: Bool? = true,
                                   failureReturen: Bool? = false,
                                   encode: ParameterEncoding? = JSONEncoding.default,
                                   completion: @escaping(_ result: DataResponse<T, AFError>?) -> Void) {
        
        guard NetworkState.isConnected() else {
            self.showErrorMessage(message: Constant.noNetwork.localized)
            return
        }
        
        //Activity Indicator Animation start
        if showLoader {
            LoadingIndicator.show()
        }
        
        var baseUrl = AppConfigurationManager.shared.getBaseUrl()
        if baseUrl == "" {
            baseUrl = APPConstant.baseUrl
        }
        
        //Form base url & add header (if both same )
        var url = ""
        if baseUrl == endPointURL {
            url = baseUrl
        }else {
            url = baseUrl + endPointURL
        }
        
        var headers: HTTPHeaders = [Constant.RequestType: Constant.RequestValue,
                                    Constant.ContentType: Constant.ContentValue]
        
        if accessTokenAdd ?? true {
            if let accessToken = AppManager.shared.accessToken {
                headers[Constant.Authorization] = Constant.Bearer+" "+accessToken
            }
        }
        
        print("Request URL: \(url)")
        print("Parameters: \(params ?? [:])")
        
        //Alamofire request
        AF.request(url, method: urlMethod!, parameters: params, encoding: encode!, headers: headers).validate().responseObject { (response: DataResponse<T, AFError>) in
            
            //Activity Indicator Animation stop
            if showLoader {
                LoadingIndicator.hide()
            }
            
            //Response validate
            switch response.result {
                case .success:
                    completion(response)
                case .failure:
                    print("error:--->",response.error as Any)
                    if failureReturen! {
                        completion(response)
                    }else if let data = response.data {
                        self.showErrorMessage(responseData: data)
                    }else {
                        print("error:",response.error.debugDescription)
                }
            }
        }
    }
    
    /**
     Call Webservice with Multipart FormData
     
     - Parameter type:                   Mappable model for this API Call
     - parameter endPointURL:            EndPoint URL for this API. Default: empty string.
     - parameter imageData:              Single iamge data.
     - parameter showLoader:             Loader show and hide.
     - parameter Params:                 Parameters for this API. Default: nil
     - parameter accessTokenAdd:         Add access token for this Api.  Default: true
     - parameter failureReturen:         Failure returen to view for this Api.  Default: false
     - Completion:                       Return model response to the handler
     */
    
    func requestToImageUpload<T: Mappable>(type: T.Type,with endPointURL: String,
                                           imageData: [String:Data]?,
                                           showLoader: Bool,
                                           params: Parameters? = nil,
                                           accessTokenAdd: Bool? = true,
                                           failureReturen: Bool? = false,
                                           encode: ParameterEncoding? = JSONEncoding.default,
                                           completion: @escaping(_ result: DataResponse<T, AFError>?) -> Void) {
        
        //Network reachable check
        guard NetworkState.isConnected() else {
            self.showErrorMessage(message: Constant.noNetwork.localized)
            return
        }
        
        //Activity Indicator Animation start
        if showLoader {
            LoadingIndicator.show()
        }
        
        //Form base url & add header
        var baseUrl = AppConfigurationManager.shared.getBaseUrl()
        if baseUrl == "" {
            baseUrl = APPConstant.baseUrl
        }
        
        //Form base url & add header (if both same )
        var url = ""
        if baseUrl == endPointURL {
            url = baseUrl
        }else {
            url = baseUrl + endPointURL
        }
        
        var headers: HTTPHeaders = [Constant.RequestType: Constant.RequestValue,
                                    Constant.ContentType: Constant.multiPartValue]
        
        if let accessToken = AppManager.shared.accessToken {
            headers[Constant.Authorization] = Constant.Bearer+" "+accessToken
        }
        
        print("Request URL: \(url)")
        print("Parameters: \(params ?? [:]))")
        AF.upload(multipartFormData: { (multipartFormData) in
            
            //Param Mapping
            for (key, value) in params ?? [:] {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            //File Name
            let uniqueString: String = ProcessInfo.processInfo.globallyUniqueString
            
            //Data Mapping
            for (key,value) in imageData ?? [:] {
                multipartFormData.append(value, withName: key, fileName: uniqueString+".png", mimeType: "image/png")
            }
            
        }, to: url, method: .post, headers: headers).uploadProgress { progress in
            print("Upload Progress: \(progress.fractionCompleted)")
        }
            
        .responseObject(completionHandler: { (response: DataResponse<T, AFError>) in
            
            //Activity Indicator Animation stop
            LoadingIndicator.hide()
            if response.response?.statusCode == 200 {
                completion(response)
            }else if failureReturen! {
                completion(response)
            }else if let data = response.data {
               // if response.data?.
                self.showErrorMessage(responseData: data)
            }else {
                print("Error: \(response.error.debugDescription)")
            }
        })
    }
    
    func errorCode(errorCode: URLError) {
        switch errorCode.code {
            case .notConnectedToInternet:
                if let topViewController = UIApplication.topViewController() {
                    AppAlert.shared.simpleAlert(view: topViewController, title: String.empty, message: Constant.noNetwork.localized)
                }
                break
            case .timedOut:
                if let topViewController = UIApplication.topViewController() {
                    AppAlert.shared.simpleAlert(view: topViewController, title: String.empty, message: Constant.requestTimeOut.localized)
                }
                break
            case .networkConnectionLost:
                if let topViewController = UIApplication.topViewController() {
                    AppAlert.shared.simpleAlert(view: topViewController, title: String.empty, message: Constant.noNetwork.localized)
                }
                break
            default:
                break
        }
    }
    
    func showErrorMessage(responseData: Data) {
        if let utf8Text = String(data: responseData, encoding: .utf8),
            let messageDic = AppUtils.shared.stringToDictionary(text: utf8Text),
            let message = messageDic[Constant.message],let errorCode = messageDic[Constant.errorCode] {
            if !isGuestAccount {
            // let msg = message as! String
                self.showErrorMessage(message: message as! String)
                  
                if let code = errorCode as? String,code == "401" {
                    // Force Logout
                    DispatchQueue.main.async {
                        CommonFunction.forceLogout()
                    }
                }
            }
        }
    }
    
    
    //Show error message
    func showErrorMessage(message: String) {
        if  message.count > 40 {
            DispatchQueue.main.async {
                  let alert = UIAlertController(title: nil, message: message, preferredStyle: UIAlertController.Style.alert)
                     //okButton Action
                let okButton = UIAlertAction(title: Constant.SOk.localized, style: UIAlertAction.Style.default) {
                         (result : UIAlertAction) -> Void in
                         //self.onTapAction?(0)
                     }
                     alert.addAction(okButton)
                UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)

            }}else{
        DispatchQueue.main.async {
            ToastManager.show(title: message, state: .error)
        }
        }
    }
    
    // Method to convert JSON String to Dictionary
    func stringToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print("error:>",error.localizedDescription)
            }
        }
        return nil
    }
}

//MARK: - NetworkState

class NetworkState {
    class func isConnected() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
