//
//  UIViewController+Error.swift
//  BrainMove
//
//  Created by Heriberto Ureña madrigal on 6/30/20.
//  Copyright © 2020 Heriberto Ureña Madrigal. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(title: String, description: String, completion: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: description, preferredStyle: UIAlertController.Style.alert)

        // add an action (button)
        alert.addAction(UIAlertAction(title: self.getLocalizedString(key: "accept_button_text"), style: UIAlertAction.Style.default, handler: completion))

        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
}
