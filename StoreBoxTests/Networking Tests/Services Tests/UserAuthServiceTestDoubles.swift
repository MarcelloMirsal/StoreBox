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
                let userAuth = UserAuth(message: "Welcome", token: "TokenID")
                completion(userAuth, nil)
            case .networkFailure:
                completion(nil, NSError())
            case .badJSONDecoding:
                completion(nil , nil)
        }
    }
}
