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
            let spaces = data["spaces"] as? Array<[String: Any]>,
            let activityId = data["activityId"] as? String else {
                return nil
        }
        
        var contains = false
        
        for user in spaces {
            if (user["id"] as? String ?? "" == userId) {
                contains = true
                break
            }
        }

        self.maxCapacity = maxCapacity
        self.date = date.dateValue()
        self.availableSpaces = maxCapacity - spaces.count
        self.isReserved = contains
        self.activityId = activityId
    
    }
}
