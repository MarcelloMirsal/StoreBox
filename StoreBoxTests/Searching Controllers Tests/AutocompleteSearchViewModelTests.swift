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
    let tableView = UITableView(frame: .init(x: 0, y: 0, width: 100, height: 100), style: .plain)
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = AutocompleteSearchViewModel()
        sut.set(tableViewDataSource: .init(tableView: tableView, cellProvider: {_,_,_ in return .init()}))
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSetTableViewDataSource_ShouldTableViewDataSourceShouldEqualToPassed() {
        let dataSource = AutocompleteSearchViewModel.ViewDiffableDataSource(tableView: .init() , cellProvider: { _,_,_ in return nil })
        
        sut.set(tableViewDataSource: dataSource)
        
        XCTAssertEqual(sut.tableViewDataSource, dataSource)
    }
    
    func testMapAutocompleteResultsListDTO_ShouldReturnNotEmptySearchResults() {
        let list: ProductsSearchingService.AutocompleteSearchResultListDTO = .init(products: [.init(name: "HelloWorld", subcategoryName: "sub")])
        let mappedResultsList = sut.map(autocompleteList: list)
        XCTAssertTrue(!mappedResultsList.isEmpty)
    }
    
    func testMapNilAutocompleteResultsListDTO_ShouldReturnEmptySearchResults() {
        let mappedResultsList = sut.map(autocompleteList: nil)
        XCTAssertTrue(mappedResultsList.isEmpty)
    }
    
    func testUpdateDataSourceSnapshotFromResultsList_DataSourceSnapshotShouldContainsPassedResults() {
        let product1: ProductsSearchingService.AutocompleteSearchResultDTO = .init(name: "name1", subcategoryName: "sub1")
        let product2: ProductsSearchingService.AutocompleteSearchResultDTO = .init(name: "name2", subcategoryName: "sub2")
        let product3: ProductsSearchingService.AutocompleteSearchResultDTO = .init(name: "name3", subcategoryName: "sub3")
        let results: [ProductsSearchingService.AutocompleteSearchResultDTO] = [product1, product2 , product3]
        let mappedResults = results.map({AutocompleteSearchResult.init(result: $0.name, detailsDescription: String(describing: $0.subcategoryName) )})
        
        
        let list: ProductsSearchingService.AutocompleteSearchResultListDTO = .init(products: results)

        
        sut.updateDataSourceSnapshot(from: list)
        
        let items = sut.tableViewDataSource.snapshot().itemIdentifiers.map({$0.item})
        XCTAssertEqual(Set(items), Set(mappedResults))
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
        sut.set(tableViewDataSource: .init(tableView: .init(), cellProvider: {_,_,_ in return nil}))
    }
    
    func arrangeSutWithSuccessSearchingService() {
        let fakeSearchingService = ProductsSearchingServiceFake(responseType: .success)
        sut = .init(searchingService: fakeSearchingService)
        sut.set(tableViewDataSource: .init(tableView: .init(), cellProvider: {_,_,_ in return nil}))
    }
}
