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
    
    
    func productSearch(query: String, completion: @escaping ProductsSearchingService.ProductSearchResponse) {
    }
    
    
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
                let searchResult: ProductAutocompleteSearchResult = .init(name: "name", subCategoryName: "category")
                completion(nil , [searchResult] )
        }
        
    }
    
}
