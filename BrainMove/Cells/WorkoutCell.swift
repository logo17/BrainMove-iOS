//
//  WorkoutCell.swift
//  BrainMove
//
//  Created by Heriberto Ureña madrigal on 6/27/20.
//  Copyright © 2020 Heriberto Ureña Madrigal. All rights reserved.
//

import Foundation
import UIKit

class WorkoutCell : UITableViewCell {
    @IBOutlet weak var workoutImage: UIImageView!
    @IBOutlet weak var workoutQuantity: UILabel!
    @IBOutlet weak var workoutName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.borderWidth = 1.0

        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true
    }
    
    func inflateImageView(url: String) {
        self.workoutImage.kf.setImage(with: URL(string: url)!, placeholder: UIImage(named: "imagen_loading_placeholder"))
    }
}
