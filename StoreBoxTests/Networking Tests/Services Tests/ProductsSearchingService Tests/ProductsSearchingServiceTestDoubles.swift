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
    
    var productsSearchURLRequest: NetworkRequestProtocol = NetworkRequest(path: "")
    
    var authToken: String = "TokenId"
    
    var searchFilters: [String : String]?
    
    func search(query: String, completion: @escaping ProductsSearchingService.ProductsSearchResponse) {
        switch responseType {
            case .failed:
                completion([ProductSearchResult]() , .badNetwork)
            case .success:
                let products = [
                    ProductSearchResult(name: "A", subCategoryName: "Z"),
                    ProductSearchResult(name: "B", subCategoryName: "X"),
                ]
            completion(products, nil)
        }
    }
    
    
}
