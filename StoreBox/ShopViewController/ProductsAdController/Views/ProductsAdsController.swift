//
//  ProductsAdsController.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 05/05/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import UIKit

class ProductsAdsController: UICollectionViewController , UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    
    lazy var ShiftedSize: CGSize = {
        let width = (collectionView.frame.size.width - 48)
        let calculator = AspectRatioCalculator(width: width)
        let calculatedSize = calculator.get(aspectWidth: 3, aspectHeight: 4)
        return CGSize(width: calculatedSize.width, height: calculatedSize.height)
    }()
    
    func setupCollectionView() {
        let nib = UINib(name: "ProductsAdCollectionViewCell")
        collectionView.register(nib, forCellWithReuseIdentifier: cellId)
    }
    
    // MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ProductsAdCollectionViewCell
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
    
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let productDetailsViewController = UIStoryboard(name: "ProductDetailsViewController").instantiateInitialViewController() as! ProductDetailsViewController
//        navigationController?.pushViewController(productDetailsViewController, animated: true)
//    }

}
