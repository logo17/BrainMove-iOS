//
//  PlanViewModel.swift
//  BrainMove
//
//  Created by Heriberto Ureña madrigal on 6/26/20.
//  Copyright © 2020 Heriberto Ureña Madrigal. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import RxSwift
import RxCocoa

protocol PlanViewModelType {
    associatedtype Input
    associatedtype Output

    var input : Input { get }
    var output : Output { get }
}

final class PlanViewModel : PlanViewModelType {
    var input: PlanViewModel.Input
    var output: PlanViewModel.Output
    
    let db = Firestore.firestore()
    private let planSubject = BehaviorSubject<Plan>(value: Plan())
    private let isLoadingSubject = PublishSubject<Bool>()
    private let showErrorSubject = PublishSubject<Bool>()
    
    struct Input {
        
    }

    struct Output {
        let plan: Driver<Plan>
        let isLoading: Driver<Bool>
        let showError: Driver<Bool>
    }
    
    init() {
        self.input = Input()
        self.output = Output(plan: planSubject.asObservable().asDriver(onErrorJustReturn: Plan()), isLoading: isLoadingSubject.asObservable().asDriver(onErrorJustReturn: false), showError: showErrorSubject.asObservable().filter{$0}.asDriver(onErrorJustReturn: false))
    }
    
    func getPlan() {
        guard let user = Auth.auth().currentUser else {
            return
        }
        self.isLoadingSubject.onNext(true)
        db.collection("plan")
            .limit(to: 1)
            .whereField("toDate", isGreaterThan: Timestamp(date: Date()))
            .whereField("userId", isEqualTo: user.uid)
            .getDocuments() { (querySnapshot, err) in
                self.isLoadingSubject.onNext(false)
                if err != nil {
                    self.showErrorSubject.onNext(true)
                } else {
                    for document in querySnapshot!.documents {
                        if let plan = Plan(data: document.data()) {
                            self.planSubject.onNext(plan)
                        }
                    }
                }
            }
    }
}
