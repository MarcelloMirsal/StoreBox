//
//  UserLoginViewModelTests.swift
//  StoreBoxTests
//
//  Created by Marcello Mirsal on 04/08/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import XCTest
@testable import StoreBox

class UserLoginViewModelTests: XCTestCase {
    var sut: UserLoginViewModel!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = UserLoginViewModel(userAuthService: UserAuthServiceMock() )
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testHandleGuestLogin_ErrorShouldBeNil() {
        let exp = expectation(description: "testHandleGuestLogin_ErrorShouldBeNil")
        sut.handleGuestLogin { (dict, error) in
            XCTAssertNil(error)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
    
//    func testHandleGuestLogin_ShouldBeNil() {
//        let exp = expectation(description: "testHandleGuestLogin")
//        sut.handleGuestLogin { (dict, error) in
//            XCTAssertNil(error)
//            exp.fulfill()
//        }
//        wait(for: [exp], timeout: 10)
//    }
    
    
}
