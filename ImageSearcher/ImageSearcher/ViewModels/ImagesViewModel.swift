//
//  ImagesViewModel.swift
//  ImageSearcher
//
//  Created by AnnGorobchenko on 11/25/17.
//  Copyright © 2017 AnnGorobchenko. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources
import RxCocoa

struct ImagesViewModel {
    
    private let bag = DisposeBag()
    
    init() {
        
        providerViewModel = ImagesDataProvider(query: "")
       
        query.asObservable()
            .distinctUntilChanged()
            .filter {$0.lengthOfBytes(using: String.Encoding.utf8) > 3}
            .flatMap {query in
                return ImagesDataProvider(query: query).loadPictures()
                                .catchErrorJustReturn([])
            }
            .bind(to: data)
            .disposed(by: bag)
        
}
    private var data: Variable<[Image]> = Variable([])

    var displayData: Driver<[SectionModel<String, Image>]> {
        return data.asDriver()
                .map { (data) in
                    return [SectionModel(model: "", items: data)] }
        }

    var showsEmptyState: Driver<Bool> {
        return data.asDriver()
                .map { $0.count == 0 }
                .skip(1) ///skip initial value
    }
    
    private var providerViewModel: ImagesDataProvider

    /// Variable with search query value
    fileprivate let query: Variable<String> = Variable("")

}

extension ImagesViewModel {
    
    /// Change query variable's old value to new value
    /// to retrieve new data
    ///
    /// - Parameter query: new query
    func searchQueryChanged(query: String) {
        self.query.value = query
    }
}

extension ImagesViewModel {
    
    struct ImagesDataProvider {

        let query : String

        func loadPictures() -> Observable<[Image]> {
            return ImageManager.images(for: query)
            
        }

    }
    
}


