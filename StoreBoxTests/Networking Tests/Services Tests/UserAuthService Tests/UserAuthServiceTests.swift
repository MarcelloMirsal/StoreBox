//
//  UserAuthServiceTests.swift
//  StoreBoxTests
//
//  Created by Marcello Mirsal on 27/07/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import XCTest
@testable import StoreBox

class UserAuthServiceTests: XCTestCase {
    
    var sut: UserAuthService!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        arrangeSutWithCorrectRouter()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        UserAuthService.token = nil
    }
    
    func testStartGuestLoginWithSuccessfulResponse_UserAuthShouldBeNotNil() {
        let exp = expectation(description: "testStartGuestLoginWithSuccessfulResponse")
        
        sut.startGuestLogin { (error, userAuth) in
            XCTAssertNotNil(userAuth)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2)
    }
    
    func testStartGuestLoginWithBadFormattedJSON_UserAuthShouldBeNil() {
        let exp = expectation(description: "testStartGuestLoginWithBadFormattedJSON")
        arrangeSutWithInvalidResponseRouter()
        
        sut.startGuestLogin { (error, userAuth) in
            XCTAssertNil(userAuth)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2)
    }
    
    func testStartGuestLoginWithBadPath_ErrorShouldBeNotNil() {
        arrangeSutWithBadRouter()
        
        let exp = expectation(description: "testStartGuestLoginWithBadPath")
        
        sut.startGuestLogin { (error, userAuth) in
            XCTAssertNotNil(error)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2)
    }
    
    func testTokenIsSavedAfterUserAuthAction_TokenShouldBeNotNil() {
        let exp = expectation(description: "testTokenIsSavedAfterUserAuthAction")
        
        sut.startGuestLogin { (error, userAuth) in
            XCTAssertNotNil(UserAuthService.token)
            UserAuthService.token = nil
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2)
    }
    
    func arrangeSutWithBadRouter() {
        let router =  UserAuthRouter(guestLogin: NetworkRequestFake(path: "BAD PATH"))
        sut = UserAuthService(router: router)
    }
    
    func arrangeSutWithCorrectRouter() {
        let jsonResponsesFilePath = Bundle(for: UserAuthServiceTests.self).path(forResource: "UserAuthServiceResponses", ofType: "json")!
        
        let router = UserAuthRouter(guestLogin: NetworkRequestFake(path: jsonResponsesFilePath))
        sut = UserAuthService(router: router)
    }
    
    func arrangeSutWithInvalidResponseRouter() {
        let jsonResponsesFilePath = Bundle(for: UserAuthServiceTests.self).path(forResource: "UserAuthServiceWrongFormattedResponse", ofType: "json")!
        
        let router = UserAuthRouter(guestLogin: NetworkRequestFake(path: jsonResponsesFilePath))
        sut = UserAuthService(router: router)
    }
    
}


// MARK:- UserAuthRouter Tests
import Alamofire
class UserAuthRouterTests: XCTestCase {
    
    var sut: UserAuthServiceRoutesProtocol!
    
    let guestPath = "/sessions/guest"
    
    override func setUp() {
        sut = UserAuthRouter()
    }
    
    func testGuestLogin_ShouldBeEqualToGuestPath() {
        XCTAssertEqual(sut.guestLogin.path, guestPath)
    }
    func testGuestLoginMethod_ShouldBeEqualToPOST() {
        XCTAssertEqual(sut.guestLogin.method, HTTPMethod.post)
    }
    
}
