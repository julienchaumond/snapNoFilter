//
//  PhotoOverlayView.swift
//  clicherLikeApp
//
//  Created by Julien Chaumond on 25/04/2017.
//  Copyright © 2017 Clicher. All rights reserved.
//

import UIKit

protocol PhotoOverlayViewDelegate {
    func didClickOnCloseButton(sender: PhotoOverlayView)
    
    func didClickOnPhotoButton(sender: PhotoOverlayView)
}

class PhotoOverlayView: UIView {

    var delegate: PhotoOverlayViewDelegate?
    
    private let photoButton = UIButton()
    
    private let closeButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        photoButton.setBackgroundImage(#imageLiteral(resourceName: "takePicture").withRenderingMode(.alwaysTemplate), for: .normal)
        photoButton.tintColor = .white
        photoButton.addTarget(self, action: #selector(clickPhotoButton), for: .touchUpInside)
        
        closeButton.setBackgroundImage(#imageLiteral(resourceName: "cross").withRenderingMode(.alwaysTemplate), for: .normal)
        closeButton.tintColor = .white
        closeButton.addTarget(self, action: #selector(clickCloseButton), for: .touchUpInside)
        
        addSubview(photoButton)
        addSubview(closeButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        closeButton.frame = CGRect(x: Style.horizontalMargin,
                                   y: Style.verticalMargin,
                                   width: 50,
                                   height: 50)
        
        let photoButtonSize = CGSize(width: 80, height: 80)
        photoButton.frame = CGRect(x: frame.width/2 - photoButtonSize.width/2,
                                   y: frame.height - photoButtonSize.height - Style.verticalMargin,
                                   width: photoButtonSize.width,
                                   height: photoButtonSize.height)
    }
    
    func clickPhotoButton() {
        delegate?.didClickOnPhotoButton(sender: self)
    }
    
    func clickCloseButton() {
        delegate?.didClickOnCloseButton(sender: self)
    }
}
