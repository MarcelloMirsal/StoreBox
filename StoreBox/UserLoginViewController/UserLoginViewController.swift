//
//  UserLoginViewController.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 26/07/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import UIKit

class UserLoginViewController: UIViewController {
    
    let viewModel = UserLoginViewModel()
    
    @IBAction func handleGuestLoginAction() {
        viewModel.handleGuestLogin(completion: handleGuestLoginResponse(dict:error:))
    }
    
    func handleGuestLoginResponse(dict: [String:Any]? , error: Error? ) {
        if let _ = dict { dismiss(animated: true) }
    }
}
