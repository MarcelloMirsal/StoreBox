//
//  ProductSearchingServiceRouterTests.swift
//  StoreBoxTests
//
//  Created by Marcello Mirsal on 26/10/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import XCTest
@testable import StoreBox

class ProductSearchingServiceRouterTests: XCTestCase {
    var sut: ProductsSearchingService.Router!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = .init()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testInit_RequestsPathsShouldBeEqualToPassedPaths() {
        let searchPath = "/SearchPath"
        let autocompletePath = "/autocompletePath"
        
        sut = .init(searchRequest: NetworkRequestFake(path: searchPath), autocompleteSearchRequest: NetworkRequestFake(path: autocompletePath))
        
        XCTAssertEqual(sut.searchRequest.path, searchPath)
        XCTAssertEqual(sut.autocompleteSearchRequest.path, autocompletePath)
    }
    
    func testSearchRequestWithQueryAndParams_ShouldReturnRequestWithPassedParamsAndSearchQuery() {
        let searchParamKey = ProductsSearchingService.SearchFiltersParams.search.rawValue
        let searchQuery = "Product"
        let searchFilters = [ "Key1" : "Value", "Key2" : "Value2" ]
        var requestParams = searchFilters
        requestParams[searchParamKey] = searchQuery
        
        let searchRequest = sut.searchRequest(withQuery: searchQuery, params: searchFilters )
        
        
        XCTAssertEqual(searchRequest.params as? [String : String], requestParams)
    }
    
    func testAutocompleteSearchRequestWithQuery_ShouldSetSearchQueryToParams() {
        let searchQuery = "Product"
        
        let autocompleteSearchRequest = sut.autocompleteSearchRequest(withQuery: searchQuery)
        let searchParam = autocompleteSearchRequest.params?.first as? (String, String)
        
        XCTAssertEqual(searchParam?.0, ProductsSearchingService.SearchFiltersParams.search.rawValue)
        XCTAssertEqual(searchParam?.1, searchQuery)
    }
}
