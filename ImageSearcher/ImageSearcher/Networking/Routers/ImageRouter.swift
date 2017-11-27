//
//  ImageRouter.swift
//  ImageSearcher
//
//  Created by AnnGorobchenko on 11/25/17.
//  Copyright © 2017 AnnGorobchenko. All rights reserved.
//

import Alamofire

enum ImageRouter: BaseRouter {
    
    case list (query : String)
   
}

extension ImageRouter {
    
    func asURLRequest() throws -> URLRequest {
        
        switch self {
            
        case .list(let query):
            
            let params : [String: Any] = ["q" : query]
            
            return self.unauthorizedRequest(method: .get,
                                            params: params)
            
        }
        
    }
    
}
