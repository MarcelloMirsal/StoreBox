//
//  ProductsAdCollectionViewCell.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 05/05/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import UIKit

class ProductsAdCollectionViewCell: UICollectionViewCell {
    
    // Cell Views are self-sizing height accoriding to subtitle and imageView
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBOutlet weak var titleLable: UILabel!
    
    
    @IBOutlet weak var subtitleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    func setupLayers() {
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        layer.shadowOffset = .init(width: 0, height: 18)
        layer.shadowColor = UIColor.systemGray.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 10
        layer.masksToBounds = false
    }
    
    
    // MARK:- View Cycle
    override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        setupLayers()
    }
    
    
    
}
