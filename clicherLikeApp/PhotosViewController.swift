//
//  PhotosViewController.swift
//  clicherLikeApp
//
//  Created by Julien Chaumond on 25/04/2017.
//  Copyright © 2017 Clicher. All rights reserved.
//

import UIKit
import Photos

class PhotosViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    private let cellIdentifier = "cellIdentifier"
    
    private let album: PHAssetCollection
    private var photos = [UIImage]()
    
    private let collectionViewLayout = UICollectionViewFlowLayout()
    private let collectionView: UICollectionView
    private let loadingView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    init(album: PHAssetCollection) {
        self.album = album
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        
        super.init(nibName: nil, bundle: nil)
        
        self.title = album.localizedTitle
        
        let imageManager = PHImageManager.default()
        
        let albumPhotosFetch = PHAsset.fetchAssets(in: album, options: nil)

        albumPhotosFetch.enumerateObjects({ (asset, idx, stop) in
            imageManager.requestImage(for: asset,
                                      targetSize: PHImageManagerMaximumSize,
                                      contentMode: .default,
                                      options: nil,
                                      resultHandler: { (image, _) in
                                        if let image = image {
                                            self.photos.append(image)
                                        }
            })
        })
        
        collectionView.backgroundColor = .white
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        loadingView.tintColor = Style.keyColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(collectionView)
        view.addSubview(loadingView)
        
        loadingView.startAnimating()
        
        let itemWidth = (view.frame.width - Style.horizontalMargin * 2) / 3 - Style.horizontalMargin
        collectionViewLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        collectionViewLayout.minimumLineSpacing = Style.verticalMargin * 2
        collectionViewLayout.minimumInteritemSpacing = Style.horizontalMargin
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Only reload at this moment to assure the view is visible
        self.collectionView.reloadData()
        loadingView.stopAnimating()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        loadingView.frame = view.bounds
        collectionView.frame = view.bounds
        
        let insets = UIEdgeInsets(top: topLayoutGuide.length + Style.verticalMargin, left: Style.horizontalMargin, bottom: 0, right: Style.horizontalMargin)
        collectionView.scrollIndicatorInsets = insets
        collectionView.contentInset = insets
    }
    
    // MARK: - UICollectionViewDatasource methods

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        
        cell.backgroundView = UIImageView(image: photos[indexPath.row])
        
        return cell
    }
    
}
