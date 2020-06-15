//
//  ProductsSearchViewControllerTests.swift
//  StoreBoxTests
//
//  Created by Marcello Mirsal on 11/06/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import XCTest
@testable import StoreBox

class ProductsSearchViewControllerTests: XCTestCase {

    var sut: ProductsSearchViewController!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = ProductsSearchViewController()
        _ = sut.view
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSearchControllerDelegate_ShouldBeEqualToSUT() {
        XCTAssertTrue(sut === sut.searchController.delegate)
    }
    
    func testSearchControllerDelegateDidDisDismiss() {
        // UI details nothing need to test
        sut.didDismissSearchController(sut.searchController)
    }
    
    
    func testSearchController_ShouldBeNotNil() {
        XCTAssertNotNil(sut.searchController)
    }
    
    func testSearchControllerResultsController_ShouldBeNotNil() {
        XCTAssertNotNil(sut.searchController.searchResultsController)
    }
    
    func testSearchControllerCompletionResultsDelegate_ShouldBeEqualToSUT() {
        let completionResultsViewController = sut.searchController.searchResultsController as! SearchCompletionResults
        XCTAssertTrue(completionResultsViewController.delegate === sut)
    }
    
    // TODO:- 
    func testDidSelectSearchCompletion_ShouldPushSearchDetails() {
        sut.searchCompletionResults(didSelectResult: "")
    }
    
    
    func testNavigationItemSearchController_ShouldBeNotNil() {
        XCTAssertNotNil(sut.navigationItem.searchController)
    }
    
    
    
    func testViewDidAppear_SearchBarShouldBeFirstResponder() { // UI details nothing need to test
        sut.viewDidAppear(true)
    }
    
}
