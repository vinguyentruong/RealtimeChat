//
//  Repository.swift
//  RealtimeChatApp
//
//  Created by David Nguyen Truong on 8/28/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

class Repository<T: Object>: NSObject {
    
    internal var realm: Realm {
        return Realm.shared
    }
    
    internal var tableName: String {
        return T.className()
    }
    
    func write(_ body: () -> Void) {
        autoreleasepool {
            let realm = self.realm
            try? realm.write(body)
        }
    }
    
    func get(withId id: String) -> T? {
        let result = realm.objects(T.self)
            .filter("id = '\(id)'")
            .first
        return result
    }
    
    func getAll() -> [T]? {
        let results = realm.objects(T.self)
        if results.isEmpty {
            return nil
        }
        var data = [T]()
        for item in results {
            data.append(item)
        }
        return data
    }
    
    func add(_ entity: T, update: Bool) {
        autoreleasepool {
            let realm = self.realm
            realm.beginWrite()
            realm.add(entity, update: update)
            try? realm.commitWrite()
        }
    }
    
    func add(_ entities: [T], update: Bool) {
        if entities.isEmpty {
            return
        }
        autoreleasepool {
            let realm = self.realm
            realm.beginWrite()
            realm.add(entities, update: update)
            try? realm.commitWrite()
        }
    }
    
    func delete(_ entity: T) {
        autoreleasepool {
            let realm = self.realm
            realm.beginWrite()
            realm.delete(entity)
            try? realm.commitWrite()
        }
    }
    
    func delete(_ entities: [T]) {
        if entities.isEmpty {
            return
        }
        autoreleasepool {
            let realm = self.realm
            realm.beginWrite()
            realm.delete(entities)
            try? realm.commitWrite()
        }
    }
    
    func delete(_ entities: Results<T>) {
        if entities.isEmpty {
            return
        }
        autoreleasepool {
            let realm = self.realm
            realm.beginWrite()
            realm.delete(entities)
            try? realm.commitWrite()
        }
    }
    
    func delete(_ entity: Object) {
        autoreleasepool {
            let realm = self.realm
            realm.beginWrite()
            realm.delete(entity)
            try? realm.commitWrite()
        }
    }
    
    class func deleteAll() {
        autoreleasepool {
            let realm = Realm.shared
            realm.beginWrite()
            realm.deleteAll()
            try? realm.commitWrite()
        }
    }
    
    func getIndex(page: Int, limit: Int, total: Int) -> (Int, Int) {
        let startIndex = page * limit
        let endIndex = startIndex + limit
        if endIndex <= total {
            return (startIndex, endIndex)
        }
        return (startIndex, total)
    }
    
}

