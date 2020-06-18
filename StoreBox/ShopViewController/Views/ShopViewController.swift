//
//  ShopViewController.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 05/05/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import UIKit

final class ShopViewController: UITableViewController {
    var categorySectionIndexPath = IndexPath(row: 0, section: 4)
    var categorySectionHeight: CGFloat = 200
    let headerId = "headerId"
    
    
    func tableViewSetup() {
        tableView.register(ShopTableViewHeaderSection.self, forHeaderFooterViewReuseIdentifier: headerId)
        tableView.contentInset.bottom = 40
    }
    
    func setupFakeSearchController() {
        let searchController = UISearchController()
        searchController.searchBar.searchTextField.placeholder = "Search for Products"
        searchController.searchBar.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    
    
    func handleProductsSearchPresentation() {
        let searchCompletionResults = SearchCompletionResults()
        searchCompletionResults.delegate = self
        let nv = UINavigationController(rootViewController: searchCompletionResults)
        nv.modalPresentationStyle = .fullScreen
        present(nv, animated: false)
    }
    
    // MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSetup()
        setupFakeSearchController()
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
//                headerView?.sectionLabel.text = "New Products"
//            case 3:
//                headerView?.sectionLabel.text = "Most Ordered"
//            case 4:
//                headerView?.sectionLabel.text = "Categories"
//            default:
//                break
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


extension ShopViewController: UICollectionViewDynamicSizeDelegate {
    func collectionView(setDynamicSize dynamicSize: CGSize) {
        // TODO:- Stop Reloading Rows while presenting Products Search Controller
        //        categorySectionHeight = dynamicSize.height
        //        tableView.reloadRows(at: [categorySectionIndexPath], with: .top)
    }
}

extension ShopViewController: SearchCompletionResultsDelegate {
    func searchCompletionResults(didSelectResult result: String) {
        let newSearchDetailsViewController = UIStoryboard(name: "SearchDetailsViewController").getInitialViewController(of: SearchDetailsViewController.self)
        newSearchDetailsViewController.title = result
        navigationController?.pushViewController(newSearchDetailsViewController, animated: false)
    }
}

extension ShopViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        handleProductsSearchPresentation()
        return false
    }
}
