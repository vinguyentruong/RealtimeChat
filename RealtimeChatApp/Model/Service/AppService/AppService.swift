//
//  AppService.swift
//  RealtimeChatApp
//
//  Created by David Nguyen Truong on 8/24/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import Foundation
import RxSwift

protocol AppService: class {
    
    func getUser() -> Observable<User>
}
