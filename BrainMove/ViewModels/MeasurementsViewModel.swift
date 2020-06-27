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
    private let nameSubject = PublishSubject<String>()
    
    struct Input {
        
    }

    struct Output {
        let measurement: Driver<Measurement>
        let userName: Driver<String>
    }
    
    let db = Firestore.firestore()

    init() {
        self.input = Input()
        self.output = Output(measurement: measurementsSubject.asObservable().asDriver(onErrorJustReturn: Measurement()), userName: nameSubject.asObservable().asDriver(onErrorJustReturn: ""))
        
        guard let user = Auth.auth().currentUser else {
            return
        }
        db.collection("measures")
            .limit(to: 1)
            .order(by: "date", descending: true)
            .whereField("user_id", isEqualTo: user.uid)
            .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            if let measurement = Measurement(data: document.data()) {
                                self.measurementsSubject.onNext(measurement)
                                self.nameSubject.onNext(user.displayName ?? "")
                            }
                        }
                    }
            }
    }
}
