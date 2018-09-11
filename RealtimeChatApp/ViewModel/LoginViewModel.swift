//
//  LoginViewModel.swift
//  RealtimeChatApp
//
//  Created by David Nguyen Truong on 8/23/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON

class LoginViewModel: BaseViewModel {
    
    // MARK: Property
    
    private let oauthService: OAuthProtocol
    private let appService: AppService
    internal var success = Variable<Bool>(false)
    internal var processing = Variable<Bool>(false)
    internal var error = Variable<Error?>(nil)
    
    // MARK: Construction
    
    init(navigator: Navigator, oauthService: OAuthProtocol, appService: AppService) {
        self.oauthService = oauthService
        self.appService = appService
        
        super.init(navigator: navigator)
    }
    
    // MARK: Lifecycle
    
    override func onDidLoad() {
        super.onDidLoad()
        
        disposeBag = DisposeBag()
    }
    
    // MARK: Private methods
    
    func getUser() {
        appService.getUser()
            .observeOn(MainScheduler.instance)
            .asObservable()
            .subscribe(
                onNext: { [weak self] user in
                    guard let sSelf = self else {
                        return
                    }
                    let userDefault = user
                    userDefault.logined = true
                    User.default = userDefault
                    sSelf.processing.value = true
                },
                onError: { [weak self] error in
                    guard let sSelf = self else {
                        return
                    }
                    sSelf.processing.value = true
                }
            ).disposed(by: disposeBag)
    }
    
    //MARK: Internal methods
    
    internal func login(username: String, password: String) {
        processing.value = true
        oauthService
            .login(email: username, password: password)
            .observeOn(MainScheduler.instance)
            .asObservable()
            .subscribe(
                onNext: { [weak self] token in
                    guard let sSelf = self else {
                        return
                    }
                    sSelf.success.value = true
                    OAuthToken.default.update(oauthToken: token)
                    sSelf.processing.value = false
                    sSelf.getUser()
                },
                onError: { [weak self] error in
                    guard let sSelf = self else {
                        return
                    }
                    sSelf.error.value = error
                    sSelf.processing.value = false
                }
            ).disposed(by: disposeBag)
    }
    
}
