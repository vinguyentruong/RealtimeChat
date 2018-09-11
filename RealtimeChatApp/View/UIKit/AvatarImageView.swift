//
//  AvatarImageView.swift
//  RealtimeChatApp
//
//  Created by David Nguyen Truong on 8/3/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import UIKit

class AvatarImageView: UIView {
    
    internal var imageView: UIImageView = { return UIImageView() }()
    internal var stateView: UIView = { return UIView() }()
    internal var stateColor: UIColor?
    private var defaultStateColor = UIColor(red: 116/255, green: 211/255, blue: 104/255, alpha: 1)
    
    private var r: CGFloat = 7.0
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialize()
    }
    
    private func initialize() {
        r = bounds.width / 5.8
        backgroundColor = UIColor.clear
        imageView.removeFromSuperview()
        stateView.removeFromSuperview()
        
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        imageView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        let margin: CGFloat = -frame.width * 0.5 * (1 - 1 / sqrt(2)) + r
        addSubview(stateView)
        stateView.backgroundColor = stateColor ?? defaultStateColor
        stateView.translatesAutoresizingMaskIntoConstraints = false
        stateView.heightAnchor.constraint(equalToConstant: r * 2.0).isActive = true
        stateView.widthAnchor.constraint(equalToConstant: r * 2.0).isActive = true
        stateView.rightAnchor.constraint(equalTo: rightAnchor, constant: margin).isActive = true
        stateView.topAnchor.constraint(equalTo: topAnchor, constant: -margin).isActive = true
        stateView.clipsToBounds = true
        stateView.borderColor = UIColor.white
        stateView.layer.borderWidth = 1.5
        
        backgroundColor = UIColor.clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if bounds == .zero {
            return
        }
        initialize()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = imageView.bounds.height/2
        stateView.layer.cornerRadius = stateView.bounds.height/2

    }
}
