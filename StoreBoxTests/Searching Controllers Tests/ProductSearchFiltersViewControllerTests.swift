//
//  ProductSearchFiltersViewControllerTests.swift
//  StoreBoxTests
//
//  Created by Marcello Mirsal on 03/10/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import XCTest
@testable import StoreBox
class ProductSearchFiltersViewControllerTests: XCTestCase {
    var sut: ProductSearchFiltersViewController!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = UINavigationController(rootViewController: ProductSearchFiltersViewController.initiate()).topViewController as? ProductSearchFiltersViewController
        _ = sut.view
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testInitiate_ShouldReturnTableViewWithInsetGroupedStyle() {
        sut = ProductSearchFiltersViewController.initiate()
        XCTAssertNotNil(sut)
    }
    
    func testsSetupTableViewDataSource_DataSourceShouldBeNotNil() {
        sut.setupTableViewDataSource()
        
        XCTAssertNotNil(sut.tableView.dataSource)
    }

    func testDataSourceCellProvider_ShouldReturnNotNilCell() {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = sut.dataSourceCellProvider(sut.tableView, indexPath, .init(item: .init(name: "")))
        XCTAssertNotNil(cell)
    }
    
    func testUIDetails() {  //NothingToTest
        sut.tableView(sut.tableView, didSelectRowAt: IndexPath(row: 0, section: 0) )
        sut.handleSubmitAction()
        sut.handleFiltersResetAction()
    }
    
}

