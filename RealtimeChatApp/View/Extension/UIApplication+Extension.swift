//
//  UIApplication+Extension.swift
//  TodoProject
//
//  Created by David Nguyen Truong on 7/10/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import UIKit

extension UIApplication {
    
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
    
    class func topViewController(base: UIViewController? = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
    
    class func rootViewController() -> UIViewController? {
        return (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController
    }
}

