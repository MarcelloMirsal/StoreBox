//
//  AutocompleteSearchViewModel.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 10/09/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import UIKit
protocol AutocompleteSearchViewModelDelegate: class {
    func autocompleteSearchFailed(message: String)
    func autocompleteSearchSuccess()
}
extension AutocompleteSearchViewModel {
    typealias ViewDiffableDataSource = UITableViewDiffableDataSource<Section, ListItem<AutocompleteSearchResult>>
    typealias AutocompleteResultsListDTO = ProductsSearchingService.AutocompleteSearchResultListDTO
}

class AutocompleteSearchViewModel {
    private let searchingService: ProductsSearchingServiceProtocol
    private(set) var tableViewDataSource: ViewDiffableDataSource!
    weak var delegate: AutocompleteSearchViewModelDelegate?
    
    init(searchingService: ProductsSearchingServiceProtocol = ProductsSearchingService()) {
        self.searchingService = searchingService
    }
    
    func set(tableViewDataSource: ViewDiffableDataSource ) {
        self.tableViewDataSource = tableViewDataSource
    }
    func map(autocompleteList: AutocompleteResultsListDTO?) -> [ ListItem<AutocompleteSearchResult> ] {
        let mappedResults = autocompleteList?.products.map { (searchResult) -> AutocompleteSearchResult in
            .init(result: searchResult.name, detailsDescription: "\(String(describing: searchResult.subcategoryName))")
        }.map({ ListItem<AutocompleteSearchResult>(item: $0) })
        return mappedResults ?? []
    }
    
    func updateDataSourceSnapshot(from list: AutocompleteResultsListDTO?) {
        let listItems = map(autocompleteList: list)
        var freshSnapshot = NSDiffableDataSourceSnapshot<Section, ListItem<AutocompleteSearchResult> >()
        freshSnapshot.appendSections([.main])
        freshSnapshot.appendItems(listItems)
        tableViewDataSource.apply(freshSnapshot)
    }
    
    
    func isValid(searchQuery: String) -> Bool {
        let isTrimmingTextEmpty = searchQuery.trimmingCharacters(in: .whitespaces).isEmpty
        let isSearchQueryCountIsLess = searchQuery.count < 3
        return isTrimmingTextEmpty || isSearchQueryCountIsLess ? false : true
    }
    
    func autocompleteSearch(query: String) {
        guard isValid(searchQuery: query) else { return }
        searchingService.autocompleteSearch(query: query) { [weak self] (serviceError, searchResultsList) in
            if let error = serviceError {
                self?.delegate?.autocompleteSearchFailed(message: error.localizedDescription)
                return
            }
            self?.updateDataSourceSnapshot(from: searchResultsList)
            self?.delegate?.autocompleteSearchSuccess()
        }
    }
}

extension AutocompleteSearchViewModel {
    enum Section {
        case main
    }
}
