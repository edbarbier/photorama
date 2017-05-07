//
//  Photo.swift
//  Photorama
//
//  Created by Edouard Barbier on 08/05/17.
//  Copyright © 2017 Edouard Barbier. All rights reserved.
//

import Foundation


class Photo {
    
    
    //TODO: use fileprivate to declare these variables
    
    let title: String
    let remoteURL: URL
    let photoID: String
    let dateTaken: Date
    
    init(title: String, photoID: String, remoteURL: URL, dateTaken: Date) {
        
        self.title = title
        self.remoteURL = remoteURL
        self.photoID = photoID
        self.dateTaken = dateTaken
        
    }
    
}
