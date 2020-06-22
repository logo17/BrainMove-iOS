//
//  UIView+Utils.swift
//  BrainMove
//
//  Created by Heriberto Ureña madrigal on 6/20/20.
//  Copyright © 2020 Heriberto Ureña Madrigal. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func applyShadow() {
        // Shadow and Radius
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.5)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 0.0
        self.layer.masksToBounds = false
    }
    
    func toRounded(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = false
    }
}
