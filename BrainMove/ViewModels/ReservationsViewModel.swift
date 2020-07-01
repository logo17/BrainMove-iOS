//
//  ReservationsViewModel.swift
//  BrainMove
//
//  Created by Heriberto Ureña madrigal on 6/24/20.
//  Copyright © 2020 Heriberto Ureña Madrigal. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import RxSwift
import RxCocoa


protocol ReservationsViewModelType {
    associatedtype Input
    associatedtype Output

    var input : Input { get }
    var output : Output { get }
}

final class ReservationsViewModel : ReservationsViewModelType {
    var input: ReservationsViewModel.Input
    var output: ReservationsViewModel.Output
    
    private let reservationsSubject = PublishSubject<Array<Reservation>>()
    private let isLoadingSubject = PublishSubject<Bool>()
    private let showErrorSubject = PublishSubject<Bool>()
    
    
    struct Input {
        
    }

    struct Output {
        let reservations: Driver<Array<Reservation>>
        let isLoading: Driver<Bool>
        let showError: Driver<Bool>
    }
    
    let db = Firestore.firestore()

    init() {
        self.input = Input()
        self.output = Output(reservations: reservationsSubject.asObservable().asDriver(onErrorJustReturn: Array()), isLoading: isLoadingSubject.asObservable().asDriver(onErrorJustReturn: false), showError: showErrorSubject.asObservable().filter{$0}.asDriver(onErrorJustReturn: false))
    }
    
    func getReservations(isToday: Bool) {
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        self.isLoadingSubject.onNext(true)
        let currentDate = Date()
        let todayStart = Calendar.current.date(bySettingHour: 00, minute: 00, second: 00, of: currentDate)
        var components = DateComponents()
        components.day = 1
        let todayEnd = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: todayStart ?? Date())
        let tomorrowStart = Calendar.current.date(byAdding: components as DateComponents, to: todayStart ?? Date())
        let tomorrowEnd = Calendar.current.date(byAdding: components as DateComponents, to: todayEnd ?? Date())
        
        let fromDate = (isToday ? currentDate : tomorrowStart) ?? currentDate
        let toDate = (isToday ? todayEnd : tomorrowEnd) ?? currentDate
        db.collection("reservation")
            .whereField("date", isGreaterThan: Timestamp(date: fromDate))
            .whereField("date", isLessThan: Timestamp(date: toDate))
            .getDocuments() { (querySnapshot, err) in
                    self.isLoadingSubject.onNext(false)
                    if err != nil {
                        self.showErrorSubject.onNext(true)
                    } else {
                        var reservations = [Reservation]()
                        for document in querySnapshot!.documents {
                            if let reservation = Reservation(userId: user.uid, reservationId: document.documentID, data: document.data()) {
                                reservations.append(reservation)
                            }
                        }
                        self.reservationsSubject.onNext(reservations)
                    }
            }
    }
    
    func makeReservation(reservation: Reservation, isToday: Bool) {
        guard let user = Auth.auth().currentUser else {
            return
        }
        self.isLoadingSubject.onNext(true)
        db.collection("reservation").document(reservation.id)
            .updateData([
                "spaces": FieldValue.arrayUnion([user.uid])
            ]) { (error) in
                self.isLoadingSubject.onNext(false)
                if error != nil {
                    self.showErrorSubject.onNext(true)
                } else {
                    self.getReservations(isToday: isToday)
                }
        }

    }
    
    func releaseReservation(reservation: Reservation, isToday: Bool) {
        guard let user = Auth.auth().currentUser else {
            return
        }
        self.isLoadingSubject.onNext(true)
        db.collection("reservation").document(reservation.id)
            .updateData([
                "spaces": FieldValue.arrayRemove([user.uid])
            ]) { (error) in
                self.isLoadingSubject.onNext(false)
                if error != nil {
                    self.showErrorSubject.onNext(true)
                } else {
                    self.getReservations(isToday: isToday)
                }
        }
    }
}
