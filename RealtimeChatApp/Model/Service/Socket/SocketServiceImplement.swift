//
//  SocketServiceImplement.swift
//  RealtimeChatApp
//
//  Created by David Nguyen Truong on 8/23/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON

class SocketServiceImplement {
    
    private let socketHelper: SocketHelper
    
    init(socketHelper: SocketHelper) {
        self.socketHelper = socketHelper
    }
}

extension SocketServiceImplement: SocketService {
    
    func connect(_ completion: (() -> Void)? = nil) {
        socketHelper.connect(timeoutAfter: 0.0) {
            print("connected")
            completion?()
        }
    }
    
    func disConnect() {
        socketHelper.disconnect()
    }
    
    func sendTyping(userId: String, groupId: String, isTyping: Bool) {
        let parameters: [String: Any] = [
            "userId": userId,
            "groupId": groupId,
            "isTyping": isTyping]
        socketHelper.put("/api/messages/typing", parameters: parameters, responseHandler: nil)
    }
    
    func registerTyping() -> Observable<UserGroup> {
        return Observable.create({ (e) -> Disposable in
            self.socketHelper.on(event: "messages/typing", responseHandler: { (json, error) in
                if let err = error {
                    e.onError(err)
                } else if let json = json?["data"] {
                    let userGroup = UserGroup(json: json)
                    e.onNext(userGroup)
                }
            })
            return Disposables.create()
        })
    }
    
    func unregisterTyping() {
        socketHelper.off(event: "messages/typing")
    }
    
    func registerMessageRecive()-> Observable<Message> {
        return Observable.create({ (e) -> Disposable in
            self.socketHelper.on(event: "messages/receive", responseHandler: { (json, error) in
                if let err = error {
                    e.onError(err)
                } else if let json = json{
                    let message = Message(json: json)
                    e.onNext(message)
                }
            })
            return Disposables.create()
        })
    }
    
    func unRegisterMessageRecive() {
        self.socketHelper.off(event: "message/receive")
    }
    
    func registerGroupUpdate() -> Observable<Group> {
        return Observable.create({ (e) -> Disposable in
            self.socketHelper.on(event: "groups/update", responseHandler: { (json, error) in
                if let err = error {
                    e.onError(err)
                } else if let json = json?["data"] {
                    print(json)
                    let group = Group(json: json)
                    e.onNext(group)
                }
            })
            return Disposables.create()
        })
    }
    
    func unregisterGroupUpdate() {
        socketHelper.off(event: "groups/update")
    }
    
    func sendMessage(id: String, userId: String, groupId: String, data: String) -> Observable<Message> {
        let parameters: [String: Any] = ["id": id,
                                         "userId": userId,
                                         "groupId": groupId,
                                         "data": data]
        return Observable.create({ (e) -> Disposable in
            self.socketHelper.post("/api/messages/create", parameters: parameters) { (json, error) in
                if let err = error {
                    print(err.localizedDescription)
                    e.onError(err)
                } else if let json = json{
                    let message = Message(json: json)
                    e.onNext(message)
                }
                e.onCompleted()
            }
            return Disposables.create()
        })
    }
    
}
