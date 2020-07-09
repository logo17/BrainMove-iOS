//
//  UIImageView+Rounded.swift
//  BrainMove
//
//  Created by Heriberto Ureña madrigal on 7/8/20.
//  Copyright © 2020 Heriberto Ureña Madrigal. All rights reserved.
//
import Foundation
import UIKit

extension UIImageView {
    
    func rounded(){
        
        self.layer.borderWidth = 0
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
        
    }
}
