//
//  Reservation.swift
//  BrainMove
//
//  Created by Heriberto Ureña madrigal on 6/24/20.
//  Copyright © 2020 Heriberto Ureña Madrigal. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Reservation {
    var id: String
    var maxCapacity: Int
    var date: Date
    var availableSpaces: Int
    var isReserved: Bool
    var activityId: String
    
    init() {
        self.id = ""
        self.maxCapacity = 0
        self.date = Date()
        self.availableSpaces = 0
        self.isReserved = false
        self.activityId = ""
    }
    
    init?(userId: String, reservationId: String, data: [String: Any]) {
        self.id = reservationId
        guard let maxCapacity = data["maxCapacity"] as? Int,
            let date = data["date"] as? Timestamp,
            let spaces = data["spaces"] as? Array<String>,
            let activityId = data["activityId"] as? String else {
                return nil
        }

        self.maxCapacity = maxCapacity
        self.date = date.dateValue()
        self.availableSpaces = maxCapacity - spaces.count
        self.isReserved = spaces.contains(userId)
        self.activityId = activityId
    
    }
}
