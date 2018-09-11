//
//  Boolean+Extension.swift
//  TodoProject
//
//  Created by David Nguyen Truong on 7/16/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import Foundation

extension Bool {
    
    internal mutating func toggle() {
        self = !self
    }
}
