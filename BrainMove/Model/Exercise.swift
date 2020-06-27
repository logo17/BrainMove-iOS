//
//  Exercise.swift
//  BrainMove
//
//  Created by Heriberto Ureña madrigal on 6/26/20.
//  Copyright © 2020 Heriberto Ureña Madrigal. All rights reserved.
//

import Foundation

struct Exercise {
    var backgroundImageUrl: String
    var demoUrl: String
    var name: String
    var quantity: String
    var explanations: Array<String>
    
    init?(data: [String: Any]) {
        guard let backgroundImageUrl = data["backgroundImageUrl"] as? String,
            let demoUrl = data["demoUrl"] as? String,
            let name = data["name"] as? String,
            let quantity = data["quantity"] as? String,
            let explanations = data["explanations"] as? Array<String> else {
                return nil
        }

        self.backgroundImageUrl = backgroundImageUrl
        self.demoUrl = demoUrl
        self.name = name
        self.quantity = quantity
        self.explanations = explanations
    }
}
