//
//  Realm+ViewModel.swift
//  KeepSafe
//
//  Created by Tran Van Tuat on 7/4/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import RealmSwift
import KeychainSwift

extension Realm {
    
    public static var secretKey: Data? {
        get {
            let keychain = KeychainSwift()
            return keychain.getData("realmTodo")
        }
        set {
            let keychain = KeychainSwift()
            if let hasValue = newValue {
                keychain.set(hasValue, forKey: "realmTodo")
            } else {
                keychain.delete("realmTodo")
            }
        }
    }
    
    public static var shared: Realm = {
        do {
            var config: Realm.Configuration

            if let key = Realm.secretKey {
                config = Realm.Configuration.defaultConfiguration
//                config.encryptionKey = key
                config.deleteRealmIfMigrationNeeded = true
            } else {
                var key = Data(count: 64)
                _ = key.withUnsafeMutableBytes { bytes in
                    SecRandomCopyBytes(kSecRandomDefault, 64, bytes)
                }
                config = Realm.Configuration.defaultConfiguration
                config.encryptionKey = key
                config.deleteRealmIfMigrationNeeded = true
                Realm.secretKey = key
            }
            let folderPath = config.fileURL!.deletingLastPathComponent().path
            print(folderPath)
            let fileAttribute = FileAttributeKey(rawValue: FileAttributeKey.protectionKey.rawValue)
            let attributes = [fileAttribute: FileProtectionType.none]
            try? FileManager.default.setAttributes(attributes, ofItemAtPath: folderPath)

            return try Realm(configuration: config)
        } catch {
            return try! Realm()
        }
    }()
    
}
