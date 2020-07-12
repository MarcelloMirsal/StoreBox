//
//  StoreDetailsViewControllerTests.swift
//  StoreBoxTests
//
//  Created by Marcello Mirsal on 06/07/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import XCTest
@testable import StoreBox

class StoreDetailsViewControllerTests: XCTestCase {
    var sut: StoreDetailsViewController!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = UIStoryboard(name: "StoreDetailsViewController").getInitialViewController(of: StoreDetailsViewController.self)
        _ = sut.view
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testStoreImageViewUserInteractionIsEnabled_ShouldBeTrue() {
        XCTAssert(sut.storeImageView.isUserInteractionEnabled)
    }
    
    // MARK:- UITableView Delegate & DataSource
    func testRegisteredCell_ShouldBeNotNil() {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = sut.tableView.dequeueReusableCell(withIdentifier: sut.cellId, for: indexPath) as? ProductTableViewCell
        XCTAssertNotNil(cell)
    }
    
    func testCellAtIndexPath_ShouldBeNotNil() {
        sut.tableView.reloadData()
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = sut.tableView(sut.tableView, cellForRowAt: indexPath) as? ProductTableViewCell
        XCTAssertNotNil(cell)
    }
    
    func testViewForHeaderInSection_ShouldBeNotNil() {
        sut.tableView.reloadData()
        let indexPath = IndexPath(row: 0, section: 0)
        let headerView = sut.tableView(sut.tableView, viewForHeaderInSection: indexPath.section) as? CategoriesTableSectionHeader
        XCTAssertNotNil(headerView)
    }
    
    func testDidSelectedRow_SelectedRowsShouldBeNil() {
        let indexPath = IndexPath(row: 0, section: 0)
        sut.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        sut.tableView(sut.tableView, didSelectRowAt: indexPath)
        XCTAssertNil(sut.tableView.indexPathForSelectedRow)
    }
}
