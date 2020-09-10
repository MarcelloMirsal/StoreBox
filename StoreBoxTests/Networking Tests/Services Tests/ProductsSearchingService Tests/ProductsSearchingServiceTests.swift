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
    
    
    func testGetAutocompleteSearchRequest_RequestSearchParamShouldBeEqualToPassedQuery() {
        let searchQuery = "Product"
        let searchRequest = sut.getAutocompleteSearchRequest(searchQuery: searchQuery)
        XCTAssertEqual(searchRequest.params?["search"], searchQuery)
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

class SearchingServiceParserTests: XCTestCase {
    
    var sut: SearchingServiceParser!
    override func setUp() {
        sut = SearchingServiceParser()
    }
    
    func testDecoderDecodingStrategy_ShouldBeEqualToSnakeCase() {
        let decodingStrategy = sut.decoder.keyDecodingStrategy
        switch decodingStrategy {
            case .convertFromSnakeCase: break
            default: XCTFail()
        }
    }
    
    func testParseAutocompleteFromNilData_ShouldThrowNoDataFound() {
        let exp = expectation(description: "testParseAutocompleteFromNilData")
        do { _ = try sut.parseAutocompleteResults(from: nil) }
        catch NetworkServiceError.noDataFound { exp.fulfill() }
        catch { XCTFail() }
        wait(for: [exp], timeout: 1)
    }
    
    func testParseAutocompleteFromEmptyData_ShouldThrowJSONDecodingFailure() {
        let exp = expectation(description: "testParseAutocompleteFromEmptyData")
        let data = Data()
        
        do { _ = try sut.parseAutocompleteResults(from: data) }
        catch NetworkServiceError.jsonDecodingFailure { exp.fulfill() }
        catch { XCTFail() }
        wait(for: [exp], timeout: 1)
    }
    
    func testParseAutocompleteFromDictDataWithWrongProductsKey_ShouldThrowJSONDecodingFailure() {
        let exp = expectation(description: "testParseAutocompleteFromEmptyData")
        let dict = ["WRONG Key" : 10]
        let dictData = try! JSONSerialization.data(withJSONObject: dict)
        
        do { _ = try sut.parseAutocompleteResults(from: dictData) }
        catch NetworkServiceError.jsonDecodingFailure { exp.fulfill() }
        catch { XCTFail() }
        wait(for: [exp], timeout: 1)
    }
    
    func testParseAutocompleteFromSuccessfulDataResponse_SearchResultsShouldBeNotNil() {
        let searchResult1 = ProductsSearchingService.AutocompleteSearchResult(name: "name1", subCategoryName: "sub1")
        let searchResult2 = ProductsSearchingService.AutocompleteSearchResult(name: "name2", subCategoryName: "sub2")
        
        let responseDict = [ "products" : [ searchResult1, searchResult2 ] ]
        
        let dictData = try! JSONEncoder().encode(responseDict)
        
        let searchResults = try? sut.parseAutocompleteResults(from: dictData)
        
        XCTAssertNotNil(searchResults)
    }
    
}
