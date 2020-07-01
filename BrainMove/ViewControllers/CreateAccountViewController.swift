//
//  CreateAccountViewController.swift
//  BrainMove
//
//  Created by Heriberto Ureña madrigal on 5/30/20.
//  Copyright © 2020 Heriberto Ureña Madrigal. All rights reserved.
//

import Foundation
import UIKit
import MaterialComponents
import RxSwift
import RxCocoa

class CreateAccountViewController : UIViewController {
    let viewModel = CreateAccountViewModel()
    let disposeBag = DisposeBag()
    
    var spinner: LoadingView?
    
    @IBOutlet weak var fullName:  MDCTextField!
    @IBOutlet weak var email:  MDCTextField!
    @IBOutlet weak var password: MDCTextField!
    @IBOutlet weak var createAccountButton: UIButton!
    
    var fullNameController: MDCTextInputControllerFilled?
    var emailController: MDCTextInputControllerFilled?
    var passwordController: MDCTextInputControllerFilled?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        initViews()
        bindListeners()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    private func initViews() {
        createAccountButton.toRoundedButton(radius: 19)
        email.delegate = self
        email.placeholder = NSLocalizedString("email_placeholder", comment: "")
        emailController = MDCTextInputControllerFilled(textInput: email)
        emailController?.toAppStyle()
        password.delegate = self
        password.placeholder = NSLocalizedString("password_placeholder", comment: "")
        passwordController = MDCTextInputControllerFilled(textInput: password)
        passwordController?.toAppStyle()
        fullName.delegate = self
        fullName.placeholder = NSLocalizedString("fullname_placeholder", comment: "")
        fullNameController = MDCTextInputControllerFilled(textInput: fullName)
        fullNameController?.toAppStyle()
    }
    
    private func bindListeners() {
        fullName
        .rx.text.orEmpty
        .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
        .distinctUntilChanged()
        .observeOn(MainScheduler.instance)
        .bind(to: viewModel.input.name)
        .disposed(by: disposeBag)
        
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
                self?.createAccountButton.handleButtonEnabled(isEnabled: isEnabled)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.emailSent
            .drive(onNext:{ [weak self] isSuccess in
                if (isSuccess) {
                    self?.showAlert(title: self?.getLocalizedString(key: "app_name") ?? "", description: self?.getLocalizedString(key: "create_account_success") ?? "", completion: {(alert: UIAlertAction!) in self?.navigationController?.popViewController(animated: true)})
                } else {
                    self?.showAlert(title: self?.getLocalizedString(key: "general_error_title") ?? "", description: self?.getLocalizedString(key: "general_error_description") ?? "", completion: nil)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.output.showLoading
        .drive(onNext:{ [weak self] isLoading in
            self?.handleSpinner(isLoading: isLoading)
        })
        .disposed(by: disposeBag)
    }
    
    private func handleSpinner(isLoading: Bool) {
        if (isLoading) {
            self.spinner = showSpinner(onView: self.view)
        } else {
            if let spinner = self.spinner {
                self.removeSpinner(spinner: spinner)
            }
        }
    }
    @IBAction func createAccountClicked(_ sender: Any) {
        viewModel.createAccount(email: email.text ?? "", password: password.text ?? "", name: fullName.text ?? "")
    }
}
