//
//  ShopViewControllerTests.swift
//  StoreBoxTests
//
//  Created by Marcello Mirsal on 05/05/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import XCTest
@testable import StoreBox
class ShopViewControllerTests: XCTestCase {
    
    var sut: ShopViewController!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = ShopViewController(collectionViewLayout: .init())
        _ = sut.view
    }
    
    
    // MARK:- Setup collectionView dataSource tests
    func testSetupCollectionViewDataSource_CollectionViewDataSourceShouldBeNotNil() {
        
    }
    
    func testDataSourceCellProviderBlock_ShouldReturnNotNilRegisteredCell() {
        let indexPath = IndexPath(item: 0, section: 0)
        let cell = sut.dataSourceCellProvider(sut.collectionView, indexPath, .init(item: "name"))
        XCTAssertNotNil(cell)
    }
}

