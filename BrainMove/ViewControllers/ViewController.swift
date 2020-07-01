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
    
    var spinner: LoadingView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        initViews()
        bindListeners()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private func initViews() {
        loginButton.toRoundedButton(radius: 19)
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
        
        viewModel.output.successLogin
            .drive(onNext:{ [weak self] isEnabled in
                self?.email.text = ""
                self?.password.text = ""
                self?.performSegue(withIdentifier: "showMainScreenFromLogin", sender: self)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.emailVerified
            .drive(onNext:{ [weak self] isVerified in
                if (!isVerified) {
                    self?.showSendVerifyEmailAlert()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.output.showError
            .drive(onNext:{ [weak self] isError in
                self?.showAlert(title: self?.getLocalizedString(key: "general_error_title") ?? "", description: self?.getLocalizedString(key: "general_error_description") ?? "", completion: nil)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.isLoading
            .drive(onNext:{ [weak self] isLoading in
                self?.handleLoadingSpinner(isLoading: isLoading)
            })
            .disposed(by: disposeBag)
    }
    @IBAction func forgotPasswordClicked(_ sender: Any) {
        performSegue(withIdentifier: "showForgotPassword", sender: self)
    }
    @IBAction func createAccountClicked(_ sender: Any) {
        performSegue(withIdentifier: "showCreateAccount", sender: self)
    }
    @IBAction func loginClicked(_ sender: Any) {
        viewModel.loginUser(email: self.email.text ?? "", password: self.password.text ?? "")
    }
    
    private func showSendVerifyEmailAlert() {
        let emailNotVerifiedTitle = self.getLocalizedString(key: "email_not_verified_title")
        let emailNotVerifiedDescription = self.getLocalizedString(key: "email_verification_sent")
        // create the alert
        let alert = UIAlertController(title: emailNotVerifiedTitle, message: emailNotVerifiedDescription, preferredStyle: UIAlertController.Style.alert)

        // add an action (button)
        alert.addAction(UIAlertAction(title: self.getLocalizedString(key: "accept_button_text"), style: UIAlertAction.Style.default, handler: nil))
        alert.addAction(UIAlertAction(title: self.getLocalizedString(key: "resend_button_text"), style: UIAlertAction.Style.default, handler: {(alert: UIAlertAction!) in self.viewModel.sendVerificationEmail()}))

        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    private func handleLoadingSpinner(isLoading: Bool) {
        if (isLoading) {
            spinner = self.showSpinner(onView: self.view)
        } else {
            if let spinner = self.spinner {
                self.removeSpinner(spinner: spinner)
            }
        }
    }
}

