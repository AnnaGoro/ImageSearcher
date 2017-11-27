//
//  Image.swift
//  ImageSearcher
//
//  Created by AnnGorobchenko on 11/25/17.
//  Copyright © 2017 AnnGorobchenko. All rights reserved.
//

import Foundation
import RxDataSources
import ObjectMapper
import RxSwift
import Alamofire

struct Image: Mappable {
    
    var fullUrl: String = ""
    var thumbnail: String = ""
    
    init?(map: Map) {
        mapping(map: map)
        
    }
    
    /// This function is where all variable mappings should occur. It is executed by Mapper during the mapping
    /// (serialization and deserialization) process.
    mutating func mapping(map: Map) {
        
        fullUrl <- map["pagemap.cse_image.0.src"]
        thumbnail <- map["pagemap.cse_thumbnail.0.src"]
        
        if thumbnail.count < 1 {
            thumbnail <- map["pagemap.thumbnail.0.src"]
            
        }
    }
}

extension Image : IdentifiableType, Equatable {
    
    typealias Identity = String
    
    /// IdentifiableType protocol implementation
    var identity: String {
        return self.fullUrl
    }
    
    /// Equatable protocol implementation
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    /// - Returns: a Boolean value indicating whether two values are equal
    static func ==(lhs: Image, rhs: Image) -> Bool {
        return lhs.fullUrl == rhs.fullUrl
    }
}
