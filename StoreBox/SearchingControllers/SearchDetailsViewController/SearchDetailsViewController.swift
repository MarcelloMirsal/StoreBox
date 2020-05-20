//
//  SearchDetailsViewController.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 19/05/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import UIKit

protocol SearchDetailsNavigationDelegate: class {
    func rootNavigationController() -> UINavigationController?
    func rootSearchController() -> UISearchController?
}

class SearchDetailsViewController: UIViewController, UICollectionViewDelegate , UICollectionViewDataSource {
    
    let cellId = "cellId"
    let headerId = "headerId"
    var items = 0
    weak var searchDetailsNavigationDelegate: SearchDetailsNavigationDelegate?
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var loadingLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        items = 0
        collectionView.reloadData()
        activityIndicator.startAnimating()
        loadingLabel.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.items = 5
            self?.loadingLabel.isHidden = true
            self?.activityIndicator.stopAnimating()
            self?.collectionView.reloadData()
        }
    }
    
    func setupCollectionView() {
        let nib = UINib(name: "ProductCollectionViewCell")
        let headerNib = UINib(name: "SearchHeaderCollectionViewCell")
        collectionView.register(nib, forCellWithReuseIdentifier: "cellId")
        collectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        
    }
    
}
// MARK:- CollectionView Delegate , DataSource & FlowLayoutDelegate
extension SearchDetailsViewController: UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = AspectRatioCalculator(width: (collectionView.frame.width - 32) / 2).get(aspectWidth: 1, aspectHeight: 2)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId, for: indexPath) as! SearchHeaderCollectionViewCell
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let contentDetailsVC = UIStoryboard(name: "ProductDetailsViewController").getInitialViewController(of: ProductDetailsViewController.self)
        guard let rootNV = searchDetailsNavigationDelegate?.rootNavigationController() else {
            return
        }
        guard let searchController = searchDetailsNavigationDelegate?.rootSearchController() else {
            return
        }
        searchController.searchBar.resignFirstResponder()
        rootNV.pushViewController( contentDetailsVC , animated: true)
        
    }
    
}
