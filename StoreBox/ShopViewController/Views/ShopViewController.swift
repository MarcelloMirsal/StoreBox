//
//  ShopViewController.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 05/05/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import UIKit

class ShopViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var contentsView: UIView!
    @IBOutlet weak var categoriesViewHeightConstraint: NSLayoutConstraint!
    let categoriesViewId = "CategoriesViewController"
    
    func setupSearchController() {
        navigationItem.searchController = .init()
    }
    
    // MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == categoriesViewId {
            let vc = segue.destination as! CategoriesViewController
            vc.dynamicSizeDelegate = self
        }
    }
    
}

extension ShopViewController: UICollectionViewDynamicSizeDelegate {
    func collectionView(setDynamicSize dynamicSize: CGSize) {
        categoriesViewHeightConstraint.constant = dynamicSize.height
        contentsView.layoutIfNeeded()
    }
}
