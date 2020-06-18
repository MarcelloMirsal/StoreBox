//
//  SearchCompletionResultsTests.swift
//  StoreBoxTests
//
//  Created by Marcello Mirsal on 12/06/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import XCTest
@testable import StoreBox

final class SearchCompletionResultsTests: XCTestCase {
    var sut: SearchCompletionResults!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = SearchCompletionResults()
        _ = sut.view
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testTableViewRegisteredCell_ShouldBeNotNil() {
        sut.tableView.reloadData()
        let dequeuedCell = sut.tableView.dequeueReusableCell(withIdentifier: sut.cellId)
        XCTAssertNotNil(dequeuedCell)
    }
    
    func testTableViewCellForRowAtIndexPath_ShouldReturnNoNil() {
        let indexPath = IndexPath(row: 0, section: 0)
        let tableView = sut.tableView!
        let cell = sut.tableView(tableView, cellForRowAt: indexPath)
        XCTAssertNotNil(cell)
    }
    
    func testTableViewDidSelectRow_SelectedRowsShouldBeNil() {
        sut.tableView.reloadData()
        let indexPath = IndexPath(row: 0, section: 0)
        sut.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        sut.tableView(sut.tableView, didSelectRowAt: indexPath)
        XCTAssertNil(sut.tableView.indexPathsForSelectedRows)
    }
    
    func testSearchCompletionResultsDelegate_ShouldBeNil() {
        XCTAssertNil(sut.delegate)
    }
    
    func testSearchBarSearchText_ShouldUpdateResults() {
        let searchText = "Product"
        let itemsCountBeforeUpdate = sut.items
        sut.searchBar(.init(), textDidChange: searchText)
        let itemsCountAfterUpdate = sut.items
        XCTAssertNotEqual(itemsCountBeforeUpdate, itemsCountAfterUpdate)
    }
    
    func testViewDidAppear_() { // UI Test nothing to test
        sut.viewDidAppear(false)
    }
    
    func testSearchBarCancelButtonDidClick_() { // UI Test nothing to test
        let searchBar = sut.navigationItem.searchController!.searchBar
        sut.searchBarCancelButtonClicked(searchBar)
    }
    
    
    
    
}
