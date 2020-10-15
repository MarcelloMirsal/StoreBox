//
//  ListingServiceTests.swift
//  StoreBoxTests
//
//  Created by Marcello Mirsal on 13/10/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import XCTest
@testable import StoreBox

class ListingServiceTests: XCTestCase {
    
    var sut: ListingService!
    
    override func setUp() {
        sut = ListingService()
    }
    
    func testParseLisetFromNilData_ShouldRetunNil() {
        XCTAssertNil(sut.parseList(from: nil, type: ProductsList.self))
    }
    
    func testGetListFromSuccessfulResponse_ListShouldBeNotNil() {
        let urlRequest = getSuccessfulJSONResponseLocalURLRequest()
        let exp = expectation(description: "testGetListFromSuccessfulResponse")
        
        sut.getList(listType: ProductsList.self, urlRequest) { (serviceError, list) in
            XCTAssertNil(serviceError)
            XCTAssertNotNil(list)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
    }
    
    func testGetListFromBadPathResponse_ListShouldBeNil() {
        let urlRequest = getBadPathResponseURLRequest()
        let exp = expectation(description: "testGetListFromBadPathResponse")
        
        sut.getList(listType: ProductsList.self, urlRequest) { (serviceError, list) in
            XCTAssertNotNil(serviceError)
            XCTAssertNil(list)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
    }
    
    func testGetListFromWrongResponse_ListShouldBeNil() {
        let urlRequest = getWrongJSONResponseFromLocalURLRequest()
        let exp = expectation(description: "testGetListFromWrongResponse")
        
        sut.getList(listType: ProductsList.self, urlRequest) { (serviceError, list) in
            XCTAssertNotNil(serviceError)
            XCTAssertNil(list)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
    }
    
    func getSuccessfulJSONResponseLocalURLRequest() -> URLRequest {
        let jsonResponsesFilePath = Bundle(for: ListingServiceTests.self).path(forResource: "ProductsListSuccessfulResponse", ofType: "json")!
        return NetworkRequestFake(path: jsonResponsesFilePath).urlRequest!
    }
    
    
    func getWrongJSONResponseFromLocalURLRequest() -> URLRequest {
        let jsonResponsesFilePath = Bundle(for: ListingServiceTests.self).path(forResource: "ProductsListWrongJSONResponse", ofType: "json")!
        
        return NetworkRequestFake(path: jsonResponsesFilePath).urlRequest!
    }
    
    func getBadPathResponseURLRequest() -> URLRequest {
        return NetworkRequestFake(path: "").urlRequest!
    }
    
    
}
