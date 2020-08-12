//
//  UserLoginViewController.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 26/07/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import UIKit

class UserLoginViewController: UIViewController {
    
    var viewModel = UserLoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
    }
    
    @IBAction func handleGuestLoginAction() {
        viewModel.handleGuestLogin()
    }
}

extension UserLoginViewController: UserLoginViewModelDelegate {
    func userLoginViewModel(isUserAuthenticated: Bool, message: String) {
        guard isUserAuthenticated else {
            let title = "Error?"
            present(UIAlertController.makeAlert(message, with: title), animated: true)
            return
        }
        dismiss(animated: true)
    }
}
