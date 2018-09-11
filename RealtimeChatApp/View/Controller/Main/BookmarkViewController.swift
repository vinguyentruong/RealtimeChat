//
//  BookmarkViewController.swift
//  RealtimeChatApp
//
//  Created by David Nguyen Truong on 8/14/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import UIKit

class BookmarkViewController: BaseViewController {

    override var delegate: ViewModelDelegate? {
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareTabItem()
    }

}

extension BookmarkViewController {
    
    fileprivate func prepareTabItem() {
        tabItem.title = "Bookmarked"
    }
}
