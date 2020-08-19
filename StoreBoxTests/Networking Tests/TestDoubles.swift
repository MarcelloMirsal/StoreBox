//
//  Mocks.swift
//  StoreBoxTests
//
//  Created by Marcello Mirsal on 04/08/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import Foundation
import Alamofire
@testable import StoreBox

struct NetworkRequestFake: NetworkRequestProtocol {
    
    var method: HTTPMethod
    var path: String
    var body: [String : String]?
    var params: [String: String]?
    var headers: [String: String]?
    
    init(method: HTTPMethod = .get, path: String, body: [String : String]? = nil, params: [String: String]? = nil , headers: [String: String]? = nil) {
        self.method = method
        self.path = path
        self.body = body
        self.params = params
        self.headers = headers
    }
    
    func asURLRequest() throws -> URLRequest {
        return setupURLRequest(from: getConfiguredURL())
    }
    
    func setupURLRequest(from url: URL) -> URLRequest {
        return URLRequest(url: url)
    }
    
    func getConfiguredURL() -> URL {
        return URL(fileURLWithPath: path)
    }
}
