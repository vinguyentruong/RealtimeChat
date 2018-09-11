//
//  Navigator.swift
//  RealtimeChatApp
//
//  Created by David Nguyen Truong on 8/23/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import UIKit

public struct ViewKey {
    
    public let name: String
    
    public init(_ name: String) {
        self.name = name
    }
    
}

public class Navigator {
    
    // MARK: Property
    
    public private(set) weak var viewController: UIViewController?
    
    // MARK: Constructor
    
    public init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    // MARK: Navigator implement
    
    public func dismissView(animated flag: Bool, completion: (() -> Void)? = nil) {
        viewController?.dismiss(animated: flag, completion: completion)
    }
    
    public func popView(animated flag: Bool){
        _ = viewController?.navigationController?.popViewController(animated: flag)
    }
    
    public func popViewToRoot(animated flag: Bool) {
        _ = viewController?.navigationController?.popToRootViewController(animated: flag)
    }
    
    public func showView(key akey: ViewKey) {
        showView(key: akey, data: nil)
    }
    
    public func showView(key akey: ViewKey, data: Any?) {
        viewController?.performSegue(withIdentifier: akey.name, sender: data)
    }
    
    public func showAlert(
        title           : String,
        message         : String,
        negativeTitle   : String,
        negativeHandler : ((UIAlertAction) -> Void)? = nil) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: negativeTitle, style: .cancel, handler: negativeHandler))
        viewController?.showDetailViewController(alertController, sender: nil)
    }
    
    public func showAlert(
        title           : String,
        message         : String,
        negativeTitle   : String,
        positiveTitle   : String,
        negativeHandler : ((UIAlertAction) -> Void)? = nil,
        positiveHandler : ((UIAlertAction) -> Void)? = nil) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: negativeTitle, style: .cancel, handler: negativeHandler))
        alertController.addAction(UIAlertAction(title: positiveTitle, style: .default, handler: positiveHandler))
        viewController?.showDetailViewController(alertController, sender: nil)
    }
    
    public func beginIgnoringEvent() {
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    public func endIgnoringEvent() {
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
}

