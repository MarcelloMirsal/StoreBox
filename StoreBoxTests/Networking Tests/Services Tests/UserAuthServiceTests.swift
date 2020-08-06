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
        arrangeSutWithCorrectPath()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        UserAuthService.token = nil
    }
    
    func testStartGuestLogin_DictShouldBeNotNil() {
        let exp = expectation(description: "testStartGuestLogin_ErrorShouldBeNotNil")
        
        sut.startGuestLogin { (dict, error) in
            XCTAssertNotNil(dict)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
    
    func testStartGuestLoginWithBadPath_ErrorShouldBeNotNil() {
        arrangeSutWithFailablePath()
        
        let exp = expectation(description: "testStartGuestLoginWithBadPath")
        
        sut.startGuestLogin { (dict, error) in
            XCTAssertNotNil(error)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
    
    func arrangeSutWithFailablePath() {
        let router =  UserAuthRouter()
        router.guestLogin = NetworkRequestFake(path: "BAD PATH")
        sut = UserAuthService(router: router)
    }
    
    func arrangeSutWithCorrectPath() {
        let path = Bundle(for: UserAuthServiceTests.self).path(forResource: "UserAuthServiceResponses", ofType: "json")!
        
        
        let router = UserAuthRouter()
        router.guestLogin = NetworkRequestFake(path: path)
        
        sut = UserAuthService(router: router)
    }
    
    func testTokenIsSavedAfterUserAuthAction_TokenShouldBeNotNil() {
        let exp = expectation(description: "testTokenIsSavedAfterUserAuthAction")
        
        sut.startGuestLogin { (dict, error) in
            XCTAssertNotNil(UserAuthService.token)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
}


// MARK:- UserAuthRouter Tests
import Alamofire
class UserAuthRouterTests: XCTestCase {
    
    var sut: UserAuthServiceRoutes!
    
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
