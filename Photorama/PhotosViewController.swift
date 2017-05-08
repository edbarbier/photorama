//
//  PhotoViewController.swift
//  Photorama
//
//  Created by Edouard Barbier on 07/05/17.
//  Copyright © 2017 Edouard Barbier. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {
    
    //MARK: - @IBOUTLETS
    
    @IBOutlet var imageView: UIImageView!
    
    //MARK: - VARIABLES
    
    var store: PhotoStore!
    
    //MARK: - VIEW LIFE CYCLE
    
    override func viewDidLoad() {
        
        store.fetchInterestingPhotos { (photoResult) -> Void in
            
            switch photoResult {
            case let .success(photos):
                print("Successfully found \(photos.count) photos")
                
                if let firstPhoto = photos.first {
                    
                    self.updateImageView(for: firstPhoto)
                }
                
            case let .failure(error):
                print("Error fetching interesting photos: \(error)")
            }
        }
    }
    
    func updateImageView(for photo: Photo) {
        
        store.fetchImage(for: photo) { (imageResult) -> Void in
            
            switch imageResult {
                
            case let .success(image):
                self.imageView.image = image
            case let .failure(error):
                print("Error downloading image : \(error)")
            }
        }
    }
}
