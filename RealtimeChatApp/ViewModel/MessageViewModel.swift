//
//  MessageViewModel.swift
//  RealtimeChatApp
//
//  Created by David Nguyen Truong on 8/23/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import Foundation
import RxSwift

class MessageViewModel: BaseViewModel {
    
    private let messagingService: MessagingService!
    private let socketService: SocketService
    private let groupRepository: GroupRepository!
    internal var processing = Variable<Bool>(false)
    internal var groups = Variable<[Group]>([])
    internal var error = Variable<Error?>(nil)
    
    init(navigator: Navigator, messagingService: MessagingService, groupRepository: GroupRepository, socketService: SocketService) {
        self.messagingService = messagingService
        self.groupRepository = groupRepository
        self.socketService = socketService
        
        super.init(navigator: navigator)
    }
    
    override func onDidLoad() {
        super.onDidLoad()
        
        disposeBag = DisposeBag()
        registerGroupUpdate()
    }
    
    override func onWillAppear() {
        super.onWillAppear()
        
        if disposeBag == nil {
            disposeBag = DisposeBag()
        }
        fetchGroup()
        getGroups()
    }
    
    override func onDestroy() {
        super.onDestroy()
        
        unregisterGroupUpdate()
    }
    
    // MARK: Private methods
    
    private func reOrderGroups(_ groups: [Group])-> [Group] {
        let newGroups = groups.sorted(by: {$0.updatedAt?.compare($1.updatedAt ?? Date()) == .orderedDescending})
        return newGroups
    }
    
    private func registerGroupUpdate() {
        socketService
            .registerGroupUpdate()
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] group in
                    guard let sSelf = self else {
                        return
                    }
                    if let index = sSelf.groups.value.index(where: { $0.id == group.id }) {
                        sSelf.groups.value[index] = group
                        sSelf.groups.value = sSelf.reOrderGroups(sSelf.groups.value)
                    }
                },onError: { [weak self] err in
                    guard let sSelf = self else {
                        return
                    }
                    sSelf.error.value = err
                }
            ).disposed(by: disposeBag)
    }
    
    private func unregisterGroupUpdate() {
        socketService.unregisterGroupUpdate()
    }
    
    // MARK" Internal methods
    
    internal func fetchGroup() {
        print(groupRepository.realm.configuration.fileURL)
        if let groups = groupRepository.getAll() {
            self.groups.value = groups
        }
    }
    
    internal func getGroups() {
        processing.value = true
        messagingService
            .getGroups()
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] groups in
                    guard let sSelf = self else {
                        return
                    }
                    sSelf.groupRepository.add(groups, update: true)
                    sSelf.groups.value = sSelf.reOrderGroups(groups)
                    sSelf.processing.value = false
                },
                onError: { [weak self] error in
                    guard let sSelf = self else {
                        return
                    }
                    sSelf.processing.value = false
                    sSelf.error.value = error
            }
        ).disposed(by: disposeBag)
    }
}
