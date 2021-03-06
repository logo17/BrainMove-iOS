//
//  ForgotPasswordViewController.swift
//  BrainMove
//
//  Created by Heriberto Ureña madrigal on 5/28/20.
//  Copyright © 2020 Heriberto Ureña Madrigal. All rights reserved.
//

import Foundation
import UIKit
import MaterialComponents
import RxSwift
import RxCocoa

class ForgotPasswordViewController : UIViewController {
    var disposeBag = DisposeBag()
    let viewModel = ForgotPasswordViewModel()
    
    var spinner: LoadingView?
    @IBOutlet weak var sendRecoveryEmailButton: UIButton!
    @IBOutlet weak var email:  MDCTextField!
    var emailController: MDCTextInputControllerFilled?
    
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
        sendRecoveryEmailButton.toRoundedButton(radius: 19)
        email.delegate = self
        email.placeholder = self.getLocalizedString(key: "email_placeholder")
        emailController = MDCTextInputControllerFilled(textInput: email)
        emailController?.toAppStyle()
    }
    
    private func bindListeners() {
        email
            .rx.text.orEmpty
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .observeOn(MainScheduler.instance)
            .bind(to: viewModel.input.email)
            .disposed(by: disposeBag)
        
        viewModel.output.isButtonEnabled
            .drive(onNext:{ [weak self] isEnabled in
                self?.sendRecoveryEmailButton.handleButtonEnabled(isEnabled: isEnabled)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.emailSent
            .drive(onNext:{ [weak self] isSuccess in
                if let spinner = self?.spinner {
                    self?.removeSpinner(spinner: spinner)
                }
                if (isSuccess) {
                    self?.showAlert(title: self?.getLocalizedString(key: "app_name") ?? "", description: self?.getLocalizedString(key: "reset_password_success") ?? "", completion: {(alert: UIAlertAction!) in self?.navigationController?.popViewController(animated: true)})
                } else {
                    self?.showAlert(title: self?.getLocalizedString(key: "general_error_title") ?? "", description: self?.getLocalizedString(key: "general_error_description") ?? "", completion: nil)
                }
            })
            .disposed(by: disposeBag)
    }
    
    @IBAction func sendRecoveryEmail(_ sender: Any) {
        spinner = self.showSpinner(onView: self.view)
        self.viewModel.resetPassword(email: self.email.text ?? "")
    }
}
