//
//  ListingService.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 13/10/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import Foundation

class ListingService {
    
    let networkManager = NetworkManagerFacade()
    
    func getList<T: Decodable>(listType: T.Type, _ urlRequest: URLRequest, completion: @escaping (NetworkServiceError?, T?) -> () ) {
        networkManager.json(urlRequest.urlRequest!) { (requestError, jsonData) in
            if let error = requestError {
                completion(.badNetworkRequest(error) , nil)
                return
            }
            
            guard let list = self.parseList(from: jsonData, type: listType) else { completion(.jsonDecodingFailure , nil)
                return
            }
            
            completion(nil, list)
        }
    }
    
    func parseList<T: Decodable>(from jsonData: Data?, type: T.Type) -> T? {
        guard let data = jsonData else { return nil }
        let jsonDecoder = Parser().decoder
        do {
            let list = try jsonDecoder.decode(T.self, from: data)
            return list
        } catch {
            print(error)
            return nil
        }
    }
    
    
    
}



extension ListingService {
    class Parser: NetworkServiceParser {
        var decoder: JSONDecoder = {
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            return jsonDecoder
        }()
    }
    
    class Router {
        var subCategoryNetworkRequest: NetworkRequestProtocol = NetworkRequest(path: "/sub_categories")
        var citiesNetworkRequest: NetworkRequestProtocol = NetworkRequest(path: "/cities")
        init() {
            // TODO:
            subCategoryNetworkRequest.set(headers: [ "Authorization" : UserAuthService.token ?? "" ])
            citiesNetworkRequest.set(headers: [ "Authorization" : UserAuthService.token ?? "" ])
        }
    }
    
}
