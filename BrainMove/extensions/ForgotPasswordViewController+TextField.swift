//
//  ForgotPasswordViewController+TextField.swift
//  BrainMove
//
//  Created by Heriberto Ureña madrigal on 5/28/20.
//  Copyright © 2020 Heriberto Ureña Madrigal. All rights reserved.
//

import Foundation
import UIKit

extension ForgotPasswordViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
