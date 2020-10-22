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
    
    func testSetProductsList_ShouldSetProductsList() {
        let product = Product(id: 1, name: "", price: 10, discount: 1, priceAfterDiscount: 9, storeName: "", subCategoryName: "")
        let newProductsList = ProductsList(products: [product], pagination: .emptyListPagination())
        
        sut.set(productList: newProductsList)
        
        XCTAssertEqual(sut.productsList.products, [product])
        XCTAssertEqual(sut.productsList.pagination.nextPage, newProductsList.pagination.nextPage)
        
    }
    
    func testUpdateProductList_ShouldSetNewProductListWhenListIsEmpty() {
        let product = Product(id: 1, name: "", price: 10, discount: 1, priceAfterDiscount: 9, storeName: "", subCategoryName: "")
        let newProductsList = ProductsList(products: [product], pagination: .emptyListPagination())
        
        sut.update(fetchedProductsList: newProductsList)
        
        XCTAssertEqual(sut.productsList.products, [product])
        XCTAssertEqual(sut.productsList.pagination.nextPage, newProductsList.pagination.nextPage)
    }
    
    func testUpdateProductList_ShouldAppendNewProductListWhenListIsNotEmpty() {
        let currentProduct = Product(id: 1, name: "", price: 10, discount: 1, priceAfterDiscount: 9, storeName: "", subCategoryName: "")
        let currentProductsList = ProductsList(products: [currentProduct], pagination: .emptyListPagination())
        sut.set(productList: currentProductsList)
        let newProduct = Product(id: 10, name: "", price: 10, discount: 1, priceAfterDiscount: 9, storeName: "", subCategoryName: "")
        
        let newPagination = ListPagination(currentPage: 2, nextPage: 3, previousPage: 1, totalPages: 10, totalEntries: 10)
        let newProductsList = ProductsList(products: [newProduct], pagination: newPagination)
        
        sut.update(fetchedProductsList: newProductsList)
        
        XCTAssertEqual(sut.productsList.products, [currentProduct , newProduct])
        XCTAssertEqual(sut.productsList.pagination.nextPage, newPagination.nextPage)
        XCTAssertEqual(sut.productsList.pagination.previousPage, newPagination.previousPage)

    }
    
    func testSetSearchFiltersParams_ShouldSetSearchFiltersParams() {
        let searchParams: [String : String] = [ "A" : "Filter", "B" : "10" ]
        sut.set(searchFiltersParams: searchParams)
    
        XCTAssertEqual(searchParams["A"], sut.searchFiltersParams["A"] as? String)
        XCTAssertEqual(searchParams["B"], sut.searchFiltersParams["B"] as? String)
    }
    
    func testProductSearchFiltersViewModel_ShouldSetSearchFiltersParams() {
        let searchParams: [String : String] = [ "A" : "Filter", "B" : "10" ]
        sut.productSearchFiltersViewModel(didSubmitFilters: searchParams)
        
        XCTAssertEqual(searchParams["A"], sut.searchFiltersParams["A"] as? String)
        XCTAssertEqual(searchParams["B"], sut.searchFiltersParams["B"] as? String)
    }
    
    func testProductSearch_ShouldSetSearchQueryFromProductName() {
        let productName = "Product"
        sut.productSearch(productName: productName)
        XCTAssertEqual(sut.searchQuery, productName)
    }
    
    func testProductSearch_ShouldSetProductListToEmpty() {
        let product = Product(id: 10, name: "name", price: 12, discount: 12, priceAfterDiscount: 12, storeName: "", subCategoryName: "")
        let pagination = ListPagination(currentPage: 1, nextPage: 2, previousPage: nil, totalPages: 10, totalEntries: 10)
        sut.set(productList: .init(products: [product], pagination: pagination))
        
        sut.productSearch(productName: "productName")
    
        let list = sut.productsList
        let emptyListPagination = ListPagination.emptyListPagination()
        
        XCTAssertTrue(list.products.isEmpty)
        XCTAssertTrue(list.pagination.nextPage == emptyListPagination.nextPage)
        XCTAssertTrue(list.pagination.previousPage == emptyListPagination.previousPage)
    }
    
    func testProductSearch_DelegateSpyIsSearchDidBeginShouldBeTrue() {
        let exp = expectation(description: "testProductSearch_DelegateSpyIsSearchDidBeginShouldBeTrue")
        let productName = "Shirt"
        let delegateSpy = ProductSearchViewModelDelegateSpy(exp: exp)
        sut.delegate = delegateSpy
        
        sut.productSearch(productName: productName)
        XCTAssertTrue(delegateSpy.isSearchDidBegin ?? false)
        
        wait(for: [exp], timeout: 1)
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

