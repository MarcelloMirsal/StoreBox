//
//  ProductsSearchViewModelTests.swift
//  StoreBoxTests
//
//  Created by Marcello Mirsal on 13/08/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import XCTest
@testable import StoreBox

class ProductsSearchViewModelTests: XCTestCase {

    var sut: ProductsSearchViewModel!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = ProductsSearchViewModel(productsSearchingService: ProductsSearchingService(authToken: "TokenID") )
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGetProductSearchResultsAtIndex_ShouldGetTheProperValue() {
        let result1 = ProductSearchResult(name: "A", subCategoryName: "Z")
        let result2 = ProductSearchResult(name: "B", subCategoryName: "X")
        sut.set(productsSearchResults: [ result1 , result2 ])
        
        let productSearchResult = sut.getProductsSearchResults(at: 0)!
        
        
        XCTAssertEqual(productSearchResult.name, result1.name)
    }
    
    func testSearchForProducts_SutDelegateShouldBeNotifiedWhenSearchDidFail() {
        let exp = expectation(description: "SutDelegateShouldBeNotifiedWhenSearchDidFail")
        let spyDelegate = ProductsSearchViewModelDelegateSpy()
        spyDelegate.searchFailedExp = exp
        sut = ProductsSearchViewModel(productsSearchingService: ProductsSearchingServiceFake(responseType: .failed))
        sut.delegate = spyDelegate
        
        let searchQuery = "product"
        sut.searchForProducts(query: searchQuery)
        
        XCTAssertTrue(spyDelegate.isSearchFailedNotified ?? false)
        wait(for: [exp], timeout: 1)
    }
    
    func testSearchForProducts_SutDelegateShouldBeNotifiedWhenSearchDidBegin() {
        let exp = expectation(description: "SutDelegateShouldBeNotifiedWhenSearchDidBegin")
        let spyDelegate = ProductsSearchViewModelDelegateSpy()
        spyDelegate.searchDidBeginExp = exp
        sut = ProductsSearchViewModel(productsSearchingService: ProductsSearchingServiceFake(responseType: .failed))
        sut.delegate = spyDelegate

        let searchQuery = "product"
        sut.searchForProducts(query: searchQuery)

        XCTAssertTrue(spyDelegate.isSearchDidBeginNotified ?? false)
        wait(for: [exp], timeout: 1)
    }
    
    func testSearchForProducts_SutDelegateShouldBeNotifiedWhenSearchDidComplete() {
        let exp = expectation(description: "SutDelegateShouldBeNotifiedWhenSearchDidComplete")
        let spyDelegate = ProductsSearchViewModelDelegateSpy()
        spyDelegate.searchDidBeginExp = exp
        
        sut = ProductsSearchViewModel(productsSearchingService: ProductsSearchingServiceFake(responseType: .success))
        sut.delegate = spyDelegate

        let searchQuery = "product"
        sut.searchForProducts(query: searchQuery)

        XCTAssertTrue(spyDelegate.isSearchDidCompleteNotified ?? false)
        wait(for: [exp], timeout: 1)
    }
    
    func testSearchForProducts_ProductSearchResultsShouldBePassedToSutWhenSearchDidComplete() {
        let exp = expectation(description: "ProductSearchResultsShouldBePassedToSutWhenSearchDidComplete")
        let spyDelegate = ProductsSearchViewModelDelegateSpy()
        spyDelegate.searchDidBeginExp = exp
        
        sut = ProductsSearchViewModel(productsSearchingService: ProductsSearchingServiceFake(responseType: .success))
        sut.delegate = spyDelegate

        sut.searchForProducts(query: "product")
        XCTAssertTrue(sut.productsSearchResultsCount != 0)
        wait(for: [exp], timeout: 1)
    }
    
    
    
}

private class ProductsSearchViewModelDelegateSpy: ProductsSearchViewModelDelegate {

    
    var searchFailedExp: XCTestExpectation?
    var searchDidBeginExp: XCTestExpectation?
    var SearchDidCompleteExp: XCTestExpectation?
    
    var isSearchFailedNotified: Bool?
    var isSearchDidBeginNotified: Bool?
    var isSearchDidCompleteNotified: Bool?
    
    func searchFailed(error: ProductSearchingErrors) {
        XCTAssertTrue(error == .badNetwork)
        isSearchFailedNotified = true
        searchFailedExp?.fulfill()
    }
    
    func searchDidBegin() {
        isSearchDidBeginNotified = true
        searchDidBeginExp?.fulfill()
    }
    
    func searchDidComplete() {
        isSearchDidCompleteNotified = true
        SearchDidCompleteExp?.fulfill()
    }
    
}



