//
//  NetworkConstants.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 27/07/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import Foundation
import Alamofire

enum NetworkConstants: String {
    case version = "/v1"
    case scheme = "https"
    case host = "store-box-api.herokuapp.com"
    static func value(of networkConstant: NetworkConstants ) -> String {
        return networkConstant.rawValue
    }
    
    static func getBaseURL() -> URL {
        var baseURL = URLComponents()
        baseURL.scheme = NetworkConstants.value(of: .scheme)
        baseURL.host = NetworkConstants.value(of: .host)
        baseURL.path = NetworkConstants.value(of: .version)
        return baseURL.url!
    }
}

protocol NetworkRequestProtocol: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var body: [String: String]? { get }
    var params: [String: Any]? { get }
    var headers: [String: String]? { get }
    
    init(method: HTTPMethod, path: String, body: [ String : String ]?, params: [String : Any]?, headers: [String: String]? )
}


struct NetworkRequest: NetworkRequestProtocol {
    var method: HTTPMethod
    var path: String
    var body: [String : String]?
    var params: [String : Any]?
    var headers: [String: String]?
    
    init(method: HTTPMethod = .get, path: String, body: [String : String]? = nil, params: [String : Any]? = nil , headers: [String: String]? = nil) {
        self.method = method
        self.path = path
        self.body = body
        self.params = params
        self.headers = headers
    }
    
    func asURLRequest() throws -> URLRequest {
        return setupURLRequest(from: getConfiguredURL() )
    }
    
    func setupURLRequest(from url: URL) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.method = method
        if let _ = headers { urlRequest.headers = .init(headers!) }
        if let _ = body { urlRequest.httpBody = try? JSONEncoder().encode(body!) }
        return urlRequest
    }
    
    func getConfiguredURL() -> URL {
        let baseURL = NetworkConstants.getBaseURL()
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)!
        
        urlComponents.path += path
        
        urlComponents.queryItems = params?.reduce([URLQueryItem](), { (result, queryItem) -> [URLQueryItem] in
            return result + [ URLQueryItem(name: queryItem.key, value: queryItem.value as? String) ]
        })
        return urlComponents.url!
    }
    
}
