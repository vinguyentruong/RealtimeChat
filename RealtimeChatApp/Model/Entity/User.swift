//
//  User.swift
//  RealtimeChatApp
//
//  Created by David Nguyen Truong on 8/22/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import Foundation
import SwiftyJSON

class User: NSObject {
    
    internal var id: String!
    internal var username: String!
    internal var password: String!
    internal var email: String!
    internal var displayName: String!
    internal var createdAt: Date?
    internal var updatedAt: Date?
    internal var deletedAt: Date?
    internal var logined = false
    
    private static var _default: User?
    
    internal static var `default`: User? {
        get {
            if _default == nil {
                if let data = UserDefaults.standard.dictionary(forKey: "user") {
                    _default = User(json: JSON(data))
                }
            }
            return _default
        }
        set {
            if let value = newValue {
                UserDefaults.standard.set(value.toDictionary(), forKey: "user")
            } else {
                UserDefaults.standard.removeObject(forKey: "user")
            }
            _default = newValue
        }
    }
    
    // MARK: Construction
    
    internal init(json: JSON) {
        id          = json["id"].stringValue
        displayName = json["displayName"].stringValue
        username    = json["username"].stringValue
        createdAt   = json["createdAt"].dateTime
        updatedAt   = json["updatedAt"].dateTime
        deletedAt   = json["deletedAt"].dateTime
        logined     = json["logined"].bool ?? false
    }
    
    // MARK: Internal methods
    
    func toDictionary() -> [String: Any] {
        var dictionary = [String: Any]()
        dictionary["id"]          = id
        dictionary["displayName"] = displayName
        dictionary["username"]    = username
        dictionary["createdAt"]   = createdAt
        dictionary["updatedAt"]   = updatedAt
        dictionary["deletedAt"]   = deletedAt
        dictionary["logined"]     = logined
        return dictionary
    }
}
