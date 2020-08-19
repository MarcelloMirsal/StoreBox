//
//  ProductsSearchViewController.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 13/08/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import UIKit

class ProductsSearchViewController: UITableViewController {
    
    private(set) lazy var viewModel: ProductsSearchViewModel = {
        let viewModel = ProductsSearchViewModel()
        viewModel.delegate = self
        return viewModel
    }()
    let cellId = "cellId"
    
    // MARK: View Life's Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.navigationItem.searchController?.searchBar.becomeFirstResponder()
        }
    }
    
    func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    func setupSearchController() {
        let searchController = UISearchController()
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.searchTextField.placeholder = "Search for Products"
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }
    
    
}

// MARK:- TableView Delegate and DataSource Implementation
extension ProductsSearchViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.productsSearchResultsCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = viewModel.getProductsSearchResults(at: indexPath.row)?.name
        cell.imageView?.image = #imageLiteral(resourceName: "Search")
        return cell
    }

}

extension ProductsSearchViewController: ProductsSearchViewModelDelegate {
    
    func searchDidBegin() {
        print("didBegin")
    }
    
    func searchFailed(error: ProductSearchingErrors) {
        print("searchFaild")
        present(UIAlertController.makeAlert("Please try again", title: "Error"), animated: true)
    }
    
    func searchDidComplete() {
        print("Did Complete ")
        tableView.reloadData()
    }
    
    
}

extension ProductsSearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationController?.dismiss(animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload(_:)), object: searchBar)
        perform(#selector(self.reload(_:)), with: searchBar, afterDelay: 1)
    }
    
    @objc func reload(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, query.trimmingCharacters(in: .whitespaces) != "" else {return}
        viewModel.searchForProducts(query: query)
    }
}
