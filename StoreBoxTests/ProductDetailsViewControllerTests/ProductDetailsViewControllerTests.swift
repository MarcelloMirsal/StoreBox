//
//  ProductDetailsViewControllerTests.swift
//  StoreBoxTests
//
//  Created by Marcello Mirsal on 11/05/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import XCTest
@testable import StoreBox
class ProductDetailsViewControllerTests: XCTestCase {
    
    var sut: ProductDetailsViewController!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = UIStoryboard(name: "ProductDetailsViewController").getInitialViewController(of: ProductDetailsViewController.self)
        _ = sut.view
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testScrollView_ShouldBeNotNil() {
        XCTAssertNotNil(sut.scrollView)
    }
    
    func testDescriptionTextView_ShouldBeNotNil() {
        XCTAssertNotNil(sut.descriptionTextView)
    }
    
    func testDescriptionTextViewHeightConstraint_ShouldBeNotNil() {
        XCTAssertNotNil(sut.descriptionHeightConstraint)
    }
    
    func testHandleImageSliderViewPresentation_PresentationControllerShouldBeNotNil() {
        sut.handleImageSliderViewPresentation()
        XCTAssertNotNil(sut.presentationController)
    }
    
    
    
    
}
