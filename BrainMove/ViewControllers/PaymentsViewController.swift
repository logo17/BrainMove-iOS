//
//  PaymentsViewController.swift
//  BrainMove
//
//  Created by Heriberto Ureña madrigal on 7/3/20.
//  Copyright © 2020 Heriberto Ureña Madrigal. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class PaymentsViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let viewModel = PaymentsViewModel()
    let disposeBag = DisposeBag()
    var plan = Plan()
    var payments = Array<Payment>()
    @IBOutlet weak var paymentsTable: UITableView!
    @IBOutlet weak var emptyView: UIView!
    var spinner: LoadingView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        initViews()
        bindListeners()
    }
    
    private func initViews() {
        paymentsTable.separatorStyle = .none
    }
    
    private func bindListeners() {
        viewModel.output.payments
            .drive(onNext:{ [weak self] payments in
                self?.emptyView.isHidden = true
                self?.paymentsTable.isHidden = false
                self?.payments = payments
                self?.paymentsTable.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.output.isLoading
            .drive(onNext:{ [weak self] isLoading in
                self?.handleLoadingSpinner(isLoading: isLoading)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.showError
            .drive(onNext:{ [weak self] showError in
                self?.showAlert(title: self?.getLocalizedString(key: "general_error_title") ?? "", description: self?.getLocalizedString(key: "general_plan_error_description") ?? "", completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.payments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "PaymentCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PaymentCell  else {
            fatalError("The dequeued cell is not an instance of PaymentCell.")
        }
        
        let payment = self.payments[indexPath.section]
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd/MM/YYYY"
        dateFormatterPrint.locale = Locale(identifier: "ES")
        let dateResult = dateFormatterPrint.string(from: payment.paymentDate)
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = .current
        let totalFormatted = formatter.string(from: payment.total as NSNumber)!
        
        cell.titleLabel.text = payment.description
        cell.dateLabel.text = dateResult
        cell.totalLabel.text = "₡ \(totalFormatted)"
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 16
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: section == 0 ? 0 : 16))
        headerView.backgroundColor = UIColor.white
        return headerView
    }
    
    private func handleLoadingSpinner(isLoading: Bool) {
        if (isLoading) {
            spinner = self.showSpinner(onView: self.view)
        } else {
            if let spinner = self.spinner {
                self.removeSpinner(spinner: spinner)
            }
        }
    }
}
