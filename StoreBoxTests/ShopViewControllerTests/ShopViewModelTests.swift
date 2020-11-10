//
//  ShopViewModelTests.swift
//  StoreBoxTests
//
//  Created by Marcello Mirsal on 01/11/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import XCTest
@testable import StoreBox


class ShopViewModelTests: XCTestCase {
    
    var sut: ShopViewModel!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = ShopViewModel()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // MARK:- Setup collectionViewDataSource tests
    func testSetCollectionViewDataSource_DataSourceShouldBeEqualToPassed() {
        let dataSource = ShopViewModel.ViewDataSource(collectionView: .init(frame: .zero, collectionViewLayout: .init()), cellProvider: { _,_,_ in return .init() })
        sut.set(collectionViewDataSource: dataSource)
        
        XCTAssertEqual(dataSource, sut.collectionViewDataSource)
    }
    
}
