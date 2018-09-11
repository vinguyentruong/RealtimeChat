//
//  MessagingService.swift
//  RealtimeChatApp
//
//  Created by David Nguyen Truong on 8/23/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import Foundation
import RxSwift

protocol MessagingService: class {
    
//    func getUser(username: String) -> Observable<User>
    
    func getGroups() -> Observable<[Group]>
    
//    func createGroup(userId: String, type: TypeChatGroup) -> Observable<Group>
//
    func getGroupMembers(groupId: String) -> Observable<[UserGroup]>
    func fetchMessages(groupId: String, page: Int, limit: Int) -> Observable<[Message]>
//
//    func clearMessages(groupId: String) -> Observable<Bool>
//    
//    func sendMessage(groupId         : String,
//                     receiverId      : String?,
//                     type            : Int,
//                     groupType       : GroupType,
//                     body            : String,
//                     id              : String,
//                     securityStatus  : Int,
//                     context         : Parameters,
//                     status          : String?,
//                     isIgnored       : Bool) -> Observable<String>
    
}


