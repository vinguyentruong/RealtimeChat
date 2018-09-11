//
//  UIColor+Extension.swift
//  TodoProject
//
//  Created by David Nguyen Truong on 7/16/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    static let appColor = UIColor(red: 81/255, green: 148/255, blue: 220/255, alpha: 1)
    static let violet = UIColor(rgb: 0x4865D3, alpha: 1)
    static let blueSky = UIColor(rgb: 0x337EE3, alpha: 1)
    
    convenience init(redRgb: Int, greenRgb: Int, blueRgb: Int, alpha: CGFloat) {
        assert(redRgb >= 0 && redRgb <= 255, "Invalid red component")
        assert(greenRgb >= 0 && greenRgb <= 255, "Invalid green component")
        assert(blueRgb >= 0 && blueRgb <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(redRgb) / 255.0, green: CGFloat(greenRgb) / 255.0, blue: CGFloat(blueRgb) / 255.0, alpha: alpha)
    }
    
    convenience init(rgb: Int, alpha: CGFloat = 1.0) {
        self.init(
            redRgb: (rgb >> 16) & 0xFF,
            greenRgb: (rgb >> 8) & 0xFF,
            blueRgb: rgb & 0xFF,
            alpha: alpha
        )
    }
}
