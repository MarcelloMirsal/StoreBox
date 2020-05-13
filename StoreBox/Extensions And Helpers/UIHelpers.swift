//
//  UIHelpers.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 06/05/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
//    static func random() -> UIColor {
//        return UIColor(displayP3Red: CGFloat.random(in: 0...1) , green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1)
//    }
}

struct AspectRatioCalculator {
    let width: CGFloat
    
    func get(aspectWidth: CGFloat = 16 , aspectHeight: CGFloat = 9) -> CGSize {
        let calculatedHeight = width * aspectHeight / aspectWidth
        return CGSize(width: width, height: calculatedHeight)
    }
}

extension UINib {
    
    convenience init(name: String) {
        self.init(nibName: name, bundle: nil)
    }
    
    func initFirstView<T>(ofType: T.Type) -> T {
        return instantiate(withOwner: nil, options: .init()).first as! T
    }
}

extension UIStoryboard {
    
    convenience init(name: String) {
        self.init(name: name, bundle: nil)
    }
    
    func getInitialViewController<T>(of type: T.Type) -> T {
        return instantiateInitialViewController() as! T
    }
}


extension NSAttributedString {
    
}

