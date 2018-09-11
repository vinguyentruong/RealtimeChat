//
//  ChatViewController.swift
//  RealtimeChatApp
//
//  Created by David Nguyen Truong on 8/14/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import UIKit
import Material
import RxSwift
import NVActivityIndicatorView

class ChatViewController: BaseViewController {
    
    @IBOutlet weak var messageBox: MessageBox!
    @IBOutlet weak var chatLogContainerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var messageBottomConstraint: NSLayoutConstraint!
    private var typingView: TypingView!
    
    internal var viewModel: ChatViewModel!
    private var chatLogCollectionView: ChatLogController!
    let defaultNumberOfMemberShow = 6
    let defaultTimeOut = 20
    var countTime = 20
    var timer: Timer?
    override var delegate: ViewModelDelegate? {
        return viewModel
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        disposeBag = DisposeBag()
        prepareChatView()
        prepareCollectionView()
        prepareNavitionBar()
        prepareMessageBox()
        
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        timer?.invalidate()
    }
    
    // MARK: Overide methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let controller = segue.destination as? ChatLogController {
            chatLogCollectionView = controller
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        prepareLayoutCollectionView()
    }
    
    override func willTransition(to newCollection: UITraitCollection,
                                 with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        DispatchQueue.main.async {
            self.messageBox.updateMessageBoxSize()
        }
        coordinator.animateAlongsideTransition(in: view, animation: { _ in
            self.collectionView.collectionViewLayout.invalidateLayout()
        }, completion: nil)
    }
}

// MARK: Binding

extension ChatViewController {
    
    override func bindData() {
        viewModel
            .members
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let sSelf = self else {
                    return
                }
                sSelf.collectionView.reloadData()
            }
        ).disposed(by: disposeBag)
        
        viewModel
            .messages
            .asDriver()
            .drive(onNext: { [weak self] messages in
                guard let sSelf = self else {
                    return
                }
                sSelf.chatLogCollectionView.setUpMessages(messages: messages)
                sSelf.chatLogCollectionView.collectionView?.reloadData()
            }
        ).disposed(by: disposeBag)
        
        viewModel
            .hasNewMessage
            .asObservable()
            .subscribe(onNext: { [weak self] hasNewMessage in
                guard let sSelf = self else {
                    return
                }
                if hasNewMessage {
                    sSelf.chatLogCollectionView.scrollToBottom(animated: true)
                    sSelf.viewModel.hasNewMessage.value = false
                }
            }
        ).disposed(by: disposeBag)
        
        viewModel
            .userTyping
            .asObservable()
            .subscribe(onNext: { [weak self] userGroup in
                guard let sSelf = self else {
                    return
                }
                if let user = userGroup {
                    sSelf.handleTypingView()
                    if user.isTyping {
                        sSelf.typingView.titleView.text = "\(user.memberName!) is typing"
                        sSelf.typingView.startAnimating()
                    } else {
                        sSelf.prepareNavitionBar()
                        sSelf.typingView.stopAnimating()
                    }
                }
            }
        ).disposed(by: disposeBag)
    }
}

// MARK: Prepare views

extension ChatViewController {
    
    private func prepareNavitionBar() {
        let titleHeight = navigationController?.navigationBar.bounds.height
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: (navigationController?.navigationBar.bounds.width)!, height: titleHeight!))
        let titleLabel = UILabel()
        titleView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: titleView.topAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: titleView.leftAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: titleView.rightAnchor).isActive = true
        
        let detailLabel = UILabel()
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(detailLabel)
        detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        detailLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        detailLabel.rightAnchor.constraint(equalTo: titleLabel.rightAnchor).isActive = true
        detailLabel.bottomAnchor.constraint(equalTo: titleView.bottomAnchor).isActive = true
        
        titleLabel.textAlignment = .center
        titleLabel.text = viewModel.group.name
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        
        detailLabel.textAlignment = .center
        detailLabel.text = viewModel.makeLatestUpdateString()
        detailLabel.font = UIFont.systemFont(ofSize: 10)
        detailLabel.textColor = .lightGray
        
        navigationItem.titleView = titleView
        
        let leftBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_left_arrow"), style: .plain, target: self, action: #selector(handleBackAction))
        let rightBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_more"), style: .plain, target: self, action: #selector(handleMoreAction))
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItem = rightBarButton
        navigationController?.navigationBar.tintColor = UIColor.red
    }
    
    private func prepareMessageBox() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: .UIKeyboardWillHide, object: nil)
        messageBox.delegate = self
    }
    
    private func prepareChatView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCollectionTapGesture))
        tapGesture.cancelsTouchesInView = false
        chatLogContainerView.addGestureRecognizer(tapGesture)
    }
    
    private func prepareCollectionView() {
        collectionView.dataSource = self
        collectionView.register(ImageCell.nib, forCellWithReuseIdentifier: ImageCell.className)
        collectionView.register(AdditionAvatarCell.nib, forCellWithReuseIdentifier: AdditionAvatarCell.className)
        collectionView.isPagingEnabled = true
    }
    
    private func prepareLayoutCollectionView() {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        let numberOfMembers = min(viewModel.members.value.count, defaultNumberOfMemberShow + 1)
        let padding: CGFloat = 12
        let cellWidth = min(35.0, (collectionView.bounds.width - CGFloat(numberOfMembers + 1) * padding) / CGFloat(numberOfMembers))
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        layout.minimumLineSpacing = padding
        layout.minimumInteritemSpacing = padding
        let totalCellWidth = cellWidth * CGFloat(numberOfMembers)
        let totalSpacingWidth = padding * CGFloat(numberOfMembers - 1)
        let leftInset = (collectionView.bounds.width - (totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset
        collectionView.contentInset = UIEdgeInsets(top: padding, left: leftInset, bottom: padding, right: rightInset)
    }
    
}

// MARK: Actions

extension ChatViewController {
    
    private func startTimer() {
        if timer == nil {
            print("Start timer")
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        }
    }
    
    @objc private func updateTimer() {
        if countTime == 0 {
            countTime = defaultTimeOut
            timer?.invalidate()
            timer = nil
            viewModel.sendTyping(isTyping: false)
        } else {
            countTime -= 1
        }
    }
    
    @objc
    private func handleCollectionTapGesture() {
        view.endEditing(false)
    }
    
    @objc
    private func handleKeyboardNotification(notification: Notification) {
       
        if
            let userInfor = notification.userInfo,
            let keyboardFrame = userInfor[UIKeyboardFrameEndUserInfoKey] as? CGRect {
            let isHide = notification.name == .UIKeyboardWillHide
            if let window = UIApplication.shared.keyWindow {
                messageBottomConstraint.constant = isHide ? 0 : -keyboardFrame.bounds.height + window.safeAreaInsets.bottom
                
                print(keyboardFrame.bounds.height)
            }
        }
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.chatLogCollectionView.scrollToCurrentMessage()
        }, completion: nil)
    }
    
    @objc
    private func handleMoreAction() {
        //
    }
    
    @objc
    private func handleBackAction() {
        navigationController?.popViewController(animated: true)
    }
    
    private func handleTypingView() {
        let titleHeight = navigationController?.navigationBar.bounds.height
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: (navigationController?.navigationBar.bounds.width)!, height: titleHeight!))
        let titleLabel = UILabel()
        titleView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: titleView.topAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: titleView.leftAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: titleView.rightAnchor).isActive = true
        
        typingView = TypingView()
        typingView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(typingView)
        typingView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        typingView.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor).isActive = true
        typingView.bottomAnchor.constraint(equalTo: titleView.bottomAnchor).isActive = true
        
        titleLabel.textAlignment = .center
        titleLabel.text = "David và những người bạn"
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        
        navigationItem.titleView = titleView
        
        let leftBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_left_arrow"), style: .plain, target: self, action: #selector(handleBackAction))
        let rightBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_more"), style: .plain, target: self, action: #selector(handleMoreAction))
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItem = rightBarButton
        navigationController?.navigationBar.tintColor = UIColor.red
    }
}

// MARK: UICollectionViewDataSource

extension ChatViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(defaultNumberOfMemberShow + 1, viewModel.members.value.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let members = viewModel.members.value
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdditionAvatarCell.className, for: indexPath) as? AdditionAvatarCell,
            indexPath.item == defaultNumberOfMemberShow {
            cell.config(text: "+\(members.count - defaultNumberOfMemberShow)")
            return cell
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.className, for: indexPath) as? ImageCell else {
            return UICollectionViewCell()
        }
        cell.config(image: UIImage.getDefaultImageWithInitialName(name: members[indexPath.item].memberName,
                                                                  parentView: cell.contentView,
                                                                  size: cell.bounds.size))
        return cell
    }
}

extension ChatViewController: MessageBoxDelegate {
    
    func messageBox(didSend button: UIButton, textView: CustomTextView) {
        let message = viewModel.message(from: textView.text)
        chatLogCollectionView.sendMessage(message: message) {
            self.viewModel.sendMessage(message: message)
        }
        viewModel.sendTyping(isTyping: false)
    }
    
    func messageBox(textDidChanged textView: CustomTextView) {
        if countTime >= defaultTimeOut {
            viewModel.sendTyping(isTyping: true)
        }
        startTimer()
    }
}
