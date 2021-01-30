//
//  ImageViewController.swift
//  GoJekUser
//
//  Created by Ansar on 29/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    var imageView : UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints =  false
        imgView.setCornerRadiuswithValue(value: 5.0)
        imgView.contentMode = .scaleToFill
        return imgView
    }()
    
    lazy var closeButton:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        closeButton.setImage(UIImage(named: "close1"), for: .normal)
        closeButton.addTarget(self, action: #selector(tapClose), for: .touchUpInside)
        self.view.addSubview(imageView)
        self.view.addSubview(closeButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setConstraints()
    }
    
    func setConstraints() {
        //imageView
        imageView.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.7).isActive  =  true
        imageView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.7).isActive =  true
        imageView.centerXAnchor.constraint(equalTo: (imageView.superview!.centerXAnchor)).isActive = true
        imageView.centerYAnchor.constraint(equalTo: (imageView.superview!.centerYAnchor)).isActive = true
        
        closeButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10).isActive = true
        closeButton.topAnchor.constraint(equalTo: imageView.topAnchor, constant:-15).isActive = true
        closeButton.widthAnchor.constraint(lessThanOrEqualTo: imageView.widthAnchor, multiplier: 0.12, constant: 0).isActive = true
        closeButton.heightAnchor.constraint(lessThanOrEqualTo: imageView.widthAnchor, multiplier: 0.12, constant: 0).isActive = true
    }
    
    @objc func tapClose()  {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }
}
