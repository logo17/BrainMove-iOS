//
//  RoutineCell.swift
//  BrainMove
//
//  Created by Heriberto Ureña madrigal on 6/26/20.
//  Copyright © 2020 Heriberto Ureña Madrigal. All rights reserved.
//

import Foundation
import UIKit

class RoutineCell : UITableViewCell {
    @IBOutlet weak var content: UIView!
    @IBOutlet weak var routineNameLabel: UILabel!
    @IBOutlet weak var initPlanLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        content.layer.cornerRadius = 19
        initPlanLabel.toRoundedLabel(radius: 13)
    }
}
