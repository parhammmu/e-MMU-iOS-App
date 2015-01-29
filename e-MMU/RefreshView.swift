//
//  RefreshView.swift
//  e-MMU
//
//  Created by Parham on 22/01/2015.
//  Copyright (c) 2015 Parham Majdabadi. All rights reserved.
//

import UIKit

protocol RefreshViewDelegate: class {
    func refreshViewDidRefresh(refreshView: RefreshView)
}

private let sceneHeight: CGFloat = 120

class RefreshView: UIView {
    
    private unowned var scrollView: UIScrollView
    var progressPercentage: CGFloat = 0
    weak var delegate: RefreshViewDelegate?
    var isRefreshing = false
    var refreshItems = [RefreshItem]()
    
    required init(coder aDecoder: NSCoder) {
        self.scrollView = UIScrollView()
        assert(false, "use init(frame:scrollView:)")
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, scrollView: UIScrollView) {
        self.scrollView = scrollView
        super.init(frame: frame)
        clipsToBounds = true
        
        updateBackgroundColor()
        setupRefreshItems()
    }
    
    func setupRefreshItems() {
        let buildingsImageView = UIImageView(image: UIImage(named: "buildings"))
        let sunImageView = UIImageView(image: UIImage(named: "sun"))
        
        refreshItems = [
            RefreshItem(view: buildingsImageView,
                centerEnd: CGPoint(x: CGRectGetMidX(bounds),
                    y: CGRectGetHeight(bounds) - CGRectGetHeight(sunImageView.bounds) - CGRectGetHeight(buildingsImageView.bounds) / 2),
                parallaxRatio: 1.5, sceneHeight: sceneHeight),
            RefreshItem(view: sunImageView,
                centerEnd: CGPoint(x: CGRectGetWidth(bounds) * 0.1,
                    y: CGRectGetHeight(bounds) - CGRectGetHeight(buildingsImageView.bounds) - CGRectGetHeight(sunImageView.bounds)),
                parallaxRatio: 3, sceneHeight: sceneHeight)
        ]
        
        for refreshItem in refreshItems {
            addSubview(refreshItem.view)
        }
    }


    func updateBackgroundColor() {
        let value = self.progressPercentage * 0.7 + 0.2
        backgroundColor = UIColor(red: value, green: value, blue: value, alpha: 1.0)
    }
    
    func updateRefreshItemPositions() {
        for refreshItem in refreshItems {
            refreshItem.updateViewPositionForPercentage(progressPercentage)
        }
    }
    func beginRefreshing() {
        isRefreshing = true
        
        UIView.animateWithDuration(0.4, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            self.scrollView.contentInset.top += sceneHeight
            }, completion: { (_) -> Void in
        })
    }
    
    func endRefreshing() {
        UIView.animateWithDuration(0.4, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            self.scrollView.contentInset.top -= sceneHeight
            }, completion: { (_) -> Void in
                self.isRefreshing = false
        })
    }
    

}

extension RefreshView: UIScrollViewDelegate {
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if !isRefreshing && progressPercentage == 1 {
            beginRefreshing()
            targetContentOffset.memory.y = -scrollView.contentInset.top
            delegate?.refreshViewDidRefresh(self)
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if isRefreshing {
            return
        }
        
        let refreshViewVisibleHeight = max(0, -(scrollView.contentOffset.y + scrollView.contentInset.top))
        progressPercentage = min(1, refreshViewVisibleHeight / sceneHeight)
        
        updateBackgroundColor()
        updateRefreshItemPositions()
    }
}

