//
//  TypingView.swift
//  RealtimeChatApp
//
//  Created by David Nguyen Truong on 8/28/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class TypingView: UIView {
    
    internal var indicatorView: NVActivityIndicatorView!
    internal var titleView: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        inititalize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    
        inititalize()
    }
    
    private func inititalize() {
        indicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 10), type: .ballPulse, color: UIColor.blue, padding: 20)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        titleView = UILabel()
        titleView.textAlignment = .right
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.font = UIFont.systemFont(ofSize: 10)
        titleView.textColor = UIColor.blue
        addSubview(titleView)
        addSubview(indicatorView)
        
        titleView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        titleView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        titleView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        indicatorView.leftAnchor.constraint(equalTo: titleView.rightAnchor, constant: 4).isActive = true
        indicatorView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        indicatorView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        indicatorView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        indicatorView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
    
    internal func startAnimating() {
        isHidden = false
        indicatorView.startAnimating()
    }
    
    internal func stopAnimating() {
        isHidden = true
        indicatorView.stopAnimating()
    }

}
