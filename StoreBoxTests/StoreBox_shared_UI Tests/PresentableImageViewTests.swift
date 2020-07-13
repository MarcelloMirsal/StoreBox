//
//  PresentableImageViewTests.swift
//  StoreBoxTests
//
//  Created by Marcello Mirsal on 13/07/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import XCTest
@testable import StoreBox
class PresentableImageViewTests: XCTestCase {
    var sut: PresentableImageView!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = PresentableImageView(frame: .zero)
        sut.image = .init()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testDrawWithNilImage_InputImagesShouldBeEmpty() {
        sut.image = nil
        sut.draw(.zero)
        XCTAssertTrue(sut.images.isEmpty)
    }
    
    func test_UI_Details() {
        sut.draw(.zero)
    }
    
    
}
