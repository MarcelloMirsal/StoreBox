//
//  ProductsAdsControllerTests.swift
//  StoreBoxTests
//
//  Created by Marcello Mirsal on 13/05/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import XCTest
@testable import StoreBox

class ProductsAdsControllerTests: XCTestCase {
    
    var sut: ProductsAdsController!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = UIStoryboard(name: "ProductsAdsController").getInitialViewController(of: ProductsAdsController.self)
        _ = sut.view
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    
}
