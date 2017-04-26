//
//  PhotoSavingHandler.swift
//  clicherLikeApp
//
//  Created by Julien Chaumond on 25/04/2017.
//  Copyright © 2017 Clicher. All rights reserved.
//

import UIKit
import Photos

// Class handling photo saving in album. 
// Source: http://stackoverflow.com/questions/28708846/how-to-save-image-to-custom-album
class PhotoSavingHandler {
    
    static let shared = PhotoSavingHandler()
    
    private let albumName = NSLocalizedString("AppTitle", comment: "")
    
    var assetCollection: PHAssetCollection!
    
    init() {
        
        let fetchAssetCollectionForAlbum = { () -> PHAssetCollection? in
            
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "title = %@", self.albumName)
            
            let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
            
            if let firstObject = collection.firstObject {
                return firstObject
            }
            
            return nil
        }
        
        if let assetCollection = fetchAssetCollectionForAlbum() {
            self.assetCollection = assetCollection
            return
        }
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: self.albumName)
        }) { success, _ in
            if success {
                self.assetCollection = fetchAssetCollectionForAlbum()
            }
        }
    }
    
    func saveImage(image: UIImage, completionHandler: ((_ error: Error?) -> ())?) {
        
        if assetCollection == nil {
            return   // If there was an error upstream, skip the save.
        }
        
        PHPhotoLibrary.shared().performChanges({
            let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
            
            if let assetPlaceholder = assetChangeRequest.placeholderForCreatedAsset,
                let albumChangeRequest = PHAssetCollectionChangeRequest(for: self.assetCollection) {
                albumChangeRequest.addAssets([assetPlaceholder] as NSArray)
            }
        }, completionHandler: { (_, error) in
            completionHandler?(error)
        })
    }
    
}
