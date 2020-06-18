//
//  SearchCompletionResults.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 12/06/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import UIKit

protocol SearchCompletionResultsDelegate: class {
    func searchCompletionResults(didSelectResult result: String)
}

final class SearchCompletionResults: UITableViewController {
    var items = 0
    let cellId = "cellId"
    weak var delegate: SearchCompletionResultsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        setupSearchController()
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.searchController?.isActive = true
        DispatchQueue.main.async {
            self.navigationItem.searchController?.searchBar.becomeFirstResponder()
        }
        
    }
    
    func setupTableView(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    func setupSearchController() {
        let searchController = UISearchController()
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.showsCancelButton = true
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        
    }
}

// MARK:- TableView Delegate & DataSource Implementation
extension SearchCompletionResults {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = "indexPath \(indexPath)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.searchCompletionResults(didSelectResult: "\(indexPath)")
        tableView.deselectRow(at: indexPath, animated: true)
        navigationItem.searchController?.searchBar.endEditing(true)
        dismiss(animated: true) // for searchContrller
        dismiss(animated: true) // for self
        //navigationItem.searchController?.dismiss(animated: true)
    }
}

extension SearchCompletionResults: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismiss(animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        items = searchText.count
        tableView.reloadData()
    }
    
}





