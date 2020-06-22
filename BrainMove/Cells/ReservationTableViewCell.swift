//
//  ReservationTableViewCell.swift
//  BrainMove
//
//  Created by Heriberto Ureña madrigal on 6/20/20.
//  Copyright © 2020 Heriberto Ureña Madrigal. All rights reserved.
//

import Foundation
import UIKit

class ReservationTableViewCell : UITableViewCell {
    @IBOutlet weak var reservationDetail: UILabel!
    @IBOutlet weak var reservationButton: UIButton!
    @IBOutlet weak var content: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        content.layer.cornerRadius = 22
        reservationButton.toRoundedButton(radius: 13)
    }
}
