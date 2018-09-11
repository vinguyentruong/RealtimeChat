//
//  AppDelegate.swift
//  RealtimeChatApp
//
//  Created by David Nguyen Truong on 8/2/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        window = UIWindow()
        if let loginView = UIStoryboard.main.getViewController(LoginViewController.self) {
            window?.rootViewController = loginView
        }
        if let user = User.default, user.logined {
            UIView.transition(with: window!, duration: 0.33, options: .transitionCrossDissolve, animations: { [weak self] in
                guard let sSelf = self else {
                    return
                }
                guard let mainView = UIStoryboard.main.getViewController(MainViewController.self) else {
                    return
                }
                let navigation = UINavigationController(rootViewController: mainView)
                sSelf.window?.rootViewController = navigation
                sSelf.window?.windowLevel = UIWindowLevelNormal
            })
        }
        SyncMessageManager.default.clean()
        return true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        SyncMessageManager.default.autoSync()
    }
}

