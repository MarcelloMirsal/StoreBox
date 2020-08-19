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
    
    override func setUp() {
        sut = ProductsSearchingService(authToken: "TokenId")
    }
    
    func testProductsSearchURLRequest_ShouldBeEqualToProductsSearchPath() {
        let searchPath = "https://store-box-api.herokuapp.com/v1/products"
        XCTAssertEqual(searchPath, sut.productsSearchURLRequest.urlRequest!.url!.absoluteString)
    }
    
    func testSutInit_AuthTokenShouldBeEqualToPassedValue() {
        let authToken = "TokenId"
        sut = ProductsSearchingService(authToken: authToken)
        XCTAssertEqual(sut.authToken, authToken)
    }
    
    
    func testInitSearchRequestAuthorizationHeaderValue_ShouldBeEqualPassedToken() {
        XCTAssertEqual(sut.productsSearchURLRequest.headers?.first?.value , sut.authToken)
    }
    
    func testSearchRequestMethod_ShouldBeEqualGET() {
        let searchRequestMethod = "GET"
        XCTAssertEqual(sut.productsSearchURLRequest.method.rawValue , searchRequestMethod)
    }
    
    func testSetSearchFilter_SearchFiltersShouldBeEqualToPassed() {
        let searchFilters = ["key" : "value" , "key2" : "value2"]
        sut.set(searchFilters: searchFilters)
        XCTAssertEqual(sut.searchFilters, searchFilters)
    }
    
    func testSetupSearchParametersWithoutSearchFilters_ProductsSearchURLRequestShouldBeEqualToSearchURLString() {
        let searchQuery = "product"
        let searchURLString = "https://store-box-api.herokuapp.com/v1/products?search=product"
        
        sut.setupSearchParameters(with: searchQuery)
        XCTAssertEqual(sut.productsSearchURLRequest.urlRequest!.url!.absoluteString, searchURLString)
    }
    
    
    // using this approach because search parameters are placed randomly
    func testSetupSearchParametersWithSearchFilters_ProductsSearchURLRequestContainAllSearchFilters() {
        let searchQuery = "product"
        let searchFilters = ["Key" : "Value"]
        
        sut.set(searchFilters: searchFilters)
        sut.setupSearchParameters(with: searchQuery)
        
        let isContainingFilter = sut.productsSearchURLRequest.params!.contains { (pair) -> Bool in
            (pair.key == searchFilters.keys.first!) && (pair.value == searchFilters.values.first!)
        }
        XCTAssertTrue(isContainingFilter)
    }
    
    func testParseProductSearchResultsFromJSONData_ShouldReturnNotNilProductSearchResult() {
        let jsonDict = ["products" :
            [ ProductSearchResult(name: "productA", subCategoryName: "A"),
              ProductSearchResult(name: "productB", subCategoryName: "B"),
              ProductSearchResult(name: "productC", subCategoryName: "C")] ]
        let jsonData = try! JSONEncoder().encode(jsonDict)
        
        let searchProductResults = try? sut.parseProductSearchResults(from: jsonData)
        
        XCTAssertNotNil(searchProductResults)
    }
    
    func testParseProductSearchResultsFromBadFormattedJSONData_ShouldThrowBadFormattedError() {
        // jsonDict value is the bad formatted data
        let jsonDict = ["products" : [ "A" , "B" , "C" ] ]
        let jsonData = try! JSONEncoder().encode(jsonDict)
        
        do {
            let _ = try sut.parseProductSearchResults(from: jsonData)
            XCTFail()
        } catch ProductSearchingErrors.badFormattedJSON {
            XCTAssertTrue(true)
        } catch {}
    }
    
    func testSearchWithNetworkError_ProductSearchingErrorShouldBeNotNil() {
        let searchQuery = "product"
        let exp = expectation(description: "testSearchWithNetworkError")
        arrangeSutWithBadNetworkRequest()
        
        sut.search(query: searchQuery) { (products, error) in
            XCTAssertNil(products)
            XCTAssertNotNil(error)
            XCTAssertTrue(error! == .badNetwork)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
    
    func testSearchWithBadFormattedJSON_BadFormattedJSONErrorShouldBeNotNil() {
        arrangeSutWithBadJSONResponse()
        let exp = expectation(description: "testSearchWithBadFormattedJSON")
        sut.search(query: "product") { (products, error) in
            XCTAssertNil(products)
            XCTAssertNotNil(error)
            XCTAssertTrue(error! == .badFormattedJSON)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
    }
    
    func testSearchWithSuccessfultResponse_ProductSearchResultsShouldBeNotNil() {
        let searchQuery = "product"
        let exp = expectation(description: "testSearchWithSuccessfultResponse")
        arrangeSutWithLocalSuccessfulResponse()
        
        sut.search(query: searchQuery) { (products, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(products)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
    
    
    func arrangeSutWithLocalSuccessfulResponse() {
        let jsonResponsesFilePath = Bundle(for: ProductsSearchingServiceTests.self).path(forResource: "ProductsSearchingServiceResponses", ofType: "json")!
        sut = ProductsSearchingService(authToken: "TokenId", productsSearchURLRequest: NetworkRequestFake(path: jsonResponsesFilePath))
    }
    
    func arrangeSutWithBadJSONResponse() {
        let jsonResponsesFilePath = Bundle(for: ProductsSearchingServiceTests.self).path(forResource: "ProductsSearchingServiceBadJSON", ofType: "json")!
        sut = ProductsSearchingService(authToken: "TokenId", productsSearchURLRequest: NetworkRequestFake(path: jsonResponsesFilePath))
    }
    
    func arrangeSutWithBadNetworkRequest() {
        let jsonResponsesFilePath = Bundle(for: ProductsSearchingServiceTests.self).path(forResource: "ProductsSearchingServiceResponses", ofType: "json")!
        sut = ProductsSearchingService(authToken: "TokenId", productsSearchURLRequest: NetworkRequestFake(path: jsonResponsesFilePath + "BAD")) // BAD is the extra value in url which is cause a network error
    }
    
}

