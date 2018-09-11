//
//  String+Extension.swift
//  TodoProject
//
//  Created by David Nguyen Truong on 7/20/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import UIKit

extension String {
    
    internal var nib: UINib {
        return UINib(nibName: self, bundle: Bundle.todo)
    }
    
    public func localized(tableName: String? = nil) -> String {
        return NSLocalizedString(self, tableName: tableName, bundle: Bundle.main, value: "", comment: "")
    }
    
    public var isLocalPath: Bool {
        let path = FileManager.todoDirectory.appendingPathComponent(self).path
        return FileManager.default.fileExists(atPath: path)
    }
    
    internal var urlEncoded: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    }
    
    internal var urlDecoded: String {
        return self.removingPercentEncoding ?? ""
    }
    
    internal var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    internal var isPasswordValid: Bool {
        let passRegEx = "^(?=.*[a-z])[A-Za-z\\d$@$#!%*?&]{8,}"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passRegEx)
        return passwordTest.evaluate(with: self)
    }
    
    internal var isDisplaynameValid: Bool {
        if self.count > 20 {
            return false
        }
        return true
    }
}

extension String {
    
    func subString(from: Int, offset: Int)-> String {
        let start = self.index(self.startIndex, offsetBy: from)
        let end = self.index(self.endIndex, offsetBy: -self.count + offset)
        let range = start..<end
        return String(self[range])
    }
}
