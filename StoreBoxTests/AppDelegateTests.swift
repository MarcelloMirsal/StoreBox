//
//  AppDelegateTests.swift
//  StoreBoxTests
//
//  Created by Marcello Mirsal on 13/08/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import XCTest
@testable import StoreBox

class SceneDelegateTests: XCTestCase {
    
    var sut: SceneDelegate!
    override  func setUp() {
        sut = UIApplication.shared.connectedScenes.first!.delegate as? SceneDelegate
    }
    override func tearDown() {
        UserAuthService.token = nil
    }
    
    func testSutWindowRootViewController_ShouldBeEqualToUserLoginViewControllerWhenTokenIsNil() {
        let savedToken = UserAuthService.token
        UserAuthService.token = nil
        
        sut.sceneDidBecomeActive(UIApplication.shared.connectedScenes.first!)
        UserAuthService.token = savedToken
        
        XCTAssertTrue(sut.window?.rootViewController?.presentedViewController is UserLoginViewController)
    }
    
    func testSutWindowRootViewController_ShouldBeEqualToMainTabBarControllerWhenTokenIsNotNil() {
        let savedToken = UserAuthService.token
        UserAuthService.token = "TokenId"
        sut.sceneDidBecomeActive(UIApplication.shared.connectedScenes.first!)
        UserAuthService.token = savedToken
        XCTAssertTrue(sut.window?.rootViewController is UITabBarController)
        UserAuthService.token = nil
    }
    
    
}
