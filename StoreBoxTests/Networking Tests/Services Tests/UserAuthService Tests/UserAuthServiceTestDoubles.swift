//
//  UserAuthServiceTestDoubles.swift
//  StoreBoxTests
//
//  Created by Marcello Mirsal on 04/08/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import Foundation
@testable import StoreBox

class UserAuthServiceFake: UserAuthServiceProtocol {
    
    enum FakeResponseType {
        case success
        case networkFailure
        case badJSONDecoding
    }
    
    let jsonFileURL: URL
    let responseType: FakeResponseType
    
    init(responseType: FakeResponseType) {
        let filePath = Bundle(for: UserAuthServiceTests.self).path(forResource: "UserAuthServiceResponses", ofType: "json")!
        self.jsonFileURL = URL(fileURLWithPath: filePath)
        self.responseType = responseType
    }
    
    func startGuestLogin(completion: @escaping UserAuthService.UserAuthResponse) {
        switch responseType {
            case .success:
                let userAuth = UserAuthService.UserAuth(message: "Welcome", token: "TokenID")
                completion(nil , userAuth)
            case .networkFailure:
                completion(.badNetworkRequest(.badRequest), nil)
            case .badJSONDecoding:
                completion(.jsonDecodingFailure, nil)
        }
    }
}
