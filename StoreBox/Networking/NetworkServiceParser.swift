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
        guard let decodedType = try? decoder.decode(T.self, from: data) else { throw NetworkServiceError.jsonDecodingFailure }
        return decodedType
    }
}
