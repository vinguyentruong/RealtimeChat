//
//  Entity.swift
//  RealtimeChatApp
//
//  Created by David Nguyen Truong on 8/22/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class Entity: Object {
    
    // MARK: Property
    
    @objc
    internal dynamic var id: String = ""
    @objc
    internal dynamic var createdAt: Date?
    @objc
    internal dynamic var updatedAt: Date?
    @objc
    internal dynamic var deletedAt: Date?
    
    // MARK: Override method
    
    internal override class func primaryKey() -> String? {
        return "id"
    }
    
    // MARK: Internal method
    
    internal func from(json: JSON) {
        id = json["id"].stringValue
        createdAt = json["createdAt"].dateTime
        updatedAt = json["updatedAt"].dateTime
        deletedAt = json["deletedAt"].dateTime
    }
    
    internal func toJSON() -> [String: Any] {
        return [:]
    }
    
    func encryptProperties() -> [String] {
        return []
    }
    
    func toDictionary() -> [String: Any] {
        return [:]
    }
}


