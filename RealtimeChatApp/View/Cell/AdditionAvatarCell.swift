//
//  AdditionAvatarCell.swift
//  RealtimeChatApp
//
//  Created by David Nguyen Truong on 8/15/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import UIKit

class AdditionAvatarCell: UICollectionViewCell {

    @IBOutlet weak var inforLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    internal func config(text: String?) {
        inforLabel.text = text
    }
}
