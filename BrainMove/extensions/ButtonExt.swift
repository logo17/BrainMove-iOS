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
        self.backgroundColor = UIColor.init(hexString: isEnabled ? "#F39200" : "#AAAAAA")
        self.isEnabled = isEnabled
    }
}
