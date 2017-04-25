//
//  OnBoardingViewController.swift
//  clicherLikeApp
//
//  Created by Julien Chaumond on 25/04/2017.
//  Copyright © 2017 Clicher. All rights reserved.
//

import Foundation
import UIKit

class OnBoardingViewController: UIViewController, UIScrollViewDelegate {
    
    private let scrollView = UIScrollView()
    private let pageControl = UIPageControl()
    
    private var pages = [OnBoardingPage]()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        pages.append(OnBoardingPage(title: "Test", content: "sefsefesf", image: #imageLiteral(resourceName: "onBoardingBackground")))
        pages.append(OnBoardingPage(title: "Test2", content: "Plopefsfe", image: #imageLiteral(resourceName: "onBoardingBackground")))
        pages.append(OnBoardingPage(title: "Test3", content: "aAeeara", image: #imageLiteral(resourceName: "onBoardingBackground")))
        
        scrollView.isPagingEnabled = true
        scrollView.backgroundColor = .red
        
        scrollView.delegate = self
        
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.tintColor = Style.keyColor
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.addTarget(self, action: #selector(switchPage(sender:)), for: .valueChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        scrollView.frame = view.frame
        
        let pageControlSize = CGSize(width: 200, height: 50)
        pageControl.frame = CGRect(x: view.frame.width/2 - pageControlSize.width/2,
                                   y: view.frame.height - Style.verticalMargin,
                                   width: pageControlSize.width,
                                   height: pageControlSize.height)
        
        view.addSubview(pageControl)
        view.addSubview(scrollView)
        
        for i in 0..<pages.count {
            let page = pages[i]
            
            page.frame.origin.x = scrollView.frame.size.width * CGFloat(i)
            page.frame.size = scrollView.frame.size
            
            scrollView.addSubview(page)
        }
        
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(pages.count), height: view.frame.height)
        
        for page in pages {
            page.frame = view.bounds
            scrollView.addSubview(page)
        }
    }
    
    func switchPage(sender: AnyObject) {
        let offSetX = CGFloat(pageControl.currentPage) * scrollView.frame.width
        scrollView.setContentOffset(CGPoint(x: offSetX, y: 0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = Int(pageNumber)
    }
}
