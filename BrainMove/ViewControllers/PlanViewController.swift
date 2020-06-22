//
//  PlanViewController.swift
//  BrainMove
//
//  Created by Heriberto Ureña madrigal on 6/20/20.
//  Copyright © 2020 Heriberto Ureña Madrigal. All rights reserved.
//

import Foundation
import UIKit

class PlanViewController : UIViewController {
    @IBOutlet weak var noPlanLabelContainer: UIView!
    @IBOutlet weak var noPlanImageContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        initViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private func initViews() {
        noPlanImageContainer.applyShadow()
        noPlanLabelContainer.applyShadow()
        noPlanLabelContainer.toRounded(radius: 16)
    }
}
