//
//  ProductSearchViewControllerTests.swift
//  StoreBoxTests
//
//  Created by Marcello Mirsal on 15/09/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import XCTest
@testable import StoreBox
class ProductSearchViewControllerTests: XCTestCase {
    
    var sut: ProductSearchViewController!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = ProductSearchViewController.initiate(for: "Product")
        _ = sut.view
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSharedInitiate_ViewControllerTitleShouldBeEqualToPassedSearchQuery() {
        let searchQuery = "BAG"
        let viewController = ProductSearchViewController.initiate(for: searchQuery)
        XCTAssertEqual(viewController.title, searchQuery)
    }
    
    func testSutViewModelDelegate_ShouldBeEqualToSUT() {
        XCTAssertTrue(sut.viewModel.delegate === sut )
    }
    
    func testDataSourceCellProvider_ShouldRetunNotNilRegisteredCell() {
        let product = Product(id: 100, name: "NAME", price: 1.0, discount: 0.0, priceAfterDiscount: 1.0, storeName: "STORE", subCategoryName: "CATEGORY")
        let indexPath = IndexPath(item: 0, section: 0)
        
        let cell = sut.dataSourceCellProvider(collectionView: sut.collectionView, indexPath: indexPath, product: product)
        
        XCTAssertNotNil(cell)
        
    }
    
    func testCollectionViewDataSource_ShouldBeEqualToDataSource() {
        XCTAssertTrue(sut.collectionView.dataSource === sut.dataSource)
    }
    
    func testUI_Details() {
        sut.collectionView(sut.collectionView, didSelectItemAt: .init(item: 0, section: 0))
        sut.handleFilterAction()
        sut.searchRequestFailed(message: "")
        sut.searchRequestSuccess()
    }
}


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
        
        sut.productsSearch(productName: productName)
        XCTAssertTrue(delegateSpy.isSearchFailed ?? false)
        
        wait(for: [exp], timeout: 1)
        
    }
    
    func testProductSearchWithSuccessResponse_ServiceSpyDelegateShouldCallSearchSuccess() {
        arrangeSutWithSuccessSearchingService()
        let exp = expectation(description: "testProductSearchWithSuccessResponse")
        let productName = "Shirt"
        let delegateSpy = ProductSearchViewModelDelegateSpy(exp: exp)
        sut.delegate = delegateSpy
        
        sut.productsSearch(productName: productName)
        XCTAssertTrue(delegateSpy.isSearchSuccess ?? false)
        
        wait(for: [exp], timeout: 1)
        
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


class ProductSearchViewModelDelegateSpy: ProductSearchViewModelDelegate {
    
    let exp: XCTestExpectation
    
    init(exp: XCTestExpectation) {
        self.exp = exp
    }
    var isSearchFailed: Bool?
    var isSearchSuccess: Bool?
    
    func searchRequestFailed(message: String) {
        isSearchFailed = true
        exp.fulfill()
    }
    
    func searchRequestSuccess() {
        isSearchSuccess = true
        exp.fulfill()
    }
    
    
}
