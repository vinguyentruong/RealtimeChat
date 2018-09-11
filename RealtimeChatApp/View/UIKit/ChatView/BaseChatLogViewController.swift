//
//  BaseChatLogViewController.swift
//  RealtimeChatApp
//
//  Created by David Nguyen Truong on 8/21/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import UIKit

class BaseChatLogViewController: UICollectionViewController {
    
    internal var currentMessageIndex: IndexPath?
    private var inputFrame: CGRect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: .UIKeyboardWillHide, object: nil)
    }
}

// MARK: Scrolling

extension BaseChatLogViewController {
    
    @objc
    private func handleKeyboardNotification(notification: Notification) {
        if
            let userInfor = notification.userInfo,
            let keyboardFrame = userInfor[UIKeyboardFrameEndUserInfoKey] as? CGRect {
            inputFrame = keyboardFrame
        }
    }
    
    @objc
    internal func scrollToCurrentMessage() {
        if let index = currentMessageIndex {
            collectionView?.scrollToItem(at: index, at: .bottom, animated: true)
        }
    }
    
    internal func getLastVisibleIndexPath() -> IndexPath? {
        let indexPaths: [IndexPath] = collectionView!.visibleCells.map { (cell) -> IndexPath? in
            return self.collectionView!.indexPath(for: cell)
            }.compactMap{$0}.sorted()
        return indexPaths.last
    }
    
    internal func scrollToBottom(animated: Bool) {
//        self.collectionView?.setContentOffset(self.collectionView?.contentOffset ?? CGPoint.zero, animated: false)
//
//        let offsetY = max(-(self.collectionView?.contentInset.top)!, (self.collectionView?.collectionViewLayout.collectionViewContentSize.height)! - (self.collectionView?.bounds.height)! + (self.collectionView?.contentInset.bottom)!)
//
//        if animated {
//            UIView.animate(withDuration: 0.33, animations: { () -> Void in
//                self.collectionView?.contentOffset = CGPoint(x: 0, y: offsetY)
//            })
//        } else {
//            self.collectionView?.contentOffset = CGPoint(x: 0, y: offsetY)
//        }
        let lastItem = (collectionView?.numberOfItems(inSection: 0))! - 1
        if currentMessageIndex?.item != lastItem, lastItem > 0 {
            let index = IndexPath(row: lastItem, section: 0)
            self.collectionView?.scrollToItem(at: index, at: .bottom, animated: animated)
            currentMessageIndex = index
        }
    }
    
    func adjustCollectionViewInsets(shouldUpdateContentOffset: Bool) {
        
        let inputHeightWithKeyboard = self.view.bounds.height - self.inputFrame.minY
        let newInsetBottom = self.collectionView!.contentInset.bottom + inputHeightWithKeyboard
        let insetBottomDiff = newInsetBottom - self.collectionView!.contentInset.bottom
        var newInsetTop = self.topLayoutGuide.length + self.collectionView!.contentInset.top
        let contentSize = self.collectionView!.collectionViewLayout.collectionViewContentSize
        
        let prevContentOffsetY = self.collectionView!.contentOffset.y
        
        let newContentOffsetY: CGFloat = {
            let minOffset = -newInsetTop
            let maxOffset = contentSize.height - (self.collectionView!.bounds.height - newInsetBottom)
            let targetOffset = prevContentOffsetY + insetBottomDiff
            return max(min(maxOffset, targetOffset), minOffset)
        }()
        
        guard shouldUpdateContentOffset else { return }
        
        self.collectionView!.contentOffset.y = newContentOffsetY
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentMessageIndex = getLastVisibleIndexPath()
    }
}
