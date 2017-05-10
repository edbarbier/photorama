//
//  PhotoInfoViewController.swift
//  Photorama
//
//  Created by Edouard Barbier on 10/05/17.
//  Copyright © 2017 Edouard Barbier. All rights reserved.
//

import UIKit

class PhotoInfoViewController: UIViewController {
    
    //MARK: - @IBOUTLETS
    
    @IBOutlet var imageView: UIImageView!
    
    
    //MARK: - VARIABLES 
    
    var photo: Photo! {
        didSet{
            
            navigationItem.title = photo.title
        }
    }
    
    var store: PhotoStore!
    
    //MARK: - VIEW LIFE CYCLE 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        store.fetchImage(for: photo) { (result) -> Void in
            
            switch result {
                
            case let .success(image):
                self.imageView.image = image
            case let .failure(error):
                print("Error fetching image for photo: \(error)")
            }
            
        }
    }
}

