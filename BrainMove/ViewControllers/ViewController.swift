//
//  ViewController.swift
//  BrainMove
//
//  Created by Heriberto Ureña madrigal on 5/28/20.
//  Copyright © 2020 Heriberto Ureña Madrigal. All rights reserved.
//

import UIKit
import MaterialComponents
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    var disposeBag = DisposeBag()
    let viewModel = LoginViewModel()
    
    @IBOutlet weak var email:  MDCTextField!
    @IBOutlet weak var password: MDCTextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var emailController: MDCTextInputControllerFilled?
    var passwordController: MDCTextInputControllerFilled?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        initViews()
        bindListeners()
    }

    private func initViews() {
        email.delegate = self
        email.placeholder = NSLocalizedString("email_placeholder", comment: "")
        emailController = MDCTextInputControllerFilled(textInput: email)
        emailController?.toAppStyle()
        password.delegate = self
        password.placeholder = NSLocalizedString("password_placeholder", comment: "")
        passwordController = MDCTextInputControllerFilled(textInput: password)
        passwordController?.toAppStyle()
    }
    
    private func bindListeners() {
        email
            .rx.text.orEmpty
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .observeOn(MainScheduler.instance)
            .bind(to: viewModel.input.email)
            .disposed(by: disposeBag)
        
        password
            .rx.text.orEmpty
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .observeOn(MainScheduler.instance)
            .bind(to: viewModel.input.password)
            .disposed(by: disposeBag)
        
        viewModel.output.isButtonEnabled
            .drive(onNext:{ [weak self] isEnabled in
                self?.loginButton.handleButtonEnabled(isEnabled: isEnabled)
            })
            .disposed(by: disposeBag)
    }
    @IBAction func forgotPasswordClicked(_ sender: Any) {
        performSegue(withIdentifier: "showForgotPassword", sender: self)
    }
}

