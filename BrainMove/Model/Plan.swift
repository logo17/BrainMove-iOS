//
//  Plan.swift
//  BrainMove
//
//  Created by Heriberto Ureña madrigal on 6/26/20.
//  Copyright © 2020 Heriberto Ureña Madrigal. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Plan {
    var userId: String
    var name: String
    var goal: String
    var toDate: Date
    var fromDate: Date
    var routines: Array<Routine>
    
    init() {
        self.userId = ""
        self.name = ""
        self.goal = ""
        self.toDate = Date()
        self.fromDate = Date()
        self.routines = Array()
    }
    
    init?(data: [String: Any]) {
        guard let userId = data["userId"] as? String,
            let name = data["name"] as? String,
            let goal = data["goal"] as? String,
            let toDate = data["toDate"] as? Timestamp,
            let fromDate = data["fromDate"] as? Timestamp,
            let routines = data["routines"] as? Array<[String: Any]> else {
                return nil
        }
        
        var auxRoutines = Array<Routine>()
        
        routines.forEach {
            if let routine = Routine(data: $0) {
                auxRoutines.append(routine)
            }
        }

        self.userId = userId
        self.name = name
        self.goal = goal
        self.toDate = Date(timeIntervalSince1970: TimeInterval(toDate.seconds))
        self.fromDate = Date(timeIntervalSince1970: TimeInterval(fromDate.seconds))
        self.routines = auxRoutines
    }
}
