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
        
        store.fetchInterestingPhotos()
    }
}
