//
//  MeasurementsViewController.swift
//  BrainMove
//
//  Created by Heriberto Ureña madrigal on 6/19/20.
//  Copyright © 2020 Heriberto Ureña Madrigal. All rights reserved.
//

import Foundation
import UIKit

class MeasurementsViewController : UIViewController {
    @IBOutlet weak var dateTextView: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        initViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private func initViews() {
        dateTextView.toPrimaryRounded()
        
    }
}
