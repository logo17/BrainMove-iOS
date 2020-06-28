//
//  BlockCell.swift
//  BrainMove
//
//  Created by Heriberto Ureña madrigal on 6/27/20.
//  Copyright © 2020 Heriberto Ureña Madrigal. All rights reserved.
//

import Foundation
import UIKit

class BlockCell : UITableViewCell {
    @IBOutlet weak var blockImage: UIImageView!
    @IBOutlet weak var blockTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func inflateImageView(url: String) {
        if let parseURL = URL.init(string: url) {
            blockImage.load(url: parseURL)
        }
    }
}
