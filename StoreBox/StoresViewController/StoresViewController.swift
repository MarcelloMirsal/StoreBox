//
//  StoresViewController.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 05/07/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import UIKit

class StoresViewController: UITableViewController {
    
    let cellId = "cellId"
    let headerId = "headerId"
    var items = [
        ("Electronics" , [ "One Store" , "Second Store" , "Last Store" ]) ,
        
        ("Cloths" , [ "One Store" , "Last Store" ] ) ,
        
        ("Shoes" , ["1 Store"])
    ]
    
    // MARK:- View's Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFakeSearchController()
        setupTableView()
    }
    
    // MARK:- Setup UI
    func setupFakeSearchController() {
        let searchController = UISearchController()
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func setupTableView() {
        tableView.contentInset.bottom = 24
        tableView.register(DetailsTableViewHeader.self, forHeaderFooterViewReuseIdentifier: headerId)
    }
    
    func pushStoreDetailsViewController(isAnimated: Bool = true) {
        let storeDetailsVC = UIStoryboard(name: "StoreDetailsViewController").getInitialViewController(of: StoreDetailsViewController.self)
        navigationController?.pushViewController(storeDetailsVC, animated: isAnimated)
    }
    
    func handleStoresSearchPresentation() {
        let searchCompletionResults = SearchCompletionResults()
        searchCompletionResults.delegate = self
        let nv = UINavigationController(rootViewController: searchCompletionResults)
        nv.modalPresentationStyle = .fullScreen
        present(nv, animated: false)
    }
}

// MARK:- UITableView Delegate & DataSource
extension StoresViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].1.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! StoreTableViewCell
        cell.textLabel?.text = items[indexPath.section].1[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier:
            headerId) as! DetailsTableViewHeader
        headerView.contentView.backgroundColor = tableView.backgroundColor
        headerView.sectionLabel.text = items[section].0
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushStoreDetailsViewController()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 42
    }
}

// MARK:- SearchCompletionResultsDelegate
extension StoresViewController: SearchCompletionResultsDelegate {
    func searchCompletionResults(didSelectResult result: String) {
        let newSearchDetailsViewController = UIStoryboard(name: "StoreSearchDetailsViewController").getInitialViewController(of: StoreSearchDetailsViewController.self)
        newSearchDetailsViewController.title = result
        navigationController?.pushViewController(newSearchDetailsViewController, animated: false)
    }
}

// MARK:- UISearchBarDelegate
extension StoresViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        handleStoresSearchPresentation()
        return false
    }
}
