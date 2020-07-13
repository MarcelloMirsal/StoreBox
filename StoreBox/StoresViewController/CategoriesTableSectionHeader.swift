//
//  CategoriesTableSectionHeader.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 06/07/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import UIKit


final class CategoriesTableSectionHeader: UITableViewHeaderFooterView {
    
    let cellId = "cellId"
    let categoriesSections = ["All" , "Men Cloths" , "Food & bakery" , "Men Shoes" ]
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        let cellNib = UINib(name: "CategoriesSectionCollectionViewCell")
        collectionView.register(cellNib, forCellWithReuseIdentifier: cellId )
        return collectionView
    }()
    
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        contentView.addSubview(collectionView)
        NSLayoutConstraint.activate( [
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ] )
    }
    
}


extension CategoriesTableSectionHeader: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriesSections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CategoriesSectionCollectionViewCell
        cell.contentView.backgroundColor = .clear
        cell.sectionLabel.text = categoriesSections[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let textWidth = categoriesSections[indexPath.row].width(withConstrainedHeight: collectionView.frame.height, font: UIFont(name: "AvenirNext-Medium", size: UIFont.systemFontSize+2)!)
        
        return CGSize(width: textWidth + 16, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
}


final class CategoriesSectionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var sectionLabel: UILabel!
    
    @IBOutlet weak var sectionIndicatorView: UIView!
    
    override var isSelected: Bool {
        didSet {
            sectionLabel.isHighlighted = isSelected
            sectionIndicatorView.backgroundColor = isSelected ? UIColor.systemBlue : sectionLabel.backgroundColor
        }
        
    }
    
    
}
