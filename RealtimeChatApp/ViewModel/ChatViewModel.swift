//
//  ChatViewModel.swift
//  RealtimeChatApp
//
//  Created by David Nguyen Truong on 8/24/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON
import EventBusSwift

class ChatViewModel: BaseViewModel {
    
    // MARK: Property
    
    private let messageRepository: MessageRepository
    private let userGroupRepository: UserGroupRepository
    private let messagingService: MessagingService
    private let socketService: SocketService
    
    internal var group: Group!
    internal var processing = Variable<Bool>(false)
    internal var members = Variable<[UserGroup]>([])
    internal var messages = Variable<[Message]>([])
    internal var error = Variable<Error?>(nil)
    internal var hasNewMessage = Variable<Bool>(false)
    internal var userTyping = Variable<UserGroup?>(nil)
    internal var inprogress = Variable<Bool>(false)
    
    private var isFulled = false
    private var page = 1
    private var limit = 100
    
    // MARK: Construction
    
    init(navigator              : Navigator,
         messagingService       : MessagingService,
         socketService          : SocketService,
         messageRepository      : MessageRepository,
         userGroupRepository    : UserGroupRepository) {
        
        self.messagingService       = messagingService
        self.socketService          = socketService
        self.messageRepository      = messageRepository
        self.userGroupRepository    = userGroupRepository
        
        super.init(navigator: navigator)
    }
    
    // MARK: Lifecycle
    
    override func onDidLoad() {
        super.onDidLoad()
        
        socketService.connect(nil)
        registerMessagesRecived()
        registerTyping()
        registerCreateMessage()
    }
    
    override func onDidReceive(data: Any?) {
        disposeBag = DisposeBag()
        if let group = data as? Group {
            self.group = group
            fetchGroupMembers(groupId: group.id)
            fetchAllMessage(groupId: group.id)
            getGroupMembers(groupId: group.id)
            getMessages(groupId: group.id)
        }
    }
    
    override func onDestroy() {
        super.onDestroy()
    
        unregisterMessageRecived()
        unregisterTyping()
        unregisterCreateMessage()
    }
    
    // MARK: Private methods
    
    private func reOrderMessages(_ messages: [Message])-> [Message] {
        let newMessages = messages.sorted(by: { $0.createdAt?.compare($1.createdAt ?? Date()) == .orderedAscending })
        return newMessages
    }
    
    private func fetchGroupMembers(groupId: String) {
        self.members.value = userGroupRepository.getUserGroups(groupId: groupId)
    }
    
    private func getGroupMembers(groupId: String) {
        processing.value = true
        messagingService
            .getGroupMembers(groupId: groupId)
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] members in
                    guard let sSelf = self else {
                        return
                    }
                    sSelf.processing.value = false
                    sSelf.members.value = members
                    sSelf.userGroupRepository.add(members, update: true)
                },
                onError: { [weak self] error in
                    guard let sSelf = self else {
                        return
                    }
                    sSelf.processing.value = false
                    sSelf.error.value = error
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func fetchAllMessage(groupId: String) {
        let messages = messageRepository.getAllMessages(groupId: groupId)
        self.messages.value = reOrderMessages(messages)
    }
    
    // MARK: Internal methods
    
    internal func getMessages(groupId: String) {
        messagingService
            .fetchMessages(groupId: groupId, page: page, limit: limit)
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] messages in
                    guard let sSelf = self else {
                        return
                    }
                    sSelf.page += 1
                    sSelf.inprogress.value = false
                    sSelf.isFulled = messages.count < sSelf.limit
                    sSelf.messages.value = sSelf.reOrderMessages(messages)
                    sSelf.messageRepository.add(messages, update: true)
                },
                onError: { [weak self] error in
                    guard let sSelf = self else {
                        return
                    }
                    sSelf.error.value = error
                }
            )
            .disposed(by: disposeBag)
    }
    
    internal func sendTyping(isTyping: Bool) {
        guard let userId = User.default?.id else {
            return
        }
        socketService.sendTyping(userId: userId, groupId: group.id, isTyping: isTyping)
    }
    
    internal func message(from data: String) -> Message {
        let message = Message()
        messageRepository.write {
            message.id = UUID().uuidString.trimmed.lowercased()
            message.groupId = self.group.id
            message.userId = (User.default?.id)!
            message.data = data
            message.createdAt = Date()
            message.updatedAt = Date()
        }
        return message
    }
    
    internal func sendMessage(message: Message) {
        var messages = self.messages.value
        messages.append(message)
        SyncMessageManager.default.syncMessage(.create, message: message)
        self.messages.value = reOrderMessages(messages)  
    }
    
    internal func loadMore() {
        if !inprogress.value, !isFulled  {
            inprogress.value = true
            getMessages(groupId: group.id)
        }
    }
}

// MARK: Register event

extension ChatViewModel {
    
    private func registerCreateMessage() {
        EventBus.shared.register(self, name: .createMessage) { [weak self] (object) in
            guard let sSelf = self else {
                return
            }
            guard let message = object as? Message else {
                return
            }
            if let index = sSelf.messages.value.index(where: { $0.id == message.id }) {
                sSelf.messages.value[index] = message
            }
        }
    }
    
    private func unregisterCreateMessage() {
        EventBus.shared.unregister(self, name: .createMessage)
    }
    
    private func registerMessagesRecived() {
        socketService
            .registerMessageRecive()
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] message in
                    guard let sSelf = self else {
                        return
                    }
                    var messages = sSelf.messages.value
                    messages.append(message)
                    sSelf.messages.value = sSelf.reOrderMessages(messages)
                    sSelf.hasNewMessage.value = true
                },
                onError: { [weak self] error in
                    guard let sSelf = self else {
                        return
                    }
                    sSelf.error.value = error
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func unregisterMessageRecived() {
        socketService.unRegisterMessageRecive()
    }
    
    private func registerTyping() {
        socketService
            .registerTyping()
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] userGroup in
                    guard let sSelf = self else {
                        return
                    }
                    sSelf.userTyping.value = userGroup
                },
                onError: { [weak self] error in
                    guard let sSelf = self else {
                        return
                    }
                    sSelf.error.value = error
                    print(error.localizedDescription)
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func unregisterTyping() {
        sendTyping(isTyping: false)
        socketService.unregisterTyping()
    }
}

// MARK: Datetime

extension ChatViewModel {
    
    internal func makeLatestUpdateString() -> String {
        guard let date = group.updatedAt else {
            return ""
        }
        let diffTime = date.diffTimeInterval(betweenDate: Date())
        if diffTime == 0.0 {
            return "Just update now"
        } else {
            let days = timeIntervalToDays(timeInterval: abs(Int(diffTime)))
            let hours = timeIntervalToHours(timeInterval: abs(Int(diffTime)))
            let minutes = timeIntervalToMinutes(timeInterval: abs(Int(diffTime)))
            if days > 0 {
                if days > 31 {
                    return date.dateToString(format: DateFormat.MMM_dd_yyyy_HH_mm_aa.name)
                } else {
                    return "Last message \(days) days ago"
                }
            } else if hours > 0 {
                return "Last message \(hours) hours ago"
            } else if minutes > 0 {
                return "Last message \(minutes) minutes ago"
            } else {
                return "Last message \(abs(Int(diffTime))) seconds ago"
            }
        }
    }
    
    private func timeIntervalToDays(timeInterval: Int) -> Int {
        return Int(timeInterval / (24 * 3600))
    }
    
    private func timeIntervalToHours(timeInterval: Int) -> Int {
        return Int(timeInterval / (3600))
    }
    
    private func timeIntervalToMinutes(timeInterval: Int) -> Int {
        return Int(timeInterval / (60))
    }
}
