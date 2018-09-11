//
//  ChatLogController.swift
//  RealtimeChatApp
//
//  Created by David Nguyen Truong on 8/16/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import UIKit
import LoremIpsum

struct MessageCellData {
    var message: Message?
    var status: String?
    var date: String?
}

class ChatLogController: BaseChatLogViewController {
    
    // MARK: Property
    
    internal var messages = [MessageCellData]()
    private var indexSelected: IndexPath?

    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        for i in 0...2 {
//            let mess = Message()
//            mess.data = LoremIpsum.sentence()
//            messages.append(MessageCellData(message: mess, status: nil, date: nil))
//        }
        collectionView?.register(BubbleChatCell.self, forCellWithReuseIdentifier: BubbleChatCell.className)
        collectionView?.register(DateTimeCell.self, forCellWithReuseIdentifier: DateTimeCell.className)
        collectionView?.register(StatusCell.self, forCellWithReuseIdentifier: StatusCell.className)
        collectionView?.alwaysBounceVertical = true
        self.collectionView?.contentInset.bottom = 8
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        scrollToBottom(animated: false)
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        coordinator.animateAlongsideTransition(in: view, animation: { _ in
            self.collectionView?.collectionViewLayout.invalidateLayout()
            self.collectionView?.reloadData()
        }, completion: nil)
    }
    
    // MARK: Internal methods
    
    internal func setUpMessages(messages: [Message]) {
        self.messages = []
        for mess in messages {
            let messData = MessageCellData(message: mess,
                                           status: nil,
                                           date: nil)
            self.messages.append(messData)
        }
    }
    
    internal func sendMessage(message: Message, complete: @escaping ()->Void) {
        collectionView?.performBatchUpdates({
            messages.append(MessageCellData(message: message, status: nil, date: nil))
            let indexPath = IndexPath(row: messages.count - 1, section: 0)
            collectionView?.insertItems(at: [indexPath])
        }, completion: {_ in
            self.scrollToBottom(animated: true)
            complete()
        })
    }
}

// MARK: UICollectionViewDataSource

extension ChatLogController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: BaseCell = BaseCell()
        if let index = indexSelected, index == indexPath {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: DateTimeCell.className, for: indexPath) as! BaseCell
        } else if let index = indexSelected, index.item + 2 == indexPath.item {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: StatusCell.className, for: indexPath) as! BaseCell
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: BubbleChatCell.className, for: indexPath) as! BaseCell
            (cell as? BubbleChatCell)?.profileImageView.image = #imageLiteral(resourceName: "image_avatar")
        }
        cell.config(message: messages[indexPath.item])
        return cell
    }
}

// MARK: UICollectionViewDelegate

extension ChatLogController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let index = indexSelected, index == indexPath || index.item + 2 == indexPath.item {
            return
        }
        if let index = indexSelected {
            messages.remove(at: index.item + 2)
            messages.remove(at: index.item)
            collectionView.deleteItems(at: [IndexPath(row: index.item + 2, section: 0), IndexPath(row: index.item, section: 0)])
            if index.item + 1 == indexPath.item {
                indexSelected = nil
                return
            }
        }
        if let index = indexSelected, indexPath.item > index.item + 2 {
            indexSelected = IndexPath(row: indexPath.item - 2, section: 0)
        } else {
            indexSelected = IndexPath(row: indexPath.item, section: 0)
        }
        let currentIndex = getLastVisibleIndexPath()
        var dateItem = messages[indexSelected!.item]
        dateItem.date = dateItem.message?.updatedAt?.dateToString(format: DateFormat.MMM_dd_yyyy_HH_mm_aa.name)
        var statusItem = messages[indexSelected!.item]
        statusItem.status = "Read"
        messages.insert(dateItem, at: indexSelected!.item)
        messages.insert(statusItem, at: indexSelected!.item + 2)
        collectionView.insertItems(at: [indexSelected!, IndexPath(row: indexSelected!.item + 2, section: 0)])
        if (indexSelected?.item)! + 2 >= (currentIndex?.item)! {
            currentMessageIndex = IndexPath(row: indexSelected!.item + 2, section: 0)
            collectionView.scrollToItem(at: currentMessageIndex!, at: .bottom, animated: true)
        } else if indexPath.item >= messages.count - 3 {
            scrollToBottom(animated: true)
        }
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension ChatLogController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if messages[indexPath.item].date != nil || messages[indexPath.item].status != nil {
            return CGSize(width: collectionView.bounds.width, height: 16)
        }
        let mess = messages[indexPath.item].message
        let padding: CGFloat = 8
        let size = CGSize(width: collectionView.bounds.width - padding*4 - 48, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: mess?.data ?? "").boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)], context: nil)
        return CGSize(width: collectionView.bounds.width, height: estimatedFrame.height + padding*2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
    }
}
