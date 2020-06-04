//
//  ShopViewController.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 05/05/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import UIKit
import JavaScriptCore

class ShopViewController: UITableViewController {
    
    
    var searchController: UISearchController!
    var categorySectionIndexPath = IndexPath(row: 0, section: 4)
    var categorySectionHeight: CGFloat = 200
    let headerId = "headerId"
    
    
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
    
    func tableViewSetup() {
        tableView.register(ShopTableViewHeaderSection.self, forHeaderFooterViewReuseIdentifier: headerId)
        tableView.contentInset.bottom = 40
    }
    
    // MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        tableViewSetup()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0...1 ~= section ? 0 : 64
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 { return 120 }
        else if indexPath.section == 1 { return 520 }
        else if 2...3 ~= indexPath.section { return 336 }
        else { return categorySectionHeight }
    }

    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as? ShopTableViewHeaderSection
//        headerView?.contentView.backgroundColor = .white
//        switch section {
//            case 2:
//            headerView?.sectionLabel.text = "New Products"
//            case 3:
//            headerView?.sectionLabel.text = "Most Ordered"
//            case 4:
//            headerView?.sectionLabel.text = "Categories"
//            default:
//            break
//        }
//        return headerView
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CategoriesViewController" {
            let categoriesVC = segue.destination as! CategoriesViewController
            categoriesVC.dynamicSizeDelegate = self
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
        categorySectionHeight = dynamicSize.height
        tableView.reloadRows(at: [categorySectionIndexPath], with: .top)
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
