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
        sut = UserLoginViewModel(userAuthService: UserAuthServiceFake(responseType: .success))
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testHandleGuestLoginWithSuccessfulResponse_SutDelegateSpyResultShouldBeTrue() {
        let exp = expectation(description: "testHandleGuestLoginWithSuccessfulResponse")
        let spyDelegate = UserLoginViewModelDelegateSpy()
        spyDelegate.asyncExpectation = exp
        sut.delegate = spyDelegate
        
        sut.handleGuestLogin()
        
        wait(for: [exp], timeout: 1)
    }
    
    func testHandleGuestLoginWithNetworkFailure_SutDelegateSpyResultShouldBeTrue() {
        sut = UserLoginViewModel(userAuthService: UserAuthServiceFake(responseType: .networkFailure))
        
        let exp = expectation(description: "testHandleGuestLoginWithNetworkFailure")
        let spyDelegate = UserLoginViewModelDelegateSpy()
        spyDelegate.asyncExpectation = exp
        sut.delegate = spyDelegate
        
        sut.handleGuestLogin()
        
        wait(for: [exp], timeout: 1)
    }
    
    func testHandleGuestLoginWithBadJsonDataDecoding_SutDelegateSpyResultShouldBeTrue() {
        sut = UserLoginViewModel(userAuthService: UserAuthServiceFake(responseType: .badJSONDecoding))
        
        let exp = expectation(description: "testHandleGuestLoginWithNetworkFailure")
        let spyDelegate = UserLoginViewModelDelegateSpy()
        spyDelegate.asyncExpectation = exp
        sut.delegate = spyDelegate
        
        sut.handleGuestLogin()
        
        wait(for: [exp], timeout: 1)
    }
    
}

private class UserLoginViewModelDelegateSpy: UserLoginViewModelDelegate {
    weak var asyncExpectation: XCTestExpectation?
    var isUserAuthenticated: Bool?
    
    func userLoginViewModel(isUserAuthenticated: Bool, message: String) {
        guard let exp = asyncExpectation else { XCTFail() ; return }
        self.isUserAuthenticated = isUserAuthenticated
        exp.fulfill()
    }
}
