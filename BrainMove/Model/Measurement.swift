//
//  Measurement.swift
//  BrainMove
//
//  Created by Heriberto Ureña madrigal on 6/23/20.
//  Copyright © 2020 Heriberto Ureña Madrigal. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Measurement {

    var bmi: Double
    var bodyFat: Double
    var fatFreeBody: Double
    var weight: Double
    var muscleMass: Double
    var bodyWater: Double
    var bmr: Double
    var boneMass: Double
    var protein: Double
    var visceralFat: Double
    var skeletalMuscle: Double
    var subcutaneousFat: Double
    var metabolicalAge: Int
    var date: Date
    
    init() {
        self.bmi = 0
        self.bodyFat = 0
        self.fatFreeBody = 0
        self.weight = 0
        self.muscleMass = 0
        self.bodyWater = 0
        self.bmr = 0
        self.boneMass = 0
        self.protein = 0
        self.visceralFat = 0
        self.skeletalMuscle = 0
        self.subcutaneousFat = 0
        self.metabolicalAge = 0
        self.date = Date()
    }

    init?(data: [String: Any]) {

        guard let bmi = data["bmi"] as? Double,
            let body_fat = data["body_fat"] as? Double,
            let fat_free_body = data["fat_free_body"] as? Double,
            let weight = data["weight"] as? Double,
            let muscle_mass = data["muscle_mass"] as? Double,
            let body_water = data["body_water"] as? Double,
            let bmr = data["bmr"] as? Double,
            let bone_mass = data["bone_mass"] as? Double,
            let protein = data["protein"] as? Double,
            let visceral_fat = data["visceral_fat"] as? Double,
            let skeletal_muscle = data["skeletal_muscle"] as? Double,
            let subcutaneous_fat = data["subcutaneous_fat"] as? Double,
            let metabolical_age = data["metabolical_age"] as? Int,
            let date = data["date"] as? Timestamp else {
                return nil
        }

        self.bmi = bmi
        self.bodyFat = body_fat
        self.fatFreeBody = fat_free_body
        self.weight = weight
        self.muscleMass = muscle_mass
        self.bodyWater = body_water
        self.bmr = bmr
        self.boneMass = bone_mass
        self.protein = protein
        self.visceralFat = visceral_fat
        self.skeletalMuscle = skeletal_muscle
        self.subcutaneousFat = subcutaneous_fat
        self.metabolicalAge = metabolical_age
        self.date = Date(timeIntervalSince1970: TimeInterval(date.seconds))
    }
}
