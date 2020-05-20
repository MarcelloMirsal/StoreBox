//
//  ShopViewController.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 05/05/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import UIKit
import JavaScriptCore

class ShopViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentsView: UIView!
    @IBOutlet weak var categoriesViewHeightConstraint: NSLayoutConstraint!
    var searchController: UISearchController!
    
    
    func setupSearchController() {
        let searchResultsController = UIStoryboard(name: "SearchResultsViewController").getInitialViewController(of: SearchResultsViewController.self)
        
        searchController = UISearchController(searchResultsController: searchResultsController)
        
        searchController.delegate = self
        searchController.searchBar.delegate = searchResultsController

        navigationItem.searchController = searchController
    }
    
    func configureNavigatoinForSearching(isSearch: Bool = true) {
        navigationController?.navigationBar.prefersLargeTitles = isSearch ? false : true
        navigationItem.title = isSearch ? "Search" : "Shop"
    }
    
    // MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let categoriesViewId = "CategoriesViewController"
        if segue.identifier == categoriesViewId {
            let vc = segue.destination as! CategoriesViewController
            vc.dynamicSizeDelegate = self
        }
    }
    
}

extension ShopViewController: UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        guard let searchResultsVC = searchController.searchResultsController as? SearchResultsViewController else {return}
        searchResultsVC.setupSearchDetailsViewController(with: self)
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        configureNavigatoinForSearching()
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        configureNavigatoinForSearching(isSearch: false)
    }
    
}

extension ShopViewController: UICollectionViewDynamicSizeDelegate {
    func collectionView(setDynamicSize dynamicSize: CGSize) {
        categoriesViewHeightConstraint.constant = dynamicSize.height
        contentsView.layoutIfNeeded()
    }
}

// MARK:- SearchDetailsNavigationDelegate Implementation
extension ShopViewController: SearchDetailsNavigationDelegate {
    func rootNavigationController() -> UINavigationController? {
        return navigationController
    }

    func rootSearchController() -> UISearchController? {
        return searchController
    }
}
