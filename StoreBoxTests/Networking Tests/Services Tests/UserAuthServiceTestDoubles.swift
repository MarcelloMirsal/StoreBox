//
//  UserAuthServiceTestDoubles.swift
//  StoreBoxTests
//
//  Created by Marcello Mirsal on 04/08/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import Foundation
@testable import StoreBox

class UserAuthServiceMock: UserAuthService {
    
    override func startGuestLogin(completion: @escaping UserAuthService.UserAuthResponse) {
        let dictionaryAuth = [
            "message" : "Hello Guest",
            "role" : "guest",
            "token" : "token_id"
        ]
        completion(dictionaryAuth, nil)
    }
}
