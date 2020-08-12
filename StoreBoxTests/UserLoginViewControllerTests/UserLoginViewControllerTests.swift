//
//  UserLoginViewControllerTests.swift
//  StoreBoxTests
//
//  Created by Marcello Mirsal on 26/07/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import XCTest
@testable import StoreBox

class UserLoginViewControllerTests: XCTestCase {
    
    var sut: UserLoginViewController!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = UIStoryboard(name: "UserLoginViewController").getInitialViewController(of: UserLoginViewController.self)
        sut.viewModel = .init(userAuthService: UserAuthServiceFake(responseType: .success) )
        _ = sut.view
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSutViewModelDelegate_ShouldbEqualToSut() {
        XCTAssertTrue(sut.viewModel.delegate === sut)
    }
    
    func testHandleGuestLogin() { // Nothing To Test UI Details
        sut.handleGuestLoginAction()
    }
    
    
    // MARK:- UserLoginViewModelDelegate Implementation
    func testUserLoginViewModelIsAuthenticated_() {
        sut.userLoginViewModel(isUserAuthenticated: true, message: "isUserAuthenticated")
    }
    func testUserLoginViewModelIsNotAuthenticated_() {
        sut.userLoginViewModel(isUserAuthenticated: false, message: "isNotUserAuthenticated")
    }
    
}
