//
//  NetworkServiceProtocol.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 17/11/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import Foundation

protocol NetworkServiceProtocol {
    func requestObject<T: Decodable>(ofType type: T.Type, urlRequest: URLRequest, parser: NetworkServiceParser, completion: @escaping (NetworkServiceError? , T?) -> () )
}

extension NetworkServiceProtocol {
    func requestObject<T: Decodable>(ofType type: T.Type, urlRequest: URLRequest, parser: NetworkServiceParser, completion: @escaping (NetworkServiceError? , T?) -> () ) {
        let networkManager = NetworkManagerFacade()
        networkManager.json(urlRequest) { (requestError, jsonData) in
            if let error = requestError {
                completion(.badNetworkRequest(error), nil)
                return
            }
            do {
                let decodableObject: T = try parser.parse(from: jsonData)
                completion(nil , decodableObject)
            } catch let error as NetworkServiceError {
                completion(error, nil)
            } catch {
                completion(.noDataFound, nil)
            }
        }
    }
}
