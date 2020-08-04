//
//  CartViewControllerTests.swift
//  StoreBoxTests
//
//  Created by Marcello Mirsal on 01/06/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import XCTest
@testable import StoreBox

class CartViewControllerTests: XCTestCase {
    var sut: CartViewController!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = UIStoryboard(name: "CartViewController").getInitialViewController(of: UINavigationController.self).topViewController! as? CartViewController
        _ = sut.view
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

}
