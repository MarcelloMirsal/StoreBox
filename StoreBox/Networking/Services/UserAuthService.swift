//
//  UserAuthService.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 27/07/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import Foundation

protocol UserAuthServiceProtocol: class {
    func startGuestLogin(completion: @escaping UserAuthService.UserAuthResponse)
}

class UserAuthService {
    typealias UserAuthResponse = (NetworkServiceError?, UserAuth?) -> ()
    
    private(set) var router: UserAuthServiceRoutesProtocol
    
    let networkManager = NetworkManagerFacade()
    
    init(router: UserAuthServiceRoutesProtocol = UserAuthRouter() ) {
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
    
    func parseUserAuth(from jsonData: Data?) -> UserAuth? {
        guard let data = jsonData else { return nil }
        return try? JSONDecoder().decode(UserAuth.self, from: data)
    }
    
    struct UserAuth: Codable {
        let message: String
        let token: String
        
        enum CodingKeys: String, CodingKey {
            case message, token
        }
    }
    
}

extension UserAuthService: UserAuthServiceProtocol  {
    func startGuestLogin(completion: @escaping UserAuthService.UserAuthResponse)  {
        
        let urlRequest = router.guestLogin.urlRequest!
        networkManager.json(urlRequest) { [weak self] (requestError, data) in
            if let error = requestError {
                completion(.badNetworkRequest(error), nil)
                return
            }
            guard let userAuth = self?.parseUserAuth(from: data) else {
                completion(.jsonDecodingFailure, nil)
                return
            }
            UserAuthService.token = userAuth.token
            completion(nil, userAuth)
        }
    }
}


protocol UserAuthServiceRoutesProtocol {
    var guestLogin: NetworkRequestProtocol { get }
}

struct UserAuthRouter: UserAuthServiceRoutesProtocol {
    private(set) var guestLogin: NetworkRequestProtocol = NetworkRequest(method: .post , path: "/sessions/guest")
}
