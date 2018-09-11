//
//  ChatCell.swift
//  RealtimeChatApp
//
//  Created by David Nguyen Truong on 8/3/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import UIKit
import Material

class GroupChatCell: TableViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var latestMessageLabel: UILabel!
    @IBOutlet weak var avatarView: AvatarImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatarView.imageView.image = #imageLiteral(resourceName: "image_avatar")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avatarView.layoutSubviews()
    }
    
    internal func config(group: Group) {
        nickNameLabel.text = group.name
        latestMessageLabel.text = group.lastMessage
        timeLabel.text = (group.updatedAt ?? Date()).dateToString(format: DateFormat.MMM_dd_yyyy_HH_mm_aa.name)
    }
}
