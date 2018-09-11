//
//  BubbleChatCell.swift
//  RealtimeChatApp
//
//  Created by David Nguyen Truong on 8/16/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import UIKit

class BubbleChatCell: BaseCell {
    
    internal var isFriend = true
    
    internal let messageLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Sample message"
        label.backgroundColor = UIColor.clear
        return label
    }()
    
    internal let textBubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.layer.cornerRadius = 14
        return view
    }()
    
    internal let profileImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    private var messageContent: String?
    private var messageSize = CGSize(width: 40, height: 40)
    private var padding: CGFloat = 8
    
    override func setupViews() {
        super.setupViews()
        
        profileImageView.removeFromSuperview()
        textBubbleView.removeFromSuperview()
        messageLabel.removeFromSuperview()
        addSubview(profileImageView)
        addSubview(textBubbleView)
        addSubview(messageLabel)
        
        if isFriend {
            setupFriendMessage()
        } else {
            setupCurrentUserMessage()
        }
    }
    
    private func setupFriendMessage() {
        profileImageView.frame = CGRect(x: padding, y: contentView.bounds.height - 30, width: 30, height: 30)
        textBubbleView.frame = CGRect(x: profileImageView.bounds.width + padding*2, y: 0, width: messageSize.width
            + padding*2, height: contentView.bounds.height)
        messageLabel.frame = CGRect(x: textBubbleView.frame.origin.x + padding, y: padding, width: messageSize.width, height: messageSize.height)
        
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 15
        textBubbleView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        messageLabel.textColor = UIColor.darkText
    }
    
    private func setupCurrentUserMessage() {
        profileImageView.removeFromSuperview()
        textBubbleView.frame = CGRect(x: contentView.bounds.width - messageSize.width - padding*3, y: 0, width: messageSize.width + padding*2, height: contentView.bounds.height)
        messageLabel.frame = CGRect(x: textBubbleView.frame.origin.x + padding, y: padding, width: messageSize.width, height: messageSize.height)
        
        textBubbleView.backgroundColor = UIColor(rgb: 0x62C5B0)
        messageLabel.textColor = UIColor.white
    }
    
    private func updateSize() {
        let maxWidth = self.bounds.width - padding*4 - 48
        let size = CGSize(width: maxWidth, height: 2000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: messageContent ?? "").boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)], context: nil)
        messageSize = estimatedFrame.size
        setupViews()
    }
    
    override func config(message: MessageCellData) {
        if let mess = message.message {
            messageLabel.text = mess.data
            isFriend = mess.isFriend
            messageContent = mess.data
            updateSize()
        }
    }
}
