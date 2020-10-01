//
//  ProductCollectionViewCell.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 06/05/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cartButton: UIButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    
    @IBOutlet weak var discountLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupSelectionBackgroundView()
        configureLayer()
    }
    
    func setupSelectionBackgroundView() {
        let selectionGrayView = UIView(frame: bounds)
        selectionGrayView.backgroundColor = .systemGray4
        self.selectedBackgroundView = selectionGrayView
    }
    
    func configureLayer() {
        layer.cornerRadius = 6
        layer.masksToBounds = true
    }
}
