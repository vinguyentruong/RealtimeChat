//
//  MessageBody.swift
//  RealtimeChatApp
//
//  Created by David Nguyen Truong on 8/24/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import Foundation

class MessageBody: Entity {
    
    internal var userId: String!
    internal var groupId: String!
    internal var data: String!
    internal var isTyping: Bool!
}
