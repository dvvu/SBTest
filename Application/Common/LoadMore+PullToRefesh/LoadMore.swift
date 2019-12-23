//
//  LoadMore.swift
//  Application
//
//  Created by Vu Doan on 11/29/19.
//  Copyright © 2019 Vu Doan. All rights reserved.
//

import UIKit

public protocol LoadMoreDelegate {
    func loadMoreAnimationDidStart(view: LoadMoreView)
    func loadMoreAnimationDidEnd(view: LoadMoreView)
}

public class LoadMoreView: UIView {
    
    // Default is true. When you set false load more view will be hide
    var loadMoreDirection: LoadMoreDirection = .Vertical
    var isEnabled: Bool = true {
        didSet {
            if loadMoreDirection == .Vertical {
                if isEnabled {
                    frame = CGRect(x: 0, y: scrollView.contentSize.height, width: frame.size.width, height: height)
                } else {
                    frame = CGRect(x: 0, y: scrollView.contentSize.height, width: frame.size.width, height: 0)
                }
            } else {
                if isEnabled {
                    frame = CGRect(x: scrollView.contentSize.width, y: 0, width: width, height: frame.size.height)
                } else {
                    frame = CGRect(x: scrollView.contentSize.width, y: 0, width: 0, height: frame.size.height)
                }
            }
        }
    }
    
    var isLoading: Bool = false {
        didSet {
            if isLoading {
                startAnimating()
            } else {
                stopAnimating()
            }
        }
    }
    
    private var width: CGFloat
    private var height: CGFloat
    private var scrollView: UIScrollView!
    private var contentOffsetObservation: NSKeyValueObservation?
    private var contentSizeObservation: NSKeyValueObservation?
    private var panStateObservation: NSKeyValueObservation?
    
    private var animator: LoadMoreDelegate
    private var action: (() -> ()) = {}
    
    
    convenience init(action: @escaping (() -> ()), frame: CGRect) {
        var bounds = frame
        bounds.origin.y = 0
        let animator = LoadMoreAnimator(frame: bounds)
        self.init(frame: frame, animator: animator)
        self.action = action
        addSubview(animator)
    }
    
    convenience init(action: @escaping (() -> ()), frame: CGRect, animator: LoadMoreDelegate) {
        self.init(frame: frame, animator: animator)
        self.action = action
    }
    
    public init(frame: CGRect, animator: LoadMoreDelegate) {
        self.height = frame.height
        self.width = frame.width
        self.animator = animator
        super.init(frame: frame)
        self.autoresizingMask = .flexibleWidth
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        if newSuperview == nil {
            removeKeyValueObervation()
        } else {
            guard newSuperview is UIScrollView else { return }
            
            scrollView = newSuperview as? UIScrollView
            scrollView.alwaysBounceVertical = (loadMoreDirection == .Vertical) ? true : false
            scrollView.alwaysBounceHorizontal = (loadMoreDirection == .Horizontal) ? true : false
            addKeyValueObservations()
        }
    }
    
    deinit {
        removeKeyValueObervation()
    }
}

extension LoadMoreView {
    
    private func startAnimating() {
        animator.loadMoreAnimationDidStart(view: self)
        if self.loadMoreDirection == .Vertical {
            let frameHeight = frame.height
            let contentSizeHeight = scrollView.contentSize.height
            let scrollViewHeight = scrollView.bounds.height
            let contentInsetBottom = scrollView.contentInset.bottom
            
            UIView.animate(withDuration: 0.3, animations: {
                self.scrollView.contentOffset.y = frameHeight + contentSizeHeight - scrollViewHeight + contentInsetBottom
                self.scrollView.contentInset.bottom += frameHeight
            }, completion: { _ in
                self.action()
            })
        } else {
            let frameHeight = frame.width
            let contentSizeHeight = scrollView.contentSize.width
            let scrollViewHeight = scrollView.bounds.width
            let contentInsetBottom = scrollView.contentInset.right
            
            UIView.animate(withDuration: 0.3, animations: {
                self.scrollView.contentOffset.x = frameHeight + contentSizeHeight - scrollViewHeight + contentInsetBottom
                self.scrollView.contentInset.right += frameHeight
            }, completion: { _ in
                self.action()
            })
        }
    }
    
    private func stopAnimating() {
        animator.loadMoreAnimationDidEnd(view: self)
        if self.loadMoreDirection == .Vertical {
            UIView.animate(withDuration: 0.3, animations: {
                self.scrollView.contentInset.bottom -= self.frame.height
                self.scrollView.setContentOffset(self.scrollView.contentOffset, animated: false)
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.scrollView.contentInset.right -= self.frame.width
                self.scrollView.setContentOffset(self.scrollView.contentOffset, animated: false)
            })
        }
    }
    
    private func addKeyValueObservations() {
        contentOffsetObservation = scrollView.observe(\.contentOffset) { [weak self] scrollView, _ in
            self?.handleContentOffsetChange()
        }
        
        contentSizeObservation = scrollView.observe(\.contentSize) { [weak self] scrollView, _ in
            self?.handleContentSizeChange()
        }
    }
    
    private func removeKeyValueObervation() {
        contentOffsetObservation?.invalidate()
        contentSizeObservation?.invalidate()
        
        contentOffsetObservation = nil
        contentSizeObservation = nil
    }
    
    private func handleContentOffsetChange() {
        if isLoading || !isEnabled { return }
        if self.loadMoreDirection == .Vertical {
            if scrollView.contentSize.height <= scrollView.bounds.height { return }
            if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.height + scrollView.contentInset.bottom + 20 {
                isLoading = true
            }
        } else {
            if scrollView.contentSize.width <= scrollView.bounds.width { return }
            if scrollView.contentOffset.x > scrollView.contentSize.width - scrollView.bounds.width + scrollView.contentInset.right + 20 {
                isLoading = true
            }
        }
    }
    
    private func handleContentSizeChange() {
        if self.loadMoreDirection == .Vertical {
            frame = CGRect(x: 0, y: scrollView.contentSize.height, width: frame.size.width, height: frame.size.height)
        } else {
            frame = CGRect(x: scrollView.contentSize.width, y: 0, width: frame.size.width, height: frame.size.height)
        }
    }
}

