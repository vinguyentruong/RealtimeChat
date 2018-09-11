//
//  UIViewController+Extension.swift
//  TodoProject
//
//  Created by David Nguyen Truong on 7/23/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import UIKit

extension UIViewController {
    
    internal static var className: String {
        return String(describing: self)
    }
}

