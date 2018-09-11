//
//  StatusCell.swift
//  RealtimeChatApp
//
//  Created by David Nguyen Truong on 8/22/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import UIKit

class StatusCell: BaseCell {
    
    internal let statusLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Sample message"
        label.backgroundColor = UIColor.clear
        label.textAlignment = .left
        label.textColor = UIColor.lightGray
        return label
    }()
    
    override func setupViews() {
        super.setupViews()

        addSubview(statusLabel)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        statusLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 46).isActive = true
        statusLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8).isActive = true
    }
    
    override func config(message: MessageCellData) {
        if
            let mess = message.message,
            let status = message.status {
            statusLabel.text = status
            if mess.isFriend {
                statusLabel.textAlignment = .left
            } else {
                statusLabel.textAlignment = .right
            }
        }
    }
}
