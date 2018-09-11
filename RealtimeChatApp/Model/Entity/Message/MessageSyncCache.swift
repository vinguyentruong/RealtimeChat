//
//  MessageSyncCache.swift
//  RealtimeChatApp
//
//  Created by David Nguyen Truong on 8/30/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
import SwinjectStoryboard

class MessageSyncCache: Entity {
    
    @objc
    internal dynamic var rawAction = SyncAction.update.rawValue
    
    @objc
    internal dynamic var messageID: String = ""
    
    internal var action: SyncAction {
        switch rawAction {
        case SyncAction.create.rawValue:
            return SyncAction.create
        case SyncAction.update.rawValue:
            return SyncAction.update
        case SyncAction.delete.rawValue:
            return SyncAction.delete
        default:
            return SyncAction.update
        }
    }
    
    internal var message: Message? {
        let message = messageRepository.get(withId: messageID)
        return message
    }
    
    private var messageRepository: MessageRepository!
    
    // MARK: Construction
    
    required init() {
        super.init()
        
        messageRepository = SwinjectStoryboard.defaultContainer.resolve(MessageRepository.self)
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
        
        messageRepository = SwinjectStoryboard.defaultContainer.resolve(MessageRepository.self)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
        
        messageRepository = SwinjectStoryboard.defaultContainer.resolve(MessageRepository.self)
    }
}
