//
//  ProductsAdsController.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 05/05/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import UIKit

class ProductsAdsController: UICollectionViewController , UICollectionViewDelegateFlowLayout {
    
    lazy var ShiftedSize: CGSize = {
        let width = (collectionView.frame.size.width - 32) - 32
        let calculator = AspectRatioCalculator(width: width)
        let calculatedSize = calculator.get(aspectWidth: 3, aspectHeight: 4)
        return CGSize(width: calculatedSize.width, height: calculatedSize.height)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 32, right: 0)
        let nib = UINib(nibName: "ProductsAdCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "cellId")
        collectionView.backgroundColor = .red
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! ProductsAdCollectionViewCell
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return ShiftedSize
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
}
