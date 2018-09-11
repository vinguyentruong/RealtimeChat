//
//  Message.swift
//  RealtimeChatApp
//
//  Created by David Nguyen Truong on 8/22/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON
import Realm

enum DataType: String {
    case text, image, audio
}

class Message: Entity {
    
    @objc
    internal dynamic var userId: String = ""
    @objc
    internal dynamic var groupId: String = ""
    @objc
    internal dynamic var data: String?
    internal var dataType: DataType! {
        get {
            return DataType(rawValue: rawType)
        }
        set {
            rawType = newValue.rawValue
        }
    }
    
    @objc
    internal dynamic var rawType: String = DataType.text.rawValue
    
    internal var isFriend: Bool! {
        if let id = User.default?.id {
            return userId != id
        }
        return true
    }
    
    override class func indexedProperties() -> [String] {
        return ["isFriend","dataType"]
    }
    
    // MARK: Construction
    
    required init() {
        super.init()
        if let id = User.default?.id {
            userId = id
        }
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    init(json: JSON) {
        super.init()
        id          = json["id"].stringValue
        userId      = json["userId"].stringValue
        groupId     = json["groupId"].stringValue
        data        = json["data"].stringValue
        rawType     = json["rawType"].stringValue
        deletedAt   = json["deletedAt"].dateTime
        createdAt   = json["createdAt"].dateTime
        updatedAt   = json["updatedAt"].dateTime
    }
    
    override func toDictionary() -> [String : Any] {
        var dictionary = [String: Any]()
        dictionary["id"]        = id
        dictionary["userId"]    = userId
        dictionary["groupId"]   = groupId
        dictionary["data"]      = data
        dictionary["rawType"]   = rawType
        dictionary["createdAt"] = createdAt
        dictionary["updatedAt"] = updatedAt
        dictionary["deletedAt"] = deletedAt
        return dictionary
    }
}
