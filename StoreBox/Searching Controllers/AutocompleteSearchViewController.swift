//
//  AutocompleteSearchViewController.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 10/09/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import UIKit


class AutocompleteSearchViewController: UITableViewController {
    
    let cellId = "cellId"
    var searchTask: DispatchWorkItem?
    let searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "Search for products"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.isActive = true
        return searchController
    }()
    
    let viewModel = AutocompleteSearchViewModel()
    
    weak var mainNavigationController: UINavigationController?
    
    func setupSearchController() {
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }
    
    func getProductSearchViewController(for productSearchQuery: String) -> UIViewController {
        let viewController = ProductSearchViewController.initiate(for: productSearchQuery)
        viewController.navigationItem.largeTitleDisplayMode = .never
        return viewController
    }
    
    // MARK:- View's Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        viewModel.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.searchController.searchBar.searchTextField.becomeFirstResponder()
        }
    }
}

extension AutocompleteSearchViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let index = indexPath.row
        cell.textLabel?.text = viewModel.searchResults[at: index]?.name
        cell.detailTextLabel?.text = viewModel.searchResults[at: index]?.subCategoryName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let  index = indexPath.row
        let productSearchQuery = viewModel.searchResults[at: index]?.name ?? ""
        let productSearchViewController = getProductSearchViewController(for: productSearchQuery)
        tableView.deselectRow(at: indexPath, animated: true)
        mainNavigationController?.pushViewController(productSearchViewController, animated: false)
        searchController.dismiss(animated: false) {
            self.dismiss(animated: true)
        }
    }
}


extension AutocompleteSearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismiss(animated: true)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTask?.cancel()
        searchTask = DispatchWorkItem { [weak self] in // to avoid Retain cycle
            self?.viewModel.autocompleteSearch(query: searchText)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75, execute: searchTask!)
    }
}

extension AutocompleteSearchViewController: AutocompleteSearchViewModelDelegate {
    func autocompleteSearchFailed(message: String) {
        let alertController = UIAlertController.makeAlert(message, title: "Request failed")
        present(alertController, animated: true)
    }
    
    func autocompleteSearchSuccess() {
        tableView.reloadData()
    }
}
