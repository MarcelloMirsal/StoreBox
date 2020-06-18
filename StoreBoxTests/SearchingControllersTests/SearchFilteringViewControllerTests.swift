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
        sut = (UIStoryboard(name: "SearchFilteringViewController").getInitialViewController(of: UINavigationController.self).topViewController as! SearchFilteringViewController)
        _ = sut.view
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
}
