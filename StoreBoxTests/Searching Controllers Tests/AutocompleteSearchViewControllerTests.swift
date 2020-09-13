//
//  AutocompleteSearchViewControllerTests.swift
//  StoreBoxTests
//
//  Created by Marcello Mirsal on 10/09/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import XCTest
@testable import StoreBox

class AutocompleteSearchViewControllerTests: XCTestCase {
    
    var sut: AutocompleteSearchViewController!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = UIStoryboard(name: "AutocompleteSearchViewController").getInitialViewController(of: AutocompleteSearchViewController.self)
        _ = sut.view
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testViewModelDelegate_ShouldBeEqualToSut() {
        XCTAssertTrue(sut.viewModel.delegate === sut)
    }
    
    func testSetupSearchController_NavigationItemSearchControllerShouldBeNotNil() {
        sut.setupSearchController()
        XCTAssertNotNil(sut.navigationItem.searchController)
    }
    
    func testSearchControllerBarDelegate_ShouldBeEqualToSut() {
        XCTAssertTrue(sut.searchController.searchBar.delegate === sut)
    }
    
    
    // MARK:- TableView delegate and DataSource Tests
    func testRegisteredCell_ShouldBeNotNil() {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = sut.tableView.dequeueReusableCell(withIdentifier: sut.cellId, for: indexPath)
        XCTAssertNotNil(cell)
    }
    
    func testCellForRow_ShouldReturnNotNilCell() {
        let indexPath = IndexPath(row: 0, section: 0)
        XCTAssertNotNil(sut.tableView(sut.tableView, cellForRowAt: indexPath))
    }
    
    
    // MARK: UI Details Tests
    func testViewDetails() {
        sut.viewDidAppear(true)
        sut.searchBarCancelButtonClicked(.init())
        sut.searchBar(.init(), textDidChange: "Search Query")
        sut.autocompleteSearchSuccess()
        sut.autocompleteSearchFailed(message: "message")
        
    }
}
