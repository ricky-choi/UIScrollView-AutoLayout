//
//  ScrollViewController.swift
//  Scroll
//
//  Created by Jae Young Choi on 2017. 6. 28..
//  Copyright © 2017년 Appcid. All rights reserved.
//

import UIKit

open class ScrollViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentBackgroundView = UIView()
    
    public var contentView: UIView? {
        didSet {
            if isViewLoaded {
                setupContentView()
            }
        }
    }
    
    private var contentBackgroundViewWidthConstraint: NSLayoutConstraint!
    private var contentBackgroundViewHeightConstraint: NSLayoutConstraint!
    
    public var minimumZoomLock = true
    public var fitScale: CGFloat = 1
    public var margins: CGFloat = 0
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        scrollView.delegate = self
        scrollView.contentInsetAdjustmentBehavior = .automatic
        
        // setup scroll view
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        // setup content background view, not content view
        scrollView.addSubview(contentBackgroundView)
        contentBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        contentBackgroundView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentBackgroundView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentBackgroundView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentBackgroundView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        contentBackgroundViewWidthConstraint = contentBackgroundView.widthAnchor.constraint(equalToConstant: scrollView.frameLayoutGuide.layoutFrame.size.width)
        contentBackgroundViewHeightConstraint = contentBackgroundView.heightAnchor.constraint(equalToConstant: scrollView.frameLayoutGuide.layoutFrame.size.height)
        contentBackgroundViewWidthConstraint.isActive = true
        contentBackgroundViewHeightConstraint.isActive = true
        
        setupContentView()
    }
    
    private func setupContentView() {
        if let contentView = contentView {
            contentBackgroundView.addSubview(contentView)
            contentView.translatesAutoresizingMaskIntoConstraints = false
            contentView.centerXAnchor.constraint(equalTo: scrollView.contentLayoutGuide.centerXAnchor).isActive = true
            contentView.centerYAnchor.constraint(equalTo: scrollView.contentLayoutGuide.centerYAnchor).isActive = true
            
            invalidateContentConstraints(zoomAnimated: false)
        } else {
            minimumZoomLock = true
        }
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        invalidateContentConstraints(supposedScale: minimumZoomLock ? 0 : scrollView.zoomScale)
    }
    
    private func invalidateContentConstraints(supposedScale: CGFloat = 0, zoomAnimated: Bool = true) {
        guard let contentView = contentView, contentView.intrinsicContentSize > CGSize.zero else { return }
        
        let minWidthScale = scrollView.frameLayoutGuide.layoutFrame.size.width / contentView.intrinsicContentSize.width
        let minHeightScale = scrollView.frameLayoutGuide.layoutFrame.size.height / contentView.intrinsicContentSize.height
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
    
    private func invalidateContentSize(scale: CGFloat) {
        guard let contentView = contentView, contentView.intrinsicContentSize > CGSize.zero else { return }
        
        contentBackgroundViewWidthConstraint.constant = max(scrollView.frameLayoutGuide.layoutFrame.size.width / scale, contentView.intrinsicContentSize.width + margins * 2)
        contentBackgroundViewHeightConstraint.constant = max(scrollView.frameLayoutGuide.layoutFrame.size.height / scale, contentView.intrinsicContentSize.height + margins * 2)
    }
    
}

extension ScrollViewController: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentBackgroundView
    }
    
    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        invalidateContentSize(scale: scale)
        
        minimumZoomLock = scrollView.minimumZoomScale == scale
    }
}

extension CGSize: Comparable {
    public static func <(lhs: CGSize, rhs: CGSize) -> Bool {
        return lhs.width < rhs.width && lhs.height < rhs.height
    }
}

