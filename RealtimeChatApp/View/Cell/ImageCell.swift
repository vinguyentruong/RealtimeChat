//
//  ImageCell.swift
//  RealtimeChatApp
//
//  Created by David Nguyen Truong on 8/14/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    
    override var bounds: CGRect {
        didSet {
            self.layoutIfNeeded()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.height/2
    }
    
    internal func config(image: UIImage?) {
        avatarImageView.image = image
    }

}
