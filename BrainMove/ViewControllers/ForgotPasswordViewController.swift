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
    
    @IBOutlet weak var sendRecoveryEmailButton: UIButton!
    @IBOutlet weak var email:  MDCTextField!
    var emailController: MDCTextInputControllerFilled?
    
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
            print(isSuccess)
        })
        .disposed(by: disposeBag)
    }
    
    @IBAction func sendRecoveryEmail(_ sender: Any) {
        self.viewModel.resetPassword(email: self.email.text ?? "")
    }
    @IBAction func navigateBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
