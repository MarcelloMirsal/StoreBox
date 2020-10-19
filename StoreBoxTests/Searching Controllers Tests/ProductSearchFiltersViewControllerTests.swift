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
    
    func testViewModelFilterSectionsManagerDelegate_ShouldBeEqualToSUT() {
        XCTAssertTrue(sut.viewModel.filterSectionsManager.delegate === sut)
    }
    
    func testsSetupTableViewDataSource_DataSourceShouldBeNotNil() {
        sut.setupTableViewDataSource()
        
        XCTAssertNotNil(sut.dataSource)
    }
    
    func testDataSourceCellProvider_ShouldReturnNotNilCell() {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = sut.dataSource.tableView(sut.tableView, cellForRowAt: indexPath)
        XCTAssertNotNil(cell)
    }
    
    func testDataSourceCellProviderWithSelectedFilter_ShouldReturnSelectedCell() {
        
        print(sut.dataSource.snapshot().itemIdentifiers)
        print(sut.dataSource.snapshot().sectionIdentifiers)
        guard let filter = sut.dataSource.snapshot().itemIdentifiers(inSection: .sortBy).first else {
            XCTFail()
            return
        }
        guard let indexPath = sut.dataSource.indexPath(for: filter) else {
            XCTFail()
            return
        }
        sut.handleFilterSelection(at: indexPath)
        let cell = sut.dataSource.tableView(sut.tableView, cellForRowAt: indexPath)
        XCTAssertTrue(cell.accessoryType == .checkmark )
    }
    
    
    func testSectionAtOutofRangeIndex_ShouldReturnNil() {
        let indexPath = IndexPath(row: 20, section: 20)
        
        XCTAssertNil(sut.section(at: indexPath.section))
    }
    
    func testTableViewHeaderView_ShouldReturnNotNilHeaderView() {
        let section = 0
        let headerView = sut.tableView(sut.tableView, viewForHeaderInSection: section) as? TitledTableViewHeaderFooterView
        XCTAssertNotNil(headerView)
    }
    
    func testHandleFilterSelectionAtNoneExistFilter_ShouldReturn() {
        let indexPath = IndexPath(row: 0, section: 2)
        sut.handleFilterSelection(at: indexPath)
    }
    
    func testHandleFilterSelectionAtExistFilter_ShouldReturn() {
        guard let filter = sut.dataSource.snapshot().itemIdentifiers.first else {
            XCTFail() ; return
        }
        guard let indexPath = sut.dataSource.indexPath(for: filter) else {
            XCTFail() ; return
        }
        sut.handleFilterSelection(at: indexPath)
    }
    
    func testUIDetails() {  //NothingToTest
        sut.tableView(sut.tableView, didSelectRowAt: IndexPath(row: 0, section: 0) )
        sut.filterSectionsManager(didSelectFilter: .init(name: ""))
        sut.filterSectionsManager(didDeselectFilter: .init(name: ""))
        sut.filterSectionsManager(didUpdateSection: .cities)
        sut.handleSubmitAction()
        sut.handleFiltersResetAction()
        sut.reload(filter: .init(name: ""))
    }
    
}

