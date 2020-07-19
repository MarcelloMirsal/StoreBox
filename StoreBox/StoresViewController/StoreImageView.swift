//
//  StoreImageView.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 13/07/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import UIKit

@IBDesignable
final class StoreImageView: PresentableImageView {
    
    var gradientCoverPercent: CGFloat = 0.5
    var gradientLayer: CAGradientLayer!
    
    @IBInspectable var gradientColor: UIColor = .white
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setupLayers()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayers()
    }

    func setupLayers() {
        guard let currentGradientLayer = gradientLayer else {
            gradientLayer = CAGradientLayer()
            gradientLayer.colors = [ gradientColor.cgColor , UIColor.clear.cgColor ]
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 1)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
            gradientLayer.locations = [ 0.0 , gradientCoverPercent as NSNumber, 1.0 ]
            layer.addSublayer(gradientLayer)
            gradientLayer.frame = bounds
            return
        }
        currentGradientLayer.frame = bounds
    }
}



