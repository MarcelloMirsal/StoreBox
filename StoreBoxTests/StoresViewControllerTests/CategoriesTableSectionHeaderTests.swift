//
//  CategoriesTableSectionHeaderTests.swift
//  StoreBoxTests
//
//  Created by Marcello Mirsal on 06/07/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import XCTest
@testable import StoreBox

class CategoriesTableSectionHeaderTests: XCTestCase {
    
    var sut: CategoriesTableSectionHeader!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = CategoriesTableSectionHeader()
        sut.didMoveToWindow()
        sut.collectionView.reloadData()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testDequeueRegisteredCell_ShouldBeNotNil() {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = sut.collectionView.dequeueReusableCell(withReuseIdentifier: sut.cellId, for: indexPath ) as? CategoriesSectionCollectionViewCell
        XCTAssertNotNil(cell)
    }
    
    func testCellatIndexPath_ShouldBeNotNil() {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = sut.collectionView(sut.collectionView, cellForItemAt: indexPath) as? CategoriesSectionCollectionViewCell
        XCTAssertNotNil(cell)
    }
    
    
    // UI Details test
    
    func test_UI_Details() {
        let _ = sut.collectionView(sut.collectionView, layout: sut.collectionView.collectionViewLayout, sizeForItemAt: .init(item: 0, section: 0))
        
        sut.collectionView(sut.collectionView, didSelectItemAt: .init(row: 0, section: 0    ))
        
        _ = sut.collectionView(sut.collectionView, layout: .init(), minimumLineSpacingForSectionAt: 0)
        
    }
    
    
}
