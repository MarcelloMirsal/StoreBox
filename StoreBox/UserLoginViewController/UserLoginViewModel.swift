//
//  UserLoginViewModel.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 04/08/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import UIKit

protocol UserLoginViewModelDelegate: class {
    func userLoginViewModel(isUserAuthenticated: Bool, message: String)
}

class UserLoginViewModel {
    let userAuthService: UserAuthServiceProtocol
    weak var delegate: UserLoginViewModelDelegate?
    
    init(userAuthService: UserAuthServiceProtocol = UserAuthService() ) {
        self.userAuthService = userAuthService
    }
    
    func handleGuestLogin() {
        userAuthService.startGuestLogin { [weak self] (userAuth, error) in
            if let _ = error {
                self?.delegate?.userLoginViewModel(isUserAuthenticated: false, message: "Please try again")
                return
            }
            guard let _ = userAuth else {
                self?.delegate?.userLoginViewModel(isUserAuthenticated: false, message: "cant parse UserAuth")
                return
            }
            self?.delegate?.userLoginViewModel(isUserAuthenticated: true, message: "Welcome Guest")
        }
    }
    
    
    
}

