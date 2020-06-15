//
//  ProductsSearchViewController.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 11/06/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import UIKit

final class ProductsSearchViewController: UITableViewController {
    
    var searchController: UISearchController!
    
    // MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async { [weak self] in
            self?.searchController.searchBar.becomeFirstResponder()
        }
    }
    func setupSearchController() {
        let searchCompletionResults = SearchCompletionResults()
        searchCompletionResults.delegate = self
        searchController = UISearchController(searchResultsController:  searchCompletionResults )
        searchController.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        
    }

    
}

extension ProductsSearchViewController: SearchCompletionResultsDelegate {
    
    func searchCompletionResults(didSelectResult result: String) {
        let searchDetailsViewController = UIStoryboard(name: "SearchDetailsViewController").getInitialViewController(of: SearchDetailsViewController.self)
        searchDetailsViewController.title = result
        navigationController?.pushViewController(searchDetailsViewController, animated: true)
    }
}

extension ProductsSearchViewController: UISearchControllerDelegate {
    func didDismissSearchController(_ searchController: UISearchController) {
        dismiss(animated: true)
    }
}
