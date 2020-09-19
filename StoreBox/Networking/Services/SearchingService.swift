//
//  SearchingService.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 13/08/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import Alamofire

protocol ProductsSearchingServiceProtocol {
    typealias AutocompleteSearchResponse = (NetworkServiceError?,[ProductAutocompleteSearchResult]?) -> ()
    
    typealias ProductSearchResponse = (NetworkServiceError?,ProductsList?) -> ()
    
    func autocompleteSearch(query: String, completion: @escaping AutocompleteSearchResponse)
    
    func productSearch(query: String, completion: @escaping ProductSearchResponse)
    
}

class ProductsSearchingService: ProductsSearchingServiceProtocol {
    let urlRequest: NetworkRequestProtocol
    let networkManager = NetworkManagerFacade()
    
    init(authToken: String, urlRequest: NetworkRequestProtocol = NetworkRequest(path: "/products") ) {
        var authedURLRequest = urlRequest
        let authKey = NetworkConstants.authorizationKey.rawValue
        authedURLRequest.set(headers: [ authKey : authToken ] )
        self.urlRequest = authedURLRequest
    }
    
    func autocompleteSearch(query: String, completion: @escaping AutocompleteSearchResponse) {
        let searchRequest = getAutocompleteSearchRequest(searchQuery: query).urlRequest!
        
        networkManager.json(searchRequest) { (requestError, data) in
            
            if let error = requestError {
                completion(.badNetworkRequest(error), nil)
                return
            }
            
            do {
                let parser = Parser()
                let searchResponse: ProductAutocompleteSearchResponse = try parser.parse(from: data)
                let searchResults = searchResponse.products
                completion(nil, searchResults)
            }
            catch { completion(.jsonDecodingFailure, nil) }
            
        }
    }
    
    func productSearch(query: String, completion: @escaping ProductsSearchingService.ProductSearchResponse) {
        let searchRequest = getProductSearchRequest(searchQuery: query).urlRequest!
        networkManager.json(searchRequest) { (requestError, data) in

            if let error = requestError {
                completion(.badNetworkRequest(error), nil)
                return
            }

            do {
                let parser = Parser()
                let productsList: ProductsList = try parser.parse(from: data)
                completion(nil, productsList)
            }
            catch { completion(.jsonDecodingFailure, nil) }
        }
    }
    
    func getAutocompleteSearchRequest(searchQuery: String) -> NetworkRequestProtocol {
        var searchRequest = urlRequest
        searchRequest.set(params: [ "search" : searchQuery ])
        return searchRequest
    }
    
    func getProductSearchRequest(searchQuery: String) -> NetworkRequestProtocol {
        var searchRequest = urlRequest
        searchRequest.set(params: [ "search" : searchQuery ])
        return searchRequest
    }
    
}

// MARK:- Service Parser
extension ProductsSearchingService {
    class Parser: NetworkServiceParser {
        var decoder: JSONDecoder = {
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            return jsonDecoder
        }()
    }
}

// MARK:- Helpers Types
extension ProductsSearchingService {
    private struct ProductAutocompleteSearchResponse: Codable {
        let products: [ProductAutocompleteSearchResult]
        enum CodingKeyes: String, CodingKey { case products }
    }
}
