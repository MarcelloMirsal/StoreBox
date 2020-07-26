//
//  UserLoginViewController.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 26/07/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import UIKit


class UserLoginViewController: UIViewController {
    
    @IBAction func presentMainStoryboard() {
        present(getMainTabBarController() , animated: true)
    }
    
    func getMainTabBarController() -> UITabBarController {
        let mainTabBarController = UIStoryboard(name: "Main").getInitialViewController(of: UITabBarController.self)
        mainTabBarController.modalPresentationStyle = .fullScreen
        return mainTabBarController
    }
    
}
