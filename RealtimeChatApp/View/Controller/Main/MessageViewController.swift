//
//  MessageViewController.swift
//  RealtimeChatApp
//
//  Created by David Nguyen Truong on 8/10/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import UIKit
import Material
import RxSwift
import RxCocoa

class MessageViewController: BaseViewController {
    
    @IBOutlet weak var tableBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    internal var viewModel: MessageViewModel!
    override var delegate: ViewModelDelegate? {
        return viewModel
    }
    private let selectedColor = UIColor.init(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        disposeBag = DisposeBag()
        prepareViews()
        prepareTableView()
        prepareTabItem()
        
        super.viewDidLoad()
    }
}

// MARK: Binding

extension MessageViewController {
    
    override func bindData() {
        viewModel?
            .groups
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let sSelf = self else {
                    return
                }
                sSelf.tableView.reloadData()
            }).disposed(by: disposeBag)
        
//        viewModel?
//            .error
//            .asDriver()
//            .drive(onNext: { [weak self] error in
//                guard let sSelf = self else {
//                    return
//                }
//                if let err = error {
//                    sSelf.viewModel?.navigator.showAlert(title: "Error", message: err.localizedDescription, negativeTitle: "OK")
//                }
//            }).disposed(by: disposeBag)
    }
}

// MARK: Prepare views

extension MessageViewController {
    
    private func prepareViews() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        tapGesture.cancelsTouchesInView = false
        if let topView = UIApplication.topViewController() {
            topView.view.addGestureRecognizer(tapGesture)
        }
    }
    
    private func prepareTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(GroupChatCell.nib, forCellReuseIdentifier: GroupChatCell.className)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: .UIKeyboardWillHide, object: nil)
    }
    
    fileprivate func prepareTabItem() {
        tabItem.title = "Inbox"
    }
}

// MARK: Actions

extension MessageViewController {
    
    @objc
    private func handleTapGesture() {
        if let topView = UIApplication.topViewController() {
            topView.view.endEditing(false)
        }
    }
    
    @objc
    private func handleKeyboardNotification(notification: Notification) {
        if
            let userInfor = notification.userInfo,
            let keyboardFrame = userInfor[UIKeyboardFrameEndUserInfoKey] as? CGRect {
            let isHide = notification.name == .UIKeyboardWillHide
            if let window = UIApplication.shared.keyWindow {
                tableBottomConstraint.constant = isHide ? 0 : keyboardFrame.bounds.height - window.safeAreaInsets.bottom
            }
        }
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

// MARK: UITableViewDataSource

extension MessageViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.groups.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GroupChatCell.className, for: indexPath) as? GroupChatCell else {
            return UITableViewCell()
        }
        let groups = viewModel.groups.value
        cell.config(group: groups[indexPath.item])
        return cell
    }
}

// MARK: UITableViewDelegate

extension MessageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let chatView = UIStoryboard.main.getViewController(ChatViewController.self) {
            chatView.assignData(viewModel.groups.value[indexPath.item])
            navigationController?.pushViewController(chatView, animated: true)
        }
    }
}

