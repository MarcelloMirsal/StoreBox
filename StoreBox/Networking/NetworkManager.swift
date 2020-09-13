//
//  NetworkManager.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 08/09/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import Alamofire

class NetworkManagerFacade {
    
    typealias JSONDataResponse = (NetworkRequestError?, Data?) -> ()
    
    func json(_ urlRequest: URLRequest, completion: @escaping JSONDataResponse ) {
        
        AF.request(urlRequest).validate().responseJSON { jsonDataResponse in
            let networkRequestError = AFErrorAdapter(aferror: jsonDataResponse.error)?.getNetworkRequestError()
            let data = jsonDataResponse.data
            completion(networkRequestError , data)
        }
        
    }
}


class AFErrorAdapter {
    let aferror: AFError
    init?(aferror: AFError?) {
        guard let error = aferror else { return nil }
        self.aferror = error
    }
    
    func getNetworkRequestError() -> NetworkRequestError {
        let unSpecifiedErrorStatusCode = 0
        
        switch aferror {
            case .sessionTaskFailed(let error as NSError):
                let statusCode = error.code
                return networkRequestError(from: statusCode)
            case .responseValidationFailed(let failureReason):
                let statusCode = responseStatusCode(from: failureReason)
                return networkRequestError(from: statusCode ?? unSpecifiedErrorStatusCode )
            default:
                return networkRequestError(from: unSpecifiedErrorStatusCode )
        }
    }
    
    private func networkRequestError(from statusCode: Int) -> NetworkRequestError {
        switch statusCode {
            case 400:
                return .badRequest
            case 401:
                return .unauthorizedAccess
            case 404:
                return .pathNotFound
            case -1001:
                return .timeout
            case -1009:
                return .noInternetConnection
            default:
                return .unSpecified
        }
    }
    
    private func responseStatusCode(from responseFailureReason: AFError.ResponseValidationFailureReason) -> Int? {
        switch responseFailureReason {
            case .unacceptableStatusCode(let responseStatusCode):
                return responseStatusCode
            default:
                return nil
        }
    }
}
