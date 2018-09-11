//
//  ApiResponse.swift
//  RealtimeChatApp
//
//  Created by David Nguyen Truong on 8/23/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import UIKit

public class ApiResponse<T>: NSObject {
    
    // MARK: Property
    
    public var error: Error?
    public var data: T?
}
