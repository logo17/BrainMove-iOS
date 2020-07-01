//
//  LauncherViewModel.swift
//  BrainMove
//
//  Created by Heriberto Ureña madrigal on 6/21/20.
//  Copyright © 2020 Heriberto Ureña Madrigal. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth

protocol LauncherViewModelType {
    associatedtype Output

    var output : Output { get }
}

final class LauncherViewModel : LauncherViewModelType {
    
    var output: LauncherViewModel.Output

    struct Output {
        let isLoggedInUser: Driver<Bool>
    }
    
    private let loggedInUserSubject = PublishSubject<Bool>.init()

    init() {
        self.output = Output(isLoggedInUser: loggedInUserSubject.asObservable().asDriver(onErrorJustReturn: false))
    }
    
    func checkLoggedInUser () {
        if let user = Auth.auth().currentUser {
            if (user.isEmailVerified) {
                user.getIDTokenResult(completion: { (result, error) in
                    guard let admin = result?.claims["admin"] as? NSNumber else {
                        self.loggedInUserSubject.onNext(true)
                        return
                    }
                    self.loggedInUserSubject.onNext(!admin.boolValue)
                })
            } else {
                self.loggedInUserSubject.onNext(false)
            }
        } else {
            loggedInUserSubject.onNext(false)
        }
    }
    
}
