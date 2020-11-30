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
}
