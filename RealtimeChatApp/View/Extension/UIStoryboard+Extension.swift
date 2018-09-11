//
//  UIStoryboard+Extension.swift
//  TodoProject
//
//  Created by David Nguyen Truong on 7/23/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    
    internal static var main: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
    
    internal func getViewController<T>(_ type: T.Type) -> T? {
        let identifier = String(describing: type)
        let viewController = instantiateViewController(withIdentifier: identifier) as? T
        return viewController
    }
}
