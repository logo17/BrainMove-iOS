//
//  WorkoutDetailViewController.swift
//  BrainMove
//
//  Created by Heriberto Ureña madrigal on 6/27/20.
//  Copyright © 2020 Heriberto Ureña Madrigal. All rights reserved.
//

import Foundation
import UIKit

class WorkoutDetailViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var workoutsTableView: UITableView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var durationUnitLabel: UILabel!
    
    private let itemsPerRow: CGFloat = 2
    
    private let sectionInsets = UIEdgeInsets(top: 10.0,
    left: 10.0,
    bottom: 10.0,
    right: 10.0)
    
    var block = Block(data: [String:Any]())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = block?.name
        self.durationLabel.text = "\(block?.duration ?? 0)"
        self.durationUnitLabel.text = block?.unit.uppercased()
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func initViews() {
        workoutsTableView.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.block?.exercises.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "WorkoutTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? WorkoutCell  else {
            fatalError("The dequeued cell is not an instance of WorkoutCell.")
        }
        
        if let workout = self.block?.exercises[indexPath.row] {
            cell.workoutName.text = workout.name
            cell.workoutQuantity.text = workout.quantity
            cell.inflateImageView(url: workout.backgroundImageUrl)
            cell.selectionStyle = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 25
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: section == 0 ? 0 : 25))
        headerView.backgroundColor = UIColor.white
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showExplanations", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showExplanations") {
            let indexPath : NSIndexPath = self.workoutsTableView.indexPathForSelectedRow! as NSIndexPath
            let exercise = self.block?.exercises[indexPath.row]
            let destinationVC = segue.destination as! ExerciseExplanationViewController
            destinationVC.workout = exercise
        }
    }
}
