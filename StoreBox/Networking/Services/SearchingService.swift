//
//  SearchingService.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 13/08/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import Alamofire


// tomorrow:
//request router
//response parser

protocol ProductsSearchingServiceProtocol {
    func autocompleteSearch(query: String, completion: @escaping ProductsSearchingService.AutocompleteResponse)
}

class ProductsSearchingService: ProductsSearchingServiceProtocol {
    typealias AutocompleteResponse = (NetworkServiceError?,[AutocompleteSearchResult]?) -> ()
    
    let urlRequest: NetworkRequestProtocol
    let networkManager = NetworkManagerFacade()
    
    init(authToken: String, urlRequest: NetworkRequestProtocol = NetworkRequest(path: "/products") ) {
        var authedURLRequest = urlRequest
        authedURLRequest.set(headers: [ "Authorization" : authToken ] )
        self.urlRequest = authedURLRequest
    }
    
    func autocompleteSearch(query: String, completion: @escaping AutocompleteResponse) {
        let searchRequest = getAutocompleteSearchRequest(searchQuery: query).urlRequest!
        
        networkManager.json(searchRequest) { (requestError, data) in
            if let error = requestError {
                completion(.badNetworkRequest(error), nil)
                return
            }
            
            do {
                let parser = SearchingServiceParser()
                let searchResults = try parser.parseAutocompleteResults(from: data)
                completion(nil, searchResults)
            }
            catch { completion(.jsonDecodingFailure, nil) }
            
        }
    }
    
    func getAutocompleteSearchRequest(searchQuery: String) -> NetworkRequestProtocol {
        var searchRequest = urlRequest
        searchRequest.set(params: [ "search" : searchQuery ])
        return searchRequest
    }
    
    struct AutocompleteSearchResult: Codable {
        let name: String
        let subCategoryName: String
        enum CodingKeyes: String , CodingKey {
            case name , subCategoryName = "sub_category_name"
        }
    }
}


class SearchingServiceParser {
    typealias AutocompleteSearchResults = [ProductsSearchingService.AutocompleteSearchResult]
    
    let decoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }()
    
    func parseAutocompleteResults(from jsonData: Data?) throws -> AutocompleteSearchResults {
        
        guard let data = jsonData else { throw NetworkServiceError.noDataFound }
        
        guard let searchResponse = try? decoder.decode(AutocompleteSearchResponse.self, from: data) else { throw NetworkServiceError.jsonDecodingFailure }
        
        return searchResponse.products
    }
    
    private struct AutocompleteSearchResponse: Codable {
        let products: AutocompleteSearchResults
        enum CodingKeyes: String, CodingKey { case products }
    }
    
}



