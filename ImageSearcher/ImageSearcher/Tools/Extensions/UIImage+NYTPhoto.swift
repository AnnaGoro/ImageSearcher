//
//  UIImage+NYTPhoto.swift
//  ImageSearcher
//
//  Created by AnnGorobchenko on 11/25/17.
//  Copyright © 2017 AnnGorobchenko. All rights reserved.
//

import NYTPhotoViewer
import RxSwift
import RxCocoa
import NSObject_Rx
import Kingfisher

// MARK: - Implementation of the full screen mode and NYTPhotosViewControllerDelegate
extension UIImageView: NYTPhotosViewControllerDelegate {
    
    ///Enables feature to open image view full screen
    ///
    /// - Parameters:
    ///   - viewController: in which image could be displayed full screen
    ///   - imageUrl: url of given image
    func enableFullScreenMode(in viewController: UIViewController?, imageUrl: String?) {
        guard let vc = viewController, let url = imageUrl else {return}
        enableFullScreenMode(in: vc, imageUrl: url, disposeBag: rx.disposeBag)
    }
    
    ///Enables feature to open image view full screen
    ///
    /// - Parameters:
    ///   - viewController: in which image could be displayed full screen
    ///   - imageUrl: url of given image
    ///   - disposeBag: bag in which observable can be disposed
    func enableFullScreenMode(in viewController:UIViewController,
                              imageUrl: String,
                              disposeBag: DisposeBag) {

        isUserInteractionEnabled = true
        let gr = UITapGestureRecognizer()
        self.addGestureRecognizer(gr)
        
        gr.rx.event.asDriver()
            .flatMapLatest{ [weak viewController, unowned self]  (value: UITapGestureRecognizer) -> Driver<Void> in

                guard let fullUrl = URL(string: imageUrl) else {
                    return Driver.empty()
                }
                
                let photos : [DisplayPhoto?] = [DisplayPhoto(image: nil, placeHolderImage: self.image)]
                let photosViewController = self.generatePhotoViewer(with: photos)
                viewController?.present(photosViewController, animated: true, completion:nil)
                
                KingfisherManager.shared.retrieveImage(with: fullUrl, options: nil, progressBlock: nil) { (image, error, _ , _ ) in
                    
                    if let _ = error, image == nil {
                        return
                    }
                    
                    for photo in photos {
                        photo?.image = image
                        photosViewController.updateImage(for: photo)
                    }
                }
                return Driver.empty()
            }
            .drive( onCompleted:{
            })
            .disposed(by: disposeBag)
        
        }
        

    public func photosViewController(_ photosViewController: NYTPhotosViewController,
                                     referenceViewFor photo: NYTPhoto) -> UIView? {
        return self
    }
    
}

extension UIImageView {
    
    func generatePhotoViewer(with photos: [DisplayPhoto?]) -> NYTPhotosViewController {
        
        let photosViewController = NYTPhotosViewController(photos: photos as? [NYTPhoto])
        photosViewController.delegate = self
        return photosViewController
    }
    
}


/// NYTPhoto implementation
/// The model for photos displayed in the `NYTPhotosViewController`.
class DisplayPhoto: NSObject, NYTPhoto {
    
    /// The image to display
    var image: UIImage?
    
    /// The image data to display
    var imageData: Data? = nil
    
    /// A placeholder image for display while the image is loading
    var placeholderImage: UIImage?
    
    /// An attributed string for display as the title of the caption
    let attributedCaptionTitle: NSAttributedString? = nil
    
    /// An attributed string for display as the summary of the caption
    let attributedCaptionSummary: NSAttributedString? = nil
    
    /// An attributed string for display as the credit of the caption
    let attributedCaptionCredit: NSAttributedString? = nil
    
    /// Initilization of DisplayPhoto object
    ///
    /// - Parameters:
    ///   - image: The image to display
    ///   - placeHolderImage: A placeholder image for display while the image is loading
    init(image: UIImage?, placeHolderImage: UIImage?) {
        self.image = image
        self.placeholderImage = placeHolderImage
        super.init()
    }
}

