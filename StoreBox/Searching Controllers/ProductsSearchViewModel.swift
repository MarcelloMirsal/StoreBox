//
//  ProductsSearchViewModel.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 13/08/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import Foundation

protocol ProductsSearchViewModelDelegate: class {
    func searchDidBegin()
    func searchFailed(error: ProductSearchingErrors)
    func searchDidComplete()
}

class ProductsSearchViewModel {
    
    private var productsSearchResults = [ProductSearchResult]()
    
    let productsSearchingService: ProductsSearchingServiceProtocol?
    weak var delegate: ProductsSearchViewModelDelegate?
    
    init(productsSearchingService: ProductsSearchingServiceProtocol? = ProductsSearchingService(authToken: UserAuthService.token) ) {
        self.productsSearchingService = productsSearchingService
    }
    
    var productsSearchResultsCount: Int {
        return productsSearchResults.count
    }
    
    func set(productsSearchResults: [ProductSearchResult]) {
        self.productsSearchResults = productsSearchResults
    }
    
    func getProductsSearchResults(at index: Int) -> ProductSearchResult? {
        return productsSearchResults[at: index]
    }
    
    
    
    
    func searchForProducts(query: String) {
        guard let searchService = productsSearchingService else { return }
        // if delegate nil cancel all
        delegate!.searchDidBegin()
        searchService.search(query: query) { [weak self] (products, responseError) in
            if let error = responseError {
                self?.delegate?.searchFailed(error: error)
            }
            guard let productSearchResults = products else { return }
            self?.set(productsSearchResults: productSearchResults)
            self?.delegate?.searchDidComplete()
        }
    }
    
}
