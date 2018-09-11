//
//  MessageSyncCacheRepository.swift
//  RealtimeChatApp
//
//  Created by David Nguyen Truong on 8/30/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import Foundation

class MessageSyncCacheRepository: Repository<MessageSyncCache> {
    
    internal override func getAll() -> [MessageSyncCache]? {
        let results = realm.objects(MessageSyncCache.self)
        if results.isEmpty {
            return nil
        }
        return results
            .map{$0}
            .sorted(by: {$0.createdAt! < $1.createdAt!} )
    }
}
