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
    private(set) weak var mainNavigationController: UINavigationController?
    private(set) lazy var viewModel: AutocompleteSearchViewModel = {
        let viewModel = AutocompleteSearchViewModel()
        viewModel.delegate = self
        return viewModel
    }()
    
    
    // MARK:- Factory
    static func initiate(mainNavigationController: UINavigationController?) -> AutocompleteSearchViewController {
        let viewController = AutocompleteSearchViewController()
        viewController.mainNavigationController = mainNavigationController
        return viewController
    }
    
    // MARK:- View's Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupTableViewDataSource()
    }
    
    // MARK:- setup views
    func setupTableView() {
        tableView.register(ResultTableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    // MARK:- setup ViewModel with tableViewDatasource
    func setupTableViewDataSource() {
        viewModel.set(tableViewDataSource: .init(tableView: tableView, cellProvider: { [id = self.cellId]
            (tableView, indexPath, listItem) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as? ResultTableViewCell
            cell?.textLabel?.text = listItem.item.result
            cell?.detailTextLabel?.text = "in subcategory"
            return cell
        }))
    }
    
    // MARK:- Presentation
    @discardableResult
    func presentProductSearchViewController(for productSearchQuery: String) -> ProductSearchViewController {
        let productSearchViewController = ProductSearchViewController.initiate(for: productSearchQuery)
        productSearchViewController.navigationItem.largeTitleDisplayMode = .never
        mainNavigationController?.pushViewController(productSearchViewController, animated: true)
        return productSearchViewController
    }
}

// MARK:- TableView delegate
extension AutocompleteSearchViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedListItem = viewModel.tableViewDataSource.itemIdentifier(for: indexPath) {
            let productSearchQuery = selectedListItem.item.result
            presentProductSearchViewController(for: productSearchQuery)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

// MARK:- UISearchBar delegate
extension AutocompleteSearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismiss(animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTask?.cancel()
        searchTask = DispatchWorkItem { [weak self] in
            self?.viewModel.autocompleteSearch(query: searchText)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75, execute: searchTask!)
    }
}

// MARK:- ViewModel delegate
extension AutocompleteSearchViewController: AutocompleteSearchViewModelDelegate {
    func autocompleteSearchFailed(message: String) {
        let alertController = UIAlertController.makeAlert(message, title: "Error")
        present(alertController, animated: true)
    }
    func autocompleteSearchSuccess() {
    }
}

// MARK:- Helpers UIViews
extension AutocompleteSearchViewController {
    class ResultTableViewCell: UITableViewCell {
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: .value1, reuseIdentifier: reuseIdentifier)
            setupUI()
        }
        
        required init?(coder: NSCoder) {
            return nil
        }
        
        func setupUI() {
            imageView?.image = UIImage(systemName: "magnifyingglass")
            imageView?.tintColor = .systemGray
            detailTextLabel?.textColor = .systemGray
        }
    }
}
