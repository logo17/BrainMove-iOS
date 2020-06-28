//
//  PlanViewController.swift
//  BrainMove
//
//  Created by Heriberto Ureña madrigal on 6/20/20.
//  Copyright © 2020 Heriberto Ureña Madrigal. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class PlanViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var noPlanLabelContainer: UIView!
    @IBOutlet weak var noPlanImageContainer: UIView!
    @IBOutlet weak var planTitleLabel: UILabel!
    @IBOutlet weak var planDateLabel: UILabel!
    @IBOutlet weak var planTableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var planView: UIView!
    var spinner: LoadingView?
    
    
    let viewModel = PlanViewModel()
    let disposeBag = DisposeBag()
    var plan = Plan()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        initViews()
        bindListeners()
        getPlan()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private func initViews() {
        noPlanImageContainer.applyShadow()
        noPlanLabelContainer.applyShadow()
        noPlanLabelContainer.toRounded(radius: 16)
        planTitleLabel.layer.cornerRadius = 16
        planTitleLabel.layer.masksToBounds = true
        planTableView.separatorStyle = .none
    }
    
    private func bindListeners() {
        viewModel.output.plan
            .drive(onNext:{ [weak self] plan in
                if let spinner = self?.spinner {
                    self?.removeSpinner(spinner: spinner)
                }
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.dateFormat = "EEEE, dd MMMM, yyyy"
                dateFormatterPrint.locale = Locale(identifier: "ES")
                self?.planDateLabel.text = "Hasta: \(dateFormatterPrint.string(from: plan.toDate))"
                self?.planTitleLabel.text = plan.name.uppercased()
                self?.plan = plan
                self?.planTableView.reloadData()
                self?.planView.isHidden = plan.routines.isEmpty
                self?.emptyView.isHidden = !plan.routines.isEmpty
            })
            .disposed(by: disposeBag)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plan.routines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "RoutineTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RoutineCell  else {
            fatalError("The dequeued cell is not an instance of RoutineCell.")
        }
        
        let routine = plan.routines[indexPath.row]
        
        cell.routineNameLabel.text = routine.name.uppercased()
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showRoutine", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showRoutine") {
            let indexPath : NSIndexPath = self.planTableView.indexPathForSelectedRow! as NSIndexPath
            let routine = plan.routines[indexPath.row]
            let destinationVC = segue.destination as! RoutineViewController
            destinationVC.routine = routine
        }
    }
    
    private func getPlan() {
        spinner = self.showSpinner(onView: self.view)
        viewModel.getPlan()
    }
}
