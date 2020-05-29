//
//  UILabel+Ext.swift
//  BrainMove
//
//  Created by Heriberto Ureña madrigal on 6/19/20.
//  Copyright © 2020 Heriberto Ureña Madrigal. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    func toPrimaryRounded(){
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
    }
}
