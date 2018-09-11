//
//  CustomTextView.swift
//  RealtimeChatApp
//
//  Created by David Nguyen Truong on 8/16/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CustomTextView: UITextView {
    
    @IBInspectable
    internal var placeholder: String = "" {
        didSet {
            text = placeholder
            textColor = .lightGray
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.delegate = self
    }
    
    internal var valueChanged: ((UITextView) -> ())?
}

extension CustomTextView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
            valueChanged?(self)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholder
            textView.textColor = .lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        valueChanged?(self)
    }
}
