//
//  Date+Extension.swift
//  TodoProject
//
//  Created by David Nguyen Truong on 7/13/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import Foundation

extension Date {
    func dateToString(format: String) -> String{
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = format //"dd_MM_yyyy_HH_mm" / EEE dd MM yyyy HH:mm
        dateFormatter.timeZone = NSTimeZone.local as TimeZone
        let dateString = dateFormatter.string(from: self as Date)
        
        return dateString
        
    }
}

extension DateFormatter {
    
    public static let yyyy_MM_dd = "yyyy-MM-dd"
    public static let yyyy_MM_dd_T_HH_mm_ss_SSS = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    public static let MMM_dd_yyyy_HH_mm_aa = "MMM dd, yyyy hh:mm aa"
    public static let MMM_dd_yyyy = "MMM dd, yyyy"
    public static let hh_mm_aa = "hh:mm aa"
    
}
