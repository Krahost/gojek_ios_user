//
//  LottieViewManager.swift
//  GoJekUser
//
//  Created by Rajes on 30/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Lottie
class LottieViewManager {
    static var  lottieView = AnimationView()
    
    static func playWithFrame(fileName:String,sourceView:UIView) {
       
        let animationView = AnimationView(name: fileName)
            lottieView = animationView
            lottieView.frame = sourceView.bounds
            lottieView.center = sourceView.center
            lottieView.contentMode = .scaleAspectFill
            sourceView.addSubview(lottieView)
        
          lottieView.play()
        
    }
    

}
