//
//  MessageRepository.swift
//  RealtimeChatApp
//
//  Created by David Nguyen Truong on 8/28/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import Foundation

class MessageRepository: Repository<Message> {
    
    internal func getAllMessages(groupId: String) -> [Message] {
        let results = realm.objects(Message.self)
            .filter("groupId = '\(groupId)'")
        var data = [Message]()
        for item in results {
            data.append(item)
        }
        return data
    }
}
