//
//  ImageExtension.swift
//  GoJekUser
//
//  Created by Ansar on 21/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation
import UIKit

var imageCache = NSMutableDictionary()
let cache = NSCache<NSString,UIImage>()


extension UIImageView {
    
    func setImageColor(color: UIColor) {
      let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
      self.image = templateImage
      self.tintColor = color
    }
    
    //Tint Color
    func imageTintColor(color1: UIColor) { // -> UIImage
        if self.image == nil {
            return
        }
        UIGraphicsBeginImageContextWithOptions(self.image!.size, false, (self.image?.scale)!)
        color1.setFill()
        
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.image!.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(origin: .zero, size: CGSize(width: self.image!.size.width, height: self.image!.size.height))
        context?.clip(to: rect, mask: self.image!.cgImage!)
        context?.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.image = newImage
    }
    
    func setRoundCorner() {
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.height/2
        
        self.layoutIfNeeded()
    }
    
    func setShadow(color: UIColor) {
        self.layer.shadowOpacity = 0.7
        self.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        self.layer.shadowRadius = 7.0
        self.layer.shadowColor = color.cgColor
    }
    
    fileprivate var activityIndicator: UIActivityIndicatorView {
        get {
            let activityIndicator = UIActivityIndicatorView(style: .gray)
            activityIndicator.hidesWhenStopped = true
            let height = self.frame.height
            let width = (self.frame.width*40)/100
            activityIndicator.frame = CGRect(x: (self.frame.width/2)-(width/2), y: (self.frame.height/2)-(height/2), width: width, height: height)
            activityIndicator.tag = 100
            activityIndicator.stopAnimating()
            self.addSubview(activityIndicator)
            return activityIndicator
        }
    }
    
    func downloadImage(withURL urlStr: URL,completion: @escaping (_ image:UIImage?) -> ()) {
        self.activityIndicator.startAnimating()
        
        let dataTask = URLSession.shared.dataTask(with: urlStr) { data, url, error in
            var downloadedImage:UIImage?
            if let data = data {
                downloadedImage = UIImage(data: data)
            }
            if downloadedImage != nil {
                cache.setObject(downloadedImage!, forKey: urlStr.absoluteString as NSString)
            }
            DispatchQueue.main.async {
                self.stopAnimation()
                completion(downloadedImage)
            }
        }
        dataTask.resume()
    }
    
    func getImage(withURL url: URL,completion: @escaping (_ image:UIImage?) -> ()) {
        if let image =  cache.object(forKey: url.absoluteString as NSString){
            self.stopAnimation()
            completion(image)
        }else{
            downloadImage(withURL: url, completion: completion)
        }
    }
    
    func load(url: URL,placeHolderImage:UIImage?=nil,completion: @escaping ((UIImage) -> Void)) {
        
        self.activityIndicator.startAnimating()
        self.image = nil
        
        if let _  = placeHolderImage {
            image = placeHolderImage
        } else {
            image = UIImage(named: Constant.imagePlaceHolder)?.imageTintColor(color1: UIColor.veryLightGray.withAlphaComponent(0.8))
        }
        
        let cache =  URLCache.shared
        let request = URLRequest(url: url)
        DispatchQueue.global(qos: .userInitiated).async {
            if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.stopAnimation()
                    completion(image)
                }
            } else {
                URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                    if let data = data, let response = response, ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300, let image = UIImage(data: data) {
                        let cachedData = CachedURLResponse(response: response, data: data)
                        cache.storeCachedResponse(cachedData, for: request)
                        DispatchQueue.main.async {
                            self.stopAnimation()
                            completion(image)
                        }
                    }
                }).resume()
            }
        }
    }
    
    func stopAnimation() {
        for loader in self.subviews {
            if loader.tag == 100 {
                loader.removeFromSuperview()
            }
        }
    }
}

extension UIImage {
    
    func isEqual(to image: UIImage) -> Bool {
        guard let data1: Data = self.pngData(),
            let data2: Data = image.pngData() else {
                return false
        }
        return data1.elementsEqual(data2)
    }
    
    func resizeImage(newWidth: CGFloat) -> UIImage?{
        
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(origin: .zero, size: CGSize(width: newWidth, height: newHeight)))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    

    
    
    //MARK: Tint Color
    func imageTintColor(color1: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color1.setFill()
        
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(origin: .zero, size: CGSize(width: self.size.width, height: self.size.height))
        context?.clip(to: rect, mask: self.cgImage!)
        context?.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? UIImage()
    }
    
    func resizeImageFrame(scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}

extension UIImageView {
    func applyshadowWithCorner(containerView : UIView, cornerRadious : CGFloat){
        containerView.clipsToBounds = false
        containerView.layer.shadowColor = UIColor.lightGray.cgColor
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowOffset = CGSize.zero
        containerView.layer.shadowRadius = 10
        containerView.layer.cornerRadius = cornerRadious
        containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: cornerRadious).cgPath
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadious
    }
}
