//
//  ArrayResponse.swift
//  ImageSearcher
//
//  Created by AnnGorobchenko on 11/25/17.
//  Copyright © 2017 AnnGorobchenko. All rights reserved.
//

import ObjectMapper

protocol ResponeProtocol : Mappable {
    
    associatedtype DataType

    var items: DataType? { get }
    
    var code: Int? { get }
    var errorMessage: String? { get }
    
}

struct ArrayResponse<S: Mappable> : ResponeProtocol {

    var items: [S]?
    
    var code: Int?
    var errorMessage: String?
    
    init?(map: Map) {
        mapping(map: map)
    }
    
    /// This function is where all variable mappings should occur.
    /// It is executed by Mapper during the mapping (serialization and deserialization) process.
    mutating func mapping(map: Map) {
        
        items <- map["items"]
        code <- map["error.code"]
        errorMessage <- map["error.message"]
    }
    
}
