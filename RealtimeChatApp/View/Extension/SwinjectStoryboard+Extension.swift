//
//  SwinjectStoryboard+Extension.swift
//  TodoProject
//
//  Created by David Nguyen Truong on 7/20/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard

extension SwinjectStoryboard {
    
    @objc class func setup() {
        Container.loggingFunction = nil
        registerRepository()
        registerService()
        registerStoryboard()
        registerSync()
    }
    
    private static func registerSync() {
        let container = SwinjectStoryboard.defaultContainer
        
        container.register(JobManager.self) { _ in
            JobManager()
        }.inObjectScope(.container)
        
        container.register(SyncMessageManager.self, factory: {container in
            let syncManager = SyncMessageManager(messageRepository: container.resolve(MessageRepository.self)!,
                                                 appService: container.resolve(AppService.self)!,
                                                 socketService: container.resolve(SocketService.self)!,
                                                 jobManager: container.resolve(JobManager.self)!)
            return syncManager
        }).inObjectScope(.container)
    }
    
    private static func registerRepository() {
        let container = SwinjectStoryboard.defaultContainer
        container.register(GroupRepository.self) { _ in
            GroupRepository()
        }.inObjectScope(.container)
        
        container.register(MessageRepository.self) { _ in
            MessageRepository()
        }.inObjectScope(.container)
        
        container.register(UserGroupRepository.self) { _ in
            UserGroupRepository()
        }.inObjectScope(.container)
    }

    private static func registerService() {
        let container = SwinjectStoryboard.defaultContainer
        
        container.register(OAuthProtocol.self, factory: {_ in
            OAuthServiceImpl()
        }).inObjectScope(.container)

        container.register(ApiHelper.self) { _ in
            ApiHelper(
                baseUrl: Configuration.BaseUrl,
                oauthProtocol: container.resolve(OAuthProtocol.self)
            )
        }.inObjectScope(.container)
        
        container.register(AppService.self) { container in
            AppServiceImplement(apiHelper: container.resolve(ApiHelper.self)!)
        }.inObjectScope(.container)

        container.register(UploadService.self) { container in
            UploadServiceImplement(apiHelper: container.resolve(ApiHelper.self)!)
        }.inObjectScope(.container)
        
        container.register(MessagingService.self) { container in
            MessagingServiceImplement(apiHelper: container.resolve(ApiHelper.self)!)
        }.inObjectScope(.container)
        
        container.register(SocketHelper.self) { container in
            SocketHelper(baseUrl: Configuration.BaseUrl, namespace: "/messaging", oauthProtocol: container.resolve(OAuthProtocol.self))
        }.inObjectScope(.container)
        
        container.register(SocketService.self) { container in
            SocketServiceImplement(socketHelper: container.resolve(SocketHelper.self)!)
        }.inObjectScope(.container)
    }

    private static func registerStoryboard() {
        let container = SwinjectStoryboard.defaultContainer

        container.storyboardInitCompleted(LoginViewController.self) { (container, controller) in
            let viewModel = LoginViewModel(
                navigator: Navigator(viewController: controller),
                oauthService: container.resolve(OAuthProtocol.self)!,
                appService: container.resolve(AppService.self)!)
            controller.viewModel = viewModel
        }
        
        container.storyboardInitCompleted(MessageViewController.self) { (container, controller) in
            let viewModel = MessageViewModel(
                navigator: Navigator(viewController: controller),
                messagingService: container.resolve(MessagingService.self)!,
                groupRepository: container.resolve(GroupRepository.self)!,
                socketService: container.resolve(SocketService.self)!)
            controller.viewModel = viewModel
        }
        
        container.storyboardInitCompleted(ChatViewController.self) { (container, controller) in
            let viewModel = ChatViewModel(
                navigator: Navigator(viewController: controller),
                messagingService: container.resolve(MessagingService.self)!,
                socketService: container.resolve(SocketService.self)!,
                messageRepository: container.resolve(MessageRepository.self)!,
                userGroupRepository: container.resolve(UserGroupRepository.self)!)
            controller.viewModel = viewModel
        }
    }
}
