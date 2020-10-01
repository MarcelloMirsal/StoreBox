//
//  AutocompleteSearchViewModel.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 10/09/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import Foundation


protocol AutocompleteSearchViewModelDelegate: class {
    func autocompleteSearchFailed(message: String)
    func autocompleteSearchSuccess()
}

class AutocompleteSearchViewModel {
    private let searchingService: ProductsSearchingServiceProtocol
    weak var delegate: AutocompleteSearchViewModelDelegate?
    private(set) var searchResults: [ProductAutocompleteSearchResult] = []
    
    init(searchingService: ProductsSearchingServiceProtocol = ProductsSearchingService(authToken: UserAuthService.token ?? "")) {
        self.searchingService = searchingService
    }
    
    func set(searchResults: [ProductAutocompleteSearchResult] ) {
        self.searchResults = searchResults
    }
    
    func isValid(searchQuery: String) -> Bool {
        let isTrimmingTextEmpty = searchQuery.trimmingCharacters(in: .whitespaces).isEmpty
        let isSearchQueryCountIsLess = searchQuery.count < 3
        return isTrimmingTextEmpty || isSearchQueryCountIsLess ? false : true
    }
    
    func autocompleteSearch(query: String) {
        guard isValid(searchQuery: query) else { return }
        searchingService.autocompleteSearch(query: query) { [weak self] (serviceError, searchResults) in
            
            if let error = serviceError {
                self?.delegate?.autocompleteSearchFailed(message: error.localizedDescription)
                return
            }
            self?.set(searchResults: searchResults ?? [])
            self?.delegate?.autocompleteSearchSuccess()
        }
    }
    
    
}
