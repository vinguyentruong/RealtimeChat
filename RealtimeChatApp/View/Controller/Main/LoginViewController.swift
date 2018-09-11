//
//  ViewController.swift
//  RealtimeChatApp
//
//  Created by David Nguyen Truong on 8/2/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import UIKit
import Material
import RxSwift

class LoginViewController: BaseViewController {
    
    @IBOutlet weak var passwordTextField: TextField!
    @IBOutlet weak var usernameTextField: TextField!
    @IBOutlet weak var loginButton: RaisedButton!
    @IBOutlet weak var loginContainerView: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var backgroundImageHomeView: UIView!
    
    private var buttonColor = UIColor(rgb: 0x0096FF)
    private var isEnableSignInButton = Variable<Bool>(false)
    internal var viewModel: LoginViewModel!
    override var delegate: ViewModelDelegate? {
        return viewModel
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        disposeBag = DisposeBag()
        prepareUI()
        
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        prepareUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        prepareNavigationBar()
    }
    
    // MARK: IB Actions
    
    @IBAction func loginAction(_ sender: Any) {
        viewModel.login(username: usernameTextField.text!, password: passwordTextField.text!)
    }
}

// MARK: Binding

extension LoginViewController {
    
    override func bindAction() {
        
        usernameTextField.rx
            .controlEvent(UIControlEvents.editingChanged)
            .subscribe { [weak self] (_) in
                guard let sSelf = self else {
                    return
                }
                sSelf.isEnableSignInButton.value = (sSelf.usernameTextField.text != "") && (sSelf.passwordTextField.text != "")
            }.disposed(by: disposeBag)
        
        passwordTextField.rx
            .controlEvent(UIControlEvents.editingChanged)
            .subscribe { [weak self] (_) in
                guard let sSelf = self else {
                    return
                }
                sSelf.isEnableSignInButton.value = (sSelf.usernameTextField.text != "") && (sSelf.passwordTextField.text != "")
            }.disposed(by: disposeBag)
        
        isEnableSignInButton
            .asDriver()
            .drive(onNext: { [weak self] value in
                guard let sSelf = self else {
                    return
                }
                sSelf.loginButton.isEnabled = value
                sSelf.loginButton.backgroundColor = value ? sSelf.buttonColor : .lightGray
                }
            ).disposed(by: disposeBag)
        
        viewModel
            .success
            .asObservable()
            .subscribe(onNext: { success in
                if success {
                    guard let mainViewController = UIStoryboard.main.getViewController(MainViewController.self) else { return }
                    guard let window = UIApplication.shared.keyWindow else {
                        return
                    }
                    let navigationController = UINavigationController(rootViewController: mainViewController)
                    UIView.transition(with: window, duration: 0.33, options: .transitionCrossDissolve, animations: {
                        window.rootViewController = navigationController
                    }, completion: nil)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel
            .error
            .asObservable()
            .subscribe(onNext: { [weak self] error in
                guard let sSelf = self else {
                    return
                }
                if let err = error {
                    sSelf.viewModel.navigator.showAlert(title: "Error", message: err.localizedDescription, negativeTitle: "OK")
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Prepare UIs

extension LoginViewController {
    
    private func prepareUI() {
        gradientView.setGradientColors(colors: [UIColor.blueSky.withAlphaComponent(0.2), UIColor.violet], cornerRadious: 0)
        backgroundImageHomeView.backgroundColor = UIColor.clear
        backgroundImageHomeView.clipsToBounds = true
        backgroundImageHomeView.setGradientColors(colors: [UIColor.blueSky.withAlphaComponent(0.1), UIColor.violet], cornerRadious: backgroundImageHomeView.bounds.height/2)
        
        loginButton.layoutIfNeeded()
        loginButton.layer.shadowPath = UIBezierPath(roundedRect: loginButton.bounds, cornerRadius: loginButton.bounds.height/2).cgPath
        loginButton.layer.shadowColor = UIColor.black.cgColor
        loginButton.layer.shadowOpacity = 0.5
        loginButton.layer.shadowRadius = 1
        loginButton.layer.shadowOffset = CGSize(width: 0.2, height: 0.2)
        loginButton.clipsToBounds = true
        loginButton.layer.masksToBounds = false
        loginButton.layer.cornerRadius = loginButton.bounds.height/2
//        loginButton.setGradientColors(colors: [UIColor.blueSky, UIColor.violet], cornerRadious: loginButton.bounds.height/2)
        
        loginContainerView.layer.shadowPath = UIBezierPath(rect: loginContainerView.bounds).cgPath
        loginContainerView.backgroundColor = UIColor.white
        loginContainerView.layer.shadowColor = UIColor.black.cgColor
        loginContainerView.layer.shadowOpacity = 0.1
        loginContainerView.layer.shadowOffset = CGSize(width: 0.2, height: 0.2)
        loginContainerView.clipsToBounds = true
        loginContainerView.layer.masksToBounds = false
        loginContainerView.layer.cornerRadius = 8
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tochEnvent)))
    }
    
    private func prepareNavigationBar() {
        navigationController?.isNavigationBarHidden = true
    }
}

// MARK: Actions

extension LoginViewController {
    
    @objc
    private func tochEnvent() {
        view.endEditing(true)
    }
}



