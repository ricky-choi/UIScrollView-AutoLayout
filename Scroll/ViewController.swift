//
//  ViewController.swift
//  Scroll
//
//  Created by Jae Young Choi on 2017. 6. 28..
//  Copyright © 2017년 Appcid. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    var image: UIImage!
    var imageView: UIImageView!
    
    var contentViewWidthConstraint: NSLayoutConstraint!
    var contentViewHeightConstraint: NSLayoutConstraint!
    
    var minimumZoomLock = true
    var fitScale: CGFloat = 1
    
    override func awakeFromNib() {
        image = UIImage(named: "sample.jpg")
        imageView = UIImageView(image: image)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        scrollView.contentInsetAdjustmentBehavior = .never
        
        // setup scroll view
        scrollView.backgroundColor = .black
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        // setup content view, not image view
        contentView.backgroundColor = .black
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        contentViewWidthConstraint = contentView.widthAnchor.constraint(equalToConstant: scrollView.frameLayoutGuide.layoutFrame.size.width)
        contentViewHeightConstraint = contentView.heightAnchor.constraint(equalToConstant: scrollView.frameLayoutGuide.layoutFrame.size.height)
        contentViewWidthConstraint.isActive = true
        contentViewHeightConstraint.isActive = true
        
        // setup image view
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: scrollView.contentLayoutGuide.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: scrollView.contentLayoutGuide.centerYAnchor).isActive = true
        
        invalidateContentConstraints(zoomAnimated: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        invalidateContentConstraints(supposedScale: minimumZoomLock ? 0 : scrollView.zoomScale)
    }
    
    func invalidateContentConstraints(supposedScale: CGFloat = 0, zoomAnimated: Bool = true) {
        
        let minWidthScale = scrollView.frameLayoutGuide.layoutFrame.size.width / image.size.width
        let minHeightScale = scrollView.frameLayoutGuide.layoutFrame.size.height / image.size.height
        let minScale = min(minWidthScale, minHeightScale) * fitScale
        
        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = 3
        
        if supposedScale < scrollView.minimumZoomScale {
            invalidateContentSize(scale: scrollView.minimumZoomScale)
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: zoomAnimated)
        } else if supposedScale > scrollView.maximumZoomScale {
            invalidateContentSize(scale: scrollView.maximumZoomScale)
            scrollView.setZoomScale(scrollView.maximumZoomScale, animated: zoomAnimated)
        } else {
            invalidateContentSize(scale: supposedScale)
        }
    }
    
    func invalidateContentSize(scale: CGFloat) {
        contentViewWidthConstraint.constant = max(scrollView.frameLayoutGuide.layoutFrame.size.width / scale, image.size.width)
        contentViewHeightConstraint.constant = max(scrollView.frameLayoutGuide.layoutFrame.size.height / scale, image.size.height)
    }
    
}

extension ViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        invalidateContentSize(scale: scale)
        
        minimumZoomLock = scrollView.minimumZoomScale == scale
    }
}

