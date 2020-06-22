//
//  LoadingView.swift
//  BrainMove
//
//  Created by Heriberto Ureña madrigal on 6/21/20.
//  Copyright © 2020 Heriberto Ureña Madrigal. All rights reserved.
//

import Foundation
import UIKit

class LoadingView : UIView {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var dataContainer: UIView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initSubViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
    }
    
    func initSubViews() {
        // standard initialization logic
        let nib = UINib(nibName: "LoadingView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        dataContainer.toRounded(radius: 10)
        addSubview(contentView)
    }
}
