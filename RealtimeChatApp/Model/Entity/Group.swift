//
//  Group.swift
//  RealtimeChatApp
//
//  Created by David Nguyen Truong on 8/23/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON
import Realm

enum TypeChatGroup: String {
    case `private`
    case group
    case chatbot
}

class Group: Entity {
    
    @objc
    internal dynamic var userId: String = ""
    @objc
    internal dynamic var rawType: String = TypeChatGroup.group.rawValue
    @objc
    internal dynamic var name: String = ""
    @objc
    internal dynamic var lastMessage: String!
    
    internal var userGroup: UserGroup?
    
    internal var type: TypeChatGroup! {
        get {
            return TypeChatGroup(rawValue: rawType)
        }
        set {
            self.rawType = newValue.rawValue
        }
    }
    
    override class func indexedProperties() -> [String] {
        return ["type"]
    }
    
    // MARK: Construction
    
    required init() {
        super.init()
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
        name        = json["name"].stringValue
        rawType     = json["type"].stringValue
        lastMessage = json["lastMessage"].stringValue
        userGroup   = UserGroup(json: json["userGroup"])
        deletedAt   = json["deletedAt"].dateTime
        createdAt   = json["createdAt"].dateTime
        updatedAt   = json["updatedAt"].dateTime
    }
    
    override func toDictionary() -> [String : Any] {
        var dictionary = [String: Any]()
        dictionary["id"]            = id
        dictionary["userId"]        = userId
        dictionary["name"]          = name
        dictionary["type"]          = rawType
        dictionary["lastMessage"]   = lastMessage
        dictionary["createdAt"]     = createdAt
        dictionary["updatedAt"]     = updatedAt
        dictionary["deletedAt"]     = deletedAt
        return dictionary
    }
}
