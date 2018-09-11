//
//  UserGroupRepository.swift
//  RealtimeChatApp
//
//  Created by David Nguyen Truong on 8/28/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import Foundation

class UserGroupRepository: Repository<UserGroup> {
    
    internal func getUserGroups(groupId: String) -> [UserGroup] {
        let results = realm .objects(UserGroup.self)
            .filter("groupId = '\(groupId)'")
        var data = [UserGroup]()
        for item in results {
            data.append(item)
        }
        return data
    }
}
