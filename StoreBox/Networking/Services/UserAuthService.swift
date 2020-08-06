//
//  UserAuthService.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 27/07/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import Alamofire
class UserAuthService {
    
    typealias UserAuthResponse = ([ String : Any ]?, Error?) -> ()
    
    static var token: String? {
        get {
            guard let tokenKey = UserDefaults().value(forKey: "token") as? String else { return nil }
            return tokenKey
        }
        set {
            UserDefaults().set(newValue, forKey: "token")
        }
    }
    
    let router: UserAuthServiceRoutes
    
    init(router: UserAuthServiceRoutes = UserAuthRouter() ) {
        self.router = router
    }
    
    
    func startGuestLogin(completion: @escaping UserAuthResponse)  {
        AF.request(router.guestLogin).responseJSON { [weak self] (jsonDataResponse) in
            let dict = self?.parseDict(from: jsonDataResponse.data)
            completion(dict, jsonDataResponse.error)
        }
    }
    
    func parseDict(from jsonData: Data?) -> [String: Any]? {
        guard let data = jsonData else { return nil}
        guard let jsonObject = try? JSONSerialization.jsonObject(with: data) else { return nil }
        let jsonDict = jsonObject as? [String : Any]
        UserAuthService.token = jsonDict?["token"] as? String
        return jsonDict
    }
    
}

class UserAuthRouter: UserAuthServiceRoutes {
    var guestLogin: NetworkRequestProtocol = NetworkRequest(method: .post , path: "/sessions/guest")
}


protocol UserAuthServiceRoutes {
    var guestLogin: NetworkRequestProtocol { get set }
}


