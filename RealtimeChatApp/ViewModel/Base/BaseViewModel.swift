//
//  BaseViewModel.swift
//  RealtimeChatApp
//
//  Created by David Nguyen Truong on 8/23/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import UIKit
import RxSwift

typealias CompletionHandeler = () -> Void

class BaseViewModel: ViewModel {
    
    internal var disposeBag: DisposeBag!
    
    override func onDestroy() {
        disposeBag = nil
    }
    
    internal func showError(error: Error) {
        navigator.showAlert(title         : "Error",
                            message       : error.localizedDescription,
                            negativeTitle : "Ok")
    }
}
