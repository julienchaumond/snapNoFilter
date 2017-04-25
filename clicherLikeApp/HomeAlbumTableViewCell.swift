//
//  HomeAlbumTableViewCell.swift
//  clicherLikeApp
//
//  Created by Julien Chaumond on 25/04/2017.
//  Copyright © 2017 Clicher. All rights reserved.
//

import UIKit
import Photos

class HomeAlbumTableViewCell: UITableViewCell {
    var albumTitle: String? {
        didSet {
            titleLabel.text = albumTitle
        }
    }
    
    var numberOfPhotos: Int? {
        didSet {
            guard let numberOfPhotos = numberOfPhotos else { return }
            subtitleLabel.text = String(format: NSLocalizedString("HomeViewControllerNumberPhotos", comment: ""), numberOfPhotos)
        }
    }
    
    var thumbnailImage: UIImage? {
        didSet {
            guard let thumbnailImage = thumbnailImage else { return }
            thumbnailImageView.image = thumbnailImage
        }
    }
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let thumbnailImageView = UIImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel.font = UIFont.systemFont(ofSize: 24)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(thumbnailImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        thumbnailImageView.frame = CGRect(x: Style.horizontalMargin/2,
                                      y: Style.verticalMargin/2,
                                      width: frame.height, // Used for a squared view
                                      height: frame.height - Style.verticalMargin)
        
        let availableSize = CGSize(width: frame.width - thumbnailImageView.frame.width,
                                                height: frame.height)
        let titleLabelSize = titleLabel.sizeThatFits(availableSize)
        
        titleLabel.frame = CGRect(x: thumbnailImageView.frame.maxX + Style.horizontalMargin,
                                  y: thumbnailImageView.frame.minY,
                                  width: titleLabelSize.width,
                                  height: titleLabelSize.height)
        
        let subtitleLabelSize = subtitleLabel.sizeThatFits(availableSize)
        subtitleLabel.frame = CGRect(x: titleLabel.frame.minX,
                                     y: titleLabel.frame.maxY,
                                     width: subtitleLabelSize.width,
                                     height: subtitleLabelSize.height)
    }
}
