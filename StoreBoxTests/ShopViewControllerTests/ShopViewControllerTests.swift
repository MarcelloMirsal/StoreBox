//
//  ShopViewControllerTests.swift
//  StoreBoxTests
//
//  Created by Marcello Mirsal on 05/05/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import XCTest
@testable import StoreBox
class ShopViewControllerTests: XCTestCase {

    var sut: ShopViewController!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let rootSut = (UIStoryboard(name: "ShopViewController").getInitialViewController(of: UINavigationController.self).topViewController as! ShopViewController)
        let nv = UINavigationController(rootViewController: rootSut)
        sut = nv.topViewController as? ShopViewController
        _ = sut.view
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFakeSearchControllerBarShouldBeginEditing_ShouldReturnFalse() {
        let shouldBeginEditing = sut.searchBarShouldBeginEditing(.init())
        XCTAssertFalse(shouldBeginEditing)
    }
    
    
    
    
}

