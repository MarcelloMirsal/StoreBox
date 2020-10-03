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
}

class ProductSearchViewModel {
    let searchingService: ProductsSearchingServiceProtocol
    weak var delegate: ProductSearchViewModelDelegate?
    private(set) var productsList : ProductsList = .emptyList()
    
    var canLoadMoreData: Bool {
        guard let _ = productsList.pagination.nextPage else { return false }
        return true
    }
    
    init(searchingService: ProductsSearchingServiceProtocol = ProductsSearchingService(authToken: UserAuthService.token ?? "")) {
        self.searchingService = searchingService
    }
  
    /// set a new products list
    func set(productList: ProductsList) {
        self.productsList = productList
    }
    
    /// update the current products list (appending products then set the new pagination )
    func update(productList: ProductsList) {
        self.productsList.append(products: productList.products)
        self.productsList.set(pagination: productList.pagination)
    }
    
    func productSearch(productName: String) {
        searchingService.productSearch(query: productName, params: [:], completion: productSearchResponseHandler(serviceError:list:) )
    }
    
    func loadMoreData(productName: String) {
        if let nextPage = productsList.pagination.nextPage {
            let pageParam = ["page" : "\(nextPage)"]
            searchingService.productSearch(query: productName, params: pageParam, completion: productSearchResponseHandler(serviceError:list:))
        }
    }
    
    
    func productSearchResponseHandler(serviceError: NetworkServiceError?, list: ProductsList? ) {
        if let error = serviceError {
            self.delegate?.searchRequestFailed(message: error.localizedDescription)
            return
        }
        if let productsList = list {
            update(productList: productsList)
            delegate?.searchRequestSuccess()
        }
    }
    
}

