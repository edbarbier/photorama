//
//  Copyright © 2015 Big Nerd Ranch
//

import UIKit
import CoreData

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

enum TagsResult {
    
    case success([Tag])
    case failure(Error)
}

class PhotoStore {
    
    let imageStore = ImageStore()
    
    //We instantiate an NSPersistantContainer with a name that needs to be the same as 
    //the one give in the data model file that describes our entities, in this case "Photorama" 
    let persistentContainer: NSPersistentContainer = {
       
        let container = NSPersistentContainer(name: "Photorama")
        container.loadPersistentStores { (description, error) in
            
            if let error = error {
                print("Error setting up Core Data \(error)")
            }
        }
        return container
    }()
    
    let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    func processPhotosRequest(data: Data?, error: Error?, completion: @escaping (PhotosResult) -> Void) {
        guard let jsonData = data else {
            completion(.failure(error!))
            return 
        }
        
        persistentContainer.performBackgroundTask { (context) in
            
            let result = FlickrAPI.photos(fromJSON: jsonData, into: context)
            
            do {
                
                try context.save()
                
            } catch {
                
                print("Error saving to Core Data: \(error)")
                completion(.failure(error))
                return
            }
            
            switch result {
                
            case let .success(photos):
                let photoIDs = photos.map {return $0.objectID }
                let viewContext = self.persistentContainer.viewContext
                let viewContextPhotos = photoIDs.map { return viewContext.object(with: $0) } as! [Photo]
                completion(.success(viewContextPhotos))
            case .failure:
                completion(result)
            }
        
        }
    }
    
    private var photos: [Photo] = []
    
    func processImageRequest(data: Data?, error: Error?) -> ImageResult {
        
        guard
            let imageData = data,
            let image = UIImage(data: imageData) else {
                
                // Couldn't create an image
                if data == nil {
                    return .failure(error!)
                }
                else {
                    return .failure(PhotoError.imageCreationError)
                }
        }
        
        return .success(image)
    }
    
    func fetchImage(for photo: Photo, completion: @escaping (ImageResult) -> Void) {
        
        guard let photoKey = photo.photoID else {
        
            preconditionFailure("Photo expected to have a photoID")
        }
        
        if let image = imageStore.image(forKey: photoKey) {
            OperationQueue.main.addOperation {
                completion(.success(image))
            }
        }
        
        guard let photoURL = photo.remoteURL else {
            
            preconditionFailure("Photo expected to have a remote URL")
        }
        
        let request = URLRequest(url: photoURL as URL)
        
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            
            let result = self.processImageRequest(data: data, error: error)
            
            if case let .success(image) = result {
                self.imageStore.setImage(image, forKey: photoKey)
            }
            
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        task.resume()
    }
    
    func fetchInterestingPhotos(completion: @escaping (PhotosResult) -> Void) {
        
        let url = FlickrAPI.interestingPhotosURL
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data, response, error) -> Void in
          
            self.processPhotosRequest(data: data, error: error) { (result) in
             
                OperationQueue.main.addOperation {
                    
                    completion(result)
                }
            }
        }
        task.resume()
        
    }

    func fetchAllPhotos(completion: @escaping (PhotosResult) -> Void) {
    
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        let sortByDateTaken = NSSortDescriptor(key: #keyPath(Photo.dateTaken), ascending: true)
        fetchRequest.sortDescriptors = [sortByDateTaken]
        let viewContext = persistentContainer.viewContext
        viewContext.perform {
            do {
                
                let allPhotos = try viewContext.fetch(fetchRequest)
                completion(.success(allPhotos))
                
            } catch let error {
                
                completion(.failure(error))
            }
        }
    }
    
    func fetchAllTags(completion: @escaping (TagsResult) -> Void) {
        
        let fetchRequest: NSFetchRequest<Tag> = Tag.fetchRequest()
        let sortByName = NSSortDescriptor(key: #keyPath(Tag.name), ascending: true)
        fetchRequest.sortDescriptors = [sortByName]
        let viewContext = persistentContainer.viewContext
        viewContext.perform {
            
            do {
                
                let allTags = try fetchRequest.execute()
                
                completion(.success(allTags))
                
            } catch {
                
                completion(.failure(error))
            }
            
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}
