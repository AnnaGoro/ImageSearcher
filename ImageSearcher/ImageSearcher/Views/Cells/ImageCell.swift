//
//  ImageCell.swift
//  ImageSearcher
//
//  Created by AnnGorobchenko on 11/25/17.
//  Copyright © 2017 AnnGorobchenko. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class ImageCell: UICollectionViewCell {
    
    fileprivate var image: Image?
    
    @IBOutlet weak var imageView: UIImageView! {
        didSet{
            imageView.image = R.image.placeHolder()
        }
    }

    func configure(with image: Image, handler: UIViewController?) {
        
        self.image = image
        let url = URL(string: image.thumbnail)
    
        self.imageView.kf.setImage(with: url)
        self.imageView.enableFullScreenMode(in: handler, imageUrl: image.fullUrl)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }

}
