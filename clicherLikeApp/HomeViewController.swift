//
//  HomeViewController.swift
//  clicherLikeApp
//
//  Created by Julien Chaumond on 25/04/2017.
//  Copyright © 2017 Clicher. All rights reserved.
//

import UIKit
import Photos

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, PhotoOverlayViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private let cellIdentifier = "cellIdentifier"
    
    private let tableView = UITableView()
    private let cameraButtonMaterial = UIButton()
    
    private var userAlbums = [(collection: PHAssetCollection, numberOfPhotos: Int, thumbnail: UIImage)]()
    
    private let imagePicker = UIImagePickerController()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.title = NSLocalizedString("AppTitle", comment: "")
    
        retrieveUserAlbums()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        
        tableView.register(HomeAlbumTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        cameraButtonMaterial.setBackgroundImage(UIImage(named: "camera"), for: .normal)
        cameraButtonMaterial.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        for indexPathSelected in tableView.indexPathsForSelectedRows ?? [] {
            tableView.cellForRow(at: indexPathSelected)?.setSelected(false, animated: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        view.insertSubview(cameraButtonMaterial, aboveSubview: tableView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let cameraButtonSize = CGSize(width: 80, height: 80)
        cameraButtonMaterial.frame = CGRect(x: view.frame.width - Style.horizontalMargin - cameraButtonSize.width,
                                            y: view.frame.height - Style.verticalMargin - cameraButtonSize.height,
                                            width: cameraButtonSize.width,
                                            height: cameraButtonSize.height)
        
        tableView.frame = view.bounds
        
        let insets = UIEdgeInsets(top: topLayoutGuide.length,
                                  left: 0,
                                  bottom: 0,
                                  right: 0)
        
        tableView.scrollIndicatorInsets = insets
        tableView.contentInset = insets
    }
    
    // MARK: - UITableViewDatasource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userAlbums.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! HomeAlbumTableViewCell
        
        let album = userAlbums[indexPath.row]
        
        tableViewCell.albumTitle = album.collection.localizedTitle
        tableViewCell.numberOfPhotos = album.numberOfPhotos
        tableViewCell.thumbnailImage = album.thumbnail
        
        return tableViewCell
    }

    // MARK: - UITableViewDelegate methods

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = PhotosViewController(album: userAlbums[indexPath.row].collection)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK: - PhotoOverlayViewDelegate methods

    func didClickOnCloseButton(sender: PhotoOverlayView) {
        imagePicker.dismiss(animated: true, completion: nil)
        retrieveUserAlbums()
    }
    
    func didClickOnPhotoButton(sender: PhotoOverlayView) {
        imagePicker.takePicture()
    }
    
    // MARK: - UIImagePickerControllerDelegate methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            PhotoSavingHandler.shared.saveImage(image: image, completionHandler: { (error) in
                let message: String
                if error == nil {
                    message = NSLocalizedString("ToastMessageSavingPhotoComplete", comment: "")
                } else {
                    message = NSLocalizedString("ToastMessageSavingPhotoError", comment: "")
                }
                
                let alertView = UIAlertController(title: NSLocalizedString("ToastTitleSavingPhoto", comment: ""),
                                                  message: message,
                                                  preferredStyle: .alert)
                
                picker.present(alertView, animated: true, completion: nil)
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                    alertView.dismiss(animated: true, completion:nil)
                })
            })
        }
    }
    
    // MARK: - Private methods

    private func retrieveUserAlbums() {
        userAlbums.removeAll()
        let fetchUserAlbums = PHAssetCollection.fetchAssetCollections(with: .album,
                                                                      subtype: .any,
                                                                      options: nil)
        
        let imageManager = PHImageManager.default()
        
        fetchUserAlbums.enumerateObjects({ (collection, idx, stop) in
            let albumPhotosFetch = PHAsset.fetchAssets(in: collection, options: nil)
            
            let numberOfPhotos = albumPhotosFetch.count
            
            if let firstPhoto = albumPhotosFetch.firstObject {
                imageManager.requestImage(for: firstPhoto,
                                          targetSize: PHImageManagerMaximumSize,
                                          contentMode: .default,
                                          options: nil,
                                          resultHandler: { (image, _) in
                                            if let image = image {
                                                let album = (collection, numberOfPhotos, image)
                                                self.userAlbums.append(album)
                                                self.tableView.reloadData()
                                            }
                })
            }
        })
    }
    // MARK: - Public Methods
    
    func didSavePicture(image: UIImage?, withError error: Error?, usingContextInfo info: Any) {
        if error == nil {
            
        }
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            
            imagePicker.cameraDevice = .front

            let overlay = PhotoOverlayView(frame: view.frame)
            overlay.delegate = self
            
            imagePicker.cameraOverlayView = overlay
            imagePicker.cameraCaptureMode = .photo
            imagePicker.cameraFlashMode = .auto
            imagePicker.showsCameraControls = false
            
            // Fullscreen image picker
            let screenBounds = UIScreen.main.bounds.size
            let cameraAspectRatio: CGFloat = 4.0/3.0;
            let camViewHeight = screenBounds.width * cameraAspectRatio
            let scale = screenBounds.height / camViewHeight
            
            imagePicker.cameraViewTransform = CGAffineTransform(translationX: 0, y: (screenBounds.height - camViewHeight) / 2.0)
            imagePicker.cameraViewTransform = imagePicker.cameraViewTransform.scaledBy(x: scale, y: scale)
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
}
