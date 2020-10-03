//
//  ProductSearchViewModelTests.swift
//  StoreBoxTests
//
//  Created by Marcello Mirsal on 01/10/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import XCTest
@testable import StoreBox

class ProductSearchViewModelTests: XCTestCase {
    var sut: ProductSearchViewModel!
    
    override func setUp() {
        sut = ProductSearchViewModel()
    }
    
    func testProductSearchWithFailedResponse_ServiceSpyDelegateShouldCallSearchFailed() {
        arrangeSutWithFailedSearchingService()
        let exp = expectation(description: "testProductSearchWithFailedResponse")
        let productName = "Shirt"
        let delegateSpy = ProductSearchViewModelDelegateSpy(exp: exp)
        sut.delegate = delegateSpy
        
        sut.productSearch(productName: productName)
        XCTAssertTrue(delegateSpy.isSearchFailed ?? false)
        
        wait(for: [exp], timeout: 1)
        
    }
    
    func testProductSearchWithSuccessResponse_ServiceSpyDelegateShouldCallSearchSuccess() {
        arrangeSutWithSuccessSearchingService()
        let exp = expectation(description: "testProductSearchWithSuccessResponse")
        let productName = "Shirt"
        let delegateSpy = ProductSearchViewModelDelegateSpy(exp: exp)
        sut.delegate = delegateSpy
        
        sut.productSearch(productName: productName)
        XCTAssertTrue(delegateSpy.isSearchSuccess ?? false)
        
        wait(for: [exp], timeout: 1)
        
    }
    
    func testProductSearchWithSuccessResponse_ProductListShouldBeNotEmpty() {
        arrangeSutWithSuccessSearchingService()
        let exp = expectation(description: "testProductSearchWithSuccessResponse")
        let productName = "Shirt"
        let delegateSpy = ProductSearchViewModelDelegateSpy(exp: exp)
        sut.delegate = delegateSpy
        
        sut.productSearch(productName: productName)
        XCTAssertFalse(sut.productsList.products.isEmpty)
        XCTAssertTrue(delegateSpy.isSearchSuccess ?? false)
        
        wait(for: [exp], timeout: 1)
        
    }
    
    func testLoadMoreDataWith() { // Nothing Need To be tested: LoadMoreData is based on ProductSearch
        sut.set(productList: .init(products: [], pagination: .init(currentPage: 1, nextPage: 2, previousPage: nil, totalPages: 2, totalEntries: 10)))
        
        sut.loadMoreData(productName: "BAG")
    }
    
    
    func testCanLoadMoreData_ShouldReutnFalseWhenListPaginationNextPageIsNil() {
        XCTAssertFalse(sut.canLoadMoreData)
    }
    
    func testCanLoadMoreData_ShouldReutnTrueWhenListPaginationNextPageIsNotNil() {
        let listPagination = ListPagination(currentPage: 1, nextPage: 2, previousPage: nil, totalPages: 2, totalEntries: 10)
        sut.set(productList: .init(products: [], pagination: listPagination))
        XCTAssertTrue(sut.canLoadMoreData)
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

