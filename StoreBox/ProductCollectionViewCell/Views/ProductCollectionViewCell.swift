//
//  ProductCollectionViewCell.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 06/05/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var addToCartButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setupLayers()
    }
    
    
    func setupLayers() {
        addToCartButton.layer.cornerRadius = 8
        addToCartButton.layer.masksToBounds = true
        layer.cornerRadius = 8
        layer.masksToBounds = true
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.lightGray.cgColor
    }
    
    
    
    
}
