//
//  PromotionsServiceTests.swift
//  StoreBoxTests
//
//  Created by Marcello Mirsal on 19/11/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import XCTest
@testable import StoreBox
class PromotionsServiceTests: XCTestCase {
    
    var sut: PromotionsService!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = PromotionsService()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testShoppingPromotionWithSuccessfulResponse_ShouldReturnNotNilPromotions() {
        arrangeSutWithLocalSuccessfulResponse()
        let exp = expectation(description: "testShoppingPromotionWithSuccessfulResponse")
        
        sut.shoppingPromotions { (serviceError, shoppingPromotions) in
            XCTAssertNil(serviceError)
            XCTAssertNotNil(shoppingPromotions)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
    }
    
    func arrangeSutWithLocalSuccessfulResponse() {
        let jsonResponsesFilePath = Bundle(for: PromotionsServiceTests.self).path(forResource: "PromotionsServiceSuccessfulResponse", ofType: "json")!
        
        let localShoppingPromotionsRequest = NetworkRequestFake(path: jsonResponsesFilePath)
        let fakeRouter = PromotionsService.Router(shoppingPromotionsRequest: localShoppingPromotionsRequest )
        
        sut = PromotionsService(router: fakeRouter)
    }
    
}

 class PromotionsServiceRouterTests: XCTestCase {
    var sut: PromotionsService.Router!
    
    override func setUp() {
        sut = PromotionsService.Router()
    }
    
    func testShoppingPromotionsNetworkRequestPath_ShouldBeEqualToPath() {
        let path = "/public/shopping/promotions"
        XCTAssertEqual(path, sut.shoppingPromotionsRequest.path)
    }
}
