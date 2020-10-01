//
//  AutocompleteSearchViewModelTests.swift
//  StoreBoxTests
//
//  Created by Marcello Mirsal on 10/09/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import XCTest
@testable import StoreBox
class AutocompleteSearchViewModelTests: XCTestCase {
    
    var sut: AutocompleteSearchViewModel!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = AutocompleteSearchViewModel()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSetSearchResults_SearchResultsShouldBeUpdated() {
        let searchResults: [ProductAutocompleteSearchResult] = [ .init(name: "name", subCategoryName: "sub") ]
        
        sut.set(searchResults: searchResults )
        
        XCTAssertEqual(sut.searchResults.first?.name, searchResults.first?.name)
        XCTAssertEqual(sut.searchResults.first?.subCategoryName, searchResults.first?.subCategoryName)
        
    }
    
    func testIsValidSearchQueryWithEmptyText_ShouldReutnFalse() {
        let searchQuery = ""
        XCTAssertFalse(sut.isValid(searchQuery: searchQuery) )
    }
    
    func testIsValidSearchQueryWithTwoChars_ShouldReutnFalse() {
        let searchQuery = "BA"
        XCTAssertFalse(sut.isValid(searchQuery: searchQuery) )
    }
    
    func testIsValidSearchQueryWithValidQuery_ShouldReutnTrue() {
        let searchQuery = "Red Bag"
        XCTAssertTrue(sut.isValid(searchQuery: searchQuery) )
    }
    

    func testAutocompleteSearchWithFailedResponse_ServiceDelegateShouldCallSearchFailed() {
        arrangeSutWithFailedSearchingService()
        let exp = expectation(description: "testAutocompleteSearchWithFailedResponse")
        let spyDelegate = AutocompleteSearchViewModelDelegateSpy(testExpectation: exp)
        sut.delegate = spyDelegate
        let query = "Product"
        
        sut.autocompleteSearch(query: query)
        
        XCTAssertTrue(spyDelegate.isAutocompleteSearchFailed ?? false)
        
        wait(for: [exp], timeout: 1)
        
    }
    
    func testAutocompleteSearchWithSuccessResponse_ServiceDelegateShouldCallSearchSuccess() {
        arrangeSutWithSuccessSearchingService()
        let exp = expectation(description: "testAutocompleteSearchWithSuccessResponse")
        let spyDelegate = AutocompleteSearchViewModelDelegateSpy(testExpectation: exp)
        sut.delegate = spyDelegate
        let query = "Product"
        
        sut.autocompleteSearch(query: query)
        
        XCTAssertTrue(spyDelegate.isAutocompleteSearchSuccess ?? false)
        
        wait(for: [exp], timeout: 1)
        
    }
    
    func testAutocompleteSearchWithInvalidSearchQuery_() {
        let invalidSearchQuery = "BA"
        sut.autocompleteSearch(query: invalidSearchQuery)
    }
    
    func arrangeSutWithFailedSearchingService() {
        let fakeSearchingService = ProductsSearchingServiceFake(responseType: .failed)
        sut = .init(searchingService: fakeSearchingService)
    }
    
    func arrangeSutWithSuccessSearchingService() {
        let fakeSearchingService = ProductsSearchingServiceFake(responseType: .success)
        sut = .init(searchingService: fakeSearchingService)
    }
    
}


