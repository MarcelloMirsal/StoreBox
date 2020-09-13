//
//  AutocompleteSearchTestDoubles.swift
//  StoreBoxTests
//
//  Created by Marcello Mirsal on 10/09/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import XCTest
@testable import StoreBox
class AutocompleteSearchViewModelDelegateSpy: AutocompleteSearchViewModelDelegate {
    
    
    let testExpectation: XCTestExpectation
    
    init(testExpectation: XCTestExpectation) {
        self.testExpectation = testExpectation
    }
    
    var isAutocompleteSearchFailed: Bool?
    var isAutocompleteSearchSuccess: Bool?
    
    func autocompleteSearchSuccess() {
        isAutocompleteSearchSuccess = true
        testExpectation.fulfill()
    }
    func autocompleteSearchFailed(message: String) {
        isAutocompleteSearchFailed = true
        testExpectation.fulfill()
    }
}
