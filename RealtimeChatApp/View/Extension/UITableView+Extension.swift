//
//  UITableView+Extension.swift
//  TodoProject
//
//  Created by David Nguyen Truong on 7/25/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import UIKit
//import SpringIndicator

extension UITableView {
    
//    internal func startFooterLoading() {
//        for subView in tableFooterView?.subviews ?? [] {
//            if subView is SpringIndicator {
//                return
//            }
//        }
//        let view = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 25, height: 25)))
//        let indicator = SpringIndicator(frame: CGRect(origin: .zero, size: CGSize(width: 25, height: 25)))
//        indicator.lineColor = .black
//        view.layout(indicator)
//            .centerVertically()
//            .centerHorizontally()
//            .width(25)
//            .height(25)
//        tableFooterView = view
//        indicator.start()
//    }
//    
//    internal func stopFooterLoading() {
//
//        for subView in tableFooterView?.subviews ?? [] {
//            if let indicator = subView as? SpringIndicator {
//                indicator.removeFromSuperview()
//            }
//        }
//    }
    
    public func tableHeaderViewSizeToFit() {
        guard let headerView = tableHeaderView else {
            return
        }
        let size = headerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        if headerView.frame.size.height != size.height {
            headerView.frame.size.height = size.height
            tableHeaderView = headerView
            layoutIfNeeded()
        }
    }
}
