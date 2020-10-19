//
//  UIRoundButton.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 12/05/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import UIKit

class UIRoundButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    fileprivate func setupLayer() {
        layer.cornerRadius = 8
        layer.masksToBounds = true
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: UIFont.buttonFontSize)
        setupLayer()
        backgroundColor = .systemBlue
        setTitleColor(.white, for: .normal)
    }
}
