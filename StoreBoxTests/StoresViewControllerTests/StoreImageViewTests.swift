//
//  StoreImageViewTests.swift
//  StoreBoxTests
//
//  Created by Marcello Mirsal on 13/07/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import XCTest
@testable import StoreBox
class StoreImageViewTests: XCTestCase {
    
    var sut: StoreImageView!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = StoreImageView()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testDraw_UI_Details() {
        sut.draw(.zero)
        sut.layoutSubviews()
    }
    
    func testSetupLayer_GradientLayerShouldBeNotNil() {
        sut.setupLayers()
        XCTAssertNotNil(sut.gradientLayer)
    }
}
