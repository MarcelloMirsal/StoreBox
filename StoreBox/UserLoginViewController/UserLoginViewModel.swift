//
//  UserLoginViewModel.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 04/08/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import UIKit


class UserLoginViewModel {
    
    let userAuthService: UserAuthService
    
    init(userAuthService: UserAuthService = UserAuthService() ) {
        self.userAuthService = userAuthService
    }
    
    func handleGuestLogin(completion: @escaping UserAuthService.UserAuthResponse) {
        userAuthService.startGuestLogin { (dict, error) in
            completion(dict, error)
        }
    }
}
