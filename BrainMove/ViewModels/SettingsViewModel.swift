//
//  SettingsViewModel.swift
//  BrainMove
//
//  Created by Heriberto Ureña madrigal on 7/1/20.
//  Copyright © 2020 Heriberto Ureña Madrigal. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth

protocol SettingsViewModelType {
    associatedtype Output

    var output : Output { get }
}

final class SettingsViewModel : SettingsViewModelType {
    var output: SettingsViewModel.Output

    struct Output {
        let userFullName: Driver<String>
        let userEmail: Driver<String>
        let logout: Driver<Bool>
    }
    
    private let userFullNameSubject = BehaviorSubject<String>.init(value: "")
    private let emailSubject = BehaviorSubject<String>.init(value: "")
    private let logoutSubject = PublishSubject<Bool>()

    init() {
        self.output = Output(userFullName: userFullNameSubject.asObservable().asDriver(onErrorJustReturn: ""), userEmail: emailSubject.asObservable().asDriver(onErrorJustReturn: ""), logout: logoutSubject.asObservable().asDriver(onErrorJustReturn: false))
        
        if let user = Auth.auth().currentUser {
            userFullNameSubject.onNext(user.displayName ?? "")
            emailSubject.onNext(user.email ?? "")
        }
    }
    
    func logoutUser () {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            logoutSubject.onNext(true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            logoutSubject.onNext(false)
        }
    }
}
