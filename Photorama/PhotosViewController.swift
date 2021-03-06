//
//  Copyright © 2015 Big Nerd Ranch
//

import UIKit

class PhotosViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var store: PhotoStore!
    let photoDataSource = PhotoDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = photoDataSource
        collectionView.delegate = self
        
        updateDataSource()
        
        store.fetchInterestingPhotos {
            (photosResult) -> Void in
            
            self.updateDataSource()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        flowLayout.invalidateLayout()

    }
    
    //MARK: - COLLECTION VIEW DELEGATE
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        
        let photo = photoDataSource.photos[indexPath.row]
        
        // Download the image data, which could take some time
        store.fetchImage(for: photo, completion: { (result) -> Void in
            
            // The index path for the photo might have changed between the
            // time the request started and finished, so find the most
            // interesting index path
            
            guard let photoIndex = self.photoDataSource.photos.index(of: photo),
                case let .success(image) = result else {
                    return
            }
            let photoIndexPath = IndexPath(item: photoIndex, section: 0)
            
            // When the request finishes, only update the cell if it's still visible
            if let cell = self.collectionView.cellForItem(at: photoIndexPath)
                as? PhotoCollectionViewCell {
                cell.update(with: image)
            }
        })
    }
    
    private func updateDataSource() {
        
        store.fetchAllPhotos { (photosResult) in
            
            switch photosResult {
            case let .success(photos):
                self.photoDataSource.photos = photos
            case .failure:
                self.photoDataSource.photos.removeAll()
                self.collectionView.reloadSections(IndexSet(integer: 0))
            }
        
            self.collectionView.reloadSections(IndexSet(integer: 0))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 4 - 10 , height: view.frame.width / 4 - 10)
    }
    
    //MARK: - NAVIGATION 
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
            
            case "showPhoto"?:
                if let selectedInfoPath = self.collectionView.indexPathsForSelectedItems?.first {
                    
                    let photo = photoDataSource.photos[selectedInfoPath.row]
                    let destinationVC = segue.destination as! PhotoInfoViewController
                    destinationVC.photo = photo
                    destinationVC.store = store
            
            }
        
        default:
            preconditionFailure("Unexpected segue identifier")
        }
        
    }
}
