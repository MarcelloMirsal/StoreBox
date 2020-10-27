//
//  ProductsSearchingServiceTests.swift
//  StoreBoxTests
//
//  Created by Marcello Mirsal on 13/08/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import XCTest
@testable import StoreBox

class ProductsSearchingServiceTests: XCTestCase {
    
    var sut: ProductsSearchingService!
    let tokenId = "TokenId"
    
    override func setUp() {
        sut = ProductsSearchingService()
    }
    
    func testAutocompleteSearchWithBadNetwork_ErrorShouldBeBadNetworkRequest() {
        arrangeSutWithBadNetworkRequest()
        let exp = expectation(description: "testAutocompleteSearchWithBadNetwork")
        let searchQuery = "Product"
        
        sut.autocompleteSearch(query: searchQuery) { (error, searchResults) in
            XCTAssertEqual(error, NetworkServiceError.badNetworkRequest(.unSpecified) )
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
    }
    
    func testAutocompleteSearchWithBadJSON_ErrorShouldBeJSONDecodingFailure() {
        arrangeSutWithBadJSONResponse()
        let exp = expectation(description: "testAutocompleteSearchWithBadJSON")
        let searchQuery = "Product"
        
        sut.autocompleteSearch(query: searchQuery) { (error, searchResults) in
            XCTAssertEqual(error, NetworkServiceError.jsonDecodingFailure )
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5)
    }
    
    func testAutocompleteSearchWithSuccessfulResponse_SearchResultsShouldBeNotNil() {
        arrangeSutWithLocalSuccessfulAutocompleteResponse()
        let exp = expectation(description: "testAutocompleteSearchWithSuccessfulResponse")
        let searchQuery = "Product"
        
        sut.autocompleteSearch(query: searchQuery) { (error, searchResults) in
            XCTAssertNil(error)
            XCTAssertNotNil(searchResults)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
    }
    
    func testProductSearchWithBadNetwork_ErrorShouldBeBadNetworkRequest() {
        arrangeSutWithBadNetworkRequest()
        let exp = expectation(description: "testProductSearchWithBadNetwork")
        let searchQuery = "Product"
        
        sut.productSearch(query: searchQuery) { (error, searchResults) in
            XCTAssertEqual(error, NetworkServiceError.badNetworkRequest(.unSpecified) )
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
    }
    
    func testProductSearchWithBadJSON_ErrorShouldBeJSONDecodingFailure() {
        arrangeSutWithBadJSONResponse()
        let exp = expectation(description: "testProductSearchWithBadJSON")
        let searchQuery = "Product"

        sut.productSearch(query: searchQuery) { (error, searchResults) in
            XCTAssertEqual(error, NetworkServiceError.jsonDecodingFailure )
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1)
    }
    
    func testProductSearchWithSuccessfulResponse_SearchResultsShouldBeNotNil() {
        arrangeSutWithLocalSuccessfulResponse()
        let exp = expectation(description: "testProductSearchWithSuccessfulResponse")
        let searchQuery = "Product"

        sut.productSearch(query: searchQuery) { (error, productsList) in
            XCTAssertNil(error)
            XCTAssertNotNil(productsList)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1)
    }
    
    func arrangeSutWithLocalSuccessfulResponse() {
        let jsonResponsesFilePath = Bundle(for: ProductsSearchingServiceTests.self).path(forResource: "ProductsSearchingServiceResponses", ofType: "json")!
        
        let fakeRequest = NetworkRequestFake(path: jsonResponsesFilePath)
        let fakeRouter = ProductsSearchingService.Router(searchRequest: fakeRequest, autocompleteSearchRequest: NetworkRequestFake() )
        sut = ProductsSearchingService(router: fakeRouter)
    }
    
    func arrangeSutWithLocalSuccessfulAutocompleteResponse() {
        let jsonResponsesFilePath = Bundle(for: ProductsSearchingServiceTests.self).path(forResource: "AutocompleteSearchSuccessfulResponse", ofType: "json")!

        let fakeRequest = NetworkRequestFake(path: jsonResponsesFilePath)
        let fakeRouter = ProductsSearchingService.Router(searchRequest: NetworkRequestFake() , autocompleteSearchRequest: fakeRequest )
        sut = ProductsSearchingService(router: fakeRouter)
    }
    
    func arrangeSutWithBadJSONResponse() {
        let jsonResponsesFilePath = Bundle(for: ProductsSearchingServiceTests.self).path(forResource: "ProductsSearchingServiceBadJSON", ofType: "json")!

        let fakeRequest = NetworkRequestFake(path: jsonResponsesFilePath)
        let fakeRouter = ProductsSearchingService.Router(searchRequest: fakeRequest, autocompleteSearchRequest: fakeRequest )
        sut = ProductsSearchingService(router: fakeRouter)
    }
    
    func arrangeSutWithBadNetworkRequest() {
        let fakeRequest = NetworkRequestFake(path: "/BAD")
        // BAD is the extra value in url which is cause a network error
        let fakeRouter = ProductsSearchingService.Router(searchRequest: fakeRequest, autocompleteSearchRequest: fakeRequest )
        sut = ProductsSearchingService(router: fakeRouter)
    }
    
}


// MARK:- Service paths tests
extension ProductsSearchingServiceTests {
    func testServicePaths_ShouldBeEqualToLiteralValues() {
        let searchPath = ProductsSearchingService.Paths.searchRequestPath.rawValue
        let autocompleteSearchPath = ProductsSearchingService.Paths.autocompleteRequest.rawValue
        XCTAssertEqual(searchPath, "/products")
        XCTAssertEqual(autocompleteSearchPath, "/products/auto_complete")
    }
}

// MARK:- ProductSearchFiltersParams Tests
extension ProductsSearchingServiceTests {
    func testSearchFiltersParamsRawValues_ShouldBeEqual() {
        let searchFiltersParams = ProductsSearchingService.SearchFiltersParams.self
        XCTAssertEqual(searchFiltersParams.sort.rawValue, "sort")
        XCTAssertEqual(searchFiltersParams.subcategories.rawValue, "sub_category_id")
        XCTAssertEqual(searchFiltersParams.city.rawValue, "city_id")
        XCTAssertEqual(searchFiltersParams.direction.rawValue, "direction")
        XCTAssertEqual(searchFiltersParams.search.rawValue, "search")
    }
}
