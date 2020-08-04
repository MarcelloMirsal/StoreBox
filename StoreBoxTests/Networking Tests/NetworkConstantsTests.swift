//
//  NetworkConstantsTests.swift
//  StoreBoxTests
//
//  Created by Marcello Mirsal on 27/07/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import XCTest
import Alamofire
@testable import StoreBox

class NetworkConstantsTests: XCTestCase {
    
    var sut: NetworkConstants!
    
    func testSutScheme_ShouldBeEqualToHTTPS() {
        sut = NetworkConstants.scheme
        XCTAssertEqual(sut.rawValue, "https")
    }
    
    func testSutHost_ShouldBeEqualToApiHost() { // store-box-api.herokuapp.com
        sut = .host
        let apiHost = "store-box-api.herokuapp.com"
        XCTAssertEqual(sut.rawValue, apiHost)
    }
    
    func testSutVersion_ShouldBeEqualToV1() {
        sut = .version
        XCTAssertEqual(sut.rawValue, "/v1")
    }
    
    func testSharedBaseURL_ShouldBeEqualToOptimalURL() {
        let optimalBaseURL = URL(string: "https://store-box-api.herokuapp.com/v1")!
        XCTAssertEqual(NetworkConstants.getBaseURL(), optimalBaseURL)
    }
    
}

// MARK:- NetworkRequest Tests
class NetworkRequestTests: XCTestCase {
    var sut: NetworkRequest!
    
    let method = HTTPMethod.get
    let path = "/path"
    let body = [ "body" : "HTTPBody" ]
    let params = ["params" : "data"]
    let headers = ["header" : "value"]
    
    override func setUp() {
        sut = NetworkRequest(method: method, path: path, body: body, params: params, headers: headers)
    }
    
    func testGetConfiguredURL_ShouldBeEqualToRequestURL() {
        let url = URL(string: "https://store-box-api.herokuapp.com/v1/path?params=data" )!
        let configuredURL = sut.getConfiguredURL()
        print(configuredURL.absoluteString)
        XCTAssertEqual(url, configuredURL)
    }
    
    func testSetupURLRequrst_ShouldBeEqualToBodyAndHeaders() {
        let urlRequest = sut.setupURLRequest(from: sut.getConfiguredURL())
        
        XCTAssertEqual(urlRequest.httpBody, try? JSONEncoder().encode(body))
        XCTAssertEqual(urlRequest.headers.dictionary, headers )
        
    }
    
    func testNetworkRequestInit_ShouldSetPassedProperties() {
        
        XCTAssertEqual(sut.method, method)
        XCTAssertEqual(sut.path, path)
        XCTAssertEqual(reducedDict(sut.body!), reducedDict(body))
        XCTAssertEqual(reducedDict(sut.params!), reducedDict(params))
        XCTAssertEqual(reducedDict(sut.headers!), reducedDict(headers))
        
    }
    
    func testSutAsURL_ShouldBeEqualToSetupURLReqest() {
        XCTAssertEqual(try? sut.asURLRequest(), sut.setupURLRequest(from: sut.getConfiguredURL()))
    }
    
    func reducedDict(_ dict: [String: Any] ) -> String {
        return dict.reduce("") { (res, pair ) -> String in
            return res + pair.key + String(describing: pair.value)
        }
    }
    
}
