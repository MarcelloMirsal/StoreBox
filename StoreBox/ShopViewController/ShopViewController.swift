//
//  ShopViewController.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 05/05/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import UIKit

class ShopViewController: UIViewController {
    
    
    @IBOutlet weak var contentsView: UIView!
    
    @IBOutlet weak var categoriesViewHeightConstraint: NSLayoutConstraint!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "CategoriesViewController" {
        let vc = segue.destination as! CategoriesViewController
            vc.dynamicSizeDelegate = self
        }
    }
    
    
    
    // MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        categoriesViewHeightConstraint.constant = 0
    }
    
    func setupSearchController() {
        navigationItem.searchController = .init()
    }
    
}

extension ShopViewController: UICollectionViewDynamicSizeDelegate {
    func collectionView(setDynamicSize dynamicSize: CGSize) {
        categoriesViewHeightConstraint.constant = dynamicSize.height
        print(dynamicSize.height)
        contentsView.layoutIfNeeded()
    }
    
    
}
