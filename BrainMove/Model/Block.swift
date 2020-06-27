//
//  Block.swift
//  BrainMove
//
//  Created by Heriberto Ureña madrigal on 6/26/20.
//  Copyright © 2020 Heriberto Ureña Madrigal. All rights reserved.
//

import Foundation

struct Block {
    var description: String
    var unit: String
    var duration: Int
    var imageUrl: String
    var name: String
    var exercises: Array<Exercise>
    
    init?(data: [String: Any]) {
        guard let description = data["description"] as? String,
            let unit = data["unit"] as? String,
            let duration = data["duration"] as? Int,
            let imageUrl = data["imageUrl"] as? String,
            let name = data["name"] as? String,
            let exercises = data["exercises"] as? Array<[String: Any]> else {
                return nil
        }
        
        var auxExercises = Array<Exercise>()
        
        exercises.forEach {
            if let exercise = Exercise(data: $0) {
                auxExercises.append(exercise)
            }
        }

        self.description = description
        self.unit = unit
        self.duration = duration
        self.imageUrl = imageUrl
        self.name = name
        self.exercises = auxExercises
    }
}
