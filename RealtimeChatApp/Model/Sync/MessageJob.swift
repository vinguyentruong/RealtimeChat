//
//  MessageJob.swift
//  RealtimeChatApp
//
//  Created by David Nguyen Truong on 8/30/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import Foundation
import RxSwift
import EventBusSwift

class MessageJob: Job {
    
    // MARK: Property
    
    internal var message             : Message
    private var messageRepository   : MessageRepository
    private var appService          : AppService
    private var syncAction          : SyncAction
    private var disposeBag          : DisposeBag
    private var socketService       : SocketService
    
    // MARK: Construction
    
    init(priority           : JobPriority,
         message            : Message,
         messageRepository  : MessageRepository,
         appService         : AppService,
         syncAction         : SyncAction,
         socketService      : SocketService) {
        
        self.message            = message
        self.messageRepository  = messageRepository
        self.appService         = appService
        self.syncAction         = syncAction
        self.socketService      = socketService
        disposeBag = DisposeBag()
        
        super.init(priority: priority)
    }
    
    // MARK: Overide methods
    
    override func onRun() throws {
        switch syncAction {
        case .create:
            create()
        case .update:
            update()
        case .delete:
            delete()
        }
    }
    
    private func create() {
        messageRepository.add(message, update: true)
        socketService
            .sendMessage(id: message.id, userId: message.userId, groupId: message.groupId, data: message.data! )
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] message in
                    guard let sSelf = self else {
                        return
                    }
                    EventBus.shared.post(name: .createMessage, object: message)
                    sSelf.stop()
                },
                onError: { [weak self] error in
                    guard let sSelf = self else {
                        return
                    }
                    sSelf.saveSyncCache()
                    sSelf.onError(error)
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func update() {
        
    }
    
    private func delete() {
        
    }
    
    private func saveSyncCache() {
        let syncRepository = MessageSyncCacheRepository()
        let syncCache = MessageSyncCache()
        syncCache.createdAt = Date()
        syncCache.id = UUID().uuidString
        syncCache.rawAction = syncAction.rawValue
        syncCache.messageID = message.id
        syncRepository.add(syncCache, update: false)
    }
}

