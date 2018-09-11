//
//  MessagingServiceImplement.swift
//  RealtimeChatApp
//
//  Created by David Nguyen Truong on 8/23/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import Foundation
import RxSwift

class MessagingServiceImplement: RestService {

}

extension MessagingServiceImplement: MessagingService {
    
    func getGroups() -> Observable<[Group]> {
        return Observable.create({ (e) -> Disposable in
            self.apiHelper
                .get(
                    url: Configuration.BaseUrl + "/api/groups",
                    parameters: nil,
                    headerHander: { self.defaultHeaders }) { (json, error) in
                        if let err = error {
                            e.on(.error(err))
                            return
                        }
                        guard let json = json?["data"].array else {
                            return
                        }
                        var groups: [Group] = []
                        for groupData in json {
                            groups.append(Group(json: groupData))
                        }
                        e.on(.next(groups))
                        e.on(.completed)
            }
            return Disposables.create()
        })
    }
    
    func getGroupMembers(groupId: String) -> Observable<[UserGroup]> {
        return Observable.create({ (e) -> Disposable in
            self.apiHelper
                .get(
                    url: Configuration.BaseUrl + "/api/userGroups/\(groupId)",
                    parameters: nil,
                    headerHander: { self.defaultHeaders }) { (json, error) in
                        if let err = error {
                            e.on(.error(err))
                            return
                        }
                        guard let json = json?["data"].array else {
                            return
                        }
                        var userGroups: [UserGroup] = []
                        for jsonData in json {
                            userGroups.append(UserGroup(json: jsonData))
                        }
                        e.on(.next(userGroups))
                        e.on(.completed)
            }
            return Disposables.create()
        })
    }
    
    func fetchMessages(groupId: String, page: Int = 0, limit: Int = 100) -> Observable<[Message]> {
        let parameters = ["page": page, "limit": limit]
        return Observable.create({ (e) -> Disposable in
            self.apiHelper
                .get(
                    url: Configuration.BaseUrl + "/api/messages/\(groupId)",
                    parameters: parameters,
                    headerHander: {self.defaultHeaders},
                    responseHandler: { (json, error) in
                        if let err = error {
                            e.on(.error(err))
                            return
                        }
                        guard let json = json?["data"].array else {
                            return
                        }
                        
                        var messages: [Message] = []
                        for jsonData in json {
                            messages.append(Message(json: jsonData))
                        }
                        e.on(.next(messages))
                        e.on(.completed)
                })
            return Disposables.create()
        })
    }
    
}
