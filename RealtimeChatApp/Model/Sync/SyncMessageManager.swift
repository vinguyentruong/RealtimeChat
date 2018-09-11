//
//  SyncManager.swift
//  TodoProject
//
//  Created by David Nguyen Truong on 7/31/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import Foundation
import EventBusSwift
import SwinjectStoryboard
import Swinject
import Reachability

public enum SyncAction: String {
    case create
    case update
    case delete
}

class SyncMessageManager {
    
    // MARK: Property
    
    private var messageRepository  : MessageRepository
    private var appService      : AppService
    private var jobManager      : JobManager
    private var reachability    : Reachability!
    private var socketService    : SocketService
    internal var isSync         = false {
        didSet {
            if isSync {
                do {
                    try reachability?.startNotifier()
                } catch {
                    print("Unable to start notifier")
                }
            } else {
                reachability.stopNotifier()
            }
        }
    }
    
    internal static let `default` = SyncMessageManager()
    
    //MARK: Construction
    
    private convenience init() {
        let syncManager = SwinjectStoryboard.defaultContainer.resolve(SyncMessageManager.self)!
        self.init(messageRepository: syncManager.messageRepository,
                  appService: syncManager.appService,
                  socketService: syncManager.socketService,
                  jobManager: syncManager.jobManager)
    }
    
    init(messageRepository: MessageRepository, appService: AppService, socketService: SocketService, jobManager: JobManager) {
        self.messageRepository = messageRepository
        self.appService     = appService
        self.jobManager     = jobManager
        self.socketService   = socketService
        
        reachability = Reachability()
        
        reachability?.whenReachable = { reachability in
            if reachability.connection != .none {
                socketService.connect(nil)
                DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
                    self.autoSync()
                })
            }
        }
        reachability?.whenUnreachable = { reachability in
            print("Unconnected")
        }
        do {
            try reachability?.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    deinit {
        reachability.stopNotifier()
    }
    
    // MARK: Internal methods
    
    internal func getJobs() -> [Job] {
        var jobs = [Job]()
        jobs = jobManager.jobs.map{$0}
        return jobs
    }
    
    internal func syncMessage(_ action: SyncAction, message: Message) {
        let job = MessageJob(priority: .medium,
                                  message: message,
                                  messageRepository: messageRepository,
                                  appService: appService,
                                  syncAction: action,
                                  socketService: socketService)
        jobManager.addJob(job)
        jobManager.execute()
    }
    
    internal func autoSync() {
        let syncRepository = MessageSyncCacheRepository()
        guard let syncCaches = syncRepository.getAll() else {
            return
        }
        for sync in syncCaches {
            if let message = sync.message {
                print(message.data)
                let job = MessageJob(priority: .medium,
                                     message: message,
                                     messageRepository: messageRepository,
                                     appService: appService,
                                     syncAction: sync.action,
                                     socketService: socketService)
                jobManager.addJob(job)
//                self.syncMessage(sync.action, message: message)
            }
        }
        syncRepository.delete(syncCaches)
        self.jobManager.execute()
//        socketService.connect {
//            self.jobManager.execute()
//        }
    }
    
    internal func clean() {
        guard let messages = messageRepository.getAll() else {
            return
        }
        messageRepository.delete( messages.filter{$0.deletedAt != nil} )
    }
    
}
