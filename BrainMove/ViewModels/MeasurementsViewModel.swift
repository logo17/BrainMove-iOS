//
//  MeasurementsViewModel.swift
//  BrainMove
//
//  Created by Heriberto Ureña madrigal on 6/23/20.
//  Copyright © 2020 Heriberto Ureña Madrigal. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import RxSwift
import RxCocoa

protocol MeasurementsViewModelType {
    associatedtype Input
    associatedtype Output

    var input : Input { get }
    var output : Output { get }
}

final class MeasurementsViewModel : MeasurementsViewModelType {
    var input: MeasurementsViewModel.Input
    var output: MeasurementsViewModel.Output
    
    private let measurementsSubject = PublishSubject<Measurement>()
    private let nameSubject = BehaviorSubject<String>.init(value: "")
    private let logoutSubject = PublishSubject<Bool>()
    private let isLoadingSubject = PublishSubject<Bool>()
    private let showErrorSubject = PublishSubject<Bool>()
    
    struct Input {
        
    }

    struct Output {
        let measurement: Driver<Measurement>
        let userName: Driver<String>
        let logout: Driver<Bool>
        let isLoading: Driver<Bool>
        let showError: Driver<Bool>
    }
    
    let db = Firestore.firestore()

    init() {
        self.input = Input()
        self.output = Output(measurement: measurementsSubject.asObservable().asDriver(onErrorJustReturn: Measurement()), userName: nameSubject.asObservable().asDriver(onErrorJustReturn: ""), logout: logoutSubject.asObservable().asDriver(onErrorJustReturn: false), isLoading: isLoadingSubject.asObservable().asDriver(onErrorJustReturn: false), showError: showErrorSubject.asObservable().filter{$0}.asDriver(onErrorJustReturn: false))
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
    
    func getMeasures() {
        guard let user = Auth.auth().currentUser else {
            return
        }
        self.isLoadingSubject.onNext(true)
        self.nameSubject.onNext(user.displayName ?? "")
        db.collection("measures")
        .limit(to: 1)
        .order(by: "date", descending: true)
        .whereField("user_id", isEqualTo: user.uid)
        .getDocuments() { (querySnapshot, err) in
            self.isLoadingSubject.onNext(false)
            if let err = err {
                print("Error getting documents: \(err)")
                self.showErrorSubject.onNext(true)
            } else {
                if(querySnapshot!.documents.isEmpty) {
                    self.measurementsSubject.onNext(Measurement())
                } else {
                    for document in querySnapshot!.documents {
                        if let measurement = Measurement(data: document.data()) {
                            self.measurementsSubject.onNext(measurement)
                            
                        }
                    }
                }
            }
        }
    }
}
