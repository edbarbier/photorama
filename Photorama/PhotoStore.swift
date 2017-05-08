//
//  PhotoStore.swift
//  Photorama
//
//  Created by Edouard Barbier on 07/05/17.
//  Copyright © 2017 Edouard Barbier. All rights reserved.
//

import UIKit

enum ImageResult {
    case success(UIImage)
    case failure(Error)
}

enum PhotoError: Error {
    
    case imageCreationError
}

enum PhotosResult {
    case success([Photo])
    case failure(Error)
}

class PhotoStore {
    
    private let session: URLSession = {
        
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    private func processPhotosRequest(data: Data?, error: Error?) -> PhotosResult {
        
        guard let jsonData = data else {
            
            return .failure(error!)
        }
        return FlickrAPI.photos(fromJSON: jsonData)
    }
    
    private func processImageRequest(data: Data?, error: Error?) -> ImageResult {
        
        guard
            let imageData = data,
            let image = UIImage(data: imageData) else {
            
                //Couldn't create an image
                if data == nil {
                    return .failure(error!)
                } else {
                    return .failure(PhotoError.imageCreationError)
                }
            }
        return .success(image)
    }
    
    func fetchInterestingPhotos(completion: @escaping (PhotosResult) -> Void) {
        
        let url = FlickrAPI.interestingPhotosURL
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data, response, error) in
            
            let result = self.processPhotosRequest(data: data, error: error)
            completion(result)
        }
        task.resume()
    }
    
    func fetchImage(for photo: Photo, completion: @escaping (ImageResult) -> Void) {
    
        let photoURL = photo.remoteURL
        let request = URLRequest(url: photoURL)
        
        let task = session.dataTask(with: request) { (data, response, error) -> Void in
            
            print("Response status code: \(response)")
            
            let result = self.processImageRequest(data: data, error: error)
            OperationQueue.main.addOperation {
                completion(result)
            }
            
            
        }
        task.resume()
    
    }
    
}
