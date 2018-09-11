//
//  BaseViewController.swift
//  RealtimeChatApp
//
//  Created by David Nguyen Truong on 8/23/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class BaseViewController: MVVMViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindData()
        bindAction()
    }
    
    @objc
    internal dynamic func bindData() {
        //
    }
    
    @objc
    internal dynamic func bindAction() {
        //
    }
}


