//
//  DateHelper.swift
//  KeepSafe
//
//  Created by Tran Van Tuat on 7/2/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import Foundation

public struct DateFormat {
    
    public var name: String
    
    public init(_ name: String) {
        self.name = name
    }
    
}

extension DateFormat {
    
    public static let yyyy_MM_dd = DateFormat("yyyy-MM-dd")
    public static let yyyy_MM_dd_T_HH_mm_ss_SSS = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
    public static let MMM_dd_yyyy_HH_mm_aa = DateFormat("MMM dd, yyyy hh:mm aa")
    public static let MMM_dd_yyyy = DateFormat("MMM dd, yyyy")
    public static let hh_mm_aa = DateFormat("hh:mm aa")
    
}

public class DateHelper {
    
    // MARK: Property
    
    public static let shared = DateHelper()
    
    private var formatters = [String: DateFormatter]()
    
    // MARK: Constructor
    
    private init() {
        
    }
    
    // MARK: Public method
    
    public func date(from dateString: String, format: DateFormat, timeZone: String = "LOCAL", locale: Locale = .current) -> Date? {
        return formatter(format: format, timeZone: timeZone, locale: locale).date(from: dateString)
    }
    
    public func string(from date: Date, format: DateFormat, timeZone: String = "LOCAL", locale: Locale = .current) -> String {
        return formatter(format: format, timeZone: timeZone, locale: locale).string(from: date)
    }
    
    // MARK: Private method
    
    private func formatter(format: DateFormat, timeZone: String = "LOCAL", locale: Locale = .current) -> DateFormatter {
        var formatter = formatters[format.name]
        if formatter == nil {
            formatter = DateFormatter()
            formatter!.dateFormat = format.name
            formatters[format.name] = formatter
            formatter?.locale = locale
        }
        if timeZone == "LOCAL" {
            formatter!.timeZone = TimeZone.current
        } else {
            formatter!.timeZone = TimeZone(abbreviation: timeZone)
        }
        return formatter!
    }
}

extension DateHelper {
    func combineDateWithTime(date: Date, time: Date) -> Date? {
        let calendar = NSCalendar.current
        
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)
        
        var mergedComponments = DateComponents()
        mergedComponments.year = dateComponents.year!
        mergedComponments.month = dateComponents.month!
        mergedComponments.day = dateComponents.day!
        mergedComponments.hour = timeComponents.hour!
        mergedComponments.minute = timeComponents.minute!
        mergedComponments.second = timeComponents.second!
        
        return calendar.date(from: mergedComponments)
    }
}

extension Formatter {
    
    static let year: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }()
    
    static let monthString: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLL"
        return formatter
    }()
    
    static let monthInt: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "LL"
        return formatter
    }()
}

extension Date {
    
    var monthString: String  { return Formatter.monthString.string(from: self) }
    var monthInt: Int { return Int(Formatter.monthInt.string (from:self))! }
    var yearInt: Int { return Int(Formatter.year.string(from: self))!}
    
    static func from(year: Int, month: Int, day: Int) -> Date {
        let gregorianCalendar = NSCalendar(calendarIdentifier: .gregorian)!
        
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        
        let date:Date = gregorianCalendar.date(from: dateComponents)!
        return date
    }
    
    static func parse(_ string: String, format: String = DateFormat.MMM_dd_yyyy.name) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.default
        dateFormatter.dateFormat = format
        
        let date = dateFormatter.date(from: string)!
        return date
    }
}
