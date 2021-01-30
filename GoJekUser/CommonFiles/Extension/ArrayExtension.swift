//
//  ArrayExtension.swift
//  GoJekUser
//
//  Created by Ansar on 15/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation
import UIKit

extension Array {
    func indexesOf<T : Equatable>(object:T) -> Int {
        var result: [Int] = []
        for (index,obj) in self.enumerated() {
            if obj as! T == object {
                result.append(index)
                return index
            }
        }
        return 100
    }
}


extension UINavigationController {
  func popToViewController(ofClass: AnyClass, animated: Bool = true) {
    if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
      popToViewController(vc, animated: animated)
    }
  }
}
