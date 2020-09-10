//
//  NetworkManagerTests.swift
//  StoreBoxTests
//
//  Created by Marcello Mirsal on 08/09/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import XCTest
import Alamofire
@testable import StoreBox

// MARK:- Testing AFErrorAdapter
class AFErrorAdapterTests: XCTestCase {
    
    var sut: AFErrorAdapter!
    
    override func setUp() {
        
    }
    
    
    func testGetNetworkRequestErrorFromUnspecifiedErrorCode_ShouldReturnUNspecifiedError() {
        let errorCode = 1000
        let aferror = AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: errorCode))
        sut = AFErrorAdapter(aferror: aferror)
        let requestError = sut.getNetworkRequestError()
        
        XCTAssertEqual(requestError, .unSpecified)
    }
    
    func testGetNetworkRequestErrorFromBadRequestErrorCode_ShouldReturnBadRequestError() {
        let errorCode = 400
        let aferror = AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: errorCode))
        sut = AFErrorAdapter(aferror: aferror)
        let requestError = sut.getNetworkRequestError()
        
        XCTAssertEqual(requestError, .badRequest)
    }
    
    func testGetNetworkRequestErrorFromUnauthorizedAccessErrorCode_ShouldReturnUnauthorizedAccessError() {
        let errorCode = 401
        let aferror = AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: errorCode))
        sut = AFErrorAdapter(aferror: aferror)
        let requestError = sut.getNetworkRequestError()
        
        XCTAssertEqual(requestError, .unauthorizedAccess)
    }
    
    func testGetNetworkRequestErrorFromPathNotFoundErrorCode_ShouldReturnPathNotFoundError() {
        let errorCode = 404
        let aferror = AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: errorCode))
        sut = AFErrorAdapter(aferror: aferror)
        let requestError = sut.getNetworkRequestError()
        
        XCTAssertEqual(requestError, .pathNotFound)
    }
    
    func testGetNetworkRequestErrorFromTimeoutErrorCode_ShouldReturnTimeoutError() {
        let errorCode = -1001
        let aferror = AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: errorCode))
        sut = AFErrorAdapter(aferror: aferror)
        let requestError = sut.getNetworkRequestError()
        
        XCTAssertEqual(requestError, .timeout)
    }
    
    func testGetNetworkRequestErrorFromNoInternetConnectionErrorCode_ShouldReturnNoInternetConnectionError() {
        let errorCode = -1009
        let aferror = AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: errorCode))
        sut = AFErrorAdapter(aferror: aferror)
        let requestError = sut.getNetworkRequestError()
        
        XCTAssertEqual(requestError, .noInternetConnection)
    }
    
    func testGetNetworkRequestErrorFromUnspecifiedAFError_ShouldReturnUnspecifiedError() {
        let aferror = AFError.explicitlyCancelled
        sut = AFErrorAdapter(aferror: aferror)
        let requestError = sut.getNetworkRequestError()
        
        XCTAssertEqual(requestError, .unSpecified)
    }
    
    func testGetNetworkRequestErrorFromUnSpecifiedReason_ShouldReturnUnspecifiedError() {
        let aferror = AFError.responseValidationFailed(reason: .dataFileNil)
        sut = AFErrorAdapter(aferror: aferror)
        let requestError = sut.getNetworkRequestError()
        
        XCTAssertEqual(requestError, .unSpecified)
    }
    
    
}
