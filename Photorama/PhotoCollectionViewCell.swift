//
//  PhotoCollectionViewCell.swift
//  Photorama
//
//  Created by Edouard Barbier on 08/05/17.
//  Copyright © 2017 Edouard Barbier. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        update(with: nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        update(with: nil)
    }
    
    
    
    
    func update(with image: UIImage?) {
        
        if let imageToDisplay = image {
            
            spinner.stopAnimating()
            imageView.image = imageToDisplay
            
        } else {
            
            spinner.startAnimating()
            imageView.image = nil
            
        }
    }
    
}
