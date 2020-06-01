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
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        layer.cornerRadius = 8
        layer.masksToBounds = true
    }
}
