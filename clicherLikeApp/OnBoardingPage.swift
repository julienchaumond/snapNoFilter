//
//  OnBoardingPage.swift
//  clicherLikeApp
//
//  Created by Julien Chaumond on 25/04/2017.
//  Copyright © 2017 Clicher. All rights reserved.
//

import UIKit

class OnBoardingPage: UIView {
    
    private(set) var title: String
    private(set) var content: String
    private(set) var image: UIImage
    
    private let titleLabel = UILabel()
    private let contentLabel = UILabel()
    private let backgroundImage: UIImageView
    
    init(title: String, content: String, image: UIImage) {
        self.title = title
        self.content = content
        self.image = image
        self.backgroundImage = UIImageView(image: image)
        
        super.init(frame: .zero)
        
        titleLabel.text = title
        contentLabel.text = content
        
        backgroundImage.contentMode = .scaleToFill
            
        addSubview(backgroundImage)
        addSubview(titleLabel)
        addSubview(contentLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundImage.frame = bounds
        
        let titleSize = titleLabel.sizeThatFits(bounds.size)
        titleLabel.frame = CGRect(x: bounds.width/2 - titleSize.width/2,
                                  y: bounds.height/4 - titleSize.height/2,
                                  width: titleSize.width,
                                  height: titleSize.height)
        
        let contentSize = contentLabel.sizeThatFits(bounds.size)
        contentLabel.frame = CGRect(x: bounds.width/2 - contentSize.width/2,
                                    y: titleLabel.frame.maxY + Style.verticalMargin,
                                    width: contentSize.width,
                                    height: contentSize.height)
    }
}
