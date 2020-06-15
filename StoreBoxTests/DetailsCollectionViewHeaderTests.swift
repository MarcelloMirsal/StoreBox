//
//  DetailsCollectionViewHeaderTests.swift
//  StoreBoxTests
//
//  Created by Marcello Mirsal on 14/06/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import XCTest
@testable import StoreBox

class DetailsCollectionViewHeaderTests: XCTestCase {
    var sut: DetailsCollectionViewHeader!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = DetailsCollectionViewHeader()
        sut.didMoveToSuperview()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSetSectionTitles_ShouldBeEqualToPassedData() {
        let sectionTitle = "TITLE"
        let btnTitle = "BUTTON"
        sut.set(sectionTitle: sectionTitle, buttonTitle: btnTitle)
        XCTAssertEqual(sectionTitle, sut.sectionTitle.text)
        XCTAssertEqual(btnTitle, sut.detailsButton.title(for: .normal))
    }
}
