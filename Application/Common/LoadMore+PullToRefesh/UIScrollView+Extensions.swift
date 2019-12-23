//
//  UIScrollView+Extensions.swift
//  Application
//
//  Created by Vu Doan on 11/29/19.
//  Copyright © 2019 Vu Doan. All rights reserved.
//

import UIKit
import SnapKit

public enum LoadMoreDirection {
    case Vertical
    case Horizontal
}

private var pullToRefreshKey: UInt8 = 0
public let pullToRefreshDefaultHeight: CGFloat = 50
private var loadMoreKey: UInt8 = 1
public let loadMoreDefaultHeight: CGFloat = 50

/// Pull To Refresh
public extension UIScrollView {
    
    private var pullToRefreshView: PullToRefreshView? {
        get {
            return objc_getAssociatedObject(self, &pullToRefreshKey) as? PullToRefreshView
        }
        set {
            pullToRefreshView?.removeFromSuperview()
            objc_setAssociatedObject(self, &pullToRefreshKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // Add pull to refresh view with default animator
    func addPullToRefresh(direction: LoadMoreDirection, action: @escaping (() -> ())) {
        if direction == .Vertical {
            let origin = CGPoint(x: 0, y: -pullToRefreshDefaultHeight)
            let size = CGSize(width: self.frame.size.width, height: pullToRefreshDefaultHeight)
            let frame = CGRect(origin: origin, size: size)
            pullToRefreshView = PullToRefreshView(direction: direction, action: action, frame: frame)
        } else {
            let origin = CGPoint(x: -pullToRefreshDefaultHeight, y: 0)
            let size = CGSize(width: pullToRefreshDefaultHeight, height: self.frame.size.height)
            let frame = CGRect(origin: origin, size: size)
            pullToRefreshView = PullToRefreshView(direction: direction, action: action, frame: frame)
        }
        addSubview(pullToRefreshView!)
    }
    
    func addPullToRefresh(direction: LoadMoreDirection, withAnimator animator: PullToRefreshDelegate & UIView,
                          height: CGFloat = pullToRefreshDefaultHeight,
                          action: @escaping (() -> ())) {
        if direction == .Vertical {
            let frame = CGRect(x: 0, y: -height, width: self.frame.size.width, height: height)
            pullToRefreshView = PullToRefreshView(direction: direction, action: action, frame: frame, animator: animator)
        } else {
            let frame = CGRect(x: -height, y: 0, width: height, height: self.frame.size.height)
            pullToRefreshView = PullToRefreshView(direction: direction, action: action, frame: frame, animator: animator)
        }
        addSubview(pullToRefreshView!)
    }
    
    // Start pull to refresh
    func startPullToRefresh() {
        pullToRefreshView?.isLoading = true
    }
    
    // Stop pull to refresh
    func stopPullToRefresh() {
        pullToRefreshView?.isLoading = false
    }
}


/// Infinity Scrolling
public extension UIScrollView {
    
    private var loadMoreView: LoadMoreView? {
        get {
            return objc_getAssociatedObject(self, &loadMoreKey) as? LoadMoreView
        }
        set {
            loadMoreView?.removeFromSuperview()
            objc_setAssociatedObject(self, &loadMoreKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // Add load more view with default animator
    func addLoadMore(direction: LoadMoreDirection, action: @escaping (() -> ())) {
        if direction == .Vertical {
            let size = CGSize(width: self.frame.size.width, height: loadMoreDefaultHeight)
            let frame = CGRect(origin: CGPoint(x: 0, y: -100), size: size)
            loadMoreView = LoadMoreView(action: action, frame: frame)
//            loadMoreView?.backgroundColor = UIColor.red
            loadMoreView?.loadMoreDirection = direction
            loadMoreView?.autoresizingMask = [.flexibleWidth]
            addSubview(loadMoreView!)
        } else {
            let size = CGSize(width: loadMoreDefaultHeight, height: self.frame.size.height)
            let frame = CGRect(origin: .zero, size: size)
            loadMoreView = LoadMoreView(action: action, frame: frame)
            loadMoreView?.loadMoreDirection = direction
            loadMoreView?.autoresizingMask = [.flexibleHeight]
            addSubview(loadMoreView!)
        }
        
    }
    
    // Start load more
    func startLoadMore() {
        loadMoreView?.isLoading = true
    }
    
    // Stop load more
    func stopLoadMore() {
        loadMoreView?.isLoading = false
    }
    
    // Set enable/disable for loading more
    func setLoadMoreEnable(_ enable: Bool) {
        loadMoreView?.isEnabled = enable
    }
}
