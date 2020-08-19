//
//  SearchingService.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 13/08/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import Alamofire

class ProductsSearchingService: ProductsSearchingServiceProtocol {
    typealias ProductsSearchResponse = ([ProductSearchResult]?, ProductSearchingErrors?) -> ()
    
    let authToken: String
    var productsSearchURLRequest: NetworkRequestProtocol
    var searchFilters: [String : String]?
    
    init?(authToken: String?, productsSearchURLRequest: NetworkRequestProtocol = NetworkRequest(path: "/products") ) {
        guard let authToken = authToken else { return nil  }
        self.authToken = authToken
        self.productsSearchURLRequest = productsSearchURLRequest
        
        let authHeader = ["Authorization" : authToken]
        self.productsSearchURLRequest.set(headers: authHeader)
    }
    
    func search(query: String, completion: @escaping ProductsSearchResponse) {
        setupSearchParameters(with: query)
        AF.request(productsSearchURLRequest).validate().responseJSON { [weak self](jsonDataResponse) in
            
            if let _ = jsonDataResponse.error { // Network request Error here only
                completion(nil, ProductSearchingErrors.badNetwork)
                return
            }
            
            guard let data = jsonDataResponse.data else { return }
            
            do {
                let productSearchResults = try self?.parseProductSearchResults(from: data)
                completion(productSearchResults, nil)
            } catch {
                completion(nil , .badFormattedJSON)
            }
        }
    }
    
    
    func parseProductSearchResults(from data: Data) throws -> [ProductSearchResult] {
        
        let jsonDict = try! JSONSerialization.jsonObject(with: data) as! [String : Any]
        let productsJsonObject = jsonDict["products"]!
        let productsData = try! JSONSerialization.data(withJSONObject: productsJsonObject)
        let productSearchResults: [ProductSearchResult]
        do {
            let results = try JSONDecoder().decode([ProductSearchResult].self, from: productsData)
            productSearchResults = results
        } catch { throw ProductSearchingErrors.badFormattedJSON }
        return productSearchResults
    }
    
    func setupSearchParameters(with searchQuery: String) {
        let searchQueryParam = ["search" : searchQuery]
        guard let filterParams = searchFilters else {
            productsSearchURLRequest.set(params: searchQueryParam)
            return
        }
        let searchingParams = searchQueryParam.merging(filterParams, uniquingKeysWith: {$1} )
        productsSearchURLRequest.set(params: searchingParams)
    }
    
    func set(searchFilters: [String : String]?) {
        self.searchFilters = searchFilters
        // call new search
    }
    
}


protocol ProductsSearchingServiceProtocol {
    var productsSearchURLRequest: NetworkRequestProtocol { get }
    var authToken: String { get }
    var searchFilters: [String : String]? { get }
    func search(query: String, completion: @escaping ProductsSearchingService.ProductsSearchResponse )
}


enum ProductSearchingErrors: Error {
    case badFormattedJSON
    case badNetwork
}

extension ProductSearchingErrors: LocalizedError {
    var localizedDescription: String {
        switch self {
            case .badFormattedJSON:
                return "Cant decode ProductSearchResult, Model is no matching the API"
            case .badNetwork:
                return "Bad network, try again"
        }
    }
}


struct ProductSearchResult: Codable {
    let name: String
    let subCategoryName: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case subCategoryName = "sub_category_name"
    }
}
