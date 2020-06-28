//
//  LauncherViewController.swift
//  BrainMove
//
//  Created by Heriberto Ureña madrigal on 6/21/20.
//  Copyright © 2020 Heriberto Ureña Madrigal. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class LauncherViewController : UIViewController {
    let viewModel = LauncherViewModel()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindListeners()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        viewModel.checkLoggedInUser()
    }
    
    private func bindListeners() {
        viewModel.output.isLoggedInUser
            .drive(onNext:{ [weak self] isLoggedIn in
                self?.handleNavigation(isLoggedIn: isLoggedIn)
            })
            .disposed(by: disposeBag)
    }
    
    private func handleNavigation(isLoggedIn: Bool) {
        let identifier = isLoggedIn ? "showMainScreenFromLauncher" : "showLoginScreen"
        self.performSegue(withIdentifier: identifier, sender: self)
    }
}
