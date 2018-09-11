//
//  UIFont+Extension.swift
//  RealtimeChatApp
//
//  Created by David Nguyen Truong on 8/15/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    
    func sizeOfString(string: String, constrainedToWidth width: Double) -> CGSize {
        let attributes = [NSAttributedStringKey.font: self,]
        let attString = NSAttributedString(string: string,attributes: attributes)
        let framesetter = CTFramesetterCreateWithAttributedString(attString)
        return CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRange(location: 0,length: 0), nil, CGSize(width: width, height: DBL_MAX), nil)
    }
}
