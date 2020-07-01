//
//  CreateAccountViewModel.swift
//  BrainMove
//
//  Created by Heriberto Ureña madrigal on 6/29/20.
//  Copyright © 2020 Heriberto Ureña Madrigal. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import FirebaseAuth
import Firebase

protocol CreateAccountViewModelType {
    associatedtype Input
    associatedtype Output

    var input : Input { get }
    var output : Output { get }
}

final class CreateAccountViewModel : CreateAccountViewModelType {
    var input: CreateAccountViewModel.Input
    var output: CreateAccountViewModel.Output
    
    private let emailSentSubject = PublishSubject<Bool>()
    private let showLoadingSubject = PublishSubject<Bool>()
    
    private let auth = Auth.auth()
    let db = Firestore.firestore()


    struct Input {
        let name: AnyObserver<String>
        let email: AnyObserver<String>
        let password: AnyObserver<String>
        let createAccountClicked: AnyObserver<Void>
    }

    struct Output {
        let isButtonEnabled: Driver<Bool>
        let emailSent: Driver<Bool>
        let showLoading: Driver<Bool>
    }

    init() {
        let nameSubject = PublishSubject<String>()
        let emailSubject = PublishSubject<String>()
        let passwordSubject = PublishSubject<String>()
        let createAccountClickedSubject = PublishSubject<Void>()
        
        let validName = nameSubject.asObservable()
            .map{ !($0.isEmpty) }
        
        let validEmail = emailSubject.asObservable()
            .map{ $0.isValidEmail() }
        
        let validPassword = passwordSubject.asObservable()
        .map{ $0.count >= 6 }
        
        let enableButton = Observable.combineLatest (validName, validEmail, validPassword) { ivn, ive, ivp in
            ivn && ive && ivp
        }
        .startWith(false)
        .asDriver(onErrorJustReturn: false)

        self.input = Input(name: nameSubject.asObserver(), email: emailSubject.asObserver(), password: passwordSubject.asObserver(), createAccountClicked: createAccountClickedSubject.asObserver())
        self.output = Output(isButtonEnabled: enableButton, emailSent: emailSentSubject.asObservable().asDriver(onErrorJustReturn: false), showLoading: showLoadingSubject.asObservable().asDriver(onErrorJustReturn: false))
    }
    
    func createAccount(email: String, password: String, name: String) {
        self.showLoadingSubject.onNext(true)
        auth.createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard error == nil else {
                self?.showLoadingSubject.onNext(false)
                self?.emailSentSubject.onNext(false)
                return
            }
            guard let user = self?.auth.currentUser else {
                self?.showLoadingSubject.onNext(false)
                self?.emailSentSubject.onNext(false)
                return
            }
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = name
            changeRequest.commitChanges { (error) in
                print(error ?? "No error")
            }
            
            let keywords = name.split(separator: " ").map { $0.lowercased() }
        
            var ref: DocumentReference? = nil
            ref = self?.db.collection("users").addDocument(data: [
                "fullName": name,
                "email": email,
                "id": user.uid,
                "keywords": keywords
            ]) { err in
                self?.showLoadingSubject.onNext(false)
                if let err = err {
                    self?.emailSentSubject.onNext(false)
                    print("Error adding document: \(err)")
                } else {
                    user.sendEmailVerification { (error) in
                        self?.showLoadingSubject.onNext(false)
                        if error != nil {
                            self?.emailSentSubject.onNext(false)
                        } else {
                            self?.emailSentSubject.onNext(true)
                        }
                    }
                    print("Document added with ID: \(ref!.documentID)")
                }
            }
        }
    }
    
}
