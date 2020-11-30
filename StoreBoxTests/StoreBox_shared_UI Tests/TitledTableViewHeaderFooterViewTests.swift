//
//  TitledTableViewHeaderFooterViewTests.swift
//  StoreBoxTests
//
//  Created by Marcello Mirsal on 30/11/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import XCTest
@testable import StoreBox
class TitledTableViewHeaderFooterViewTests: XCTestCase {

    var sut: TitledTableViewHeaderFooterView!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = TitledTableViewHeaderFooterView()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testInitWithCoder_ShouldReturnNil() {
        sut = TitledTableViewHeaderFooterView(coder: .init())
        XCTAssertNil(sut)
    }
}
