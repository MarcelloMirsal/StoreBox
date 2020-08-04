//
//  SceneDelegate.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 04/05/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import UIKit

@available(iOS 13, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
//        guard let windowScene = (scene as? UIWindowScene) else { return }
//
//        let window = windowScene.windows.first!
//
//        guard let token = UserAuthService.token else {
//            print("sxsx")
//            let loginVC = UIStoryboard(name: "UserLoginViewController").getInitialViewController(of: UserLoginViewController.self)
//            loginVC.modalPresentationStyle = .fullScreen
//            window.rootViewController?.present(loginVC, animated: true)
//            return
//        }
//        print("sdwdw")
//
        
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = windowScene.windows.first!
        let loginVC = UIStoryboard(name: "UserLoginViewController").getInitialViewController(of: UserLoginViewController.self)
        loginVC.modalPresentationStyle = .fullScreen
        window.rootViewController?.present(loginVC, animated: true)
    }
    
}

