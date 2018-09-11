//
//  MVVMViewController.swift
//  RealtimeChatApp
//
//  Created by David Nguyen Truong on 8/23/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import UIKit
import RxSwift
import EventBusSwift

open class MVVMViewController: UIViewController {
    
    // MARK: Property
    
    public var disposeBag: DisposeBag!
    
    open var delegate: ViewModelDelegate? {
        fatalError("Must implement delegate getter.")
    }
    
    // MARK: Override method
    
    open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = destination(of: segue) as? UIViewController {
            controller.assignData(sender)
        }
    }
    
    @objc(assignData:)
    open override func assignData(_ data: Any?) {
        delegate?.onDidReceive(data: data)
    }
    
    open override func onDestroy() {
        delegate?.onDestroy()
        disposeBag = nil
    }
    
    // MARK: Descontructor
    
    deinit {
        #if DEBUG
        print("\(String(describing: self)) deinit.")
        #endif
    }
    
}

extension MVVMViewController {
    
    // MARK: Lifecycle
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate?.onDidLoad()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        delegate?.onWillAppear()
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        delegate?.onWillDisappear()
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if isBeingDismissed {
            onDestroy()
        }
    }
    
    open override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        delegate?.onReceiveMemoryWarning()
    }
    
    open override func didMove(toParentViewController parent: UIViewController?) {
        super.didMove(toParentViewController: parent)
        guard let _ = parent else {
            onDestroy()
            
            return
        }
    }
    
}

// MARK: ViewController orientation

extension MVVMViewController {
    
    open override var shouldAutorotate: Bool {
        return true
    }
    
    open override var prefersStatusBarHidden: Bool {
        return false
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
    
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return UIApplication.shared.statusBarOrientation
    }
    
    open override var isBeingDismissed: Bool {
        return navigationController?.isBeingDismissed ?? super.isBeingDismissed
    }
    
}

// MARK: UINavigationController orientation

extension UINavigationController {
    
    //    open override var shouldAutorotate: Bool {
    //        if let controller = topViewController {
    //            return controller.shouldAutorotate
    //        }
    //        if let controller = presentingViewController {
    //            return controller.shouldAutorotate
    //        }
    //        return true
    //    }
    //
    //    open override var prefersStatusBarHidden: Bool {
    //        if let controller = topViewController {
    //            return controller.prefersStatusBarHidden
    //        }
    //        if let controller = presentingViewController {
    //            return controller.prefersStatusBarHidden
    //        }
    //        return false
    //    }
    //
    //    open override var preferredStatusBarStyle: UIStatusBarStyle {
    //        if let controller = topViewController {
    //            return controller.preferredStatusBarStyle
    //        }
    //        if let controller = presentingViewController {
    //            return controller.preferredStatusBarStyle
    //        }
    //        return .default
    //    }
    //
    //    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    //        if let controller = topViewController {
    //            return controller.supportedInterfaceOrientations
    //        }
    //        if let controller = presentingViewController {
    //            return controller.supportedInterfaceOrientations
    //        }
    //        return .all
    //    }
    //
    //    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
    //        if let controller = topViewController {
    //            return controller.preferredInterfaceOrientationForPresentation
    //        }
    //        if let controller = presentingViewController {
    //            return controller.preferredInterfaceOrientationForPresentation
    //        }
    //        return .portrait
    //    }
    //
}

extension UIViewController {
    
    @objc(destination:)
    public func destination(of segue: UIStoryboardSegue) -> Any? {
        var destination: Any? = segue.destination
        if let tabBarController = destination as? UITabBarController {
            destination = tabBarController.selectedViewController
        }
        if let navigationController = destination as? UINavigationController {
            destination = navigationController.topViewController
        }
        return destination
    }
    
    @objc(assignData:)
    open func assignData(_ data: Any?) {
        
    }
    
    @objc
    open func onDestroy() {
        
    }
    
    public func register(name aName: Notification.Name, handler: @escaping EventBusHandler) {
        EventBus.shared.register(self, name: aName, handler: handler)
    }
    
    public func unregister(name aName: Notification.Name) {
        EventBus.shared.unregister(self, name: aName)
    }
    
    public func post(name aName: Notification.Name, object: Any?) {
        EventBus.shared.post(name: aName, object: object)
    }
    
    public func postSticky(name aName: Notification.Name, object: Any?) {
        EventBus.shared.postSticky(name: aName, object: object)
    }
    
}
