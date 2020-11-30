//
//  PromotionsService.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 17/11/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import Foundation

class PromotionsService: NetworkServiceProtocol {
    let router: Router
    
    init(router: Router = Router() ) {
        self.router = router
    }
    
    func shoppingPromotions(completion: @escaping (NetworkServiceError?, ShoppingPromotionsDTO?) -> () ) {
        let request = router.shoppingPromotionsRequest.urlRequest!
        requestObject(ofType: ShoppingPromotionsDTO.self, urlRequest: request, parser: Parser()) { (serviceError, shoppingPromotions) in
            completion(serviceError , shoppingPromotions)
        }
    }
}


// MARK:- Service parser & router
extension PromotionsService {
    class Parser: NetworkServiceParser {
        var decoder: JSONDecoder = JSONDecoder(keyDecodingStrategy: .convertFromSnakeCase)
    }
    class Router {
        let shoppingPromotionsRequest: NetworkRequestProtocol
        
        convenience init() {
            let shoppingPromotionsPath = "/public/shopping/promotions"
            let shoppingPromotionRequest = NetworkRequest(path: shoppingPromotionsPath)
            self.init(shoppingPromotionsRequest: shoppingPromotionRequest)
        }
        
        init(shoppingPromotionsRequest: NetworkRequestProtocol) {
            self.shoppingPromotionsRequest = shoppingPromotionsRequest
        }
        
    }
}

