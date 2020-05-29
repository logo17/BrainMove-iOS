//
//  ViewController+Snackbar.swift
//  BrainMove
//
//  Created by Heriberto Ureña madrigal on 5/30/20.
//  Copyright © 2020 Heriberto Ureña Madrigal. All rights reserved.
//

import Foundation
import UIKit
import MaterialComponents.MaterialSnackbar

extension UIViewController {
    func showSnackbar(text: String) {
        let message = MDCSnackbarMessage()
        message.text = text
        MDCSnackbarManager.show(message)
        
    }
    
    func getLocalizedString(key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }
}
