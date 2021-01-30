//
//  ServicesListCell.swift
//  GoJekSample
//
//  Created by Ansar on 07/03/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SDWebImage

class ServicesListCell: UICollectionViewCell {
    
    @IBOutlet weak var serviceOuterView: UIView!
    @IBOutlet weak var servicesImageView: UIImageView!
    @IBOutlet weak var serviceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setFont()
        setDarkMode()
    }
    
    func serviceCellDetails(details:ServicesDetails) {
       
       /*
        serviceOuterView.addShadow(radius: 3, color: .lightGray)
        let bgColor = UIColor(hexString: details.bg_color ?? "")
        serviceOuterView.backgroundColor = bgColor
        let placeHolder = UIImage(named: Constant.imagePlaceHolder)?.imageTintColor(color1: UIColor.veryLightGray.withAlphaComponent(0.8))
      
        servicesImageView.sd_setImage(with:  URL(string: details.icon ?? ""), placeholderImage:placeHolder,options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                                 // Perform operation.
                                    if (error != nil) {
                                        // Failed to load image
                                        self.servicesImageView.image = placeHolder
                                    } else {
                                        // Successful in loading image
                                        self.servicesImageView.image = image
                                    }
                                })
        serviceLabel.text = details.title ?? ""
 */
          serviceOuterView.addShadow(radius: 3, color: .lightGray)
        serviceLabel.text = details.title ?? ""
          let bgColor = UIColor(hexString: details.bg_color ?? "")
                  serviceOuterView.backgroundColor = bgColor
          if let shopImg = URL(string: details.icon ?? "") {
                            self.servicesImageView.load(url: shopImg, completion: { (image) in
                                             DispatchQueue.main.async {
                                              self.servicesImageView.image = image
                                            
                                      
                                             }
                                         })
                           
                       }else{
                        let placeHolder = UIImage(named: Constant.imagePlaceHolder)?.imageTintColor(color1: UIColor.veryLightGray.withAlphaComponent(0.8))
                                    self.servicesImageView.image = placeHolder

                         //  self.xmapView?.currentLocationMarkerImage = self.currentLocationImage.image
                       }
    }
    
    private func setFont() {
        serviceLabel.font = .setCustomFont(name: .medium, size: .x10)
    }
    
    private func setDarkMode(){
        self.backgroundColor = .boxColor
    }
    
}
