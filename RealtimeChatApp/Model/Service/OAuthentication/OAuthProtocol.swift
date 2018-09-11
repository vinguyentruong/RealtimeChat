//
//  OAuthProtocol.swift
//  RealtimeChatApp
//
//  Created by David Nguyen Truong on 8/23/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import UIKit
import RxSwift

protocol OAuthProtocol: class {
    
    func login(email            : String,
               password         : String) -> Observable<OAuthToken>
    
    func logout() -> Observable<Bool>
    
    func resgister(displayName      : String,
                   email            : String,
                   password         : String,
                   imageURL         : String?) -> Observable<User>
    
    func oauthRefreshToken(_ responseHandler: @escaping (ApiResponse<OAuthToken>) -> Void)
    
}
