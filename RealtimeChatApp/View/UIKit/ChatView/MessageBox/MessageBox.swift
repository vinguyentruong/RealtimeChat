//
//  MessageBox.swift
//  RealtimeChatApp
//
//  Created by David Nguyen Truong on 8/15/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import UIKit
import Material

protocol MessageBoxDelegate: class {
    
    func messageBox(didSend button: UIButton, textView: CustomTextView)
    func messageBox(textDidChanged textView: CustomTextView)
}

class MessageBox: UIView {
    
    override var bounds: CGRect {
        didSet {
            self.layoutSubviews()
        }
    }

    @IBOutlet weak var messageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var sendButton: FlatButton!
    @IBOutlet weak var messageTextView: CustomTextView!
    @IBOutlet weak var emotionButton: FlatButton!
    @IBOutlet weak var attachButton: FlatButton!
    
    internal var view: UIView!
    internal weak var delegate: MessageBoxDelegate?
    private let themeColor = UIColor(red: 116/255, green: 211/255, blue: 104/255, alpha: 1)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        initalize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initalize()
    }
    
    // MARK: Private method
    
    private func initalize() {
        view = loadViewFromNib()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        addConstraint(NSLayoutConstraint(
            item        : view,
            attribute   : .top,
            relatedBy   : .equal,
            toItem      : self,
            attribute   : .top,
            multiplier  : 1.0,
            constant    : 0
        ))
        addConstraint(NSLayoutConstraint(
            item        : view,
            attribute   : .bottom,
            relatedBy   : .equal,
            toItem      : self,
            attribute   : .bottom,
            multiplier  : 1.0,
            constant    : 0
        ))
        addConstraint(NSLayoutConstraint(
            item        : view,
            attribute   : .leading,
            relatedBy   : .equal,
            toItem      : self,
            attribute   : .leading,
            multiplier  : 1.0,
            constant    : 0
        ))
        addConstraint(NSLayoutConstraint(
            item        : view,
            attribute   : .trailing,
            relatedBy   : .equal,
            toItem      : self,
            attribute   : .trailing,
            multiplier  : 1.0,
            constant    : 0
        ))
        
        messageTextView.clipsToBounds = true
        messageTextView.layer.cornerRadius = 8
        prepareViews()
        prepareMessageTextView()
    }
    
    @IBAction func sendAction(_ sender: Any) {
        if messageTextView.text != "" {
            delegate?.messageBox(didSend: sendButton, textView: messageTextView)
            messageTextView.text = nil
            messageHeightConstraint.constant = CGFloat(30)
        }
    }
    
}

extension MessageBox {
    
    private func prepareViews() {
        attachButton.tintColor = themeColor
        emotionButton.tintColor = themeColor
        sendButton.tintColor = UIColor.lightGray
    }
    
    private func prepareMessageTextView() {
        messageTextView.valueChanged = { [weak self] textView in
            guard let sSelf = self else {
                return
            }
            sSelf.delegate?.messageBox(textDidChanged: sSelf.messageTextView)
            sSelf.updateMessageBoxSize()
        }
    }
    
    internal func updateMessageBoxSize() {
        let sizeThatFit = messageTextView.sizeThatFits(CGSize(width: messageTextView.bounds.size.width, height: 100))
        if sizeThatFit.height < 100 {
            messageHeightConstraint.constant = sizeThatFit.height
            messageTextView.isScrollEnabled = false
        } else {
            messageHeightConstraint.constant = 100
            messageTextView.isScrollEnabled = true
        }
    }
}
