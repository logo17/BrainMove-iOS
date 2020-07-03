//
//  PaymentsViewModel.swift
//  BrainMove
//
//  Created by Heriberto Ureña madrigal on 7/3/20.
//  Copyright © 2020 Heriberto Ureña Madrigal. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import RxSwift
import RxCocoa

protocol PaymentsViewModelType {
    associatedtype Input
    associatedtype Output

    var input : Input { get }
    var output : Output { get }
}

class PaymentsViewModel : PaymentsViewModelType {
    var input: PaymentsViewModel.Input
    var output: PaymentsViewModel.Output
    
    let db = Firestore.firestore()
    private let paymentsSubject = BehaviorSubject<[Payment]>(value: [Payment()])
    private let isLoadingSubject = PublishSubject<Bool>()
    private let showErrorSubject = PublishSubject<Bool>()
    
    struct Input {
        
    }

    struct Output {
        let payments: Driver<[Payment]>
        let isLoading: Driver<Bool>
        let showError: Driver<Bool>
    }
    
    init() {
        self.input = Input()
        self.output = Output(payments: paymentsSubject.asObservable().asDriver(onErrorJustReturn: [Payment()]), isLoading: isLoadingSubject.asObservable().asDriver(onErrorJustReturn: false), showError: showErrorSubject.asObservable().filter{$0}.asDriver(onErrorJustReturn: false))
        
        guard let user = Auth.auth().currentUser else {
            return
        }
        self.isLoadingSubject.onNext(true)
        db.collection("payments")
            .limit(to: 12)
            .whereField("userId", isEqualTo: user.uid)
            .getDocuments() { (querySnapshot, err) in
                self.isLoadingSubject.onNext(false)
                if err != nil {
                    self.showErrorSubject.onNext(true)
                } else {
                    var paymentList = Array<Payment>()
                    for document in querySnapshot!.documents {
                        if let payment = Payment(data: document.data()) {
                            paymentList.append(payment)
                        }
                    }
                    self.paymentsSubject.onNext(paymentList)
                }
            }
    }
}
