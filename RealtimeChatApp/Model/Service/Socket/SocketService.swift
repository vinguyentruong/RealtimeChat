//
//  SocketService.swift
//  RealtimeChatApp
//
//  Created by David Nguyen Truong on 8/23/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import Foundation
import RxSwift

protocol SocketService: class {
    
    func connect(_ completion: (()->Void)?)
    func disConnect()
    func sendTyping(userId: String, groupId: String, isTyping: Bool)
    func registerTyping() -> Observable<UserGroup>
    func unregisterTyping()
    func registerMessageRecive() -> Observable<Message>
    func unRegisterMessageRecive()
    func registerGroupUpdate() -> Observable<Group>
    func unregisterGroupUpdate()
    func sendMessage(id: String, userId: String, groupId: String, data: String) -> Observable<Message>
}
