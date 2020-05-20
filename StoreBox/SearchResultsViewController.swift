//
//  SearchResultsViewController.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 19/05/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import UIKit

class SearchResultsViewController: UITableViewController{
    let cellId = "cellId"
    var items = 5
    var isPresentingDetails = false
    var searchDetailsViewController: SearchDetailsViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    func setupSearchDetailsViewController(with navigationDelegate: SearchDetailsNavigationDelegate) {
        searchDetailsViewController = UIStoryboard(name: "SearchDetailsViewController").getInitialViewController(of: SearchDetailsViewController.self)
        searchDetailsViewController?.searchDetailsNavigationDelegate = navigationDelegate
        searchDetailsViewController?.modalPresentationStyle = .currentContext
    }
    
    func dismisSearchDetailsViewController() {
        if isPresentingDetails {
            isPresentingDetails = false
            dismiss(animated: false)
        }
    }
    
}

// MARK:- UITableViewDelegate and DataSource Implementation
extension SearchResultsViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = "Completion \(indexPath.row)"
        cell.imageView?.image = #imageLiteral(resourceName: "Search")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isPresentingDetails = true
        tableView.deselectRow(at: indexPath, animated: true)
        guard let searchDetailsVC = searchDetailsViewController else { return }
        present(searchDetailsVC, animated: false)
    }
    
    
    
}
// MARK:- UISearchBarDelegate Implementation
extension SearchResultsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        dismisSearchDetailsViewController()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismisSearchDetailsViewController()
        searchDetailsViewController = nil // to release from memory
        // TODO: Should Clear TableViewResults
        items = 0
        tableView.reloadData()
    }
}
