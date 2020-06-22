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

    init() {
        let isLoggedInUserInput = BehaviorSubject<Bool>(value: true)
        
        let loggedInUser = isLoggedInUserInput.asObservable()
            .map{ _ in Auth.auth().currentUser != nil }
            
        
        self.output = Output(isLoggedInUser: loggedInUser.asObservable().asDriver(onErrorJustReturn: false))
    }
    
}
