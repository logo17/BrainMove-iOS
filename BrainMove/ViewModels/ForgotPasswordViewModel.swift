//
//  ForgotPasswordViewModel.swift
//  BrainMove
//
//  Created by Heriberto Ureña madrigal on 5/28/20.
//  Copyright © 2020 Heriberto Ureña Madrigal. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa
import FirebaseAuth

protocol ForgotPasswordViewModelType {
    associatedtype Input
    associatedtype Output

    var input : Input { get }
    var output : Output { get }
}

final class ForgotPasswordViewModel : ForgotPasswordViewModelType {
    var input: ForgotPasswordViewModel.Input
    var output: ForgotPasswordViewModel.Output
    
    private let emailSentSubject = PublishSubject<Bool>()
    
    private let auth = Auth.auth()

    struct Input {
        let email: AnyObserver<String>
        let sendPasswordRecoveryClicked: AnyObserver<Void>
    }

    struct Output {
        let isButtonEnabled: Driver<Bool>
        let emailSent: Driver<Bool>
    }

    init() {
        let emailSubject = PublishSubject<String>()
        let sendPasswordRecoveryClickedSubject = PublishSubject<Void>()
        
        let validEmail = emailSubject.asObservable()
            .map{ $0.isValidEmail() }
        
        let enableButton = validEmail
            .startWith(false)
            .asDriver(onErrorJustReturn: false)

        self.input = Input(email: emailSubject.asObserver(), sendPasswordRecoveryClicked: sendPasswordRecoveryClickedSubject.asObserver())
        self.output = Output(isButtonEnabled: enableButton, emailSent: emailSentSubject.asObservable().asDriver(onErrorJustReturn: false))
    }
    
    func resetPassword(email: String) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
          guard error == nil else {
              self.emailSentSubject.onNext(false)
              return
          }
          self.emailSentSubject.onNext(true)
        }
    }
}
