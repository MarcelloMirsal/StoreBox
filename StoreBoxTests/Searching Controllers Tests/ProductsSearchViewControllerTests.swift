//
//  ProductsSearchViewControllerTests.swift
//  StoreBoxTests
//
//  Created by Marcello Mirsal on 13/08/2020.
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
        sut.viewDidAppear(false)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testViewModelDelegate_ShouldBeEqualToSut() {
        XCTAssertTrue(sut.viewModel.delegate === sut)
    }
    
    func testSetupSeachController_ShouldBeNotNil() {
        XCTAssertNotNil(sut.navigationItem.searchController)
    }
    
    func testSearchBarDelegate_ShouldBeEqualToSUT() {
        XCTAssertTrue(sut.navigationItem.searchController?.searchBar.delegate === sut)
    }
    
    func testSearchBarCancelButtonClickedShouldDismissFromNavigationController() {
        let navigationController = UINavigationController(rootViewController: sut)
        sut = navigationController.topViewController as? ProductsSearchViewController
        sut.searchBarCancelButtonClicked(.init())
    }
    
    func testSearchBarTextDidChange_() { // UI Details
        sut.searchBar(.init(), textDidChange: "")
    }
    
    
    
    // MARK:- TableView Delegate and DataSource Tests
     func testNumberOfRows_ShouldBeEqualtToViewModelSearchResultsCount() {
        let productSearchResults = [ProductSearchResult(name: "A", subCategoryName: "B") ]
        sut.viewModel.set(productsSearchResults: productSearchResults)
        sut.tableView.reloadData()
        
        XCTAssertEqual(sut.tableView(sut.tableView, numberOfRowsInSection: 0), sut.viewModel.productsSearchResultsCount)
    }

    func testRegisteredCell_ShouldBeNotNil() {
        let productSearchResults = [ProductSearchResult(name: "A", subCategoryName: "B") ]
        sut.viewModel.set(productsSearchResults: productSearchResults)
        sut.tableView.reloadData()
        
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = sut.tableView.dequeueReusableCell(withIdentifier: sut.cellId, for: indexPath)
        
        XCTAssertNotNil(cell)
    }

    func testCellAtIndexPath_ShouldBeNotNil() {
        let productSearchResults = [ProductSearchResult(name: "A", subCategoryName: "B") ]
        sut.viewModel.set(productsSearchResults: productSearchResults)
        sut.tableView.reloadData()
        
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = sut.tableView.cellForRow(at: indexPath)
        
        XCTAssertNotNil(cell)
    }
    
    func testCellAtIndexPath_ShouldSetDataFromViewModel() {
        let productName = "ProductA"
        let categoryName = "categoryA"
        sut.viewModel.set(productsSearchResults: [ .init(name: productName, subCategoryName: categoryName) ])
        sut.tableView.reloadData()
        
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = sut.tableView.cellForRow(at: indexPath)!
        
        XCTAssertEqual(cell.textLabel?.text, productName)
    
        
    }

    
    
}
