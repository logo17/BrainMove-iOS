//
//  RoutineViewController.swift
//  BrainMove
//
//  Created by Heriberto Ureña madrigal on 6/27/20.
//  Copyright © 2020 Heriberto Ureña Madrigal. All rights reserved.
//

import Foundation
import UIKit

class RoutineViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var routineTableView: UITableView!
    var routine = Routine(data: [String:Any]())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = routine?.name
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func initViews() {
        routineTableView.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.routine?.blocks.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "BlockTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? BlockCell  else {
            fatalError("The dequeued cell is not an instance of BlockCell.")
        }
        
        if let block = self.routine?.blocks[indexPath.section] {
            cell.blockTitle.text = block.name
            cell.inflateImageView(url: block.imageUrl)
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
        self.performSegue(withIdentifier: "showWorkout", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showWorkout") {
            let indexPath : NSIndexPath = self.routineTableView.indexPathForSelectedRow! as NSIndexPath
            let block = routine?.blocks[indexPath.row]
            let destinationVC = segue.destination as! WorkoutDetailViewController
            destinationVC.block = block
        }
    }
}
