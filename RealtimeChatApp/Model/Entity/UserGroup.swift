//
//  UserGroup.swift
//  RealtimeChatApp
//
//  Created by David Nguyen Truong on 8/24/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON
import Realm

class UserGroup: Entity {
    
    @objc
    internal dynamic var userId: String!
    @objc
    internal dynamic var groupId: String!
    @objc
    internal dynamic var memberName: String!
    @objc
    internal dynamic var groupName: String!
    internal var isTyping: Bool!
    
    
    override class func indexedProperties() -> [String] {
        return ["isTyping"]
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
        groupId     = json["groupId"].stringValue
        memberName  = json["memberName"].stringValue
        isTyping    = json["isTyping"].bool ?? false
        groupName   = json["groupName"].stringValue
        deletedAt   = json["deletedAt"].dateTime
        createdAt   = json["createdAt"].dateTime
        updatedAt   = json["updatedAt"].dateTime
    }
    
    override func toDictionary() -> [String : Any] {
        var dictionary = [String: Any]()
        dictionary["id"]            = id
        dictionary["userId"]        = userId
        dictionary["groupId"]       = groupId
        dictionary["memberName"]    = memberName
        dictionary["isTyping"]      = isTyping
        dictionary["groupName"]     = groupName
        dictionary["createdAt"]     = createdAt
        dictionary["updatedAt"]     = updatedAt
        dictionary["deletedAt"]     = deletedAt
        return dictionary
    }
}
