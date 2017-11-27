//
//  SearchManager.swift
//  ImageSearcher
//
//  Created by AnnGorobchenko on 11/25/17.
//  Copyright © 2017 AnnGorobchenko. All rights reserved.
//

import Foundation
import RxSwift
import MapKit
import Alamofire
import ObjectMapper

enum ImageManager {}
extension ImageManager {
    
    static func images(for query : String) -> Observable<[Image]> {
        
        let rout = ImageRouter.list(query: query)
        
        return Alamofire.request(rout)
            .rx_response(ArrayResponse<Image>.self)
        
    }
}
