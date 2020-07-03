//
//  Payment.swift
//  BrainMove
//
//  Created by Heriberto Ureña madrigal on 7/3/20.
//  Copyright © 2020 Heriberto Ureña Madrigal. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Payment {

    var description: String
    var dueDate: Date
    var paymentDate: Date
    var total: Double
    var userId: String
    
    init() {
        self.description = ""
        self.dueDate = Date()
        self.paymentDate = Date()
        self.total = 0
        self.userId = ""
    }

    init?(data: [String: Any]) {

        guard let description = data["description"] as? String,
            let dueDate = data["dueDate"] as? Timestamp,
            let paymentDate = data["paymentDate"] as? Timestamp,
            let total = data["total"] as? Double,
            let userId = data["userId"] as? String else {
                return nil
        }
        
        self.description = description
        self.dueDate = Date(timeIntervalSince1970: TimeInterval(dueDate.seconds))
        self.paymentDate = Date(timeIntervalSince1970: TimeInterval(paymentDate.seconds))
        self.total = total
        self.userId = userId
    }
}
