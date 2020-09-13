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
        userAuthService.startGuestLogin { [weak self] (serviceError, userAuth) in
            if let error = serviceError {
                self?.delegate?.userLoginViewModel(isUserAuthenticated: false, message: error.localizedDescription)
                return
            }
            self?.delegate?.userLoginViewModel(isUserAuthenticated: true, message: "")
            
        }
    }
    
    
    
}

