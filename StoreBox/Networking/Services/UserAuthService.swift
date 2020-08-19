//
//  UserAuthService.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 27/07/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import Alamofire

protocol UserAuthServiceProtocol: class {
    func startGuestLogin(completion: @escaping UserAuthService.UserAuthResponse)
    func parseUserAuth(from jsonData: Data?) -> UserAuth?
}

class UserAuthService {
    
    typealias UserAuthResponse = (UserAuth?, Error?) -> ()
    
    private(set) var router: UserAuthServiceRoutes
    
    init(router: UserAuthServiceRoutes = UserAuthRouter() ) {
        self.router = router
    }
    
    static var token: String? {
        get {
            guard let tokenKey = UserDefaults().value(forKey: "token") as? String else { return nil }
            return tokenKey
        }
        set {
            UserDefaults().set(newValue, forKey: "token")
        }
    }
}

extension UserAuthServiceProtocol {
    func parseUserAuth(from jsonData: Data?) -> UserAuth? {
        guard let data = jsonData else { return nil}
        return try? JSONDecoder().decode(UserAuth.self, from: data)
    }
}

extension UserAuthService: UserAuthServiceProtocol  {
    func startGuestLogin(completion: @escaping UserAuthService.UserAuthResponse)  {
        AF.request(router.guestLogin).validate().responseJSON { [weak self] (jsonDataResponse) in
            let userAuth = self?.parseUserAuth(from: jsonDataResponse.data) ?? nil
            UserAuthService.token = userAuth?.token
            completion(userAuth, jsonDataResponse.error)
        }
    }
}


protocol UserAuthServiceRoutes {
    var guestLogin: NetworkRequestProtocol { get }
}

struct UserAuthRouter: UserAuthServiceRoutes {
    private(set) var guestLogin: NetworkRequestProtocol = NetworkRequest(method: .post , path: "/sessions/guest")
}

struct UserAuth: Codable {
    let message: String
    let token: String
    
    enum CodingKeys: String, CodingKey {
        case message, token
    }
}
