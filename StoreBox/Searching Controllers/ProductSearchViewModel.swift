//
//  ProductSearchViewModel.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 01/10/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import UIKit

protocol ProductSearchViewModelDelegate: class {
    func searchRequestFailed(message: String)
    func searchRequestSuccess()
    func searchRequestDidBegin()
}

class ProductSearchViewModel {
    let searchingService: ProductsSearchingServiceProtocol
    weak var delegate: ProductSearchViewModelDelegate?
    private(set) var productsList : ProductsList = .emptyList()
    private(set) var searchFiltersParams = [String : Any]()
    private(set) var searchQuery: String = ""
    
    var canLoadMoreData: Bool {
        guard let _ = productsList.pagination.nextPage else { return false }
        return true
    }
    
    init(searchingService: ProductsSearchingServiceProtocol = ProductsSearchingService() ) {
        self.searchingService = searchingService
    }
  
    /// set a new products list for new search query
    func set(productList: ProductsList) {
        self.productsList = productList
    }
    
    func set(searchFiltersParams: [String : Any]) {
        self.searchFiltersParams = searchFiltersParams
    }
    
    /// update the current products list (set new products when the list is empty or appending if list is not empty )
    func update(fetchedProductsList: ProductsList) {
        if self.productsList.products.isEmpty {
            set(productList: fetchedProductsList)
        } else {
            self.productsList.append(products: fetchedProductsList.products)
            self.productsList.set(pagination: fetchedProductsList.pagination)
        }
    }
    
    /// start a fresh product search(delete previous results) with submited filters
    func productSearch(productName: String) {
        searchQuery = productName
        set(productList: .emptyList())
        delegate?.searchRequestDidBegin()
        searchingService.productSearch(query: searchQuery, params: searchFiltersParams, completion: productSearchResponseHandler(serviceError:list:) )
    }
    
    func loadMoreData(productName: String) {
        if let nextPage = productsList.pagination.nextPage {
            var searchParams = searchFiltersParams
            searchParams["page"] = "\(nextPage)"
            searchingService.productSearch(query: productName, params: searchParams, completion: productSearchResponseHandler(serviceError:list:))
        }
    }
    
    
    func productSearchResponseHandler(serviceError: NetworkServiceError?, list: ProductsList? ) {
        if let error = serviceError {
            delegate?.searchRequestFailed(message: error.localizedDescription)
            return
        }
        if let productsList = list {
            update(fetchedProductsList: productsList)
            delegate?.searchRequestSuccess()
        }
    }
    
}

// MARK:- Search filters submition delegate
extension ProductSearchViewModel: ProductSearchFiltersViewModelDelegate {
    func productSearchFiltersViewModel(didSubmitFilters filters: [String : Any]) {
        set(searchFiltersParams: filters)
        productSearch(productName: searchQuery)
    }
}

