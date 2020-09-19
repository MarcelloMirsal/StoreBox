//
//  ProductSearchViewControllerTests.swift
//  StoreBoxTests
//
//  Created by Marcello Mirsal on 15/09/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import XCTest
@testable import StoreBox
class ProductSearchViewControllerTests: XCTestCase {
    
    var sut: ProductSearchViewController!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = ProductSearchViewController()
        _ = sut.view
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSharedInitiate_ViewControllerTitleShouldBeEqualToPassedSearchQuery() {
        let searchQuery = "BAG"
        let viewController = ProductSearchViewController.initiate(for: searchQuery)
        XCTAssertEqual(viewController.title, searchQuery)
        
    }

}
