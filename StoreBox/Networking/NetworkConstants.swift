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
    case authorizationKey = "Authorization"
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
    var params: [String: Any ]? { get set }
    var headers: [String: String]? { get set }
    
    init(method: HTTPMethod, path: String, body: [ String : String ]?, params: [String: Any ]?, headers: [String: String]? )
    
    mutating func set(params: [String: Any ]? )
    mutating func set(headers: [String: String]?)
}

extension NetworkRequestProtocol {
    mutating func set(params: [String: Any ]? ) {
        self.params = params
    }
    mutating func set(headers: [String: String]?) {
        self.headers = headers
    }
}


struct NetworkRequest: NetworkRequestProtocol {
    
    var method: HTTPMethod
    var path: String
    var body: [String : String]?
    var params: [String: Any ]?
    var headers: [String: String]?
    
    init(method: HTTPMethod = .get, path: String, body: [String : String]? = nil, params: [String: Any ]? = nil , headers: [String: String]? = nil) {
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
        urlRequest.timeoutInterval = 15
        urlRequest.method = method
        if let _ = headers { urlRequest.headers = .init(headers!) }
        if let _ = body { urlRequest.httpBody = try? JSONEncoder().encode(body!) }
        return urlRequest
    }
    
    func getConfiguredURL() -> URL {
        let baseURL = NetworkConstants.getBaseURL()
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)!
        
        urlComponents.path += path
        urlComponents.queryItems = params?.map({ (paramItem) -> URLQueryItem in
            .init(name: paramItem.key, value: setupURL(paramValue: paramItem.value))
        })
        return urlComponents.url!
    }
    
    /// convert parameter values from ["1" , "2" , "3"] -> "1,2,3" , "Filter" -> "Filter"
    func setupURL(paramValue: Any ) -> String {
        switch paramValue {
            case is String:
                return paramValue as! String
            case is [String]:
                let paramValues = paramValue as! [String]
                return String(paramValues.reduce("", {$0 + $1 + ","}).dropLast())
            default:
                return String(describing: paramValue)
        }
    }
}


enum NetworkServiceError: Error, Equatable {
    case badNetworkRequest(NetworkRequestError)
    case jsonDecodingFailure
    case noDataFound
    var localizedDescription: String {
        switch self {
            case .badNetworkRequest(let requestError):
                return requestError.localizedDescription
            case .jsonDecodingFailure:
                return "No data found"
            case .noDataFound:
            return "No data found"
        }
    }
    
}


enum NetworkRequestError: Error {
    case badRequest
    case unauthorizedAccess
    case pathNotFound
    case timeout
    case noInternetConnection
    case unSpecified
    
    var localizedDescription: String {
        switch self {
            case .badRequest:
                return "No data found"
            case .unauthorizedAccess:
                return "Unauthorized Access, please re-sign in again."
            case .pathNotFound:
                return "No data found"
            case .timeout:
                return "Request timeout, please try again"
            case .noInternetConnection:
                return "No internet connection"
            case .unSpecified:
                return "No data fount"
        }
    }
}
