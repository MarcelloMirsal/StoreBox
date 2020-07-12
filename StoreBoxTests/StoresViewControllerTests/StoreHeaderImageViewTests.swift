//
//  StoreHeaderImageViewTests.swift
//  StoreBoxTests
//
//  Created by Marcello Mirsal on 11/07/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import XCTest
@testable import StoreBox

class StoreHeaderImageViewTests: XCTestCase {
    var sut: StoreHeaderImageView!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = StoreHeaderImageView()
        sut.layoutSubviews()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSetupGradientLayer_GradientLayerShouldBeNotNil() {
        XCTAssertNotNil(sut.setupLayers())
        XCTAssertNotNil(sut.gradientLayer)
    }

    
    
    
}
