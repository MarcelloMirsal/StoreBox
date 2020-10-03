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
    
    func testCollectionViewDataSource_ShouldBeEqualToDataSource() {
        XCTAssertTrue(sut.collectionView.dataSource === sut.dataSource)
    }
    
    func testDataSource_ShouldRetunNotNilRegisteredCell() {
        arrangeSutCollectionViewFakeProducts()
        let indexPath = IndexPath(item: 0, section: 0)
        
        let cell = sut.dataSource.collectionView(sut.collectionView, cellForItemAt: indexPath) as? ProductCollectionViewCell
        
        XCTAssertNotNil(cell)
    }
    
    func testDataSource_ShouldReturnNotNilRegisteredFooter() {
        arrangeSutCollectionViewFakeProducts()
        let indexPath = IndexPath(item: 0, section: 0)
        
        let footerView = sut.dataSource.collectionView(sut.collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionFooter, at: indexPath) as? UICollectionViewLoadingFooter
        
        XCTAssertNotNil(footerView)
    }
    
    func testUpdateDataSourceSnapshot_ShouldReturnSnapshotForMainSection() {
        let snapshot = sut.updateDataSourceSnapshot()
        XCTAssertTrue(snapshot.sectionIdentifiers.contains(.main))
    }
    
    func testUI_Details() {
        sut.collectionView(sut.collectionView, didSelectItemAt: .init(item: 0, section: 0))
        sut.handleFilterAction()
        sut.searchRequestFailed(message: "")
        sut.searchRequestSuccess()
    }
    
    func arrangeSutCollectionViewFakeProducts() {
        let product = Product(id: 100, name: "NAME", price: 1.0, discount: 0.0, priceAfterDiscount: 1.0, storeName: "STORE", subCategoryName: "CATEGORY")
        
        var snapshot = NSDiffableDataSourceSnapshot<ProductSearchViewController.Section, Product>()
        snapshot.appendSections([.main])
        snapshot.appendItems( [product] )
        sut.dataSource.apply(snapshot)
    }
}
