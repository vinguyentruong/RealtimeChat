//
//  UINib+Extension.swift
//  TodoProject
//
//  Created by David Nguyen Truong on 7/20/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import UIKit

extension UIView {
    
    static var className: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: className, bundle: nil)
    }
}
