//
//  TrendsViewModel.swift
//  BrainMove
//
//  Created by Heriberto Ureña madrigal on 6/28/20.
//  Copyright © 2020 Heriberto Ureña Madrigal. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import RxSwift
import RxCocoa

protocol TrendsViewModelType {
    associatedtype Output

    var output : Output { get }
}

final class TrendsViewModel : TrendsViewModelType {
    var output: TrendsViewModel.Output
    
    private let measurementsSubject = PublishSubject<Array<Measurement>>()

    struct Output {
        let measurements: Driver<Array<Measurement>>
    }
    
    let db = Firestore.firestore()

    init() {
        self.output = Output(measurements: measurementsSubject.asObservable().asDriver(onErrorJustReturn: Array<Measurement>()))
    }
    
    func getMeasures() {
        guard let user = Auth.auth().currentUser else {
            return
        }
        db.collection("measures")
        .limit(to: 10)
        .order(by: "date", descending: false)
        .whereField("user_id", isEqualTo: user.uid)
        .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    self.measurementsSubject.onNext(Array<Measurement>())
                } else {
                    if(querySnapshot!.documents.isEmpty) {
                        self.measurementsSubject.onNext(Array<Measurement>())
                    } else {
                        var result = Array<Measurement>()
                        for document in querySnapshot!.documents {
                            if let measurement = Measurement(data: document.data()) {
                                result.append(measurement)
                            }
                        }
                        self.measurementsSubject.onNext(result)
                    }
                }
        }
    }
}


