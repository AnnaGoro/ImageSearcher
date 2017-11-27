//
//  ReactiveObjectMapping.swift
//  Campfiire
//
//  Created by Vlad Soroka on 10/11/16.
//  Copyright © 2016 campfiire. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper
import RxSwift

extension Alamofire.DataRequest {

    func rx_response<T: ResponeProtocol>(_ unused: T.Type) -> Observable<T.DataType> {
        
        return Observable.create { [weak self] (subscriber) -> Disposable in
            
            let request =
                self?.validate(statusCode: 200...299)
                    
                    .responseObject { [weak self] (response: DataResponse< T >) in
                        
                        do {
                            guard let s = self else {
                                
                                ///happens when Observer get's disposed, but request.cancel() does not interrupt network request and still invokes completition handler
                                subscriber.onCompleted()
                                return;
                            }
                            
                            let data = try s.processResponse(response: response)
                            
                            subscriber.onNext( data )
                            subscriber.onCompleted()
                        }
                        catch (let er) {

                            subscriber.onError(er)
                            
                        }
            }
            
            return Disposables.create { request?.cancel() }
        }
    }
    
    
}

extension Alamofire.DataRequest {
    
    fileprivate func processResponse<S: ResponeProtocol>
        (response : DataResponse<S>) throws -> S.DataType {
        
        if let er = response.result.error {
            throw er
        }
        
        guard let mappedResponse = response.result.value else {
            fatalError("Result is not success and not error")
        }

        guard let data = mappedResponse.items else {
            throw ImageSearcherError.emptyArray
        }
        
        return data
    }
    
}
