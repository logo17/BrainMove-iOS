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

class CreateAccountViewController : UIViewController {
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    private func initViews() {
        createAccountButton.toPrimaryButton()
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
}
