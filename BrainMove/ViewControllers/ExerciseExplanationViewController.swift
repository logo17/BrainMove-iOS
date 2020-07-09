//
//  ExerciseExplanationViewController.swift
//  BrainMove
//
//  Created by Heriberto Ureña madrigal on 6/27/20.
//  Copyright © 2020 Heriberto Ureña Madrigal. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher


class ExerciseExplanationViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var explanationImageView: UIImageView!
    @IBOutlet weak var explanationsTableView: UITableView!
    
    var workout = Exercise(data: [String:Any]())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = workout?.demoUrl {
            self.explanationImageView.kf.setImage(with: URL(string: url)!, placeholder: UIImage(named: "imagen_loading_placeholder"))
        }
        explanationsTableView.separatorStyle = .none
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.title = workout?.name
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return workout?.explanations.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ExerciseCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ExerciseCell  else {
            fatalError("The dequeued cell is not an instance of ExerciseCell.")
        }
        
        if let explanation = self.workout?.explanations[indexPath.section] {
            cell.indexLabel.text = "\(indexPath.section + 1)"
            cell.explanationLabel.text = explanation
            cell.selectionStyle = .none
        }
        
        return cell
    }
}
