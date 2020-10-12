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
    
    typealias SearchFilter = ProductSearchFiltersViewController.SearchFilter
    var sut: ProductSearchFiltersViewController!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = ProductSearchFiltersViewController.initiate()
        _ = sut.view
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testInitiate_ShouldReturnTableViewWithInsetGroupedStyle() {
        sut = ProductSearchFiltersViewController.initiate()
        XCTAssertNotNil(sut)
    }
    
    func testViewModelFilterSectionsManagerDelegate_ShouldBeEqualToSUT() {
        XCTAssertTrue(sut.viewModel.filterSectionsManager.delegate === sut)
    }
    
    func testsSetupTableViewDataSource_DataSourceShouldBeNotNil() {
        sut.setupTableViewDataSource()
        
        XCTAssertNotNil(sut.dataSource)
    }
    
    func testDataSourceCellProvider_ShouldReturnNotNilCell() {
        let indexPath = IndexPath(row: 0, section: 0)
        let filter = SearchFilter(name: "Name")
        
        let cell = sut.dataSourceCellProvider(tableView: sut.tableView, indexPath: indexPath, filter: filter)
        
        XCTAssertNotNil(cell)
    }
    
    func testTableViewHeaderView_ShouldReturnNotNilHeaderView() {
        let section = 0
        let headerView = sut.tableView(sut.tableView, viewForHeaderInSection: section) as? TitledTableViewHeaderFooterView
        XCTAssertNotNil(headerView)
    }
    
    func testUIDetails() {  //NothingToTest
        sut.tableView(sut.tableView, didSelectRowAt: IndexPath(row: 0, section: 0) )
        sut.filterSectionsManager(didSelectFilter: .init(name: ""))
        sut.filterSectionsManager(didDeselectFilter: .init(name: ""))
    }
    
}

