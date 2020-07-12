//
//  StoresViewControllerTests.swift
//  StoreBoxTests
//
//  Created by Marcello Mirsal on 05/07/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import XCTest
@testable import StoreBox
class StoresViewControllerTests: XCTestCase {
    
    var sut: StoresViewController!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = UIStoryboard(name: "StoresViewController").getInitialViewController(of: UINavigationController.self).topViewController as? StoresViewController
        _ = sut.view
        sut.tableView.reloadData()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testPushStoreDetailsViewController_NavigationTopViewShouldStoreDetails() {
        sut.pushStoreDetailsViewController(isAnimated: false)
        XCTAssertTrue(sut.navigationController?.topViewController is StoreDetailsViewController)
    }
    
    // MARK:- SearchController tests
    
    func testSearchController_ShouldBeNotNil() {
        XCTAssertNotNil(sut.navigationItem.searchController)
    }
    
    func testSearchBarDelegate_ShouldBeEqualToSUT() {
        let searchBar = sut.navigationItem.searchController!.searchBar
        XCTAssertTrue(searchBar.delegate === sut)
    }
    
    func testSearchBarDidBeginEditing_ShouldReturnFalse(){
        XCTAssertFalse(sut.searchBarShouldBeginEditing(.init()))
    }
    
    func testSearchResultsCompletion_NavigationTopViewControllerShouldBeStoreSearchDetailsViewController() {
        sut.searchCompletionResults(didSelectResult: "Store Name")
        XCTAssertTrue(sut.navigationController!.topViewController is StoreSearchDetailsViewController)
    }
    
    func testHandleStoresSearchPresentation() { // UI details
        sut.handleStoresSearchPresentation()
    }
    
    
    // MARK:- TableView delegate and DataSource Tests
    func testRegisteredCell_ShouldBeNotNil() {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = sut.tableView.dequeueReusableCell(withIdentifier: sut.cellId, for: indexPath) as? StoreTableViewCell
        XCTAssertNotNil(cell)
    }
    
    func testCellAtIndexPath_ShouldBeNotNil() {
        sut.tableView.reloadData()
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = sut.tableView.cellForRow(at: indexPath) as? StoreTableViewCell
        XCTAssertNotNil(cell)
    }
    
    func testRegiteredTableViewHeader_ShouldBeNotNil() {
        let headerView = sut.tableView.dequeueReusableHeaderFooterView(withIdentifier: sut.headerId) as? DetailsTableViewHeader
        XCTAssertNotNil(headerView)
    }
    
    func testDidSelectedRow_SelectedRowsShouldBeNil() {
        let indexPath = IndexPath(row: 0, section: 0)
        sut.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        sut.tableView(sut.tableView, didSelectRowAt: indexPath)
        XCTAssertNil(sut.tableView.indexPathForSelectedRow)
    }
    
}



