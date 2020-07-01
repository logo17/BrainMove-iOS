//
//  LoginViewModel.swift
//  BrainMove
//
//  Created by Heriberto Ureña madrigal on 5/28/20.
//  Copyright © 2020 Heriberto Ureña Madrigal. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth

protocol LoginViewModelType {
    associatedtype Input
    associatedtype Output

    var input : Input { get }
    var output : Output { get }
}

final class LoginViewModel : LoginViewModelType {
    var input: LoginViewModel.Input
    var output: LoginViewModel.Output
    
    private let loginSubject = PublishSubject<Bool>()
    private let emailVerifiedSubject = PublishSubject<Bool>()
    private let isLoadingSubject = PublishSubject<Bool>()

    struct Input {
        let email: AnyObserver<String>
        let password: AnyObserver<String>
    }

    struct Output {
        let isButtonEnabled: Driver<Bool>
        let successLogin: Driver<Bool>
        let emailVerified: Driver<Bool>
        let showError: Driver<Bool>
        let isLoading: Driver<Bool>
    }

    init() {
        let emailSubject = PublishSubject<String>()
        let passwordSubject = PublishSubject<String>()
        
        let validEmail: Observable = emailSubject.asObservable()
            .map{ $0.isValidEmail() }
        
        let validPassword = passwordSubject.asObservable()
        .map{ !$0.isEmpty }
        
        let enableButton = Observable.combineLatest (validEmail, validPassword) { ive, ivp in
            ive && ivp
        }
        .startWith(false)
        .asDriver(onErrorJustReturn: false)
    
        self.input = Input(email: emailSubject.asObserver(), password:passwordSubject.asObserver())
        self.output = Output(isButtonEnabled: enableButton, successLogin: loginSubject.asObservable().filter{$0}.asDriver(onErrorJustReturn: false), emailVerified: emailVerifiedSubject.asObservable().asDriver(onErrorJustReturn: false), showError: loginSubject.asObservable().filter{!$0}.asDriver(onErrorJustReturn: false), isLoading: isLoadingSubject.asObservable().asDriver(onErrorJustReturn: false))
    }
    
    func loginUser(email: String, password: String) {
        self.isLoadingSubject.onNext(true)
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
          self?.isLoadingSubject.onNext(false)
          guard error == nil else {
              self?.loginSubject.onNext(false)
              return
          }
            if let user = Auth.auth().currentUser {
                if (user.isEmailVerified) {
                    self?.loginSubject.onNext(true)
                } else {
                    self?.emailVerifiedSubject.onNext(false)
                }
            }
          
        }
    }
    
    func sendVerificationEmail() {
        if let user = Auth.auth().currentUser {
            user.sendEmailVerification(completion: nil)
        }
    }
}
