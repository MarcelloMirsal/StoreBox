//
//  SearchingService.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 13/08/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import Alamofire

protocol ProductsSearchingServiceProtocol {
    typealias AutocompleteSearchResponse = (NetworkServiceError?,ProductsSearchingService.AutocompleteSearchResultListDTO?) -> ()
    
    typealias ProductSearchResponse = (NetworkServiceError?,ProductsList?) -> ()
    typealias SearchFilterListResponse<T> = (NetworkServiceError?,T?) -> ()
    
    func autocompleteSearch(query: String, completion: @escaping AutocompleteSearchResponse)
    
    func productSearch(query: String, params: [String: Any]  , completion: @escaping ProductSearchResponse)
}

class ProductsSearchingService: ProductsSearchingServiceProtocol {
    let networkManager = NetworkManagerFacade()
    let listingService = ListingService()
    let router: Router
    
    init(router: Router = Router() ) {
        self.router = router
    }
    
    func autocompleteSearch(query: String, completion: @escaping AutocompleteSearchResponse) {
        let searchRequest = router.autocompleteSearchRequest(withQuery: query).urlRequest!
        listingService.getList(listType: AutocompleteSearchResultListDTO.self, searchRequest) { (serviceError, list) in
            completion(serviceError, list)
        }
    }
    
    func productSearch(query: String, params: [String : Any ] = [:] , completion: @escaping ProductsSearchingService.ProductSearchResponse) {
        let searchRequest = router.searchRequest(withQuery: query, params: params).urlRequest!
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

// MARK:- Service Router
extension ProductsSearchingService {
    class Router {
    
        let searchRequest: NetworkRequestProtocol
        let autocompleteSearchRequest: NetworkRequestProtocol
        
        // used ti improve readability
        convenience init() {
            let searchRequest = NetworkRequest(path: Paths.searchRequestPath.rawValue )
            let autocompleteSearchRequest = NetworkRequest(path: Paths.autocompleteRequest.rawValue )
            
            self.init(searchRequest: searchRequest, autocompleteSearchRequest: autocompleteSearchRequest)
        }
        
        init(searchRequest: NetworkRequestProtocol, autocompleteSearchRequest: NetworkRequestProtocol) {
            var authedSearchRequest = searchRequest
            var authedAutocompleteSearchRequest = autocompleteSearchRequest
            
            let authParamKey = NetworkConstants.authorizationKey.rawValue
            let authToken = UserAuthService.token ?? ""
            
            authedSearchRequest.set(headers: [authParamKey : authToken])
            authedAutocompleteSearchRequest.set(headers: [authParamKey : authToken])
            
            self.searchRequest = authedSearchRequest
            self.autocompleteSearchRequest = authedAutocompleteSearchRequest
        }
        
        func searchRequest(withQuery query: String, params: [String : Any]) -> NetworkRequestProtocol {
            var newSearchRequest = searchRequest
            var searchRequestParams = params
            let searchParamKey = SearchFiltersParams.search.rawValue
            searchRequestParams[searchParamKey] = query
            newSearchRequest.set(params: searchRequestParams)
            return newSearchRequest
        }
        
        func autocompleteSearchRequest(withQuery query: String) -> NetworkRequestProtocol {
            var newSearchRequest = autocompleteSearchRequest
            let searchParamKey = SearchFiltersParams.search.rawValue
            newSearchRequest.set(params: [ searchParamKey : query ] )
            return newSearchRequest
        }
        
    }
}

// MARK:- Searchfiltering enums
extension ProductsSearchingService {
    
    enum Paths: String {
        case searchRequestPath = "/products"
        case autocompleteRequest = "/products/auto_complete"
    }
    
    enum SearchFiltersParams: String {
        case city = "city_id"
        case subcategories = "sub_category_id"
        case sort
        case direction
        case search
    }
    enum AssociatedSearchFiltersParams: String {
        case ascending = "asc"
        case descending = "desc"
        static func ascendingSorting() -> [String : String] {
            [SearchFiltersParams.direction.rawValue : AssociatedSearchFiltersParams.ascending.rawValue]
        }
        static func descendingSorting() -> [String : String] {
            [SearchFiltersParams.direction.rawValue : AssociatedSearchFiltersParams.descending.rawValue]
        }
    }
}

// MARK:- Helpers Types
extension ProductsSearchingService {
    struct AutocompleteSearchResultDTO: Codable {
        let name: String
        // TODO: removing optional until api updated
        let subcategoryName: String?
        
        enum CodingKeys: String, CodingKey {
            case name
            case subcategoryName = "subCategoryNameEn"
        }
    }
    struct AutocompleteSearchResultListDTO: Codable {
        let products: [AutocompleteSearchResultDTO]
        enum CodingKeys: String, CodingKey {
            case products
        }
    }
}
