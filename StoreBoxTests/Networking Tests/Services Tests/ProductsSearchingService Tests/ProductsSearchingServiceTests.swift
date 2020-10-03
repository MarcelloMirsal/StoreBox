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
        sut = ProductsSearchingService(authToken: tokenId)
    }
    
    func testSutInit_urlRequestPathShouldBeEqualToPath() {
        let path = "/products"
        XCTAssertEqual(sut.urlRequest.path, path)
    }
    
    func testSutInit_urlRequestAuthorizationHeaderShouldBeEqual() {
        XCTAssertEqual(sut.urlRequest.headers!.first!.value, tokenId)
    }
    
    
    func testGetAutocompleteSearchRequest_SearchParamShouldBeEqualToPassedSearchQuery() {
        let searchQuery = "Product"
        let searchRequest = sut.getAutocompleteSearchRequest(searchQuery: searchQuery)
        XCTAssertEqual(searchRequest.params?["search"], searchQuery)
    }
    
    func testGetProductSearchRequest_SearchParamValueShouldBeEqualToPassedSearchQuery() {
        let searchQuery = "Product"
        let searchRequest = sut.getProductSearchRequest(searchQuery: searchQuery)
        XCTAssertEqual(searchRequest.params?.first!.value, searchQuery)
    }
    
    func testGetProductSearchRequestWithParams_SearchRequestParamsShouldContainAllSearchParams() {
        let searchQuery = "Product"
        let searchParams = ["page" : "1"]
        let searchRequest = sut.getProductSearchRequest(searchQuery: searchQuery,params: searchParams)
        let isContainSearchParams = searchRequest.params?.contains(where: { (pair) -> Bool in
            pair.key == searchParams.first?.key && pair.value == searchParams.first?.value
        })
        
        XCTAssertTrue(isContainSearchParams ?? false)
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
        
        wait(for: [exp], timeout: 1)
    }
    
    func testAutocompleteSearchWithSuccessfulResponse_SearchResultsShouldBeNotNil() {
        arrangeSutWithLocalSuccessfulResponse()
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
        
        sut = ProductsSearchingService(authToken: tokenId, urlRequest: NetworkRequestFake(path: jsonResponsesFilePath))
    }
    
    func arrangeSutWithBadJSONResponse() {
        let jsonResponsesFilePath = Bundle(for: ProductsSearchingServiceTests.self).path(forResource: "ProductsSearchingServiceBadJSON", ofType: "json")!
        
        sut = ProductsSearchingService(authToken: "TokenId", urlRequest: NetworkRequestFake(path: jsonResponsesFilePath))
    }
    
    func arrangeSutWithBadNetworkRequest() {
        let jsonResponsesFilePath = Bundle(for: ProductsSearchingServiceTests.self).path(forResource: "ProductsSearchingServiceResponses", ofType: "json")!
        
        sut = ProductsSearchingService(authToken: tokenId, urlRequest: NetworkRequestFake(path: jsonResponsesFilePath + "BAD" ))
        // BAD is the extra value in url which is cause a network error
    }
    
}
