//
//  Date+Model.swift
//  KeepSafe
//
//  Created by Tran Van Tuat on 7/4/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import UIKit

extension Date {
    
    public var localDate: Date {
        return DateHelper.shared.date(from: self.localDateString, format: .yyyy_MM_dd)!
    }
    
    public var localDateString: String {
        return DateHelper.shared.string(from: self, format: .yyyy_MM_dd)
    }
    
    public var utcDateTime: Date {
        return DateHelper.shared.date(from: self.utcDateTimeString, format: .yyyy_MM_dd_T_HH_mm_ss_SSS, timeZone: "UTC")!
    }
    
    public var utcDateTimeString: String {
        return DateHelper.shared.string(from: self, format: .yyyy_MM_dd_T_HH_mm_ss_SSS, timeZone: "UTC")
    }
    
    public var prettyTimeString: String {
        let seconds = Date().timeIntervalSince1970 - timeIntervalSince1970
        let hours = seconds / 3600
        if hours < 24 {
            return DateHelper.shared.string(from: self, format: .hh_mm_aa)
        }
        let days = Int(hours / 24)
        if days <= 1 {
            return "\(days) day ago"
        }
        return DateHelper.shared.string(from: self, format: .MMM_dd_yyyy)
    }
    
    public var longTimeString: String {
        return DateHelper.shared.string(from: self, format: .MMM_dd_yyyy_HH_mm_aa)
    }
    
    public var shortTimeString: String {
        return DateHelper.shared.string(from: self, format: .hh_mm_aa)
    }
    
    public func diffTimeInterval(betweenDate date: Date) -> Double {
        return timeIntervalSince1970 - date.timeIntervalSince1970
    }
    
    public func add(year: Int, month: Int, day: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        return Calendar.current.date(byAdding: dateComponents, to: self)!
    }
    
    public func add(hour: Int, minute: Int, second: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.second = second
        return Calendar.current.date(byAdding: dateComponents, to: self)!
    }
    
    public var startOfMonthDate: Date {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: self)
        return calendar.date(from: calendar.dateComponents([.year, .month], from: startOfToday))!
    }
    
    public var endOfMonthDate: Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonthDate)!
    }
    
    public static var lastDateOfYear: Date {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        
        var dateComponents = DateComponents()
        dateComponents.year = currentYear
        dateComponents.month = 12
        
        let startOfMonthDate = calendar.date(from: dateComponents)!
        return calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonthDate)!
    }
    
    public func toYearMonthDay() -> (Int, Int, Int) {
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        return (year, month, day)
    }
    
    public var year: Int {
        let date = Date()
        let calendar = Calendar.current
        return calendar.component(.year, from: date)
    }
}
