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
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    let cellId = "cellId"
    var items = 0
    
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
    
    func calculateHeight() -> CGFloat {
        let x = cellSize.height * CGFloat((floor( Double(items / 2) ) ))
        let y = x + ( 16 * CGFloat((floor( Double(items / 2) ) )))
        return y
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            self?.items = 10
            self?.dynamicSizeDelegate?.collectionView(setDynamicSize: CGSize(width: 300, height: self!.calculateHeight()) )
            self?.dynamicSizeDelegate = nil
            self?.activityIndicator.stopAnimating()
            self?.collectionView.reloadData()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items
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
