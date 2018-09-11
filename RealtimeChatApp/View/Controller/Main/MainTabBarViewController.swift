//
//  MainTabBarViewController.swift
//  RealtimeChatApp
//
//  Created by David Nguyen Truong on 8/10/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import UIKit
import Material

class MainTabBarViewController: TabsController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
    }
    
    open override func prepare() {
        super.prepare()
        
        tabBar.lineColor = UIColor.red
        tabBar.lineHeight = 0.5
        tabBar.lineAlignment = .bottom
        tabBar.subviews.first?.backgroundColor = UIColor.clear
        tabBar.setTabItemsColor(Color.grey.base, for: .normal)
        tabBar.setTabItemsColor(Color.darkText.primary, for: .selected)
        tabBar.setTabItemsColor(Color.red.base, for: .highlighted)
        tabBarAlignment = .top
        tabBar.tabItems.first?.setTabItemColor(Color.darkText.primary, for: .selected)
        
        for item in tabBar.tabItems {
            item.titleLabel?.font = UIFont(name: "Montserrat-SemiBold", size: 15)
        }
    }
}
