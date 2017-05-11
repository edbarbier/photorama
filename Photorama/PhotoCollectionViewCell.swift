//
//  PhotoCollectionViewCell.swift
//  Photorama
//
//  Created by Edouard Barbier on 08/05/17.
//  Copyright © 2017 Edouard Barbier. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    //MARK: - @IBOUTLETS
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    //MARK: - VARIABLES
    
    var photoDescription: String?
    
    
    
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
    
    
    //MARK: - ACCESSIBILITY 
    
    override var isAccessibilityElement: Bool {
        get {
            return true 
        }
        set {
            super.isAccessibilityElement = newValue
        }
    }
    
    override var accessibilityLabel: String? {
        get {
            return photoDescription
        } set {
            //Ignore attempts to set
        }
    }
    
    override var accessibilityTraits: UIAccessibilityTraits {
        get {
            return super.accessibilityTraits | UIAccessibilityTraitImage
        }
        set {
            //Ignore attempts to set 
        }
    }
    
}
