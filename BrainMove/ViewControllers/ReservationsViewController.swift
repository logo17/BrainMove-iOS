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
import RxSwift

class ReservationViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, MDCTabBarDelegate {
    
    let viewModel = ReservationsViewModel()
    var reservations: Array<Reservation> = Array()
    var disposeBag = DisposeBag()
    @IBOutlet weak var tabContainer: UIView!
    @IBOutlet weak var emptyView: UIView!
    let tabBar = MDCTabBar()
    var spinner: LoadingView?
    
    @IBOutlet weak var tableView: UITableView!
    
    func tabBar(_ tabBar: MDCTabBar, didSelect item: UITabBarItem) {
        self.getReservations(isToday: item.tag == 0)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reservations.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let reservation = reservations[indexPath.row]
        if (reservation.availableSpaces > 0 || reservation.isReserved) {
            spinner = self.showSpinner(onView: self.view)
            if (reservation.isReserved) {
                self.viewModel.releaseReservation(reservation: reservation, isToday: tabBar.selectedItem?.tag == 0)
            } else {
                self.viewModel.makeReservation(reservation: reservation, isToday: tabBar.selectedItem?.tag == 0)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ReservationTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ReservationTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ReservationTableViewCell.")
        }
        
        let reservation = reservations[indexPath.row]
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "h:mm a"
        
        var reservationInfoText = dateFormatterPrint.string(from: reservation.date).uppercased()
        if (!reservation.isReserved && reservation.availableSpaces > 0) {
            reservationInfoText = "\(reservationInfoText) - \(reservation.availableSpaces) ESPACIOS"
        }
        
        cell.selectionStyle = .none
        cell.reservationDetail.text = reservationInfoText
        
        if (reservation.isReserved) {
            cell.reservationStatus.text = "RESERVADO"
            cell.reservationStatus.textColor = UIColor.init(hexString: "#00a19a")
            cell.content.backgroundColor = UIColor.init(hexString: "#00a19a")
        } else if (reservation.availableSpaces > 0) {
            cell.reservationStatus.text = "RESERVAR"
            cell.reservationStatus.textColor = UIColor.init(hexString: "#f39200")
            cell.content.backgroundColor = UIColor.init(hexString: "#f39200")
        } else {
            cell.reservationStatus.text = "AGOTADO"
            cell.reservationStatus.textColor = UIColor.init(hexString: "#898989")
            cell.content.backgroundColor = UIColor.init(hexString: "#898989")
        }
        
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        initViews()
        bindListeners()
        self.getReservations(isToday: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private func initViews() {
        tabBar.frame = tabContainer.bounds
        tabBar.items = [
        UITabBarItem(title: "HOY", image: nil, tag: 0),
        UITabBarItem(title: "MAÑANA", image:nil, tag: 1),
        ]
        tabBar.alignment = .justified
        tabBar.itemAppearance = .titles
        tabBar.bottomDividerColor = UIColor.init(hexString: "#898989")
        tabBar.setTitleColor(UIColor.init(hexString: "#00a19a"), for: MDCTabBarItemState.selected)
        tabBar.setTitleColor(UIColor.init(hexString: "#898989"), for: MDCTabBarItemState.normal)
        tabBar.delegate = self
        
        tabBar.tintColor = UIColor.init(hexString: "#00a19a")
        
        tabBar.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        tabBar.sizeToFit()
        tabContainer.addSubview(tabBar)
        
        tableView.separatorStyle = .none
    }
    
    private func bindListeners() {
        viewModel.output.reservations
            .drive(onNext:{ [weak self] reservations in
                if let spinner = self?.spinner {
                    self?.removeSpinner(spinner: spinner)
                }
                self?.reservations = reservations
                self?.tableView.reloadData()
                self?.tableView.isHidden = reservations.isEmpty
                self?.emptyView.isHidden = !reservations.isEmpty
            })
            .disposed(by: disposeBag)
    }
    
    private func getReservations(isToday: Bool) {
        spinner = self.showSpinner(onView: self.view)
        viewModel.getReservations(isToday: isToday)
    }
}
