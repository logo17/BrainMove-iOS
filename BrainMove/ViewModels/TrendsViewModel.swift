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
    private let isLoadingSubject = PublishSubject<Bool>()
    private let showErrorSubject = PublishSubject<Bool>()

    struct Output {
        let measurements: Driver<Array<Measurement>>
        let isLoading: Driver<Bool>
        let showError: Driver<Bool>
    }
    
    let db = Firestore.firestore()

    init() {
        self.output = Output(measurements: measurementsSubject.asObservable().asDriver(onErrorJustReturn: Array<Measurement>()), isLoading: isLoadingSubject.asObservable().asDriver(onErrorJustReturn: false), showError: showErrorSubject.asObservable().filter{$0}.asDriver(onErrorJustReturn: false))
    }
    
    func getMeasures() {
        guard let user = Auth.auth().currentUser else {
            return
        }
        self.isLoadingSubject.onNext(true)
        db.collection("measures")
            .limit(to: 10)
            .order(by: "date", descending: false)
            .whereField("user_id", isEqualTo: user.uid)
            .getDocuments() { (querySnapshot, err) in
                self.isLoadingSubject.onNext(false)
                if err != nil {
                    self.showErrorSubject.onNext(true)
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


