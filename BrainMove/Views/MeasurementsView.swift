//
//  MeasurementsView.swift
//  BrainMove
//
//  Created by Heriberto Ureña madrigal on 6/18/20.
//  Copyright © 2020 Heriberto Ureña Madrigal. All rights reserved.
//

import Foundation
import UIKit

class MeasurementsView : UIView {
    
    @IBOutlet weak var labelText: UILabel!
    @IBOutlet weak var valueText: UILabel!
    @IBOutlet var contentView: UIView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initSubViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
    }
    
    private func initSubViews() {
        // standard initialization logic
        let nib = UINib(nibName: "MeasurementsView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        contentView.layer.cornerRadius = 10
        // Shadow and Radius
        contentView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        contentView.layer.shadowOffset = CGSize(width: 0.0, height: 1.5)
        contentView.layer.shadowOpacity = 0.5
        contentView.layer.shadowRadius = 0.0
        contentView.layer.masksToBounds = false
        addSubview(contentView)
    }
    
    func setValueData(value: String) {
        self.valueText.text = value
        self.contentView.backgroundColor = UIColor.init(hexString: "#f39200")
    }
}
