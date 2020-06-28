//
//  UIViewController+Spinner.swift
//  BrainMove
//
//  Created by Heriberto Ureña madrigal on 6/21/20.
//  Copyright © 2020 Heriberto Ureña Madrigal. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func showSpinner(onView : UIView) -> LoadingView {
        let spinnerView = LoadingView.init(frame: onView.bounds)
        DispatchQueue.main.async {
            onView.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    
    func removeSpinner(spinner : LoadingView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
}
