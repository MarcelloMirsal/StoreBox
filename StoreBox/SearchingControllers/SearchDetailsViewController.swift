//
//  SearchDetailsViewController.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 14/06/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import UIKit

class SearchDetailsViewController: UICollectionViewController {
    
    
    let cellId = "cellId"
    let headerId = "headerId"
    let items = 5
    
    lazy var cellSize: CGSize = {
        let width = (collectionView.frame.width - 48 ) / 2
        let calculator = AspectRatioCalculator(width: width)
        return calculator.get(aspectWidth: 1, aspectHeight: 2)
    }()
    
    
    // MARK:- View life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    func setupCollectionView() {
        let cellNib = UINib(name: "ProductCollectionViewCell")
        collectionView.register(cellNib, forCellWithReuseIdentifier: cellId)
        collectionView.register(DetailsCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.contentInset = .init(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    @objc
    func handleFilterButton() {
        let searchFilteringNavigationController = UIStoryboard(name: "SearchFilteringViewController").getInitialViewController(of: UINavigationController.self)
        present(searchFilteringNavigationController, animated: true)
    }
    
    deinit {
        print("from details")
    }
    
}


// MARK:- implementing CollectionView Delegate, DataSource and Flow Layout
extension SearchDetailsViewController: UICollectionViewDelegateFlowLayout {

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId, for: indexPath) as! DetailsCollectionViewHeader
        headerView.set(sectionTitle: "20 Results", buttonTitle: "Filter")
        headerView.detailsButton.addTarget(self, action: #selector(handleFilterButton), for: .touchUpInside)
        return headerView
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 64)
    }
    
    

}
