//
//  ReservationsViewController.swift
//  BrainMove
//
//  Created by Heriberto Ureña madrigal on 6/20/20.
//  Copyright © 2020 Heriberto Ureña Madrigal. All rights reserved.
//

import Foundation
import UIKit
import MaterialComponents.MaterialTabs

class ReservationViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ReservationTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ReservationTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
//        let meal = meals[indexPath.row]
        
        cell.reservationDetail.text = "6:00 PM - 3 DISPONIBLES"
        cell.reservationButton.setTitle("RESERVAR", for: .normal)
        
        return cell
    }
    
    
    @IBOutlet weak var tabContainer: UIView!
    
     
    override func viewDidLoad() {
        super.viewDidLoad()
    
        initViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private func initViews() {
        let tabBar = MDCTabBar(frame: tabContainer.bounds)
        tabBar.items = [
        UITabBarItem(title: "HOY", image: nil, tag: 0),
        UITabBarItem(title: "MAÑANA", image:nil, tag: 0),
        ]
        tabBar.alignment = .justified
        tabBar.itemAppearance = .titles
        tabBar.bottomDividerColor = UIColor.init(hexString: "#898989")
        tabBar.setTitleColor(UIColor.init(hexString: "#00a19a"), for: MDCTabBarItemState.selected)
        tabBar.setTitleColor(UIColor.init(hexString: "#898989"), for: MDCTabBarItemState.normal)
        
        tabBar.tintColor = UIColor.init(hexString: "#00a19a")
        
        tabBar.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        tabBar.sizeToFit()
        tabContainer.addSubview(tabBar)
        
        tableView.separatorStyle = .none
    }
}
