//
//  ViewController.swift
//  ImageSearcher
//
//  Created by AnnGorobchenko on 11/25/17.
//  Copyright © 2017 AnnGorobchenko. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class ImagesViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    fileprivate let bag = DisposeBag()
    
    fileprivate var viewModel: ImagesViewModel = ImagesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagesCollectionView.dataSource = nil
        imagesCollectionView.keyboardDismissMode = .onDrag
      
        searchBar.delegate = self
 
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, Image>>(configureCell: { [weak self](_, collectionView, indexPath, item) in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.imageCell, for: indexPath)!
            
            cell.configure(with: item, handler: self)
        
            return cell
        })
        
        viewModel.displayData
            .drive(imagesCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        
        imagesCollectionView.bindEmptyStateTo = viewModel.showsEmptyState

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
        
}

extension ImagesViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchQueryChanged(query: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()

    }

}
