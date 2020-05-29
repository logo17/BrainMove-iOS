//
//  ButtonExt.swift
//  BrainMove
//
//  Created by Heriberto Ureña madrigal on 5/28/20.
//  Copyright © 2020 Heriberto Ureña Madrigal. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    func handleButtonEnabled(isEnabled: Bool) {
        self.backgroundColor = UIColor.init(hexString: isEnabled ? "#00a19a" : "#d0d0d0")
        self.isEnabled = isEnabled
    }
    
    func toPrimaryButton() {
        self.layer.cornerRadius = 19
        // Shadow and Radius
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.5)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 0.0
        self.layer.masksToBounds = false
    }
}
