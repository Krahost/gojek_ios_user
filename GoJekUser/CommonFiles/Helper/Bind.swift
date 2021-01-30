//
//  Bind.swift
//  GoJekUser
//
//  Created by Sravani on 30/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation

class Bind<T> {
    
    typealias Listener = (T?) -> Void
    
    var listener : Listener?
    
    var value : T? {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value : T?) {
        self.value = value
    }
    
    func bind(listener: Listener?) {
        
        self.listener = listener
        listener?(value)
    }
}
