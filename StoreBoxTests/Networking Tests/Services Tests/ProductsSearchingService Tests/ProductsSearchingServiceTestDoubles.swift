//
//  ProductsSearchingServiceTestDoubles.swift
//  StoreBoxTests
//
//  Created by Marcello Mirsal on 18/08/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import Foundation
@testable import StoreBox
class ProductsSearchingServiceFake: ProductsSearchingServiceProtocol {
    
    enum FakeResponseType {
        case failed
        case success
    }
    
    let responseType: FakeResponseType
    
    init(responseType: FakeResponseType) {
        self.responseType = responseType
    }
    
    var urlRequest: NetworkRequestProtocol = NetworkRequest(path: "")
    
    var authToken: String = "TokenId"
    
    var searchFilters: [String : String]?
    
    func autocompleteSearch(query: String, completion: ProductsSearchingServiceFake.AutocompleteSearchResponse) {
        
        switch responseType {
            case .failed:
                completion(.noDataFound, nil)
            case .success:
                let searchResults: ProductsSearchingService.AutocompleteSearchResultListDTO = .init(products: [ .init(name: "1", subcategoryName: "name")])
                completion(nil , searchResults )
        }
        
    }
    
    func productSearch(query: String, params: [String : Any] = [:], completion: @escaping ProductsSearchingService.ProductSearchResponse) {
        switch responseType {
            case .failed:
                completion(.noDataFound, nil)
            case .success:
                let product = Product(id: 20, name: "name", price: 10, discount: 1, priceAfterDiscount: 9, storeName: "store", subCategoryName: "Category")
                let productsList = ProductsList(products: [product], pagination: .emptyListPagination() )
                completion(nil ,  productsList)
                break
        }
    }
}
