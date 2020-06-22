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

    struct Input {
        let email: AnyObserver<String>
        let password: AnyObserver<String>
    }

    struct Output {
        let isButtonEnabled: Driver<Bool>
        let successLogin: Driver<Bool>
    }

    init() {
        let emailSubject = PublishSubject<String>()
        let passwordSubject = PublishSubject<String>()
        
        let validEmail = emailSubject.asObservable()
            .map{ !$0.isEmpty }
        
        let validPassword = passwordSubject.asObservable()
        .map{ !$0.isEmpty }
        
        let enableButton = Observable.combineLatest (validEmail, validPassword) { ive, ivp in
            ive && ivp
        }
        .startWith(false)
        .asDriver(onErrorJustReturn: false)
    
        self.input = Input(email: emailSubject.asObserver(), password:passwordSubject.asObserver())
        self.output = Output(isButtonEnabled: enableButton, successLogin: loginSubject.asObservable().filter{$0}.asDriver(onErrorJustReturn: false))
    }
    
    func loginUser(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
          guard error == nil else {
              self?.loginSubject.onNext(false)
              return
          }
          self?.loginSubject.onNext(true)
        }
    }
}
