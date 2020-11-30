//
//  NetworkServiceParser.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 19/09/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import Foundation
protocol NetworkServiceParser {
    var decoder: JSONDecoder { get set }
    func parse<T: Decodable>(from jsonData: Data?) throws -> T
}

extension NetworkServiceParser {
    func parse<T: Decodable>(from jsonData: Data?) throws -> T {
        guard let data = jsonData else { throw NetworkServiceError.noDataFound }
        let decodedObject: T
        do {
            decodedObject = try decoder.decode(T.self, from: data)
        } catch {
            print(error as NSError)
            throw NetworkServiceError.jsonDecodingFailure
        }
        return decodedObject
    }
}

extension JSONDecoder {
    convenience init(keyDecodingStrategy: KeyDecodingStrategy) {
        self.init()
        self.keyDecodingStrategy = keyDecodingStrategy
    }
}
