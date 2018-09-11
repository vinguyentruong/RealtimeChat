//
//  AppServiceImplement.swift
//  RealtimeChatApp
//
//  Created by David Nguyen Truong on 8/24/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import Foundation
import RxSwift

class AppServiceImplement: RestService {
    
}

extension AppServiceImplement: AppService {
    
    func getUser() -> Observable<User> {
        return Observable.create({ (e) -> Disposable in
            self.apiHelper.get(
                url             : "\(Configuration.BaseUrl)/api/users",
                parameters      : nil,
                headerHander    : { self.defaultHeaders },
                responseHandler : { (json, error) in
                    if let json = json?["data"] {
                        let user = User(json: json)
                        e.on(.next(user))
                    }
                    if let error = error {
                        e.on(.error(error))
                    }
                    e.on(.completed)
                }
            )
            return Disposables.create()
        })
    }
}
