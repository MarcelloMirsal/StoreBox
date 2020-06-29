//
//  SearchFilteringViewControllerTests.swift
//  StoreBoxTests
//
//  Created by Marcello Mirsal on 15/06/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import XCTest
@testable import StoreBox

class SearchFilteringViewControllerTests: XCTestCase {
    var sut: SearchFilteringViewController!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let nv = UIStoryboard(name: "SearchFilteringViewController").getInitialViewController(of: UINavigationController.self)
        sut = (nv.topViewController as! SearchFilteringViewController)
        _ = sut.view
        sut.tableView.reloadData()
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testTableView_ShouldBeNotNil(){
        XCTAssertNotNil(sut.tableView)
    }
    
    func testTableViewDelegateAndDataSource_ShouldBeEqualToSUT() {
        XCTAssertTrue(sut === sut.tableView.delegate)
        XCTAssertTrue(sut === sut.tableView.dataSource)
    }
    
    func testDoneButton_ShouldBeNotNil() {
        XCTAssertNotNil(sut.doneButton)
    }
    
    func testCellAtIndexPath_ShouldBeNotNil() {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = sut.tableView.cellForRow(at: indexPath)
        XCTAssertNotNil(cell)
    }
    
    func testRegisteredHeaderViewAtIndexPath_ShouldBeNotNil() {
        let indexPath = IndexPath(row: 0, section: 0)
        let headerView = sut.tableView(sut.tableView, viewForHeaderInSection: indexPath.section) as? ShopTableViewHeaderSection
        XCTAssertNotNil(headerView)
    }
    
    func testUIDetails_() { // Nothing Need To test
        sut.handleCancel(sut.doneButton!)
        sut.handleDone(sut.doneButton!)
//        let indexPath0 = IndexPath(row: 0, section: 0)
//        let indexPath1 = IndexPath(row: 0, section: 1)
//        sut.tableView(sut.tableView, didSelectRowAt: indexPath0)
//        sut.tableView(sut.tableView, didSelectRowAt: indexPath1)
    }
    
}
