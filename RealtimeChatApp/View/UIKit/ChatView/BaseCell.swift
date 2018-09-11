//
//  BaseCell.swift
//  RealtimeChatApp
//
//  Created by David Nguyen Truong on 8/16/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import UIKit

class BaseCell: UICollectionViewCell {
    
    override var bounds: CGRect {
        didSet {
            layoutSubviews()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        setupViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if frame == .zero {
            return
        }
        setupViews()
    }
    
    internal func setupViews() {
        
    }
    
    internal func config(message: MessageCellData) {
        
    }
}
