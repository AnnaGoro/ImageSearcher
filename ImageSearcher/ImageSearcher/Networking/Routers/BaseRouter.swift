//
//  BaseRouter.swift
//  ImageSearcher
//
//  Created by AnnGorobchenko on 11/25/17.
//  Copyright © 2017 AnnGorobchenko. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

struct GatewayConfiguration {
    
    static let domain = "www.googleapis.com/customsearch/v1"
    static let RESTPrefix = "https://"
    static let apiKey = "AIzaSyAh78Q5CCzdkE8koKInqsGlc-0XUbiE9tg"
    static let searchEngineKey = "015050038788973246128:rj42-jy-6mw"
  
}

protocol BaseRouter : URLRequestConvertible {
   
    func unauthorizedRequest(method: Alamofire.HTTPMethod,
                             params: Parameters,
                             encoding: ParameterEncoding,
                             headers: HTTPHeaders?) -> URLRequest
}

extension BaseRouter {
    
    func unauthorizedRequest(method: Alamofire.HTTPMethod,
                             params: Parameters = [:],
                             encoding: ParameterEncoding = URLEncoding.default,
                             headers: HTTPHeaders? = nil)
        -> URLRequest {
            
            let host = GatewayConfiguration.RESTPrefix + GatewayConfiguration.domain
            let url = URL(string: host)!
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            
            if let h = headers {
                for (key, value) in h {
                    request.setValue(value, forHTTPHeaderField: key)
                }
            }
            else {
                request.setValue("application/json", forHTTPHeaderField: "Accept")
            }
            
            
            do {
                var parameters = params
                parameters.updateValue(GatewayConfiguration.apiKey, forKey: "key")
                parameters.updateValue(GatewayConfiguration.searchEngineKey, forKey:  "cx")
                return try encoding.encode(request, with: parameters)
               
            }
            catch (let error) {
                fatalError("Error encoding request \(request), details - \(error)")
            }
            
    }
    
}

