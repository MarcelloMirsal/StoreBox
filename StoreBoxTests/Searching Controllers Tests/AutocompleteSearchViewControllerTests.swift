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
        sut = AutocompleteSearchViewController.initiate(mainNavigationController: nil)
        _ = sut.view
    }
    
    func testStaticInitiate_ShouldReturnSutWithMainNavigationControllerEqualToPassed() {
        let navigationController = UINavigationController()
        let viewController = AutocompleteSearchViewController.initiate(mainNavigationController: navigationController)
        
        XCTAssertEqual(viewController.mainNavigationController, navigationController)
    }
    
    func testViewModelDelegate_ShouldBeEqualToSut() {
        XCTAssertTrue(sut.viewModel.delegate === sut)
    }
    
    func testTableViewDataSouceCellProvider_ShouldDequeueNotNilCell() {
        arrangeSutWithAutocompleteSearchResults()
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = sut.viewModel.tableViewDataSource.tableView(sut.tableView, cellForRowAt: indexPath) as? AutocompleteSearchViewController.ResultTableViewCell
        XCTAssertNotNil(cell)
    }
    
    func testPresentProductSearchViewControllerWithSearchQuery_SearchQueryShouldBePassedToSearchViewController() {
        let productSearchQuery = "Bag"
        let searchViewController = sut.presentProductSearchViewController(for: productSearchQuery)
        XCTAssertEqual(searchViewController.title, productSearchQuery)
    }
    
    // MARK: UI Details Tests
    func testViewDetails() {
        arrangeSutWithAutocompleteSearchResults()
        sut.viewDidAppear(true)
        sut.searchBarCancelButtonClicked(.init())
        sut.searchBar(.init(), textDidChange: "Search Query")
        sut.autocompleteSearchSuccess()
        sut.autocompleteSearchFailed(message: "message")
        sut.tableView(sut.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
    }
    
    
    func arrangeSutWithAutocompleteSearchResults() {
        var snapshot = sut.viewModel.tableViewDataSource.snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems([.init(item: .init(result: "res", detailsDescription: "desc"))], toSection: .main)
        sut.viewModel.tableViewDataSource.apply(snapshot, animatingDifferences: false)
    }
}

// MARK:- ResultTableViewCell tests
extension AutocompleteSearchViewControllerTests {
    func testAutocompleResultTableViewInit_ShouldReturnNilFromCoderInit() {
        let cell = AutocompleteSearchViewController.ResultTableViewCell(coder: .init())
        XCTAssertNil(cell , "required init should always return nil")
    }
}
