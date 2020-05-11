//
//  ProductCollectionViewCell.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 06/05/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var addToCartButton: UIRoundButton!
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setupLayers()
    }
    
    func setupLayers() {
        layer.cornerRadius = 8
        layer.masksToBounds = true
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.lightGray.cgColor
    }
    
}
