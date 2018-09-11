//
//  SwiftyJSON+Extension.swift
//  TodoProject
//
//  Created by David Nguyen Truong on 7/20/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import SwiftyJSON

extension JSON {
    
    public var isNull: Bool {
        return self.type == .null
    }
    
    public var date: Date? {
        switch self.type {
        case .string:
            return DateHelper.shared.date(from: self.object as! String, format: .yyyy_MM_dd)
        default:
            return nil
        }
    }
    
    public var dateValue: Date {
        return DateHelper.shared.date(from: self.object as! String, format: .yyyy_MM_dd)!
    }
    
    public var dateTime: Date? {
        switch self.type {
        case .string:
            return DateHelper.shared.date(from: self.object as! String, format: .yyyy_MM_dd_T_HH_mm_ss_SSS, timeZone: "UTC")
        default:
            return nil
        }
    }
    
    public var dateTimeValue: Date {
        return DateHelper.shared.date(from: self.object as! String, format: .yyyy_MM_dd_T_HH_mm_ss_SSS, timeZone: "UTC")!
    }
    
    public var decimalNumberValue: NSDecimalNumber {
        return NSDecimalNumber(string: self.stringValue)
    }
    
    public var decimalNumber: NSDecimalNumber? {
        switch self.type {
        case .string:
            return NSDecimalNumber(string: self.stringValue)
        default:
            return nil
        }
    }
}

extension Array {
    
    public func toJSONString() -> String? {
        guard
            let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted),
            let dataString = String(data: data, encoding: .utf8) else {
                return nil
        }
        return dataString
    }
    
}

extension Dictionary {
    
    public func toJSONString() -> String? {
        guard
            let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted),
            let dataString = String(data: data, encoding: .utf8) else {
                return nil
        }
        return dataString
    }
    
}

