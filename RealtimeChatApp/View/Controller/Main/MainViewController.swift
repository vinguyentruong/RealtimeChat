//
//  MainViewController.swift
//  RealtimeChatApp
//
//  Created by David Nguyen Truong on 8/14/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import UIKit

class MainViewController: BaseViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var containerView: UIView!
    override var delegate: ViewModelDelegate? {
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareTabController()
        prepareUI()
        prepareNavigationBar()
    }

}

extension MainViewController {
    
    private func prepareTabController() {
        guard let messageViewController = UIStoryboard.main.getViewController(MessageViewController.self),
            let bookMarkViewController = UIStoryboard.main.getViewController(BookmarkViewController.self) else {
                return
        }
        let viewControllers = [messageViewController, bookMarkViewController]
        let tabViewController = MainTabBarViewController(viewControllers: viewControllers, selectedIndex: 0)
        addChildViewController(tabViewController)
        containerView.addSubview(tabViewController.view)
        tabViewController.didMove(toParentViewController: self)
    }
    
    private func prepareUI() {
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
            textfield.tintColor = UIColor.darkGray
            textfield.textColor = UIColor.darkGray
            if let backgroundview = textfield.subviews.first {
                backgroundview.layer.cornerRadius = 18
                backgroundview.clipsToBounds = true
                backgroundview.backgroundColor = UIColor.white
            }
        }
        searchBar.layer.borderWidth = 0
        searchBar.layer.borderColor = UIColor.clear.cgColor
        searchBar.backgroundImage = UIImage()
    }
    
    private func prepareNavigationBar() {
        title = "Messages"
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let v = UIView(frame: CGRect(x: 0, y: -16, width: 30, height: 30))
        let avatarImageView = AvatarImageView(frame: v.frame)
        avatarImageView.stateColor = UIColor.red
        avatarImageView.imageView.image = #imageLiteral(resourceName: "image_avatar")
        v.addSubview(avatarImageView)
        
        let rightBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_add"), style: .plain, target: self, action: nil)
        rightBarButton.tintColor = UIColor.red
        
        let leftBarButton = UIBarButtonItem(customView: v)
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItem = rightBarButton
    }
}
