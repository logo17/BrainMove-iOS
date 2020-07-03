//
//  SettingsViewController.swift
//  BrainMove
//
//  Created by Heriberto Ureña madrigal on 7/1/20.
//  Copyright © 2020 Heriberto Ureña Madrigal. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class SettinsViewController : UIViewController {
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var userFullNameLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    
    let viewModel = SettingsViewModel()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoutButton.toRoundedButton(radius: 16)
        bindListeners()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    private func bindListeners() {
        viewModel.output.userFullName
            .drive(onNext:{ [weak self] userFullName in
                self?.userFullNameLabel.text = userFullName
            })
            .disposed(by: disposeBag)
        
        viewModel.output.userEmail
            .drive(onNext:{ [weak self] email in
                self?.emailLabel.text = email
            })
            .disposed(by: disposeBag)
        
        viewModel.output.logout
            .drive(onNext:{ [weak self] isSuccess in
                self?.backTwo()
            })
            .disposed(by: disposeBag)
    }
    
    private func backTwo() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
    }
    
    @IBAction func logoutClicked(_ sender: Any) {
        viewModel.logoutUser()
    }
    
    @IBAction func showPayments(_ sender: Any) {
        self.performSegue(withIdentifier: "showPayments", sender: self)
    }
}
