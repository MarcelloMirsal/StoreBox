//
//  CategoriesViewController.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 08/05/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import UIKit

protocol UICollectionViewDynamicSizeDelegate: class {
    func collectionView(setDynamicSize dynamicSize: CGSize)
}

class CategoriesViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    
    weak var dynamicSizeDelegate: UICollectionViewDynamicSizeDelegate?
    
    lazy var cellSize: CGSize = {
        let width = (collectionView.frame.width - 48) / 2
        let calculator = AspectRatioCalculator(width: width)
        return calculator.get(aspectWidth: 4, aspectHeight: 5)
    }()
    
    func setupCollectionView() {
        let nib = UINib(nibName: "CategoryCollectionViewCell", bundle: nil)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.register(nib, forCellWithReuseIdentifier: cellId)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfItems = 4
        let numberOfRowsPerColumn = ceil(Float(numberOfItems) / 2.0)
        let height = numberOfRowsPerColumn * Float(cellSize.height) + (numberOfRowsPerColumn-1) * 16
        DispatchQueue.global().asyncAfter(deadline: .now()) {
            DispatchQueue.main.async {
                self.dynamicSizeDelegate!.collectionView(setDynamicSize: CGSize(width: self.collectionView.frame.width, height: CGFloat(height)))
            }
        }
        return numberOfItems
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CategoryCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
}
